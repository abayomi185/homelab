// Firewall (YHLD-SERV2) keystone rack ears, YHLR-SVRK1
//
// Replaces the firewall's two L-shaped 1U ears with printed ears that also
// hold standard RJ45 keystones in the free space each side of the box.
// This frees the 1U patch panel slot.
//
// Frame (right ear, left is mirrored):
//   x: 0 = firewall chassis side, + towards the rack rail
//   y: 0 = front face, + towards the rear
//   z: 0 = bottom of the panel
//
// MEASURE before printing (still estimates):
//   side_slot_z             heights of the chassis side screw holes
//   side_slot_y             depth range (from the ear face) the holes fall in
//   side_screw_d            clearance for the original ear screws
//
// Assembly: screw ears to the firewall on the desk (driver goes in from the
// open outer side), rack it, then snap keystones in from the rear.
//
// Export: see Makefile. part = "right" | "left" | "plate" | "assembly"

part = "assembly";

/* [Fit: measure these] */
fw_w       = 240;   // firewall chassis width (vendor drawing: 240 x 184 x 43)
right_free = 105;   // chassis side -> right rail inner edge; stock ears are 120 wide
left_free  = 450 - fw_w - right_free;
side_slot_z = [11.8, 31.8];  // chassis side screw heights
side_slot_y = [12, 58];      // slot start/end depth from front face
side_screw_d = 4.4;          // M4 clearance (3.4 for M3)

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
ks_pitch  = 17.0;
clip_t    = 2.0;   // plate thickness the keystone clips grip
latch_h   = 23.5;  // rear clearance for hook + latch

/* [Body] */
face_t    = 4;
plate_t   = 2.5;   // top / bottom plates
flange_t  = 4;     // against the chassis
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

function inner_w(free) = free - rail_clr - flange_t;
function n_ports(free) = floor(inner_w(free) / ks_pitch);
function port_x(free, i) =
    flange_t + (inner_w(free) - n_ports(free) * ks_pitch) / 2
    + ks_pitch * (i + 0.5);

nL = n_ports(left_free);
nR = n_ports(right_free);
echo(str("ports: left ", nL, ", right ", nR, ", total ", nL + nR));

module slot(len, d) {
    hull() for (s = [-1, 1]) translate([s * (len - d) / 2, 0]) circle(d = d);
}

module ear_body(free) {
    n = n_ports(free);
    w = free + ear_w;
    box_x1 = free - rail_clr;
    difference() {
        union() {
            cube([w, face_t, panel_h]);                                  // face
            cube([flange_t, flange_d, panel_h]);                         // flange
            translate([0, 0, panel_h - plate_t]) cube([box_x1, top_d, plate_t]);
            cube([box_x1, shelf_d, plate_t]);                            // shelf
            // face/plate fillets (45 deg, print-safe face down)
            for (z = [plate_t, panel_h - plate_t])
                translate([flange_t, face_t, z])
                    rotate([0, 90, 0]) linear_extrude(box_x1 - flange_t)
                        polygon(z < panel_h / 2
                            ? [[0, 0], [-fillet, 0], [0, fillet]]
                            : [[0, 0], [fillet, 0], [0, fillet]]);
        }
        // keystone openings + rear latch clearance
        for (i = [0 : n - 1]) {
            x = port_x(free, i);
            translate([x - ks_w / 2, -eps, (panel_h - ks_h) / 2])
                cube([ks_w, face_t + 2 * eps, ks_h]);
        }
        translate([flange_t + eps, clip_t, (panel_h - latch_h) / 2])
            cube([inner_w(free) - 2 * eps, face_t, latch_h]);
        // rack slots
        for (z = rack_hole_z)
            translate([w - rack_hole_from_edge, face_t + eps, z])
                rotate([90, 0, 0]) linear_extrude(face_t + 2 * eps)
                    slot(rack_slot[0], rack_slot[1]);
        // chassis side slots
        for (z = side_slot_z)
            translate([-eps, (side_slot_y[0] + side_slot_y[1]) / 2, z])
                rotate([0, 90, 0]) rotate([0, 0, 90])
                    linear_extrude(flange_t + 2 * eps)
                        slot(side_slot_y[1] - side_slot_y[0], side_screw_d);
        // zip-tie slot pair behind each port
        for (i = [0 : n - 1], s = [-1, 1])
            translate([port_x(free, i) + s * 5 - 1.1, shelf_d - 9, -eps])
                cube([2.2, 4.5, plate_t + 2 * eps]);
    }
}

// side = 1 right, -1 left. first = number of the leftmost port.
module ear(side, free, first) {
    n = n_ports(free);
    difference() {
        mirror([side < 0 ? 1 : 0, 0, 0]) ear_body(free);
        if (labels) for (i = [0 : n - 1]) {
            num = side > 0 ? first + i : first + n - 1 - i;
            translate([side * port_x(free, i), label_depth,
                       (panel_h + latch_h) / 2 + 1.2])
                rotate([90, 0, 0]) linear_extrude(label_depth + 1)
                    text(str(num), size = label_size, halign = "center",
                         font = "Liberation Sans:style=Bold");
        }
    }
}

module left()  ear(-1, left_free, 1);
module right() ear(1, right_free, nL + 1);

// face down on the bed
module print_pose() rotate([90, 0, 0]) children();

if (part == "right") print_pose() right();
if (part == "left")  print_pose() left();
if (part == "plate") {
    // stacked front-to-back, ~60mm apart, to stay clear of the bed edges
    translate([-(right_free + ear_w) / 2, 60, 0]) print_pose() right();
    translate([(left_free + ear_w) / 2, 0, 0]) print_pose() left();
}
if (part == "assembly") {
    translate([fw_w / 2, 0, 0]) right();
    translate([-fw_w / 2, 0, 0]) left();
    %translate([-fw_w / 2, 2, 1]) cube([fw_w, 200, panel_h - 2]);
}
