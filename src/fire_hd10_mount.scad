// =============================================================================
//  Fire HD 10 (2023 / 13th generation) — landscape wall mount
//  Flat-backed cradle for Command 20 lb X-Large picture hanging strips.
//
//  Design goals:
//   * Perfectly flat back   -> smooth, rigid surface for the Command strips.
//   * Both SHORT edges open  -> USB-C, power & volume are always accessible,
//                               cable can exit either side.
//   * Tool-free "lift & drop" retention -> no flexing clips to snap.
//
//  Orientation: landscape, model centered on X, bottom of plate at Y = 0.
//    X = tablet long edge (horizontal)   Y = short edge (vertical, up the wall)
//    Z = out from the wall.
//  Units: millimetres.
// =============================================================================

/* [Tablet — Fire HD 10, 2023 / 13th gen] */
tw = 246;        // long edge (horizontal in landscape)
th = 164.8;      // short edge (vertical)
tt = 8.6;        // thickness

/* [Fit clearances] */
cl_w = 0.8;      // total horizontal play (sum of both sides, between corner nubs)
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
plate_w = tw + cl_w;                 // overall plate width (= tablet + clearance)
half_w  = plate_w/2;
t_half  = tw/2;

/* [Lips & clips] */
bl_cover  = 8;                       // bottom-lip front coverage (Y)
tl_below  = 7;                       // top-lip coverage below the seated top edge
clip_w    = 55;                      // width of each top clip (X)
clip_cx   = 55;                      // top-clip centre offset from X=0
finger_w  = 46;                      // finger notch in the bottom lip
br        = 16;                      // corner-bracket leg length (sideways stop)

/* [Back-plate window (weight / ventilation)] */
win_border_x = 30;                   // solid side border (room for Command strips)
win_y0 = rest_y + bl_cover + 6;      // window bottom
win_y1 = seated_top - 6;             // window top

/* [Cosmetic] */
rc  = 4;                             // plate corner radius
eps = 0.01;
$fn = 64;

// ---------------------------------------------------------------------------
module rrect(w, h, r) {              // rounded rectangle, centered
    hull() for (sx = [-1, 1], sy = [-1, 1])
        translate([sx*(w/2 - r), sy*(h/2 - r)]) circle(r = r);
}

module backplate() {
    difference() {
        linear_extrude(back)
            translate([0, plate_h/2]) rrect(plate_w, plate_h, rc);
        // central window
        translate([0, 0, -eps])
            linear_extrude(back + 2*eps)
                translate([0, (win_y0 + win_y1)/2])
                    rrect(plate_w - 2*win_border_x, win_y1 - win_y0, 8);
    }
}

module base() {                      // bottom shelf block; top face = shelf floor
    translate([0, base_h/2, front_z/2])
        cube([tw, base_h, front_z], center = true);
}

module bottom_lip() {                // full-width front lip with finger notch
    difference() {
        translate([0, rest_y + bl_cover/2, front_z + lip_z/2])
            cube([tw + cl_w, bl_cover, lip_z], center = true);
        translate([0, rest_y + bl_cover/2, front_z + lip_z/2])
            cube([finger_w, bl_cover + 1, lip_z + 1], center = true);
    }
}

module top_clip(cx) {
    lip_y0 = seated_top - tl_below;
    // tall front lip (covers the top edge through the whole lift range)
    translate([cx, (lip_y0 + plate_h)/2, (front_z + depth)/2])
        cube([clip_w, plate_h - lip_y0, lip_z], center = true);
    // connector above the tablet, tying the lip back to the plate
    conn_y0 = seated_top + lift + head;
    translate([cx, (conn_y0 + plate_h)/2, (back + front_z)/2])
        cube([clip_w, plate_h - conn_y0, front_z - back], center = true);
}

module corner_bracket(sx) {          // sideways stop nested in a rounded corner
    // Right triangle filling the bottom-corner void. The 45-deg hypotenuse
    // faces the tablet's rounded corner (funnels it in and centres it); the
    // vertical outer leg at x = +/-half_w blocks sideways travel.
    pts = [ [sx*half_w,        rest_y     ],
            [sx*half_w,        rest_y + br ],
            [sx*(half_w - br), rest_y     ] ];
    linear_extrude(front_z) polygon(pts);
}

module mount() {
    union() {
        backplate();
        base();
        bottom_lip();
        top_clip( clip_cx);
        top_clip(-clip_cx);
        corner_bracket( 1);
        corner_bracket(-1);
    }
}

mount();
