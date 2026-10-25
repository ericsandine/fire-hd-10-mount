// =============================================================================
//  Fire HD 10 (2023 / 13th generation) — landscape wall mount  (v2)
//  Flat-backed cradle for Command 20 lb X-Large picture hanging strips.
//
//  v2 changes (from the first test print):
//   * Cable: a genuinely OPEN lay-in groove on the back — you drop the cable
//     in, no threading, no bridging tabs. Right edge -> across the back ->
//     out the bottom-left, hidden against the wall.
//   * Flush / squared look: square front edges (no decorative bevels),
//     straight-walled channel, minimal corner rounding.
//   * Bottom seats flush: the tablet's ROUNDED corners now drop into open
//     relief (no square brackets fighting the radius); two slim side rails
//     on the frame stop it sliding sideways, contacting the straight edges.
//
//  Orientation: landscape, model centered on X, bottom of plate at Y = 0.
//    X = tablet long edge (horizontal)   Y = short edge (up the wall)
//    Z = out from the wall (back face at Z=0 -> print this face DOWN).
//  Units: millimetres.
// =============================================================================

/* [Tablet — Fire HD 10, 2023 / 13th gen] */
tw  = 246;        // long edge (horizontal in landscape)
th  = 164.8;      // short edge (vertical)
tt  = 8.6;        // thickness
t_r = 12;         // tablet corner radius (approx; side rails start above it)

/* [Fit clearances] */
cl_w = 0.8;       // total horizontal play (tablet vs. pocket)
cl_t = 0.8;       // extra pocket depth beyond tablet thickness

/* [Shell] */
back     = 3.0;              // back-plate thickness
lip_z    = 2.6;             // how far lips stand proud of the tablet front
pocket_t = tt + cl_t;       // pocket depth available for the tablet (Z)
front_z  = back + pocket_t; // Z-plane of the tablet's front face (12.4)
depth    = front_z + lip_z; // overall part depth

/* [Vertical layout — Y] */
base_h   = 14;                       // bottom shelf block height (below tablet)
rest_y   = base_h;                   // shelf floor = tablet bottom edge
lift     = 11;                       // vertical travel for lift-and-drop insert
head     = 2;                        // headroom above lifted tablet
top_wall = 6;                        // top ceiling bar (ties clips to plate)
seated_top = rest_y + th;            // tablet top edge when seated
plate_h    = seated_top + lift + head + top_wall;

/* [Horizontal layout — X] */
side_border = 2;                     // frame beside the tablet (hosts side rails)
plate_w = tw + cl_w + 2*side_border; // overall plate width (250.8)
half_w  = plate_w/2;
t_half  = tw/2;
pocket_x = t_half + cl_w/2;          // inner face of the side rails (123.4)

/* [Lips, clips, side rails] */
bl_cover  = 8;                       // bottom-lip front coverage (Y)
tl_below  = 7;                       // top-lip coverage below the seated top edge
clip_w    = 55;                      // width of each top clip (X)
clip_cx   = 55;                      // top-clip centre offset from X=0
finger_w  = 46;                      // finger notch in the bottom lip
rail_y0   = rest_y + 14;             // side rails start above the corner radius
rail_len  = 40;                      // side-rail length up the edge

/* [Cable channel — simple open channel on the BACK of the base] */
cw      = 9;                         // channel width (generous — forgiving cable fit)
bd      = 5;                         // channel depth into the back of the base
ych     = 7;                         // channel centreline height
cx_left = -116;                      // left (exit) end — drops out the bottom edge

/* [Command-strip recesses — on the back] */
rec_w  = 18;                         // recess width
rec_h  = 150;                        // recess height
rec_d  = 1.5;                        // recess depth (shallow)
rec_cx = (plate_w/2 - side_border + (plate_w/2 - 30)) / 2 + side_border/2; // side-frame centre
rec_cy = plate_h/2;

/* [Styling — squared / flush] */
rc  = 3;         // plate corner radius (slight)
eps = 0.01;
$fn = 48;

/* [Back-plate window] */
win_border = 30;
ww   = plate_w - 2*win_border;       // window width
win_y0 = rest_y + bl_cover + 8;
win_y1 = seated_top - 8;
wh   = win_y1 - win_y0;              // window height
wcy  = (win_y0 + win_y1)/2;
wr   = 12;                           // window corner radius

// ---------------------------------------------------------------------------
module rrect(w, h, r) {              // rounded rectangle, centered
    hull() for (sx = [-1, 1], sy = [-1, 1])
        translate([sx*(w/2 - r), sy*(h/2 - r)]) circle(r = r);
}

// Square-edged rounded slab, centered in XY, Z in [0, thick].
module slab(w, h, thick, r) {
    linear_extrude(thick) rrect(w, h, r);
}

module plate() {
    difference() {
        translate([0, plate_h/2, 0]) slab(plate_w, plate_h, back, rc);
        // through window (square edges)
        translate([0, wcy, -eps]) linear_extrude(back + 2*eps) rrect(ww, wh, wr);
        // shallow Command-strip recesses on the back (Z=0 face)
        for (sx = [-1, 1])
            translate([sx*rec_cx, rec_cy, -eps])
                linear_extrude(rec_d + eps) rrect(rec_w, rec_h, 6);
    }
}

// Simple open channel cut into the BACK (Z=0 side) of the base: in from the open
// right edge, across under the tablet, then down and out the bottom-left. It's a
// plain rounded-cornered groove, open the full width on the back face — lay the
// cable in, the wall caps it when hung. Printed back-down the opening faces the
// bed; the ~9 mm roof is a short, easy bridge (and any minor sag is hidden and
// harmless — the channel is deliberately oversized for the cable).
module cable_cut() {
    x1 = half_w + eps;               // open at the right edge
    // horizontal run
    translate([(cx_left + x1)/2, ych, bd/2 - eps])
        cube([x1 - cx_left, cw, bd + eps], center = true);
    // left exit — straight down and out the bottom edge
    translate([cx_left, ych/2, bd/2 - eps])
        cube([cw, ych + 2*eps, bd + eps], center = true);
}

module base() {                      // bottom shelf block; top face = shelf floor
    difference() {
        translate([0, base_h/2, 0]) slab(plate_w, base_h, front_z, rc);
        cable_cut();
    }
}

module top_clip(cx) {
    lip_y0 = seated_top - tl_below;
    translate([cx, (lip_y0 + plate_h)/2, front_z])
        slab(clip_w, plate_h - lip_y0, lip_z, 2);
    conn_y0 = seated_top + lift + head;          // connector above the tablet
    translate([cx, (conn_y0 + plate_h)/2, (back + front_z)/2])
        cube([clip_w, plate_h - conn_y0, front_z - back], center = true);
}

module bottom_lip() {
    difference() {
        translate([0, rest_y + bl_cover/2, front_z])
            slab(tw + cl_w, bl_cover, lip_z, 2);
        translate([0, rest_y + bl_cover/2, front_z + lip_z/2])
            cube([finger_w, bl_cover + 2, lip_z + 2], center = true);
    }
}

// Slim rail on the side frame, inner face at the tablet's straight edge, rising
// to the tablet front. Starts above the corner radius so the rounded corner has
// clearance and the tablet seats flush on the shelf.
module side_rail(sx) {
    x0 = sx*pocket_x;                 // inner face (123.4), at the tablet edge
    x1 = sx*half_w;                   // outer face, the plate edge
    translate([(x0 + x1)/2, rail_y0 + rail_len/2, front_z/2])
        cube([abs(x1 - x0), rail_len, front_z], center = true);
}

module mount() {
    union() {
        plate();
        base();
        top_clip( clip_cx);
        top_clip(-clip_cx);
        bottom_lip();
        side_rail( 1);
        side_rail(-1);
    }
}

mount();
