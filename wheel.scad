// Wheel for U2 Model

// Copyright (C) 2014 Jeremy Bennett <jeremy@jeremybennett.com>

// Contributor: Jeremy Bennett <jeremy@jeremybennett.com>

// This file is licensed under the Creative Commons Attribution-ShareAlike 3.0
// Unported License. To view a copy of this license, visit
// http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to Creative
// Commons, PO Box 1866, Mountain View, CA 94042, USA.

// 45678901234567890123456789012345678901234567890123456789012345678901234567890


// A wheel with axle hole and four holes to reduce weight.

// Implemented as a slice of a sphere
module wheel ()
	// Slide of sphere
	difference() {
		intersection() {
			sphere(r = 10);
			cube(size = [6,200,300], center = true);
	}

	// Central axle
	rotate ([0,90,0])
		translate([ 0, 0, -5])
			cylinder(h = 10, d=2);

	// Four weight reducing holes
	rotate ([0,90,0])
		translate([ 0, 5, -5])
			cylinder(h = 10, d=6);
	rotate ([0,90,0])
		translate([ 0, 5, -5])
			cylinder(h = 10, d=6);
	rotate ([0,90,0])
		translate([ 0, -5, -5])
			cylinder(h = 10, d=6);
	rotate ([0,90,0])
		translate([ 5, 0, -5])
			cylinder(h = 10, d=6);
	rotate ([0,90,0])
		translate([ -5, 0, -5])
			cylinder(h = 10, d=6);
}


// Rotate for printing
rotate (a = [0, 90, 0])
	wheel ();
