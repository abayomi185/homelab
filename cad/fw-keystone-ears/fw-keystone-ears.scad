// Firewall (YHLD-SERV2) keystone rack ears, YHLR-SVRK1
//
// Replaces the firewall's two L-shaped 1U ears (stock: 120mm wide, 2mm steel)
// with printed ears that hold keystones in the free width each side. The
// firewall sits fw_offset off centre (limited by the SFP+ DAC reach).
// This frees the 1U patch panel slot.
//
// Both ears are open frames with a cutout that an insert snaps into:
//   right ear: one 8-port snap-in insert from the old patch panel
//   left ear:  a printed 2-port keystone insert ("insert")
//
// Frame (right ear, left is mirrored):
//   x: 0 = firewall chassis side, + towards the rack rail
//   y: 0 = front face, + towards the rear
//   z: 0 = bottom of the panel
//
// Chassis side holes (measured): 2x M3 per side, 22mm apart centred on the
// chassis height, 5mm behind the chassis front. The chassis sits fw_recess
// behind the ear face so the screws clear the 4mm face; countersunk M3 heads
// sit flush in the flange.
//
// The firewall hangs from the front only, so each ear's flange runs back to
// a third chassis screw near the rear and the top / bottom plates are
// gussets from the rail to that flange. Without them the chassis rocks on
// the front screws and the rear droops. The flange is a lattice over the
// chassis side vent.
//
// Assembly: screw the empty ears to the firewall on the desk (driver goes in
// from the open outer side), rack it, snap the inserts in from the front and
// keystones in from the rear.
//
// Export: see Makefile.
// part = "right" | "left" | "insert" | "plate" | "test-module" |
//        "test-flange" | "assembly"

part = "assembly";

/* [Fit] */
fw_w = 240;                  // firewall chassis (vendor drawing: 240 x 184 x 43)
fw_offset = -50;             // chassis centre from rack centre, - = left
fw_recess = 2;               // chassis front behind ear face
side_hole_pitch = 22;        // vertical, centred
side_hole_y = fw_recess + 5; // from ear face
side_slot_len = 1;           // extra fore/aft play
side_screw_d = 3.4;          // M3 clearance
csk_d = 6.4;                 // M3 countersunk head (DIN 7991: 6.0)
csk_angle = 90;              // included angle of the head
// Rear chassis screw: level with the upper front hole. Distance scaled from
// a photo (163-168), so it gets a slot; pan head, no countersink. Print
// "test-flange" to check all three holes before the ears.
rear_hole_dy = 166;          // behind the front pair
rear_slot = [10, 4];         // length along y, height
vent_y = [22, 160];          // flange opening over the chassis side vent
vent_z = [4.5, 36];
strut_w = 4;                 // lattice struts across it

left_kind  = "slot";         // "module" | "slot" | "plain"
right_kind = "module";

/* [Rack: EIA-310] */
panel_h  = 43.66;             // 1U minus 1/32"
ear_w    = (482.6 - 450) / 2; // 16.3, ear over the rail
rail_clr = 1;                 // gap to rail inner edge
rack_hole_z = [6.35, 38.1] - [1, 1] * (44.45 - 43.66) / 2;
rack_hole_from_edge = (482.6 - 465.1) / 2; // 8.75
rack_slot = [10, 6.6];        // M6 cage nut slot, w x h

/* [Patch panel insert: "module"] */
// 8-port snap-in insert: 144 x 44 bezel, body behind it snaps into a cutout.
// Cutout measured on the old metal frame (centred in height) and settled on
// test prints. It sits hard against the chassis flange to keep patch cables
// short.
mod_cut_w   = 138.2; // cutout width, measured
mod_cut_h   = 33.5;  // cutout height: 35 measured on the frame, but the
                     // test print needed 1.5 less for the tabs to latch
mod_clr     = 0.1;   // print clearance per side
mod_cut_dz  = 0;     // cutout centre above panel centre
mod_panel_t = 1.6;   // lip thickness the insert's tabs latch behind, measured
mod_lip     = 2;     // width of that lip around the cutout
mod_ports   = 8;
mod_bezel   = [144, 2.5, 44]; // w, thickness, h: preview only

/* [Printed insert: "slot"] */
// Same cutout height and lip as the patch panel insert, slot_w wide. The
// insert has a bezel and a sprung arm at each end that latches behind the
// lip. The arm tips show in the bezel: lever them inwards to release.
slot_w    = 44;    // cutout width
ins_ports = 2;
ins_clr   = 0.15;  // insert body to cutout, per side
bezel_t   = 2.5;
bezel_lap = 3;     // bezel over the ear face, each side
arm_t     = 1.6;
arm_gap   = 1.2;   // room for the arm to flex
arm_w     = 10;    // along z
arm_len   = 20;    // behind the ear face
arm_cap   = 2.5;   // joins the arm to the body at the rear
barb      = 0.9;   // catch behind the lip
barb_len  = 2.5;
barb_clr  = 0.6;   // lip rear to barb (0.2 did not latch: the barb's
                   // underside sags when printed)
arm_clr   = 0.5;   // arm to the bezel slot around it

/* [Keystone socket] */
ks_w      = 14.9;  // front opening
ks_h      = 16.5;
// Depths from the socket front. The fixed hook (bottom) and sprung latch
// (top) each sit in a pocket, held by a 45 deg catch at the rear. Values
// settled on test prints.
ks_d      = 10;    // socket depth
hook_d    = 2;     // hook pocket height
hook_y    = 6.5;   // hook pocket starts
latch_d   = 5.5;   // latch pocket height (test prints: 4 too tight, 6 loose)
latch_y   = 4;     // latch pocket starts
hook_catch  = 2;   // catch overhang at the rear; the rear entry is
latch_catch = 2.25; // ks_h + hook_d + latch_d - both = 19.75 (19.5 too
                    // tight for the latch to flex through, 20 loose)
catch_land  = 0.25; // flat behind each catch slope: thickens the catch to
                    // take up front-to-back play

/* [Body] */
face_t    = 4;
plate_t   = 2.5;   // top / bottom plates
flange_t  = 4;     // against the chassis
box_d     = 25;    // plates at the rail end
plate_rib = 10;    // plates at the rear end of the flange
flange_d  = side_hole_y + rear_hole_dy + rear_slot[0] / 2 + 6;

/* [Labels] */
labels    = true;
label_size = 4;
label_depth = 0.6;

$fn = 48;
eps = 0.01;

// chassis side -> rail inner edge
left_free  = (450 - fw_w) / 2 + fw_offset;
right_free = (450 - fw_w) / 2 - fw_offset;

// cutout, hard against the chassis flange
function cut_w(kind) = kind == "module" ? mod_cut_w + 2 * mod_clr : slot_w;
cut_h  = mod_cut_h + 2 * mod_clr;
cut_x0 = flange_t + mod_lip;
cut_z0 = (panel_h - cut_h) / 2 + mod_cut_dz;

function n_ports(kind) = kind == "module" ? mod_ports : kind == "slot" ? ins_ports : 0;
echo(str("ports: left ", n_ports(left_kind), ", right ", n_ports(right_kind),
         ", total ", n_ports(left_kind) + n_ports(right_kind)));
for (s = [[left_kind, left_free], [right_kind, right_free]])
    if (s[0] != "plain")
        assert(cut_x0 + cut_w(s[0]) + mod_lip <= s[1] - rail_clr, "insert does not fit");
assert(mod_panel_t <= face_t);

module slot(len, d) {
    hull() for (s = [-1, 1]) translate([s * (len - d) / 2, 0]) circle(d = d);
}

module rack_slots(w) {
    for (z = rack_hole_z)
        translate([w - rack_hole_from_edge, face_t + eps, z])
            rotate([90, 0, 0]) linear_extrude(face_t + 2 * eps)
                slot(rack_slot[0], rack_slot[1]);
}

side_hole_z = [for (s = [-1, 1]) panel_h / 2 + s * side_hole_pitch / 2];

// countersunk M3 slots through a flange of thickness t, head on the +x side
module side_slots(t) {
    csk_h = (csk_d - side_screw_d) / 2 / tan(csk_angle / 2);
    for (z = side_hole_z)
        translate([0, side_hole_y, z])
            hull() for (dy = [-1, 1] * side_slot_len / 2)
                translate([0, dy, 0]) rotate([0, 90, 0]) {
                    translate([0, 0, -eps]) cylinder(d = side_screw_d, h = t + 2 * eps);
                    translate([0, 0, t - csk_h])
                        cylinder(d1 = side_screw_d, d2 = csk_d, h = csk_h + eps);
                }
}

// flange outline in (y, z)
module flange_2d() {
    vent = [vent_y[1] - vent_y[0], vent_z[1] - vent_z[0]];
    difference() {
        square([flange_d, panel_h]);
        translate([vent_y[0], vent_z[0]]) square(vent);
    }
    // 45 deg struts: carry shear, print without support
    intersection() {
        translate([vent_y[0], vent_z[0]]) square(vent);
        for (i = [0 : ceil(vent[0] / vent[1]) - 1])
            hull() for (e = [0, 1])
                translate([vent_y[0] + (i + e) * vent[1],
                           (i % 2 == 0) == (e == 0) ? vent_z[0] : vent_z[1]])
                    circle(d = strut_w);
    }
}

module rear_slot_2d() {
    translate([side_hole_y + rear_hole_dy, side_hole_z[1]])
        slot(rear_slot[0] + rear_slot[1], rear_slot[1]);
}

// top / bottom plate outline in (x, y): gusset from the rail end to the
// rear of the flange
module plate_2d(free) {
    x1 = free - rail_clr;
    polygon([[0, 0], [x1, 0], [x1, box_d], [flange_t + plate_rib, flange_d],
             [0, flange_d]]);
}

// Ear in the right-hand frame.
module ear_body(kind, free) {
    w = free + ear_w;
    lip_z0 = max(plate_t, cut_z0 - mod_lip);
    lip_z1 = min(panel_h - plate_t, cut_z0 + cut_h + mod_lip);
    difference() {
        union() {
            cube([w, face_t, panel_h]);                                  // face
            rotate([90, 0, 90]) linear_extrude(flange_t) flange_2d();    // flange
            for (z = [0, panel_h - plate_t])                             // plates
                translate([0, 0, z]) linear_extrude(plate_t) plate_2d(free);
        }
        rack_slots(w);
        side_slots(flange_t);
        translate([-eps, 0, 0]) rotate([90, 0, 90])
            linear_extrude(flange_t + 2 * eps) rear_slot_2d();
        if (kind != "plain") {
            translate([cut_x0, -eps, cut_z0])
                cube([cut_w(kind), face_t + 2 * eps, cut_h]);
            // thin the face to a lip around the cutout
            translate([cut_x0 - mod_lip + eps, mod_panel_t, lip_z0])
                cube([cut_w(kind) + 2 * mod_lip - eps, face_t, lip_z1 - lip_z0]);
        }
    }
}

module left()  mirror([1, 0, 0]) ear_body(left_kind, left_free);
module right() ear_body(right_kind, right_free);

ks_z = (panel_h - ks_h) / 2; // bottom of the socket opening

// One keystone socket, cut from its front (y=0) to ks_d. Origin: bottom
// left of the opening. Profile is in (y, z), extruded across the opening.
module ks_cut() {
    y1 = ks_d - catch_land; // catch slopes end
    rotate([90, 0, 90]) linear_extrude(ks_w) {
        translate([-eps, 0]) square([ks_d + 2 * eps, ks_h]);
        polygon([[hook_y, eps], [hook_y, -hook_d], [y1 - hook_catch, -hook_d],
                 [y1, hook_catch - hook_d], [ks_d + eps, hook_catch - hook_d],
                 [ks_d + eps, eps]]);
        polygon([[latch_y, ks_h - eps], [latch_y, ks_h + latch_d],
                 [y1 - latch_catch, ks_h + latch_d],
                 [y1, ks_h + latch_d - latch_catch],
                 [ks_d + eps, ks_h + latch_d - latch_catch], [ks_d + eps, ks_h - eps]]);
    }
}

// Printed keystone insert for a "slot" ear. x centred on the cutout, y = 0
// at the ear face (bezel in front of it), z as the ear. Symmetric, so it
// fits either ear. Socket fronts are flush with the bezel front.
module insert() {
    w    = slot_w - 2 * ins_clr;             // body
    z0   = cut_z0 + ins_clr;
    h    = cut_h - 2 * ins_clr;
    end  = arm_t + arm_gap;                  // arm + gap at each end
    wall = (w - 2 * end - ins_ports * ks_w) / (ins_ports + 1);
    az0  = (panel_h - arm_w) / 2;
    arm_y1 = arm_len - arm_cap;              // arm is free up to here
    assert(wall >= 1.6, "insert walls too thin");
    difference() {
        union() {
            translate([-slot_w / 2 - bezel_lap, -bezel_t, 0])            // bezel
                cube([slot_w + 2 * bezel_lap, bezel_t, panel_h]);
            translate([-w / 2, 0, z0]) cube([w, ks_d - bezel_t, h]);     // body
            for (m = [0, 1]) mirror([m, 0, 0])                           // arm posts
                translate([-w / 2, 0, az0]) cube([end + wall, arm_len, arm_w]);
        }
        for (i = [0 : ins_ports - 1])
            translate([-w / 2 + end + wall + i * (ks_w + wall), -bezel_t, ks_z]) ks_cut();
        // free the arms: through the bezel, up to the cap
        for (m = [0, 1]) mirror([m, 0, 0])
            translate([-w / 2 - arm_clr, -bezel_t - eps, az0 - arm_clr])
                cube([end + arm_clr, bezel_t + arm_y1 + eps, arm_w + 2 * arm_clr]);
        if (labels) for (i = [0 : ins_ports - 1])
            translate([-w / 2 + end + wall + i * (ks_w + wall) + ks_w / 2,
                       -bezel_t + label_depth, ks_z + ks_h + 3])
                rotate([90, 0, 0]) linear_extrude(label_depth + 1)
                    text(str(i + 1), size = label_size, halign = "center",
                         font = "Liberation Sans:style=Bold");
    }
    for (m = [0, 1]) mirror([m, 0, 0]) translate([-w / 2, 0, az0]) {
        translate([0, -bezel_t, 0]) cube([arm_t, bezel_t + arm_y1 + eps, arm_w]);
        translate([0, mod_panel_t + barb_clr, 0]) linear_extrude(arm_w)   // barb
            polygon([[eps, 0], [-barb, 0], [eps, barb_len]]);
    }
}

// face down on the bed
module print_pose() rotate([90, 0, 0]) children();
module insert_print() translate([0, 0, bezel_t]) print_pose() insert();

if (part == "right")  print_pose() right();
if (part == "left")   print_pose() left();
if (part == "insert") insert_print();
if (part == "plate") {
    translate([-(right_free + ear_w) / 2, 60, 0]) print_pose() right();
    translate([-10, 0, 0]) print_pose() left();
    translate([40, 0, 0]) insert_print();
}
// front 11mm of the right ear, to check the insert snaps in and the
// chassis screws seat
if (part == "test-module") print_pose() intersection() {
    right();
    translate([-1, -1, -1]) cube([right_free + ear_w + 2, 12, panel_h + 2]);
}
// 1.2mm template of the flange, to check the three chassis holes (fits
// either side)
if (part == "test-flange") linear_extrude(1.2) difference() {
    flange_2d();
    rear_slot_2d();
    for (z = side_hole_z) translate([side_hole_y, z])
        slot(side_slot_len + side_screw_d, side_screw_d);
}
if (part == "assembly") {
    x0 = -225 + left_free; // firewall left side
    translate([x0, 0, 0]) left();
    translate([x0 + fw_w, 0, 0]) right();
    if (left_kind == "slot")
        color("SteelBlue") translate([x0 - cut_x0 - slot_w / 2, 0, 0]) insert();
    %translate([x0, fw_recess, (panel_h - 43) / 2]) cube([fw_w, 184, 43]);
    if (right_kind == "module")                                          // bezel
        %translate([x0 + fw_w + cut_x0 + (cut_w("module") - mod_bezel[0]) / 2,
                    -mod_bezel[1], (panel_h - mod_bezel[2]) / 2]) cube(mod_bezel);
}
