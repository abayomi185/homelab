// JBOD 2U drive cage: 8x 3.5" (ST4000NM0034) in 4 printed 2-high sleds
//
// Layout A: F1-F3 sit side by side at the front, drives front-to-back. Their
// rear ends open into a plenum. A printed fan wall behind the plenum pulls air
// through the 5 mm drive gaps. A rib on F4 between the two fans makes the
// right fan feed only F4, a windowed sled turned sideways at the rear right;
// the left fan exhausts freely. Air leaves through the rear vents and the
// three low-profile PCIe slots, left open (the SFF-8088 cables pass through
// them). CHECK the rear vent open area is enough for two 80 mm fans.
//
//   rear +--------------+--------+--------------------+
//        | PSU          | SFF in |  F4 (windowed)     |
//        |              |        +-[fan]-[fan]--------+  fan wall
//        |              |  plenum (connectors)        |
//        | cables       |   F1   |   F2   |   F3      |
//        | ESP32        | (open bay)  (fixed grille)  |
//  front +--------------+-----------------------------+
//
// Frame: x = 0 left wall inner face, + right; y = 0 front panel inner face,
// + rear; z = 0 floor. All mm.
//
// Isolation: drives hang on 4 side screws each (6-32 x 3/8" pan head). Each
// screw clamps a rigid PETG sleeve to the drive, the sleeve rides in a TPU
// grommet, the grommet sits in the sled wall. No hard contact drive -> sled.
//
// Location: sleds sit on the floor with pockets over the 5 mm ATX standoffs
// and over screws left proud in the old cage holes (front pins; a pocket
// next to a side wall runs out through it). The fan-wall foot sits on the
// rear lips of F1-F3, so its 3 screws into the y~198 standoffs clamp all
// three. F4 has a slotted floor tab on the standoff near (251, 351): one
// screw and washer, reachable from above before cabling. The lid (0.5 mm
// clearance) is the backstop.
//
// Standoff and cage hole positions are photo estimates. Every pocket and
// screw hole on them is a slot +-slot_tol in x and y instead of measuring;
// the lip/foot overlap allows the same. Cage holes are threaded M3;
// standoffs are M3 or 6-32: the slots clear both, use the matching screw.
// Remove any screws already in the standoffs (taller than pocket_h).
//
// Foam (airflow only goes where it should once these are closed):
//   F4 right end             between the tube end and the right wall
//   F4 rib end               to the fan wall's rear face, if it gaps
//   PSU front                block to the fan wall's left end, or exhaust
//                            loops out the open front-left bay into F1
//   F3 rear ear              2.5 mm to the right wall
//   cable notches            around the SFF and SATA power cables
//
// MEASURE before printing:
//   esp_board                ESP32-C3 board size (SuperMini assumed)
//
// Materials: sleds, roofs, fan wall, sleeves, tray: PETG/ASA.
// grommet, fan_gasket: TPU 95A. No supports needed for any part.
//
// Parts (qty): sled_f1..f3 1 each (pockets differ), sled_f4 1, roof 4,
//   grommets (plate of 36, 32 needed), sleeves (plate of 36), fanwall_l 1,
//   fanwall_r 1, fan_gasket 2, esp_tray 1, washers (plate of
//   4). Export: Makefile.
//
// Hardware: 32x 6-32 x 3/8" pan head (drives), 4x M3 x 8 (or 6-32 x 5/16")
// pan head + printed washers (3 fan wall, 1 F4 tab; washer flat towards the
// fan wall, or towards a fan screw head if it fouls one), 8x fan screws,
// 6x M3 x 4-6 pan head left proud in old cage holes as locator pins.
//
// Assembly: grommets into sled walls from outside, sleeve into each grommet,
// drive in from the front, screw. Roof in from the front. Fans onto the fan
// wall on the bench. Drop F1-F3 onto their pins, then the fan wall (foot on
// the lips, screw to standoffs), then F4 (screw the tab), then cables.

part = "assembly";

/* [Chassis: measured] */
W_int = 423;    // measured ~423
D_int = 365;    // inside the front panel fold to rear wall
H_int = 86.5;   // measured
lid_clr = 0.5;
top = H_int - lid_clr;
psu = [150, 140, 86];
psu_x = 6;

/* [Chassis: photo estimates] */
slot_tol = 3.5;   // +- slack in x and y on every pocket/hole below
standoff_h = 5;
standoffs = [            // ATX pattern, read off the photo
  [251, 128], [407, 128],
  [187, 198], [251, 198], [407, 198],
  [203, 351], [251, 351], [400, 345], [408, 329]];
floor_holes = [          // old cage holes; drop a screw in to use as a pin
  [11, 28], [168, 28], [179, 28], [288, 28], [298, 28], [410, 28],
  [168, 90], [179, 90], [288, 90], [298, 90], [410, 90]];

/* [Drive: ST4000NM0034 / SFF-8301] */
drv = [101.85, 147, 26.11];   // w, l, h (datasheet max)
drv_screw_l = [28.5, 130.1];  // side holes from the CONNECTOR end (A8, A8 + A9)
drv_screw_z = 6.35;           // side hole height from drive bottom

/* [Sled] */
t        = 3;     // side wall
gap_side = 2.5;   // drive side to wall
air      = 5;     // air gaps below, between, above drives
floor_h  = 7.5;   // solid floor (pockets from below)
roof_t   = 2.5;
groove   = 1.5;   // roof slides into wall grooves from the front
band     = 3;     // rear collar / roof lips
d_off    = 1;     // drive front from sled front
pocket_d = 8.5;
pocket_h = standoff_h + 0.5;
head_prot = 4;    // screw head + grommet flange beyond the wall
lip_l    = 12;    // F1-F3 rear floor lip, under the fan-wall foot
screw_d  = 4;     // mount screw slots: clears M3 and 6-32
washer_d = 2*slot_tol + screw_d + 5;
washer_flat = 3.2;  // flat side, clears the fan wall
sled_gap = 9;     // between sleds (2x head_prot + 1)

W = drv[0] + 2*gap_side + 2*t;   // 112.85
L = drv[1] + 2*d_off;            // 149
z_d1 = floor_h + air;
z_d2 = z_d1 + drv[2] + air;
roof_z0 = z_d2 + drv[2] + air;
roof_z1 = roof_z0 + roof_t;
screw_y = [for (s = drv_screw_l) d_off + drv[1] - s];  // connector at the rear
screw_z = [z_d1 + drv_screw_z, z_d2 + drv_screw_z];

/* [Isolation] */
grom_hole = 9.2;
grom_core = 9;
grom_fl   = 13;
grom_out  = 1.6;   // outer flange (under screw head)
grom_in   = 2.2;   // inner flange, < gap_side
grom_bore = 5.3;
sleeve_d  = 5;
sleeve_id = 3.7;   // 6-32
preload   = 0.3;
sleeve_l  = gap_side + t + grom_out - preload;  // 6.8; 3/8" screw -> 2.7 mm thread

/* [Placement] */
front_gap = 5;
rank_y = front_gap;
f3_x = W_int - 1 - head_prot - W;
rank_x = [f3_x - 2*(W + sled_gap), f3_x - (W + sled_gap), f3_x];
ear = sled_gap / 2;
ear_r_last = W_int - lid_clr - (f3_x + W) - 2;  // 2 mm width slack: foam
plenum_x0 = rank_x[0] - ear - t;   // plenum left wall outer face

/* [Fan wall] */
fan = 80;
fan_t = 25;
fan_hole = 71.5;
fan_d = 77;
fan_x = [W_int - 1 - 2*fan - 4, W_int - 1 - fan];  // left edges
fan_z0 = top - fan;
gasket_t = 1.5;
fw_y = 205;       // front face; standoffs at y~198 sit under the foot
fw_t = 4;
foot_t = 3;
foot_gap = 4;     // foot front to sled rears, > slot_tol
foot_d = fw_y - (rank_y + L + foot_gap);  // reaches over the sled lips
fan_head_d = 10.6;  // lower fan screw heads sink into the foot
split_x = 240;
cable_notch = [[200, 235], 22];  // SFF cables into plenum: x range, height
sata_notch  = [[165, 195], 22];   // SATA power through plenum left wall: y range
spoke = [2, 2];   // cable guard bars across the fan holes: width, thickness
fw_standoffs = [for (s = standoffs)
  if (s[1] > fw_y - foot_d + 3 && s[1] < fw_y - 3) s];

/* [F4] */
fan_rear = fw_y + fw_t + gasket_t + fan_t;
f4_front_x = W_int - 4;   // drive front end (right)
f4_y = fan_rear + (D_int - fan_rear - (W + 2*head_prot)) / 2 + head_prot;
f4_tab = [351 - f4_y, f4_front_x - 251];  // standoff past the connector end, sled coords
tab_h = standoff_h + foot_t;
rib_t = 2.4;              // rib between the fans (4 mm apart), on F4's front wall
rib_ly = f4_front_x - (fan_x[0] + fan + fan_x[1]) / 2;   // along the sled
rib_l = f4_y - (fw_y + fw_t) - 1;                         // to 1 mm off the fan wall
win_post = 7;             // half width of solid post around screws
win_mullion = 3;
win_max_bridge = 28;

/* [ESP32-C3 tray] */
esp_board = [18.2, 22.8, 1.0];  // SuperMini w, l, pcb
esp_wall = 1.6;
esp_pos = [3, 10];
esp_hole = floor_holes[0];

$fn = 48;
eps = 0.01;

// ---------- helpers ----------

// teardrop hole along x, point up (+z), for walls printed upright
module hole_x(d, l) {
  r = d / 2;
  rotate([90, 0, 90]) linear_extrude(l, center = true)
    intersection() {
      hull() { circle(r); rotate(45) square(r); }
      translate([-r, -r]) square([2*r, 2.2*r]);
    }
}

// hole with +-slot_tol slack in x and y
module slot_hole(d, h) {
  hull() for (i = [-1, 1], j = [-1, 1])
    translate([i * slot_tol, j * slot_tol, 0]) cylinder(d = d, h = h);
}

pocket_r = pocket_d/2 + slot_tol;   // pocket reach from its point
pocket_skin = 1.5;                  // least material left beside a pocket

// locator pocket; next to a side wall it runs out through the wall instead
// of leaving a thin skin (the six cage-hole pins all sit there)
module pocket(p) {
  hull() for (x = [p[0], if (p[0] < pocket_r + pocket_skin) -pocket_r,
                   if (p[0] > W - pocket_r - pocket_skin) W + pocket_r])
    translate([x, p[1], -1]) slot_hole(pocket_d, pocket_h + 1);
}

// pocket over a standoff with a slotted screw hole above it. The 45 deg
// roof prints without a bridge
module screw_pocket() {
  translate([0, 0, -1]) slot_hole(pocket_d, standoff_h + 1);
  hull() for (i = [-1, 1], j = [-1, 1])
    translate([i * slot_tol, j * slot_tol, standoff_h - eps])
      cylinder(d1 = pocket_d, d2 = screw_d, h = (pocket_d - screw_d) / 2);
  slot_hole(screw_d, 20);
}

// mx, my: margins. Sled sides get pocket_ms (pockets may run out there),
// sled ends pocket_me
function in_rect(p, x0, y0, x1, y1, mx, my) =
  p[0] > x0 + mx && p[0] < x1 - mx && p[1] > y0 + my && p[1] < y1 - my;
pocket_ms = pocket_d/2;
pocket_me = pocket_r + pocket_skin;

// locator points under a sled at chassis (x0, y0), unrotated
function pockets_rank(x0, y0) = [for (p = concat(standoffs, floor_holes))
  if (in_rect(p, x0, y0, x0 + W, y0 + L, pocket_ms, pocket_me)) [p[0] - x0, p[1] - y0]];

// F4: local (lx, ly) -> chassis (f4_front_x - ly, f4_y + lx)
function pockets_f4() = [for (p = concat(standoffs, floor_holes))
  if (in_rect(p, f4_front_x - L, f4_y, f4_front_x, f4_y + W, pocket_me, pocket_ms))
    [p[1] - f4_y, f4_front_x - p[0]]];

// window segments along the sled length, split by posts and mullions
function win_spans() =
  let (a = min(screw_y), b = max(screw_y),
       edges = [band + 1, a - win_post, a + win_post,
                rib_ly - win_mullion/2, rib_ly + win_mullion/2,   // rib root
                b - win_post, b + win_post, L - band - 1])
  [for (i = [0 : 2 : 6]) [edges[i], edges[i + 1]]];

module windows() {
  for (s = win_spans()) {
    len = s[1] - s[0];
    n = ceil((len + win_mullion) / (win_max_bridge + win_mullion));
    w = (len - (n - 1) * win_mullion) / n;
    for (i = [0 : n - 1])
      translate([-1, s[0] + i * (w + win_mullion), floor_h])
        cube([W + 2, w, roof_z0 - 1.5 - floor_h]);
  }
}

// ---------- parts ----------

module sled(win = false, ear_l = 0, ear_r = 0, pockets = []) {
  difference() {
    union() {
      cube([W, L, floor_h]);
      for (x = [0, W - t]) translate([x, 0, 0]) cube([t, L, top]);
      if (!win) {   // rear collar ears close the gaps to neighbours
        translate([-ear_l, L - band, 0]) cube([ear_l + eps, band, top]);
        translate([W - eps, L - band, 0]) cube([ear_r + eps, band, top]);
        // rear lip: the fan-wall foot clamps it to the floor
        translate([0, L - eps, 0]) cube([W, lip_l + eps, standoff_h]);
      } else {
        // F4 floor tab onto its standoff
        translate([f4_tab[0] - pocket_r - 2, L - eps, 0])
          cube([2*pocket_r + 4, f4_tab[1] + pocket_r + 2 - L + eps, tab_h]);
        // F4 rib: drops between the fans, splits their outlets
        translate([-rib_l, rib_ly - rib_t/2, 0]) cube([rib_l + eps, rib_t, top]);
      }
    }
    for (x = [t - groove, W - t])
      translate([x, -1, roof_z0 - 0.2]) cube([groove, L - band + 1, roof_t + 0.4]);
    for (y = screw_y, z = screw_z) translate([W/2, y, z]) hole_x(grom_hole, W + 2);
    if (win) windows();
    for (p = pockets) pocket(p);
    if (win) translate([f4_tab[0], f4_tab[1], 0]) screw_pocket();
  }
}

// slides into the wall grooves from the front; end lips close the space
// above it to the lid (printed flat, lips up)
module roof() {
  rw = W - 2*t + 2*groove - 0.4;
  rl = L - band - 0.5;
  lip_w = W - 2*t - 0.6;
  cube([rw, rl, roof_t]);
  for (y = [0, rl - band])
    translate([(rw - lip_w) / 2, y, 0]) cube([lip_w, band, top - roof_z0 - 0.3]);
}

// printed outer flange down; inner flange is a 45 deg cone, pushed through from outside
module grommet() {
  difference() {
    union() {
      cylinder(d = grom_fl, h = grom_out);
      cylinder(d = grom_core, h = grom_out + t);
      translate([0, 0, grom_out + t]) {
        cylinder(d1 = grom_core, d2 = grom_fl, h = (grom_fl - grom_core) / 2);
        translate([0, 0, (grom_fl - grom_core) / 2 - eps])
          cylinder(d = grom_fl, h = grom_in - (grom_fl - grom_core) / 2 + eps);
      }
    }
    translate([0, 0, -1]) cylinder(d = grom_bore, h = 20);
  }
}

module sleeve() {
  difference() {
    cylinder(d = sleeve_d, h = sleeve_l);
    translate([0, 0, -1]) cylinder(d = sleeve_id, h = sleeve_l + 2);
  }
}

module fan_holes() {
  for (fx = fan_x) {
    translate([fx + fan/2, 0, fan_z0 + fan/2]) rotate([-90, 0, 0]) {
      translate([0, 0, -1]) cylinder(d = fan_d, h = fw_t + 2, $fn = 96);
      for (i = [-1, 1], j = [-1, 1])
        translate([i * fan_hole/2, j * fan_hole/2, -1]) cylinder(d = 4.4, h = fw_t + 2);
    }
  }
}

// dovetail in the x-z plane at x = split_x, tab points +x
module dovetails(c = 0) {
  for (z = [18, top/2, top - 18])
    translate([split_x, fw_y - 1, z]) rotate([-90, 0, 0])
      linear_extrude(fw_t + 2)
        offset(delta = c) polygon([[-eps, -6], [8, -9], [8, 9], [-eps, 6]]);
}

module fanwall_full() {
  difference() {
    union() {
      translate([plenum_x0, fw_y, 0]) cube([W_int - lid_clr - plenum_x0, fw_t, top]);
      // foot on the standoffs
      translate([plenum_x0, fw_y - foot_d, standoff_h])
        cube([W_int - lid_clr - plenum_x0, foot_d + eps, foot_t]);
      // plenum left wall, overlaps F1's collar ear
      translate([plenum_x0, rank_y + L - band, 0])
        cube([t, fw_y - (rank_y + L - band) + eps, top]);
    }
    translate([0, fw_y, 0]) fan_holes();
    for (s = fw_standoffs) {
      translate([s[0], s[1], 0]) slot_hole(screw_d, 20);
      // wall base clears a standoff that sits further back than estimated
      translate([s[0] - slot_tol - 4, fw_y - eps, -1]) cube([2*slot_tol + 8, 2 + eps, pocket_h + 1]);
    }
    // lower fan screws: head pocket in the foot, driver groove along it
    for (fx = fan_x, i = [-1, 1])
      translate([fx + fan/2 + i * fan_hole/2, fw_y, fan_z0 + (fan - fan_hole)/2]) rotate([90, 0, 0]) {
        cylinder(d = fan_head_d, h = 8);
        cylinder(d = 7.5, h = foot_d + 1);
      }
    translate([cable_notch[0][0], fw_y - foot_d - 1, -1])
      cube([cable_notch[0][1] - cable_notch[0][0], foot_d + fw_t + 2, cable_notch[1] + 1]);
    // no foot sliver between the cable notch and the split
    translate([cable_notch[0][1] - eps, fw_y - foot_d - 1, standoff_h - eps])
      cube([split_x - cable_notch[0][1] + 2*eps, foot_d + 1, foot_t + 1]);
    translate([plenum_x0 - 1, sata_notch[0][0], -1])
      cube([t + 2, sata_notch[0][1] - sata_notch[0][0], sata_notch[1] + 1]);
  }
  // cable guards: 3 thin bars across each fan hole, on the bed side
  for (fx = fan_x, i = [-1 : 1])
    translate([fx + fan/2 + i * fan_d/4 - spoke[0]/2, fw_y + fw_t - spoke[1], fan_z0 + 1])
      cube([spoke[0], spoke[1], fan - 2]);
}

module fanwall_l() {
  difference() {
    union() {
      intersection() { fanwall_full(); translate([-1, -1, -1]) cube([split_x + 1, D_int, 100]); }
      intersection() { fanwall_full(); dovetails(0); }
    }
  }
}

module fanwall_r() {
  difference() {
    intersection() { fanwall_full(); translate([split_x, -1, -1]) cube([W_int, D_int, 100]); }
    dovetails(0.2);
  }
}

module fan_gasket() {
  difference() {
    translate([-fan/2, -fan/2, 0]) cube([fan, fan, gasket_t]);
    translate([0, 0, -1]) cylinder(d = fan_d, h = 5, $fn = 96);
    for (i = [-1, 1], j = [-1, 1])
      translate([i * fan_hole/2, j * fan_hole/2, -1]) cylinder(d = 4.6, h = 5);
  }
}

// ESP32-C3 SuperMini tray: board drops in, USB-C end open, screws to a floor hole
module esp_tray() {
  bw = esp_board[0] + 2*esp_wall + 0.4;
  bl = esp_board[1] + esp_wall + 0.4;
  hx = esp_hole[0] - esp_pos[0];
  hy = esp_hole[1] - esp_pos[1];
  difference() {
    union() {
      cube([max(bw, hx + slot_tol + 4), bl + hy + slot_tol + 4, 2]);
      translate([0, hy + slot_tol + 4, 0]) cube([bw, bl, 2 + 3]);
    }
    // board pocket, open at the +y end for USB-C
    translate([esp_wall, hy + slot_tol + 4 + esp_wall, 2]) cube([esp_board[0] + 0.4, bl, 10]);
    // lips over the board edge
    translate([esp_wall + 1.2, hy + slot_tol + 4 + esp_wall, 2 + esp_board[2] + 0.2 + 1.2])
      cube([esp_board[0] + 0.4 - 2.4, bl, 10]);
    translate([hx, hy, -1]) slot_hole(3.4, 10);
  }
}

// spreads a screw head over a slot; the flat clears the fan wall
module washer() {
  difference() {
    intersection() {
      cylinder(d = washer_d, h = 2);
      translate([-washer_d, -washer_d, 0]) cube([2*washer_d, washer_d + washer_flat, 2]);
    }
    translate([0, 0, -1]) cylinder(d = screw_d, h = 4);
  }
}

// ---------- assembly ----------

module drive_pair() {
  for (z = [z_d1, z_d2]) {
    color("dimgray") translate([t + gap_side, d_off, z]) cube([drv[0], drv[1], drv[2]]);
    color("goldenrod") translate([t + gap_side + 10, L, z + 2]) cube([40, 15, 8]);
  }
}

module chassis() {
  color("silver", 0.25) {
    translate([-1, -1, -1]) cube([W_int + 2, D_int + 2, 1]);
    translate([-1, -1, 0]) cube([1, D_int + 2, H_int]);
    translate([W_int, -1, 0]) cube([1, D_int + 2, H_int]);
    translate([-1, D_int, 0]) cube([W_int + 2, 1, H_int]);
  }
  color("black", 0.6) translate([psu_x, D_int - psu[1], 0]) cube(psu);
  color("red") for (s = standoffs) translate([s[0], s[1], 0]) cylinder(d = 6, h = standoff_h, $fn = 6);
  color("orange") for (h = floor_holes) translate([h[0], h[1], 0]) cylinder(d = 3, h = 0.5);
}

module assembly() {
  chassis();
  for (i = [0 : 2])
    translate([rank_x[i], rank_y, 0]) {
      color("steelblue") sled(false, ear, i == 2 ? ear_r_last : ear,
                              pockets_rank(rank_x[i], rank_y));
      color("lightsteelblue") translate([t - groove + 0.2, 0, roof_z0]) roof();
      drive_pair();
    }
  translate([f4_front_x, f4_y, 0]) rotate([0, 0, 90]) {
    color("teal") sled(true, pockets = pockets_f4());
    color("lightsteelblue") translate([t - groove + 0.2, 0, roof_z0]) roof();
    drive_pair();
  }
  color("darkorange") fanwall_l();
  color("orange") fanwall_r();
  color("black", 0.8) for (fx = fan_x)
    translate([fx, fw_y + fw_t + gasket_t, fan_z0]) cube([fan, fan_t, fan]);
  color("green") translate([esp_pos[0], esp_pos[1], 0]) esp_tray();
}

// ---------- output ----------

// print orientation for the fan wall: rear face on the bed
module fw_flat() { rotate([-90, 0, 0]) translate([0, -(fw_y + fw_t), 0]) children(); }

module grid(n, pitch) {
  cols = ceil(sqrt(n));
  for (i = [0 : n - 1]) translate([(i % cols) * pitch, floor(i / cols) * pitch, 0]) children();
}

if (part == "assembly") assembly();
else if (part == "sled_f1") sled(false, ear, ear, pockets_rank(rank_x[0], rank_y));
else if (part == "sled_f2") sled(false, ear, ear, pockets_rank(rank_x[1], rank_y));
else if (part == "sled_f3") sled(false, ear, ear_r_last, pockets_rank(rank_x[2], rank_y));
else if (part == "sled_f4") sled(true, pockets = pockets_f4());
else if (part == "roof") roof();
else if (part == "grommets") grid(36, grom_fl + 3) grommet();
else if (part == "washers") grid(4, washer_d + 3) washer();
else if (part == "sleeves") grid(36, sleeve_d + 4) sleeve();
else if (part == "fanwall_l") fw_flat() fanwall_l();
else if (part == "fanwall_r") fw_flat() fanwall_r();
else if (part == "fan_gasket") fan_gasket();
else if (part == "esp_tray") esp_tray();
else if (part == "info") {
  echo(W = W, L = L, rank_x = rank_x, f4_y = f4_y, plenum_x0 = plenum_x0,
       ear_r_last = ear_r_last, sleeve_l = sleeve_l,
       f1 = pockets_rank(rank_x[0], rank_y), f2 = pockets_rank(rank_x[1], rank_y),
       f3 = pockets_rank(rank_x[2], rank_y), f4 = pockets_f4(),
       fw_standoffs = fw_standoffs, roof_z1 = roof_z1, screw_y = screw_y,
       foot_d = foot_d, f4_tab = f4_tab,
       f4_gap_front = f4_y - fan_rear, f4_gap_rear = D_int - f4_y - W,
       f4_gap_right = W_int - f4_front_x);
  cube(1);
}
