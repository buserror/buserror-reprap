/*
 * New Prusa X Ends
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
 * These replace the Prusa X ends with stiffer ones, with lock screws
 * for the X smooth rods, and with a completely new way of mounting the
 * X Idle designed for the "dual bearing" method.
 *
 * Note that it does not have provision for a threaded rod mount, the idea
 * is to use a "Z Isolator" saddle that sits enderneath and decouple the
 * Z axis from the X.
 *
 * It is made to be a lot stiffer than the old version, to repvent the
 * tension of the belt and the motor movementd to create backlash.
 */

E=0.01;

SmoothRodR = 4.08;
ThreadedRodR = SmoothRodR * 1.2;
SmoothRodSpacing = 50;
ZRodSpacing = 30;

BearingSize = [24.1, 15.1];	// length, external width
WallW = 4.2;

ZSRodPosition = [SmoothRodR,  WallW + SmoothRodR + (SmoothRodSpacing / 2)];
ZTRodPosition = [ZSRodPosition[0] + ZRodSpacing, ZSRodPosition[1]];

XRod1Origin = [WallW / 2, WallW + SmoothRodR, WallW + SmoothRodR];
XRod2Origin = [XRod1Origin[0], 
	XRod1Origin[1] + SmoothRodSpacing,
	XRod1Origin[2]];

ZSmoothRodSupportW = ((2 * SmoothRodR) + (2 * WallW)) * 0.6;

M3R = 1.55;
M3NutW = 5.8;
M3NutH = 2.55;
M3WasherR = 8 / 2;

NutHeight = M3NutH;
NutTrapSize = [SmoothRodR * 1.2, WallW];
NutTrapPosition = [(2 * SmoothRodR) + ZRodSpacing - NutTrapSize[0], 
		WallW + SmoothRodR, 
		WallW + (2*SmoothRodR) + (3*0.25) /*(WallW/8)*/];

LMColumnSize = [BearingSize[1] + WallW, 
	BearingSize[1] + WallW, 
	(BearingSize[0] * 2) + ((WallW / 2) * 5)];

SupportRingW = 8;

MotorSide = 40;
MotorSideInset = 1;
MotorScrewInset = 5;
MotorMountThickness = 9;
MotorWasherInset = 4;

MotorMountBaseOffset = 13.5;
MotorMountedOutsidePosition = [ZSRodPosition[0], 
	(2 * WallW) + (4 * SmoothRodR) + SmoothRodSpacing - 2.5, 
	MotorMountBaseOffset + (MotorSide / 2)];

translate([-(ZSRodPosition[0] + ZRodSpacing) / 2, -ZSRodPosition[1], 0])
base(MotorMount = 0, IdlerMount = 1);

module base(MotorMount = 0, IdlerMount = 0) {
	difference() {
		base_outside(MotorMount, IdlerMount);
		base_inside(MotorMount, IdlerMount);
	}
}

//idlermount_outside();

BearingR = 22/2;
BearingH = 7;
WasherR = 16/2;
WasherH = 1.6;
NutH = 6.5;
NutD = 13;
MinimalDualBearingAxisW = NutH + (WasherH * 2) + (BearingH * 2);

IdlerMountSize = [30, 5, (MotorSide/2) + BearingR];
IdlerMountPosition = [ZSRodPosition[0], 
	ZSRodPosition[1] - (LMColumnSize[1]/2) - MinimalDualBearingAxisW - 1, 
	MotorMountBaseOffset];

module debug_dualbearing() {
	union() {
		cylinder(r = 4, h = 35);
		translate([0,0,0])
			nut(d = NutD, h = NutH);
		translate([0,0,NutH])
			cylinder(r = WasherR, h = WasherH);
		translate([0,0,NutH+WasherH])
			cylinder(r = BearingR, h = BearingH);
		translate([0,0,NutH+WasherH+BearingH])
			cylinder(r = BearingR, h = BearingH);
		translate([0,0,NutH+WasherH+BearingH+BearingH])
			cylinder(r = WasherR, h = WasherH);
	}
}

module idlermount_outside() {
	translate(IdlerMountPosition) {
		translate([0,MinimalDualBearingAxisW,MotorSide/2])
		rotate([90,90/3,0])
			translate([0,0,0])
			%	debug_dualbearing();
		translate([-IdlerMountSize[0]/2,-IdlerMountSize[1],0])
			cube(IdlerMountSize);
	}
}
module idlermount_inside() {
	translate(IdlerMountPosition) {
	}
}

module lmcolumn_outside() {
	translate([ZSRodPosition[0], ZSRodPosition[1], (LMColumnSize[2] / 2)])
		roundrect(size=LMColumnSize, r = 3, center = 1, $fn = 16);
}

module lmcolumn_inside() {
	translate([ZSRodPosition[0], ZSRodPosition[1], 0]) {
		// debug
//%		translate([0,0, WallW]) cylinder(h = BearingSize[0], r = BearingSize[1]/2);
//%		translate([0, 0, (WallW) + BearingSize[0] + WallW])	cylinder(h = BearingSize[0], r = BearingSize[1]/2);

		difference() {
			union() {
				// real big cylinder for bearings
				translate([0,0,-1])
					cylinder(r = (BearingSize[1] / 2), h = LMColumnSize[2] + 2);
			}
			assign(fn = $fn, fudge = 1.1) {
				translate([0,0,WallW / 2])
					torus(r1 = (BearingSize[1]/2) * fudge, r2 = (WallW / 2), $fn = fn);
				translate([0,0,(WallW) + BearingSize[0] + (WallW / 2)])
					torus(r1 = (BearingSize[1]/2) * fudge, r2 = (WallW / 2), $fn = fn);
				translate([0,0,LMColumnSize[2]])
					torus(r1 = (BearingSize[1]/2) * fudge, r2 = (WallW / 2), $fn = fn);
			}
		}
		assign(ZipSize = [3, 1.2], ZipOffset = 2.8) {
			translate([0,0,WallW + (BearingSize[0]/2) - (ZipSize[1] / 2)])
				ring(r1 = (BearingSize[1]/2) + ZipOffset + ZipSize[1], 
						r2 = (BearingSize[1]/2) + ZipOffset,
						h = ZipSize[0]);
			assign(SecondZipExtraOffset = 1)	// make sure that zip doesn't interfere with pully
			translate([0,0,WallW + BearingSize[0] + WallW + (BearingSize[0]/2) - (ZipSize[1] / 2) + SecondZipExtraOffset])
				ring(r1 = (BearingSize[1]/2) + ZipOffset + ZipSize[1], 
						r2 = (BearingSize[1]/2) + ZipOffset,
						h = ZipSize[0]);
		}
		
		// another one, offset
		translate([-SmoothRodR*1.1,0,-1])
			cylinder(r = (BearingSize[1] / 2) * 1, h = LMColumnSize[2] + 2);					
		// cut the back open
		translate([-LMColumnSize[0]-ZSRodPosition[0],-1-LMColumnSize[1]/2,0])
			cube([LMColumnSize[0],LMColumnSize[1]+2,LMColumnSize[2] + 2]);
	}
}

module motor() {
	difference() {
		motor_outside();
		motor_inside();
	}
}


module motor_outside() {
	translate(MotorMountedOutsidePosition) {
		rotate([90,0,0])
			motormount_outside();
				
		// top support
		assign(l = 22, w = 8, h = 5)
		translate([-w / 2,-l-MotorMountThickness+E,(MotorSide / 2)-MotorSideInset-h])
			cube([w, l, h]);
	
		// this is the whole underneath support
		render() translate([-(MotorSide/2)+MotorScrewInset, 
					-MotorMountThickness - MotorSideInset, 
					-(MotorSide/2)-MotorSideInset]) {
				translate([MotorMountThickness/4,MotorMountThickness+MotorSideInset,MotorMountThickness/6])
					rotate([90,0,0]) 
						cylinder(r = MotorMountThickness/1.5, h = MotorMountThickness);
				rotate([0,90,0]) 
				assign(r = MotorMountThickness + MotorSideInset, h = MotorSide-(2*MotorScrewInset), extra = MotorSideInset)
				difference() {
					cylinder(r = r + extra, h = h);
					translate([-r-extra*2,-r-1,-1])
						cube([r, (r*2) + 2, h + 2]);
					translate([-1-(extra*2),-r-1,-1])
						cube([r + 2+(4*extra), r+1+extra, h + 2]);
				
				translate([r+E+0.5,r-1,-E])
					rotate([90,-90,0])
						roundcorner(3);
			}
		}
	}
}

module motor_inside() {
	translate(MotorMountedOutsidePosition) 
		rotate([90,0,0])
			motormount_inside();
}



module motormount_outside() translate([-MotorSide/2,-MotorSide/2,0]) {
	translate([MotorSideInset, MotorSideInset, 0])
		cube([MotorSide - (2 * MotorSideInset), 
			MotorSide - (2 * MotorSideInset), 
			MotorMountThickness]);
	translate([MotorScrewInset, MotorScrewInset, 0])
		assign(d = MotorSide - (2 * MotorScrewInset)) for (x = [0:1]) for (y = [0:1])
			translate([x * d, y * d, 0])
				cylinder(r = 7, h = MotorMountThickness);
	// debug
//%	translate([0,0,-45]) cube([MotorSide, MotorSide, 45]);
%	translate([MotorSide/2,MotorSide/2,0]) cylinder(r = 8, h = 28);
}

module motormount_inside() translate([-MotorSide/2,-MotorSide/2,0]) {
	translate([-10,-10,-45-E]) cube([MotorSide+20, MotorSide+20, 45]);
	translate([MotorSide/2, MotorSide/2, -1])
		cylinder(r = (MotorSide/2) - (WallW * 1.5), h = MotorMountThickness + 2, $fn = 10);

	translate([MotorScrewInset, MotorScrewInset, 0])
		assign(d = MotorSide - (2 * MotorScrewInset)) for (x = [0:1]) for (y = [0:1])
			translate([x * d, y * d, 0]) {
				translate([0, 0, -1]) 	
					polyhole(d = M3R * 2, h = MotorMountThickness + 2);
				translate([0, 0, MotorMountThickness - MotorWasherInset])
					polyhole(d = M3WasherR * 2, h = MotorMountThickness + 2);
			}
}


module verticalsupport_outside(rotate=0, offset=[0,0,0]) render() {
	translate([0,ZSRodPosition[1],0])
	translate(offset)
	rotate([0,0,rotate])
	difference() {
		translate([105,0,63])
			rotate([90,0,0])
				ring(r1 = 100-E, r2 = 94, h = SupportRingW, $fn = 80);
		translate([0, - (SupportRingW / 2) - 1, -200+2])
			cube([200+2, SupportRingW + 2, 200]);
		translate([0, - (SupportRingW / 2) - 1, LMColumnSize[2]-WallW])
			cube([200+2, SupportRingW + 2, 200]);
		translate([ZTRodPosition[1], - (SupportRingW / 2) - 1, 0])
			cube([200+2, SupportRingW + 2, 200]);
	}
}

module nuttrap_outside() {
	translate(NutTrapPosition) {
		difference() {
			hull() {
				cylinder(h = NutTrapSize[1], r = NutTrapSize[0]);
				translate([NutTrapSize[0] * 2, 0, 0])
					cylinder(h = NutTrapSize[1], r = NutTrapSize[0]);
			}
			translate([NutTrapSize[0],-NutTrapSize[0] - 1,-1])
				cube([NutTrapSize[0]*2, (NutTrapSize[0]*2) + 2, NutTrapSize[1] + 2]);
		}
	}
}
module nuttrap_inside() {
	translate(NutTrapPosition) {
		union() {
			/* split the screw hole in 2, make sure it's printable.
			 * The membrane will have to be drilled out
			 */
			translate([0, 0, -5])
				polyhole(d = M3R * 2, h = 6);
			translate([0, 0, M3NutH + E])
				polyhole(d = M3R * 2, h = 6);
			translate([0,0, M3NutH + 1.1])
				cylinder(r1 = M3R, r2 = M3R * 6, h = 2); 
			hull() {
				translate([0,0,0])
					nut(d=M3NutW, h = M3NutH, horizontal=false);
				translate([10,0,0])
					nut(d=M3NutW, h = M3NutH, horizontal=false);
			}
		}
	}
}
module nuttrap_outsides() {
	nuttrap_outside();
	translate([0, SmoothRodSpacing, 0])
		nuttrap_outside();
}
module nuttrap_insides() {
	nuttrap_inside();
	translate([0, SmoothRodSpacing, 0])
		nuttrap_inside();
}

module smoothrod_and_nut_outside() render() {
	assign(endstop = M3NutW + (WallW * 1.2), thickness = WallW * 1.2) {
		translate([-XRod1Origin[0], 0, (WallW/2)-XRod1Origin[2]])
			translate([-thickness, -endstop/2, 0])
				roundrect(size=[WallW*2,endstop,endstop], r = 2);
	}
}

module smoothrod_and_nut_inside() {
	rotate([0,90,0])
		polyhole(d = SmoothRodR * 2, h = ZRodSpacing * 2);
	translate([-1-2*WallW,0,0])
		rotate([0,90,0])
			polyhole(d = M3R * 2, h = 3*WallW, $fn = 16);
	translate([-ZSRodPosition[0]-0.1, 0, 0])
		rotate([0,90,0]) {
			hull() {
				nut(d = M3NutW, h = M3NutH);
				translate([-10,0,0])
					nut(d = M3NutW, h = M3NutH);
			}
		}
}

module base_outside(MotorMount = 0, IdlerMount = 0) {
	assign(h = (2 * SmoothRodR) + (2 * WallW), 
		l = ZRodSpacing + (2 * SmoothRodR),
		w = SmoothRodSpacing  + (2 * SmoothRodR) + (2 * WallW),
		round = 8) {
		// two sleeves for the X smooth rods
		translate([l,0,0])
			rotate([0,-90,0])
				roundrect(size=[h, h, l], r = round);
		translate([l,w-h,0])
			rotate([0,-90,0])
				roundrect(size=[h, h, l], r = round);

		translate(XRod1Origin)
			smoothrod_and_nut_outside();
		translate(XRod2Origin)
			smoothrod_and_nut_outside();

		// bottom base
		translate([l,0,0]) {
			difference() {
				rotate([0,-90,0])
					roundrect(size=[h, w, l], r = round);
				translate([-l-1, -1, h / 2])
					cube([l + 2, w + 2, h]);
			}
		}
		// back support	-- a bit too much with the vertical braces
	//	translate([ZSmoothRodSupportW*1.3,0,0])
	//		rotate([0,-90,0])
	//			roundrect(size=[h, w, ZSmoothRodSupportW * 1.3], r = round);
	}
	nuttrap_outsides();
	lmcolumn_outside();
	verticalsupport_outside();
	if (MotorMount == 1) {
		verticalsupport_outside(rotate=-90, offset=[4,3.5,0]);
		motor_outside();
	}
	if (IdlerMount == 1) {
		verticalsupport_outside(rotate=90, offset=[4,-3.5,0]);
		idlermount_outside();
	}
}

module base_inside(MotorMount = 0, IdlerMount = 0) {
	// these are the two smooth rods
	translate(XRod1Origin)
		smoothrod_and_nut_inside();
	translate(XRod2Origin)
		smoothrod_and_nut_inside();

	translate([ZSRodPosition[0], ZSRodPosition[1], -1])
		cylinder(r = SmoothRodR, h = 20);

	// Threaded rod hole
	hull() {
		translate([ZTRodPosition[0], ZTRodPosition[1], -1])
			cylinder(r = ThreadedRodR, h = 20);
		translate([ZTRodPosition[0] + 10, ZTRodPosition[1], -1])
			cylinder(r = ThreadedRodR, h = 20);
	}
	
	difference() {
		translate([ZSmoothRodSupportW, (2*(SmoothRodR+WallW)), - 1])
			roundrect(size=[ 
				ZRodSpacing - ZSmoothRodSupportW - (WallW/2), 
				SmoothRodSpacing-(2*SmoothRodR) - (2*WallW),
				(2*(SmoothRodR + WallW)) + 2], r = 4);	
					
		translate([ZTRodPosition[0], ZTRodPosition[1], -1])
			cylinder(r = SmoothRodR*2.4, h = 20);			
		lmcolumn_outside();
		verticalsupport_outside();
	}	
	
	// slices bottom off
	translate([-30,-30, -(WallW / 2)])
		cube([100, 100, WallW]);
	// slices top off, of most things
	difference() {
		translate([-30,-30, WallW + (2*SmoothRodR) + (WallW / 2)])
			cube([100, 100, WallW]);
		nuttrap_outsides();
		lmcolumn_outside();
		verticalsupport_outside();
		if (MotorMount == 1) {
			verticalsupport_outside(rotate=-90, offset=[4,3.5,0]);
			motor_outside();
		}
		if (IdlerMount == 1) {
			verticalsupport_outside(rotate=90, offset=[4,-3.5,0]);
			idlermount_outside();
		}
	}
	nuttrap_insides();
	lmcolumn_inside();
	if (MotorMount == 1) {
		motor_inside();
	}	
	if (IdlerMount == 1) {
		idlermount_inside();
	}
	// cut the corners all around
	render() assign(w = (2*SmoothRodR)+ZRodSpacing, l = (2*SmoothRodR)+(2*WallW)+SmoothRodSpacing, r = 3) {
		translate([-E,-0.1,0]) roundcorner(r);
		translate([w+0.2,-E,0]) rotate([0,0,90]) roundcorner(r);
		translate([w+0.2,l+0.1,0]) rotate([0,0,180]) roundcorner(r);
		if (MotorMount == 0) {
			translate([-0.2,l+E,0]) rotate([0,0,270]) roundcorner(r);
		}
	}
	translate([ZTRodPosition[0] + SmoothRodR + E, ZTRodPosition[1] + ThreadedRodR - 0.2, -1])
		rotate([0,0,90])
			roundcorner(2, $fn=16);
	translate([ZTRodPosition[0] + SmoothRodR + E, ZTRodPosition[1] - ThreadedRodR + 0.2, -1])
		rotate([0,0,180])
			roundcorner(2, $fn=16);
}


/*
 * Utilities
 */
module roundrect(size=[0,0,0], r=1, center=0, fit=1) {
	assign(sx = size[0] - (fit * (2 * r)), sy = size[1] - (fit * (2 * r)))
	translate([-center * (size[0] / 2), -center * (size[1] / 2), -center * (size[2] / 2)])
	linear_extrude(height=size[2], slices=1)
	hull() {
	//	echo("r:", r, "x:", size[0], "sx:", sx, "y:", size[1], " sy:", sy);
		translate([r,r,0])
			for (x=[0:1]) for (y=[0:1]) 
				translate([x*sx, y*sy, 0])
					circle(r=r);
	}
}

module ring(r1, r2, h = 1) {
	translate([0,0,-h/2])
		linear_extrude(height=h, slices=1)
		difference() {
			circle(r = r1);
			circle(r = r2);
		}
}


module torus(r1 = 10, r2 = 1) {
	rotate_extrude() 	
	translate([r1,0,0])
		circle(r = r2);
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

// Based on nophead research
module polyhole(d,h) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}

module roundcorner(diameter){
	difference(){
		cube(size = [diameter,diameter,99], center = false);
		translate(v = [diameter, diameter, 0]) cylinder(h = 100, r=diameter, center=true);
	}
}
