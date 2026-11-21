// Firewall (YHLD-SERV2) keystone rack ears, YHLR-SVRK1
//
// Replaces the firewall's two L-shaped 1U ears (stock: 120mm wide, 2mm steel)
// with printed ears that hold keystones in the free width each side. The
// firewall sits fw_offset off centre (limited by the SFP+ DAC reach).
// This frees the 1U patch panel slot.
//
//   right ear: cutout for one 8-port snap-in insert from the old patch panel
//   left ear:  printed keystone sockets
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
// Assembly: screw ears to the firewall on the desk (driver goes in from the
// outer side, through the end wall holes on the right ear), rack it, then
// snap the insert in from the front and keystones in from the rear.
//
// Export: see Makefile.
// part = "right" | "left" | "plate" | "test-module" | "test-socket" | "assembly"

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

left_kind  = "sockets";      // "module" | "sockets" | "plain"
right_kind = "module";
max_sockets = 2;             // per ear; fewer sockets = thicker walls between

/* [Rack: EIA-310] */
panel_h  = 43.66;             // 1U minus 1/32"
ear_w    = (482.6 - 450) / 2; // 16.3, ear over the rail
rail_clr = 1;                 // gap to rail inner edge
rack_hole_z = [6.35, 38.1] - [1, 1] * (44.45 - 43.66) / 2;
rack_hole_from_edge = (482.6 - 465.1) / 2; // 8.75
rack_slot = [10, 6.6];        // M6 cage nut slot, w x h

/* [Patch panel insert] */
// 8-port snap-in insert: 144 x 44 bezel, body behind it snaps into a cutout.
// Cutout measured on the old metal frame (centred in height). It sits hard
// against the chassis flange to keep patch cables short. Print "test-module"
// to check the snap.
mod_cut_w   = 138.2; // cutout width, measured
mod_cut_h   = 33.5;  // cutout height: 35 measured on the frame, but the
                     // test print needed 1.5 less for the tabs to latch
mod_clr     = 0.1;   // print clearance per side
mod_cut_dz  = 0;     // cutout centre above panel centre
mod_panel_t = 1.6;   // lip thickness the insert's tabs latch behind, measured
mod_lip     = 2;     // width of that lip around the cutout
mod_ports   = 8;
mod_pitch   = 17.4;
mod_bezel   = [144, 2.5, 44]; // w, thickness, h: preview only

/* [Keystone socket] */
ks_w      = 15.0;  // front opening
ks_h      = 16.5;
ks_pitch  = 16.5;  // minimum: 1.5mm web
// Depths from the front face. The fixed hook (bottom) and sprung latch (top)
// each sit in a pocket, held by a 45 deg catch at the rear. Print
// "test-socket" first.
ks_d      = 10;    // socket depth
hook_d    = 2;     // hook pocket height
hook_y    = 6.5;   // hook pocket starts
latch_d   = 5.5;   // latch pocket height (test prints: 4 too tight, 6 loose)
latch_y   = 4;     // latch pocket starts
hook_catch  = 2;   // catch overhang at the rear; the rear entry is
latch_catch = 2;   // ks_h + hook_d + latch_d - both = 20 (18.5 too tight
                   // for the latch to flex through, 20.5 loose)
ks_wall   = 3;     // above / below the pockets

/* [Body] */
face_t    = 4;
plate_t   = 2.5;   // top / bottom plates, end wall
flange_t  = 4;     // against the chassis
box_d     = 60;    // plates; deep to resist the firewall twisting the ear
flange_d  = 70;
fillet    = 3;

/* [Labels] */
labels    = true;
label_size = 4;
label_depth = 0.6;

$fn = 48;
eps = 0.01;

// chassis side -> rail inner edge
left_free  = (450 - fw_w) / 2 + fw_offset;
right_free = (450 - fw_w) / 2 - fw_offset;

function inner_w(free) = free - rail_clr - flange_t;

// sockets are spread evenly across the inner width
function n_sockets(free) =
    max(0, min(max_sockets, floor(inner_w(free) / ks_pitch)));
function socket_x(free, i) = flange_t + inner_w(free) * (i + 0.5) / n_sockets(free);

// insert cutout, hard against the chassis flange
cut_w  = mod_cut_w + 2 * mod_clr;
cut_h  = mod_cut_h + 2 * mod_clr;
mod_x0 = flange_t + mod_lip;
mod_z0 = (panel_h - cut_h) / 2 + mod_cut_dz;
function mod_port_x(i) = mod_x0 + cut_w / 2 + (i - (mod_ports - 1) / 2) * mod_pitch;

function n_ports(kind, free) =
    kind == "module" ? mod_ports : kind == "sockets" ? n_sockets(free) : 0;
nL = n_ports(left_kind, left_free);
nR = n_ports(right_kind, right_free);
echo(str("ports: left ", nL, ", right ", nR, ", total ", nL + nR));
for (s = [[left_kind, left_free], [right_kind, right_free]])
    if (s[0] == "module")
        assert(mod_x0 + cut_w + mod_lip <= s[1] - rail_clr - plate_t,
               "insert does not fit");

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

ks_z = (panel_h - ks_h) / 2; // bottom of the socket opening

// One keystone socket, cut from the front (y=0) to ks_d. Origin: bottom
// left of the opening. Profile is in (y, z), extruded across the opening.
module ks_cut(w = ks_w, latch_catch = latch_catch) {
    rotate([90, 0, 90]) linear_extrude(w) {
        translate([-eps, 0]) square([ks_d + 2 * eps, ks_h]);
        polygon([[hook_y, eps], [hook_y, -hook_d], [ks_d - hook_catch, -hook_d],
                 [ks_d, hook_catch - hook_d], [ks_d + eps, hook_catch - hook_d],
                 [ks_d + eps, eps]]);
        polygon([[latch_y, ks_h - eps], [latch_y, ks_h + latch_d],
                 [ks_d - latch_catch, ks_h + latch_d],
                 [ks_d, ks_h + latch_d - latch_catch],
                 [ks_d + eps, ks_h + latch_d - latch_catch], [ks_d + eps, ks_h - eps]]);
    }
}

// zip-tie slot pair in the shelf behind a port at x
module tie_slots(x) {
    for (s = [-1, 1])
        translate([x + s * 5 - 1.1, box_d - 9, -eps])
            cube([2.2, 4.5, plate_t + 2 * eps]);
}

// Ear in the right-hand frame.
module ear_body(kind, free) {
    w = free + ear_w;
    box_x1 = free - rail_clr;
    n = n_ports(kind, free);
    lip_z0 = max(plate_t, mod_z0 - mod_lip);
    lip_z1 = min(panel_h - plate_t, mod_z0 + cut_h + mod_lip);
    difference() {
        union() {
            cube([w, face_t, panel_h]);                                  // face
            cube([flange_t, flange_d, panel_h]);                         // flange
            if (kind != "plain") for (z = [0, panel_h - plate_t])        // plates
                translate([0, 0, z]) cube([box_x1, box_d, plate_t]);
            if (kind == "module") {
                translate([box_x1 - plate_t, 0, 0])                      // end wall
                    cube([plate_t, box_d, panel_h]);
                translate([mod_x0 - mod_lip, 0, lip_z0])                 // collar
                    cube([cut_w + 2 * mod_lip, mod_panel_t, lip_z1 - lip_z0]);
            }
            if (kind == "sockets") {
                translate([flange_t, 0, ks_z - hook_d - ks_wall])
                    cube([inner_w(free), ks_d, ks_h + hook_d + latch_d + 2 * ks_wall]);
                // face/plate fillets (45 deg, print-safe face down)
                for (z = [plate_t, panel_h - plate_t])
                    translate([flange_t, face_t, z])
                        rotate([0, 90, 0]) linear_extrude(box_x1 - flange_t)
                            polygon(z < panel_h / 2
                                ? [[0, 0], [-fillet, 0], [0, fillet]]
                                : [[0, 0], [fillet, 0], [0, fillet]]);
            }
        }
        rack_slots(w);
        side_slots(flange_t);
        if (kind == "sockets") for (i = [0 : n - 1]) {
            translate([socket_x(free, i) - ks_w / 2, 0, ks_z]) ks_cut();
            tie_slots(socket_x(free, i));
        }
        if (kind == "module") {
            translate([mod_x0, -eps, mod_z0])
                cube([cut_w, max(face_t, mod_panel_t) + 2 * eps, cut_h]);
            // thin the face around the cutout if the frame is thinner
            if (mod_panel_t < face_t)
                translate([mod_x0 - mod_lip + eps, mod_panel_t, lip_z0])
                    cube([cut_w + 2 * mod_lip - eps, face_t, lip_z1 - lip_z0]);
            for (i = [0 : n - 1]) tie_slots(mod_port_x(i));
            // screwdriver access to the chassis screws, through the end
            // wall and the collar ends
            for (z = side_hole_z)
                translate([flange_t + eps, side_hole_y, z])
                    rotate([0, 90, 0]) cylinder(d = 7, h = box_x1 - flange_t);
        }
    }
}

// side = 1 right, -1 left. first = number of the leftmost socket.
module ear(side, kind, free, first) {
    n = n_ports(kind, free);
    difference() {
        mirror([side < 0 ? 1 : 0, 0, 0]) ear_body(kind, free);
        // the insert carries its own label strip
        if (labels && kind == "sockets") for (i = [0 : n - 1])
            translate([side * socket_x(free, i), label_depth, ks_z + ks_h + latch_d + 1])
                rotate([90, 0, 0]) linear_extrude(label_depth + 1)
                    text(str(side > 0 ? first + i : first + n - 1 - i),
                         size = label_size, halign = "center",
                         font = "Liberation Sans:style=Bold");
    }
}

module left()  ear(-1, left_kind, left_free, 1);
module right() ear(1, right_kind, right_free, nL + 1);

// face down on the bed
module print_pose() rotate([90, 0, 0]) children();

if (part == "right") print_pose() right();
if (part == "left")  print_pose() left();
if (part == "plate") {
    translate([-(right_free + ear_w) / 2, 60, 0]) print_pose() right();
    translate([(left_free + ear_w) / 2, 0, 0]) print_pose() left();
}
// front 11mm of the right ear, to check the insert snaps in and the
// chassis screws seat
if (part == "test-module") print_pose() intersection() {
    right();
    translate([-1, -1, -1]) cube([right_free + ear_w + 2, 12, panel_h + 2]);
}
// two-socket coupon, to check the keystone fit: [width, latch catch] per
// socket. The second socket is on the side with the cut corner.
test_sockets = [[14.8, 2.5], [14.6, 3]]; // rear entry 19.5, 19.0
if (part == "test-socket") print_pose() difference() {
    h = ks_h + hook_d + latch_d + 2 * ks_wall;
    cube([2 * ks_pitch, ks_d, h]);
    for (i = [0, 1])
        translate([(ks_pitch - test_sockets[i][0]) / 2 + i * ks_pitch, 0, hook_d + ks_wall])
            ks_cut(test_sockets[i][0], test_sockets[i][1]);
    translate([2 * ks_pitch, -eps, h]) rotate([-90, 0, 0])
        linear_extrude(ks_d + 2 * eps) polygon([[1, -1], [-2.5, -1], [1, 2.5]]);
}
if (part == "assembly") {
    x0 = -225 + left_free; // firewall left side
    translate([x0, 0, 0]) left();
    translate([x0 + fw_w, 0, 0]) right();
    %translate([x0, fw_recess, (panel_h - 43) / 2]) cube([fw_w, 184, 43]);
    if (right_kind == "module")                                          // bezel
        %translate([x0 + fw_w + mod_x0 + (cut_w - mod_bezel[0]) / 2,
                    -mod_bezel[1], (panel_h - mod_bezel[2]) / 2]) cube(mod_bezel);
}
