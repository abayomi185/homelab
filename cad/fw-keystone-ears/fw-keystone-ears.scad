// Firewall (YHLD-SERV2) keystone rack ears, YHLR-SVRK1
//
// Replaces the firewall's two L-shaped 1U ears. The left ear is minimal, so
// the firewall sits against the left rail and all the free width goes to a
// keystone row in the right ear. This frees the 1U patch panel slot.
//
// Frame (right ear, left is mirrored):
//   x: 0 = firewall chassis side, + towards the rack rail
//   y: 0 = front face, + towards the rear
//   z: 0 = bottom of the panel
//
// Chassis side holes (measured): 2x M3 per side, 22mm apart centred on the
// chassis height, 5mm behind the chassis front. The chassis sits fw_recess
// behind the ear face so the screws clear the 4mm face; countersunk M3 heads
// sit flush in the flange, clear of the keystones.
//
// Assembly: screw ears to the firewall on the desk (driver goes in from the
// open outer side), rack it, then snap keystones in from the rear.
// Port numbers on the face run 1..n left to right.
//
// Export: see Makefile. part = "right" | "left" | "plate" | "test" | "assembly"

part = "assembly";

/* [Fit] */
fw_w = 240;                  // firewall chassis (vendor drawing: 240 x 184 x 43)
fw_recess = 2;               // chassis front behind ear face
side_hole_pitch = 22;        // vertical, centred
side_hole_y = fw_recess + 5; // from ear face
side_slot_len = 2;           // extra fore/aft play
side_screw_d = 3.6;          // M3 clearance
csk_d = 6.4;                 // M3 countersunk head (DIN 7991: 6.0)

/* [Rack: EIA-310] */
panel_h  = 43.66;             // 1U minus 1/32"
ear_w    = (482.6 - 450) / 2; // 16.3, ear over the rail
rail_clr = 1;                 // gap to rail inner edge
rack_hole_z = [6.35, 38.1] - [1, 1] * (44.45 - 43.66) / 2;
rack_hole_from_edge = (482.6 - 465.1) / 2; // 8.75
rack_slot = [10, 6.6];        // M6 cage nut slot, w x h

/* [Keystone] */
ks_w      = 15.0;  // front opening
ks_h      = 16.5;
ks_pitch  = 16.5;  // 1.5mm web; 12 ports in the right ear
// Receptacle profile, depths measured from the front face. The fixed hook
// (bottom) and the sprung latch (top) each sit in a pocket and are held in
// by a 45 deg catch at the rear. Print the "test" part first to check fit.
ks_d      = 10;    // receptacle depth
hook_d    = 2;     // hook pocket height
hook_y    = 6.5;   // hook pocket starts
latch_d   = 4;     // latch pocket height
latch_y   = 4;     // latch pocket starts
catch_y   = 8;     // catches start
catch_h   = 2;     // catch overhang
ks_wall   = 3;     // above / below the pockets

/* [Body] */
face_t    = 4;
plate_t   = 2.5;   // top / bottom plates
flange_t  = 4;     // against the chassis, right ear
left_flange_t = 5; // left ear has no box, so a thicker flange
top_d     = 40;
shelf_d   = 60;    // bottom plate, rear part = strain relief shelf
flange_d  = 70;
fillet    = 3;

/* [Labels] */
labels    = true;
label_size = 4;
label_depth = 0.6;

$fn = 48;
eps = 0.01;

// chassis side -> rail inner edge
left_free  = rail_clr + left_flange_t;
right_free = 450 - fw_w - left_free;

inner_w = right_free - rail_clr - flange_t;
n = floor(inner_w / ks_pitch);
function port_x(i) = flange_t + (inner_w - n * ks_pitch) / 2 + ks_pitch * (i + 0.5);

echo(str("ports: ", n, ", right free width ", right_free));

module slot(len, d) {
    hull() for (s = [-1, 1]) translate([s * (len - d) / 2, 0]) circle(d = d);
}

module rack_slots(w) {
    for (z = rack_hole_z)
        translate([w - rack_hole_from_edge, face_t + eps, z])
            rotate([90, 0, 0]) linear_extrude(face_t + 2 * eps)
                slot(rack_slot[0], rack_slot[1]);
}

// countersunk M3 slots through a flange of thickness t, head on the +x side
module side_slots(t) {
    csk_h = (csk_d - side_screw_d) / 2; // 90 deg
    for (s = [-1, 1])
        translate([0, side_hole_y, panel_h / 2 + s * side_hole_pitch / 2])
            hull() for (dy = [-1, 1] * side_slot_len / 2)
                translate([0, dy, 0]) rotate([0, 90, 0]) {
                    translate([0, 0, -eps]) cylinder(d = side_screw_d, h = t + 2 * eps);
                    translate([0, 0, t - csk_h])
                        cylinder(d1 = side_screw_d, d2 = csk_d, h = csk_h + eps);
                }
}

ks_z = (panel_h - ks_h) / 2; // bottom of the opening

// One keystone receptacle, cut from the front (y=0) to ks_d. Origin: bottom
// left of the opening. Profile is in (y, z), extruded across the opening.
module ks_cut() {
    rotate([90, 0, 90]) linear_extrude(ks_w) {
        translate([-eps, 0]) square([ks_d + 2 * eps, ks_h]);
        polygon([[hook_y, eps], [hook_y, -hook_d], [catch_y, -hook_d],
                 [catch_y + catch_h, catch_h - hook_d], [ks_d + eps, catch_h - hook_d],
                 [ks_d + eps, eps]]);
        polygon([[latch_y, ks_h - eps], [latch_y, ks_h + latch_d],
                 [catch_y, ks_h + latch_d],
                 [catch_y + catch_h, ks_h + latch_d - catch_h],
                 [ks_d + eps, ks_h + latch_d - catch_h], [ks_d + eps, ks_h - eps]]);
    }
}

module right() {
    w = right_free + ear_w;
    box_x1 = right_free - rail_clr;
    difference() {
        union() {
            cube([w, face_t, panel_h]);                                  // face
            cube([flange_t, flange_d, panel_h]);                         // flange
            translate([0, 0, panel_h - plate_t]) cube([box_x1, top_d, plate_t]);
            cube([box_x1, shelf_d, plate_t]);                            // shelf
            translate([flange_t, 0, ks_z - hook_d - ks_wall])             // receptacles
                cube([inner_w, ks_d, ks_h + hook_d + latch_d + 2 * ks_wall]);
            // face/plate fillets (45 deg, print-safe face down)
            for (z = [plate_t, panel_h - plate_t])
                translate([flange_t, face_t, z])
                    rotate([0, 90, 0]) linear_extrude(box_x1 - flange_t)
                        polygon(z < panel_h / 2
                            ? [[0, 0], [-fillet, 0], [0, fillet]]
                            : [[0, 0], [fillet, 0], [0, fillet]]);
        }
        for (i = [0 : n - 1])
            translate([port_x(i) - ks_w / 2, 0, ks_z]) ks_cut();
        rack_slots(w);
        side_slots(flange_t);
        // zip-tie slot pair behind each port
        for (i = [0 : n - 1], s = [-1, 1])
            translate([port_x(i) + s * 5 - 1.1, shelf_d - 9, -eps])
                cube([2.2, 4.5, plate_t + 2 * eps]);
        // port numbers
        if (labels) for (i = [0 : n - 1])
            translate([port_x(i), label_depth, ks_z + ks_h + latch_d + 1])
                rotate([90, 0, 0]) linear_extrude(label_depth + 1)
                    text(str(i + 1), size = label_size, halign = "center",
                         font = "Liberation Sans:style=Bold");
    }
}

module left() mirror([1, 0, 0]) difference() {
    union() {
        cube([left_free + ear_w, face_t, panel_h]);
        cube([left_flange_t, flange_d, panel_h]);
    }
    rack_slots(left_free + ear_w);
    side_slots(left_flange_t);
}

// face down on the bed
module print_pose() rotate([90, 0, 0]) children();

if (part == "right") print_pose() right();
if (part == "left")  print_pose() left();
if (part == "plate") {
    translate([-(right_free + ear_w) / 2, 60, 0]) print_pose() right();
    translate([(left_free + ear_w) / 2, 0, 0]) print_pose() left();
}
// two-port coupon to check the keystone fit before printing the ear
if (part == "test") print_pose() intersection() {
    right();
    translate([port_x(1) - ks_pitch / 2, -1, ks_z - hook_d - ks_wall])
        cube([2 * ks_pitch, ks_d + 1 + eps, ks_h + hook_d + latch_d + 2 * ks_wall]);
}
if (part == "assembly") {
    x0 = -225 + left_free; // firewall left side
    translate([x0, 0, 0]) left();
    translate([x0 + fw_w, 0, 0]) right();
    %translate([x0, fw_recess, (panel_h - 43) / 2]) cube([fw_w, 184, 43]);
}
