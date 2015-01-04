// First fuselage section for U2 Model

// Copyright (C) 2014 Jeremy Bennett <jeremy@jeremybennett.com>

// Contributor: Jeremy Bennett <jeremy@jeremybennett.com>

// This file is licensed under the Creative Commons Attribution-ShareAlike 3.0
// Unported License. To view a copy of this license, visit
// http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to Creative
// Commons, PO Box 1866, Mountain View, CA 94042, USA.

// 45678901234567890123456789012345678901234567890123456789012345678901234567890

use <MCAD/regular_shapes.scad>


// Useful constants
FN = 360;

// Parameters
HULL_THICK = 2.5;
TAIL_DIAM = 55;
FUSE_DIAM = 60;
SEC1_LEN = 45;
SEC2_LEN = 75;

// The tailplate support block
module tailplate () {
	rotate (a = [0, -90, 0])
		linear_extrude (height = 40)
			polygon (points = [ [-60, -20], [-60, 20], [0, 5], [0, -5] ]);
}

// The first 45mm is O/D 60mm, then the section tapers to O/D 55m at the tail
// 75mm further on.

// The tailplane is mounted on a truncated triange with the same thickness as
// the fuselage.
module fuselage_1_untrimmed () {
	angtan = (FUSE_DIAM - TAIL_DIAM) / 2 / SEC2_LEN;
	ang = atan (angtan);
	extra = FUSE_DIAM * angtan;
	tail_rad = TAIL_DIAM / 2;
	fuse_rad = FUSE_DIAM / 2;
	// First section is below the X-Y plane
	translate (v = [-fuse_rad, 0, -SEC1_LEN])
		difference () {
			cylinder (r = fuse_rad, h = SEC1_LEN + extra, $fn = FN);
			cylinder (r = fuse_rad - HULL_THICK, h = SEC1_LEN + extra, $fn = FN);
		}
	rotate (a = [0, ang, 0])
	translate (v = [-fuse_rad, 0, 0])
		difference () {
			union () {
				cylinder (r1 = fuse_rad, r2 = tail_rad, h = SEC2_LEN, $fn = FN);
				rotate (a = [0, -ang, 0])
					translate (v = [fuse_rad, 0, SEC2_LEN])
						tailplate ();
			}
			cylinder (r1 = fuse_rad - HULL_THICK, r2 = tail_rad - HULL_THICK,
			          h = SEC2_LEN, $fn = FN);
		}
}

module fuselage_1 () {
	intersection () {
		cube (size = [SEC2_LEN * 2, SEC2_LEN * 2, SEC2_LEN * 2], center = true);
		fuselage_1_untrimmed ();
	}
}


fuselage_1 ();