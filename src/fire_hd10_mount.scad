// =============================================================================
//  Fire HD 10 (2023 / 13th generation) — landscape wall mount
//  Flat-backed cradle for Command 20 lb X-Large picture hanging strips.
//
//  Features:
//   * Perfectly flat back  -> smooth, rigid surface for the Command strips.
//   * Both SHORT edges open -> USB-C, power & volume always accessible.
//   * Tool-free "lift & drop" retention (no flexing clips to snap).
//   * Cable channel: route the charge cable right -> down -> under the tablet
//     -> out the bottom-left, so it runs cleanly down the wall.
//   * Shallow strip recesses on the back so the mount sits closer to the wall.
//   * Beveled / rounded edges for a finished look.
//
//  Orientation: landscape, model centered on X, bottom of plate at Y = 0.
//    X = tablet long edge (horizontal)   Y = short edge (up the wall)
//    Z = out from the wall (back face at Z=0 -> print this face DOWN).
//  Units: millimetres.
// =============================================================================

/* [Tablet — Fire HD 10, 2023 / 13th gen] */
tw = 246;        // long edge (horizontal in landscape)
th = 164.8;      // short edge (vertical)
tt = 8.6;        // thickness

/* [Fit clearances] */
cl_w = 0.8;      // total horizontal play (between corner brackets)
cl_t = 0.8;      // extra pocket depth beyond tablet thickness

/* [Shell] */
back     = 3.0;              // back-plate thickness
lip_z    = 2.6;              // how far the lips stand proud of the tablet front
pocket_t = tt + cl_t;        // pocket depth available for the tablet (Z)
front_z  = back + pocket_t;  // Z-plane of the tablet's front face
depth    = front_z + lip_z;  // overall part depth

/* [Vertical layout — Y] */
base_h   = 15;                       // bottom base / shelf block height
rest_y   = base_h;                   // shelf floor = tablet bottom edge
lift     = 11;                       // vertical travel for lift-and-drop insert
head     = 2;                        // headroom above lifted tablet
top_wall = 6;                        // top ceiling bar (ties clips to plate)
seated_top = rest_y + th;            // tablet top edge when seated
plate_h    = seated_top + lift + head + top_wall;

/* [Horizontal layout — X] */
plate_w = tw + cl_w;                 // overall plate width (tablet + clearance)
half_w  = plate_w/2;
t_half  = tw/2;

/* [Lips, clips, corner brackets] */
bl_cover  = 8;                       // bottom-lip front coverage (Y)
tl_below  = 7;                       // top-lip coverage below the seated top edge
clip_w    = 55;                      // width of each top clip (X)
clip_cx   = 55;                      // top-clip centre offset from X=0
finger_w  = 46;                      // finger notch in the bottom lip
br        = 16;                      // corner-bracket leg length (sideways stop)

/* [Cable channel] */
cw       = 6.5;                      // channel width (fits a USB-C cable)
cd       = 5.0;                      // channel depth into the base
floor_z  = front_z - cd;             // channel floor (stays well above the 3mm back)
ych      = 7.0;                      // channel centreline height
cx_end   = 116;                      // channel reaches +/-116 in X
brg_z0   = front_z - 1.3;            // retention-bridge underside

/* [Command-strip recesses — on the back] */
rec_w  = 18;                         // recess width
rec_h  = 150;                        // recess height
rec_d  = 1.5;                        // recess depth (keep shallow)
rec_cx = (plate_w/2 + (plate_w/2 - 30)) / 2;  // centre of each side border
rec_cy = plate_h/2;

/* [Styling] */
rc    = 6;       // plate corner radius
bevel = 1.2;     // front-edge bevel
eps   = 0.01;
$fn   = 48;

/* [Back-plate window] */
win_border = 30;
ww   = plate_w - 2*win_border;       // window width
win_y0 = rest_y + bl_cover + 8;
win_y1 = seated_top - 8;
wh   = win_y1 - win_y0;              // window height
wcy  = (win_y0 + win_y1)/2;
wr   = 14;                           // window corner radius

// ---------------------------------------------------------------------------
module rrect(w, h, r) {              // rounded rectangle, centered
    hull() for (sx = [-1, 1], sy = [-1, 1])
        translate([sx*(w/2 - r), sy*(h/2 - r)]) circle(r = r);
}

// Rounded slab, centered in XY, Z in [0,thick]; the top (Z=thick) outer edge
// is beveled inward by `bev` for a finished front edge.
module beveled_slab(w, h, thick, r, bev) {
    hull() {
        linear_extrude(0.01) rrect(w, h, r);
        translate([0, 0, thick - 0.01])
            linear_extrude(0.01) rrect(w - 2*bev, h - 2*bev, max(0.8, r - bev));
    }
}

module window_cut() {                // centered at origin; chamfered front edge
    union() {
        translate([0, 0, -eps]) linear_extrude(back + 2*eps) rrect(ww, wh, wr);
        translate([0, 0, back - 1.0]) hull() {
            linear_extrude(0.01) rrect(ww, wh, wr);
            translate([0, 0, 1.0]) linear_extrude(0.01) rrect(ww + 2, wh + 2, wr + 1);
        }
    }
}

module plate() {
    difference() {
        translate([0, plate_h/2, 0]) beveled_slab(plate_w, plate_h, back, rc, bevel);
        translate([0, wcy, 0]) window_cut();
        // shallow Command-strip recesses on the back (Z=0 face)
        for (sx = [-1, 1])
            translate([sx*rec_cx, rec_cy, -eps])
                linear_extrude(rec_d + eps) rrect(rec_w, rec_h, 6);
    }
}

module base() {                      // bottom shelf block; top face = shelf floor
    difference() {
        translate([0, base_h/2, 0]) linear_extrude(front_z) rrect(tw, base_h, rc);
        cable_cut();
    }
}

module cable_cut() {                 // groove: right riser -> across -> left exit
    h = (front_z - floor_z) + eps;
    zc = (floor_z + front_z)/2 + eps/2;
    // horizontal run under the tablet
    translate([0, ych, zc])              cube([2*cx_end, cw, h], center = true);
    // right entry — opens up through the shelf floor near the USB edge
    translate([cx_end, (ych + base_h)/2, zc])  cube([cw, base_h - ych, h], center = true);
    // left exit — drops down and out the bottom edge
    translate([-cx_end, (ych - 1)/2, zc])      cube([cw, ych + 2, h], center = true);
}

module cable_bridges() {             // thin retainers the cable tucks under
    for (x = [-72, 0, 72])
        translate([x, ych, (brg_z0 + front_z)/2])
            cube([4.5, cw + 4, front_z - brg_z0], center = true);
}

module top_clip(cx) {
    lip_y0 = seated_top - tl_below;
    translate([cx, (lip_y0 + plate_h)/2, front_z])
        beveled_slab(clip_w, plate_h - lip_y0, lip_z, 5, 0.8);
    conn_y0 = seated_top + lift + head;          // connector above the tablet
    translate([cx, (conn_y0 + plate_h)/2, (back + front_z)/2])
        cube([clip_w, plate_h - conn_y0, front_z - back], center = true);
}

module bottom_lip() {
    difference() {
        translate([0, rest_y + bl_cover/2, front_z])
            beveled_slab(tw + cl_w, bl_cover, lip_z, 4, 0.8);
        translate([0, rest_y + bl_cover/2, front_z + lip_z/2])
            cube([finger_w, bl_cover + 2, lip_z + 2], center = true);
    }
}

module corner_bracket(sx) {          // sideways stop nested in a rounded corner
    pts = [ [sx*half_w,        rest_y     ],
            [sx*half_w,        rest_y + br ],
            [sx*(half_w - br), rest_y     ] ];
    linear_extrude(front_z) polygon(pts);
}

module mount() {
    union() {
        plate();
        base();
        cable_bridges();
        top_clip( clip_cx);
        top_clip(-clip_cx);
        bottom_lip();
        corner_bracket( 1);
        corner_bracket(-1);
    }
}

mount();
