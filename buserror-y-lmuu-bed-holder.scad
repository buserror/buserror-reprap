/*
 * Y Bed LM8UU holder
 *
 * (C) Michel Pollet <buserror@gmail.com>
 *
 ************************LICENSING TERMS***************************
 * This part is not for commercial distribution without a commercial 
 * license acquired from the author. Distribution on a small scale 
 * basis (< 25 units) in the Reprap spirit is free of charge on the
 * basis of mentioning the Author with the bill of material, any 
 * wider distribution requires my explicit, written permission.
 ******************************************************************
 *
 * This was designed to allow the bearing to be right against the bed
 * to save height, and also to leave the bearing a bit of wigling
 * room to let it find it's own parallelism.
 *
 * print should be easy as long as you can print good bridges, I truncated
 * the 'lip' if the holder to have a bridge before the overhangs become
 * too big, after that it's fairly straighforward
 */

$fn = 50;
extrusionSize = 0.44;	// for 0.20mm layer

demo = 1;
skirt = demo == 0 ? 1 : 0;

WallW = 8 * extrusionSize;

BearingHeightTolerance = 0.0;
BearingWiggleTolerance = 0.1;
BearingSize = [24.1, 15.1];	// length, external width
BearingPos = [0, 0, (BearingSize[1]/2) + BearingHeightTolerance];

BearingBaseSize = [ BearingSize[1] + (2 * WallW), 
		BearingSize[0] + (2*WallW),
		BearingPos[2]];
BearingBasePos = [-BearingBaseSize[0]/2, -WallW, 0];

HoleDistance = 15.5*2; // from 'y-lm8uu-holder.scad'

m3_diameter = 3;
m3_nut_diameter = 5.5;
m3_nut_height = 2.5;

if (skirt == 1) {
	linear_extrude(height=0.20) difference() {
		scale([1.1,1.1,0])
			projection(cut = true) hull() holder();
		scale([0.99,0.99,1.01])
			projection(cut = true) hull() holder();
	}
}

holder();

module holder() translate([0,-BearingSize[0]/2,0]) difference () {
	outside();
	inside();
}

module outside() {
	translate(BearingPos)
		rotate([-90,0,0]) {
			if (demo == 1)
		%		cylinder(r = (BearingSize[1] / 2), 
						h = BearingSize[0]);
			translate([0,0,-WallW])
				cylinder(r = (BearingSize[1] / 2) + WallW, 
						h = BearingSize[0] + (2*WallW));
		}
	translate(BearingBasePos)
		cube(BearingBaseSize);

	hull() for (x = [0:1]) {
		translate([(x?-1:1) * (HoleDistance/2), -WallW+(BearingBaseSize[1] / 2), 0])
			cylinder(r = (m3_nut_diameter/2) + WallW, h = WallW);
	}
}

module inside() {
	translate(BearingPos)
		rotate([-90,0,0]) render() {
			hull() for (z = [0, 1]) for (x = [0:1]) 
			translate([(x ? 1:-1) * BearingWiggleTolerance, z*30, 0])
				cylinder(r = (BearingSize[1] / 2), 
						h = BearingSize[0]);
			
			difference() {
				hull() for (z = [0, 1]) for (x = [0:1]) 
				translate([(x ? 1:-1) * BearingWiggleTolerance, -(WallW*0.5)+z*30, 0])
				translate([0,0,-WallW-1])
					cylinder(r = (BearingSize[1] / 2) * 0.7, 
							h = BearingSize[0] + (3*WallW));	
				translate([-(BearingSize[1] / 2), -(BearingSize[1] / 2)-2, -WallW-2])		
					cube([15, 4, BearingSize[0] + (4*WallW)]);
			}
		}
	for (x = [0:1])
	translate([(x?-1:1) * (HoleDistance/2), -WallW+(BearingBaseSize[1] / 2), 0]) {
		cylinder(r = m3_diameter / 2, h = WallW + 2);
		translate([0,0,WallW-1])
			nut(d = m3_nut_diameter, h = m3_nut_height);
	}
	translate([-12,-10, -5])
		cube([24,40,5]);
}

module nut(d,h,horizontal=true){
cornerdiameter =  (d / 2) / cos (180 / 6);
cylinder(h = h, r = cornerdiameter, $fn = 6);
if(horizontal){
for(i = [1:6]){
	rotate([0,0,60*i]) translate([-cornerdiameter-0.2,0,0]) rotate([0,0,-45]) cube(size = [2,2,h]);
}}
}
