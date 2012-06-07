/*
 * Z Isolator with Securing nut
 *
 * (C) Michel Pollet <buserror@gmail.com>
 *
This is a redesign of http://www.thingiverse.com/thing:20147
That existing piece does the job for constant (increasing)
Z movement, however it fails to control any backlash for the
Z nut when doing the Z calibration phase and also when using
"Lift between moves" in Slic3r or Repsnapper.

This version is parametric, and has a captured M3 captured nut
to make sure the M8 nut is held in place. The smooth rod
arms are suposed to be 'snug' too, having them slack will add
backlash again.

The original piece functionality is still there, wich is to 
make sure the X carriages are decoupled from the Z axis, 
preventing very successfuly the "Z wobble" when the threaded
rods move jerk the X carriage back/forth.

As an added bonus, making sure the Z nut is secured prevents
accidents if you lower the head 'under' the bed... If you
do this on a normal prusa, the nut exits it's housing and 
you have to re-level the whole bed.
 */

// change this to 1 to get the screw tighener on the side
ScrewOnSide = 1;

NutR = 12.9 / 2;
NutH = 6.40;
RodR = (7.6 / 2);
SRodR = 8 / 2;
WallW = 4.1;
E = 0.01;

GuideL = 35;
GuideW = (SRodR * 2) + (WallW * 1.5);

ScrewL = 10;
ScrewW = (RodR * 2) + (WallW * 1.8);
ScrewNutR = 5.5 / 2;
ScrewNutH = 2;
ScrewThreadR = 3 / 2;
ScrewWasheR = 7.3 / 2;
ScrewNutInset = WallW / 3;
ScrewWasherInset = 2;

rotate(-45,0,0) {
//	rotate([180,0,0])
//		zizolator();
	translate([GuideL-NutR-ScrewL+1+(ScrewOnSide*3), 18, 0])
		rotate([0,180,0])
			zizolator();
}

module zizolator() {
	difference() {
		union() {
			cylinder(r = WallW + NutR, h = NutH + WallW);
			
			translate([GuideL / 2, 0, (NutH + WallW + E) / 2])	
				cube([GuideL, GuideW, NutH + WallW], center = true);
		
			rotate([0,0,-90 * ScrewOnSide])
			translate([-(((NutR+WallW)/2) + ScrewL), -(ScrewW/2), 0])
				cube([ScrewL, ScrewW, NutH + WallW]);		
		}
		translate([0,0,-E]) {
			nut(d = (NutR) * 2, h = NutH + (WallW/2), horizontal=false);
			cylinder(r = SRodR + 0.3, h = NutH + (2*WallW));
		
			rotate([0,0,-90 * ScrewOnSide])
			translate([-20, -RodR, 0])
				cube([20, RodR*2, NutH + (2*WallW)]);
		
			translate([15, 0, 0]) {
				cylinder(r = SRodR + 0.1, h = NutH + (2*WallW));
				translate([0, -SRodR, 0])
					cube([GuideL, SRodR*2, NutH + (2*WallW)]);
			}
		}
		rotate([0,0,-90 * ScrewOnSide])
		translate([-ScrewL-ScrewThreadR+0.5, 0, (NutH + WallW)/ 2]) {
			translate([0,(NutR * 1.5),0])
				rotate([90,00,0])
					cylinder(h = (NutR * 3), r = ScrewThreadR, $fn = 10);
			translate([0,ScrewNutInset+(ScrewW/2)+E,0])
				rotate([90,30,0])
					nut(h = ScrewNutInset*2, d = ScrewNutR*2);
			translate([0,-(ScrewW/2)+ScrewWasherInset-E,0])
				rotate([90,00,0])
					cylinder(h = ScrewWasherInset*2, r = ScrewWasheR, $fn = 16);
		}
	}
}


// PRUSA Mendel  
// Functions used in many files
// GNU GPL v3
// Josef Průša
// josefprusa@me.com
// prusadjs.cz
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel


module nut(d,h,horizontal=true){
cornerdiameter =  (d / 2) / cos (180 / 6);
cylinder(h = h, r = cornerdiameter, $fn = 6);
if(horizontal){
for(i = [1:6]){
	rotate([0,0,60*i]) translate([-cornerdiameter-0.2,0,0]) rotate([0,0,-45]) cube(size = [2,2,h]);
}}
}
