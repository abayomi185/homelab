// JBOD 2U drive cage: 8x 3.5" (ST4000NM0034) in 4 printed 2-high sleds
//
// Layout A: F1-F3 sit side by side at the front, drives front-to-back. Their
// rear ends open into a plenum. A printed fan wall behind the plenum pulls air
// through the 5 mm drive gaps and pushes it through F4, a windowed sled turned
// sideways at the rear right, then out the rear vents.
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
// (and over screw heads left proud in the old cage holes). The lid stops
// them lifting (0.5 mm clearance). The fan wall screws into 3 standoffs.
//
// Standoff and cage hole positions are photo estimates. Every pocket and
// screw hole on them is a slot +-slot_tol in x and y instead of measuring.
// Cage holes are threaded M3; standoffs assumed M3.
//
// MEASURE before printing:
//   slot_cover_*             against a stock low-profile cover
//   esp_board                ESP32-C3 board size (SuperMini assumed)
//
// Materials: sleds, roofs, fan wall, sleeves, tray, covers: PETG/ASA.
// grommet, fan_gasket: TPU 95A. No supports needed for any part.
//
// Parts (qty): sled_f1..f3 1 each (pockets differ), sled_f4 1, roof 4,
//   grommets (plate of 36, 32 needed), sleeves (plate of 36), fanwall_l 1,
//   fanwall_r 1, fan_gasket 2, slot_cover 2, esp_tray 1, washers (plate of
//   4). Export: Makefile.
//
// Hardware: 32x 6-32 x 3/8" pan head (drives), 4x M3 x 8 pan head + printed
// washers (fan wall to standoffs, ESP32 tray to cage hole), 8x fan screws,
// 6x M3 x 4-6 pan head left proud in old cage holes as locator pins. Seal
// cable notches with foam.
//
// Assembly: grommets into sled walls from outside, sleeve into each grommet,
// drive in from the front, screw. Roof in from the front. Drop sleds onto
// their pins; fan wall last (screw foot to standoffs), then cables.

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
drv_screw_l = [28.5, 130.1];  // side holes from drive front
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
sled_gap = 9;     // between sleds (2x head_prot + 1)

W = drv[0] + 2*gap_side + 2*t;   // 112.85
L = drv[1] + 2*d_off;            // 149
z_d1 = floor_h + air;
z_d2 = z_d1 + drv[2] + air;
roof_z0 = z_d2 + drv[2] + air;
roof_z1 = roof_z0 + roof_t;
screw_y = [for (s = drv_screw_l) d_off + s];
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
ear_r_last = W_int - lid_clr - (f3_x + W);
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
foot_d = 15;
split_x = 240;
cable_notch = [[200, 235], 22];  // SFF cables into plenum: x range, height
sata_notch  = [[165, 195], 22];   // SATA power through plenum left wall: y range
fw_standoffs = [for (s = standoffs)
  if (s[1] > fw_y - foot_d + 3 && s[1] < fw_y - 3) s];

/* [F4] */
fan_rear = fw_y + fw_t + gasket_t + fan_t;
f4_front_x = W_int - 4;   // drive front end (right)
f4_y = fan_rear + (D_int - fan_rear - (W + 2*head_prot)) / 2 + head_prot;
win_post = 7;             // half width of solid post around screws
win_mullion = 3;
win_max_bridge = 28;

/* [Slot cover: MEASURE against stock LP cover] */
slot_cover_w = 18.4;
slot_cover_l = 79.2;
slot_cover_t = 2;
slot_tab_l = 11.4;
slot_screw_w = 4.4;
cable_d = 10.6;
cable_slot_l = 45;

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

function in_rect(p, x0, y0, x1, y1, m) =
  p[0] > x0 + m && p[0] < x1 - m && p[1] > y0 + m && p[1] < y1 - m;

// locator points under a sled at chassis (x0, y0), unrotated
function pockets_rank(x0, y0) = [for (p = concat(standoffs, floor_holes))
  if (in_rect(p, x0, y0, x0 + W, y0 + L, pocket_d/2 + 1)) [p[0] - x0, p[1] - y0]];

// F4: local (lx, ly) -> chassis (f4_front_x - ly, f4_y + lx)
function pockets_f4() = [for (p = concat(standoffs, floor_holes))
  if (in_rect(p, f4_front_x - L, f4_y, f4_front_x, f4_y + W, pocket_d/2 + 1))
    [p[1] - f4_y, f4_front_x - p[0]]];

// window segments along the sled length, split by posts and mullions
function win_spans() =
  let (edges = [band + 1, screw_y[0] - win_post, screw_y[0] + win_post,
                screw_y[1] - win_post, screw_y[1] + win_post, L - band - 1])
  [for (i = [0 : 2 : 4]) [edges[i], edges[i + 1]]];

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
      }
    }
    for (x = [t - groove, W - t])
      translate([x, -1, roof_z0 - 0.2]) cube([groove, L - band + 1, roof_t + 0.4]);
    for (y = screw_y, z = screw_z) translate([W/2, y, z]) hole_x(grom_hole, W + 2);
    if (win) windows();
    for (p = pockets) translate([p[0], p[1], -1]) slot_hole(pocket_d, pocket_h + 1);
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
        cube([W_int - lid_clr - plenum_x0, foot_d + eps, 3]);
      // plenum left wall, overlaps F1's collar ear
      translate([plenum_x0, rank_y + L - band, 0])
        cube([t, fw_y - (rank_y + L - band) + eps, top]);
    }
    translate([0, fw_y, 0]) fan_holes();
    for (s = fw_standoffs) translate([s[0], s[1], 0]) slot_hole(3.4, 20);
    translate([cable_notch[0][0], fw_y - foot_d - 1, -1])
      cube([cable_notch[0][1] - cable_notch[0][0], foot_d + fw_t + 2, cable_notch[1] + 1]);
    translate([plenum_x0 - 1, sata_notch[0][0], -1])
      cube([t + 2, sata_notch[0][1] - sata_notch[0][0], sata_notch[1] + 1]);
  }
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

// low-profile PCIe slot cover with an open slot for one SFF-8088 cable.
// printed flat: plate on the bed, tab up
module slot_cover() {
  difference() {
    union() {
      cube([slot_cover_w, slot_cover_l, slot_cover_t]);
      translate([0, slot_cover_l - slot_cover_t, 0]) cube([slot_cover_w, slot_cover_t, slot_tab_l]);
    }
    // cable slot from the bottom end
    translate([(slot_cover_w - cable_d) / 2, -1, -1]) cube([cable_d, cable_slot_l - cable_d/2 + 1, 10]);
    translate([slot_cover_w / 2, cable_slot_l - cable_d/2, -1]) cylinder(d = cable_d, h = 10);
    // screw notch in the tab
    translate([slot_cover_w / 2, slot_cover_l + 1, slot_tab_l - 5])
      rotate([90, 0, 0]) cylinder(d = slot_screw_w, h = 10);
    translate([(slot_cover_w - slot_screw_w) / 2, slot_cover_l - 5, slot_tab_l - 5])
      cube([slot_screw_w, 10, 10]);
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

// spreads an M3 head over a slot
module washer() {
  difference() {
    cylinder(d = 2*slot_tol + 3.4 + 5, h = 2);
    translate([0, 0, -1]) cylinder(d = 3.4, h = 4);
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
else if (part == "washers") grid(4, 2*slot_tol + 3.4 + 8) washer();
else if (part == "sleeves") grid(36, sleeve_d + 4) sleeve();
else if (part == "fanwall_l") fw_flat() fanwall_l();
else if (part == "fanwall_r") fw_flat() fanwall_r();
else if (part == "fan_gasket") fan_gasket();
else if (part == "slot_cover") slot_cover();
else if (part == "esp_tray") esp_tray();
else if (part == "info") {
  echo(W = W, L = L, rank_x = rank_x, f4_y = f4_y, plenum_x0 = plenum_x0,
       ear_r_last = ear_r_last, sleeve_l = sleeve_l,
       f1 = pockets_rank(rank_x[0], rank_y), f2 = pockets_rank(rank_x[1], rank_y),
       f3 = pockets_rank(rank_x[2], rank_y), f4 = pockets_f4(),
       fw_standoffs = fw_standoffs, roof_z1 = roof_z1);
  cube(1);
}
