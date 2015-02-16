// First fuselage section for U2 Model

// Copyright (C) 2014 Jeremy Bennett <jeremy@jeremybennett.com>

// Contributor: Jeremy Bennett <jeremy@jeremybennett.com>

// This file is licensed under the Creative Commons Attribution-ShareAlike 3.0
// Unported License. To view a copy of this license, visit
// http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to Creative
// Commons, PO Box 1866, Mountain View, CA 94042, USA.

// 45678901234567890123456789012345678901234567890123456789012345678901234567890

use <MCAD/regular_shapes.scad>


// *****************************************************************************
//
//                            PRINT THIS UPSIDE DOWN!!!
//
// *****************************************************************************


// Useful constants
FN = 360;

// Parameters
HULL_THICK = 2.5;				// Fuselage wall thickness
TAIL_DIAM = 50;					// Jet pipe exit external diameter
FUSE_DIAM = 60;					// Fuselage external diameter
CONE_DIAM = 20;					// Nose cone minimum external diameter
SEC1_LEN = 230;					// Length of main fuselage section
SEC2_LEN = 155;					// Length of tapering tail fuselage section
SEC3_LEN = 180;             // Length of tapering nose cone
BOUNDING_BOX_Z = 1000;		// For triming ends of fuselage
AI_HEIGHT = 45;					// Air intake inside height
AI_WIDTH = 30;					// Air intake inside width
AI_LENGTH = 150;				// Air intake length
AI_OFFSET_X = 5;				// Air intake offset from top of fuselage
AI_OFFSET_Z = 100;				// Air intake offset from start of main fuselage
AI_CHORD_HEIGHT = 10.1568;	// Height of chord subtended by air intakes

// The tailplate support block
module tailplate () {
	rotate (a = [0, -90, 0])
		linear_extrude (height = 40)
			polygon (points = [ [-60, -20], [-60, 20], [0, 5], [0, -5] ]);
}


// Air intake internal

// The cross sectional size of each intake is 30mm x 45mm, and tapers back into
// the fuselage over 120mm

// @param[in] direction  +1 or -1 to indicate which direction to rotate in.
module air_intake_internal (direction) {
	rotate (a = [direction * atan((AI_WIDTH + HULL_THICK * 2) / AI_LENGTH),
	             0, 0])
		cube (size = [AI_HEIGHT, AI_WIDTH, AI_LENGTH], center = true);
}


// Air intakes

// The cross sectional size of each intake is 30mm x 45mm, and tapers back into
// the fuselage over 120mm

// @param[in] direction  +1 or -1 to indicate which direction to rotate in.
module air_intake (direction) {
	rotate (a = [direction * atan((AI_WIDTH + HULL_THICK * 2) / AI_LENGTH),
	             0, 0])
		difference () {
			cube (size = [AI_HEIGHT + HULL_THICK * 2, AI_WIDTH + HULL_THICK * 2,
			      AI_LENGTH], center = true);
			cube (size = [AI_HEIGHT, AI_WIDTH, AI_LENGTH], center = true);
		}
}


// The first SEC1_LEN is O/D 60mm, then the section tapers to O/D 55mm at the
// tail SEC2_LEN 75mm further on.

// The tailplane is mounted on a truncated triange with the same thickness as
// the fuselage.
module fuselage_1_untrimmed () {
	angtan = (FUSE_DIAM - TAIL_DIAM) / 2 / SEC2_LEN;
	ang = atan (angtan);
	extra = FUSE_DIAM * angtan;
	tail_rad = TAIL_DIAM / 2;
	fuse_rad = FUSE_DIAM / 2;
	cone_rad = CONE_DIAM / 2;
	// First section is below the X-Y plane
	translate (v = [-fuse_rad, 0, -SEC1_LEN])
		difference () {
			cylinder (r = fuse_rad, h = SEC1_LEN + extra, $fn = FN);
			cylinder (r = fuse_rad - HULL_THICK, h = SEC1_LEN + extra, $fn = FN);
		}
	// Tapering tail section needs slight rotation to get complete join
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
	// Cone section is below the main section, below the X-Y plane
	translate (v = [-fuse_rad, 0, -SEC1_LEN - SEC3_LEN])
			cylinder (r2 = fuse_rad, r1 = cone_rad, h = SEC3_LEN,
			          $fn = FN);
	//tailskid
		translate (v = [-52, 0, 155])
			cube (size = [10, 4, 40], center = true);
	// Cockpit is above main fuselage and nose cone
		translate (v = [0, 0, -SEC1_LEN])
			rotate (a = [ 0, 350, 0])
				cylinder (r = 15, h = 85,
			          $fn = FN);
		translate (v = [-35, 0, 140 - SEC3_LEN - SEC1_LEN])
			rotate (a = [ 0, 35, 0])
				cylinder (r = 15, h = 65,
			          $fn = FN);
	// Wing mount is flat area on underside of fuselage.
		translate (v = [-52.5, 0, -100])
			cube (size = [15, 50, 120], center = true);
		translate (v = [-39.6, 0, -35])
			rotate (a = [ 0, 300, 0])
				cube (size = [30, 50, 30], center = true);		
	//Fictional tail exists only for pretty purposes
//		translate (v = [0, 0, 100])
//			cube (size = [1, 250, 100], center = true);
//		translate (v = [75, 0, 125])
//			cube (size = [150, 1, 75], center = true);	
	// Air intakes each size are 45mm high by 30mm wide
	translate (v = [-AI_HEIGHT / 2 - HULL_THICK - AI_OFFSET_X,
	                 AI_WIDTH - AI_CHORD_HEIGHT - HULL_THICK, -AI_OFFSET_Z])
		air_intake (+1);
	translate (v = [-AI_HEIGHT / 2 - HULL_THICK - AI_OFFSET_X,
	                -AI_WIDTH + AI_CHORD_HEIGHT + HULL_THICK, -AI_OFFSET_Z])
		air_intake (-1);
}

module fuselage_1 () {
	angtan = (FUSE_DIAM - TAIL_DIAM) / 2 / SEC2_LEN;
	ang = atan (angtan);
	extra = FUSE_DIAM * angtan;
	fuse_rad = FUSE_DIAM / 2;
	intersection () {
		// Cuboid to trim off jet pipe exit squarely
		translate (v = [0, 0, SEC2_LEN - BOUNDING_BOX_Z / 2])
			cube (size = [SEC2_LEN * 2, 1000, BOUNDING_BOX_Z],
			      center = true);
		// Trim away internal stuff
		difference () {
			fuselage_1_untrimmed ();
			// Main fuselate internals
			translate (v = [-fuse_rad, 0, -SEC1_LEN])
				cylinder (r = fuse_rad - HULL_THICK, h = SEC1_LEN + extra,
				          $fn = FN);
			// Air intake internals
			translate (v = [-AI_HEIGHT / 2 - HULL_THICK - AI_OFFSET_X,
			                AI_WIDTH - AI_CHORD_HEIGHT - HULL_THICK,
			                -AI_OFFSET_Z])
				air_intake_internal (+1);
			translate (v = [-AI_HEIGHT / 2 - HULL_THICK - AI_OFFSET_X,
			                -AI_WIDTH + AI_CHORD_HEIGHT + HULL_THICK,
			                -AI_OFFSET_Z])
				air_intake_internal (-1);
			//Battery and Rx compartment
			translate (v = [ -25, 0, -230])
				linear_extrude(height = 160, center = true, convexity = 10, twist = 0)
				translate([2, 0, 0])	
				square ([40,25],center = true);
			translate (v = [ -26, 0, -230])
				linear_extrude(height = 160, center = true, convexity = 10, twist = 0)
				translate([2, 0, 0])	
				square ([36,35],center = true);
			translate (v = [ -28, 0, -230])
				linear_extrude(height = 250, center = true, convexity = 10, twist = 0)
				translate([2, 0, 0])	
				square ([36,18],center = true);
			translate (v = [-30, 0, -410])
				cylinder (r = 7.5, h = 20, $fn = FN);
			translate (v = [-15, 0, -25.0])
				cube (size = [30, 55, 60], center = true);
			translate (v = [-3, 0, -350])
				cube (size = [30, 55, 90], center = true);
			translate (v = [17.75, 0, -86.5])
				rotate (a = [ 0, 330, 0])
					cube (size = [30, 80, 90], center = true);			
			translate (v = [0, 0, -77])
				rotate (a = [ 45, 0, 0])
					cube (size = [30, 35, 35], center = true);		
			translate (v = [0, 0, -200])
				rotate (a = [ 0, 330, 0])
					cube (size = [40, 13, 24], center = true);	
			translate (v = [-50, 0, -180])
				rotate (a = [ 0, 0, 0])
					cube (size = [40, 13, 24], center = true);	
			translate (v = [-50, 0, -220])
				rotate (a = [ 0, 0, 0])
					cube (size = [40, 13, 24], center = true);	
		}
	}
}


fuselage_1 ();
