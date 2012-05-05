/*
 * Z Thread Holder
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
 * This allows to trap the Z threaded rod at exactly the 30mm from
 * the smooth rod using a 608 bearing.
 */

FilamentThickness = 0.45;
LayerHeight = 0.20;

BearingR = 22.1 / 2;
BearingH = 7;
BearingInsideR = 12.6 / 2;
RodR = 8.1 / 2;
RodDistance = 30;
WallW = 6 * FilamentThickness;

BearingWallW = 4 * FilamentThickness;
FloorH = 4 * LayerHeight;
ClampL = 11;
ClampW = 12;
LinkW = 2*WallW;

ScrewR = 3.1 / 2;
NutR = 5.72 /2;
NutH = 2.1;
NutInset = 2*FilamentThickness;
WasherR = 7.6 / 2;
WasherInset = 2*FilamentThickness;

ScrewOffset = (ClampL / 5) * 3;
TotalH = FloorH + BearingH + (2*LayerHeight);

difference() {
	outside();
	inside();
}

module outside() {

	cylinder(r = BearingR + BearingWallW, h = TotalH);

	translate([0,-LinkW/2,0])
		cube([RodDistance, LinkW, TotalH]);
	
	translate([RodDistance,0,0])
		cylinder(r = RodR + WallW, h = TotalH);		

	translate([RodDistance,-(ClampW/2),0])
		cube([ClampL, ClampW, TotalH]);

}


module inside() {

	translate([0, 0, FloorH])
		cylinder(r = BearingR, h = TotalH + 1);
	
	translate([0, 0, -1])
		cylinder(r = BearingInsideR, h = TotalH + 2);

	translate([RodDistance,0,-1])
		cylinder(r = RodR, h = TotalH + 2);		

	translate([RodDistance,-(ClampW/2) + WallW, -1])
		cube([ClampL + 1, ClampW-(2*WallW), TotalH +2]);

	translate([RodDistance + ScrewOffset, -(ClampW/2), TotalH / 2]) {
		translate([0,-1,0])
			rotate([-90,0,0])
				cylinder(r = ScrewR, h = ClampW + 2, $fn = 16);
		translate([0,-NutH + NutInset,0])
			rotate([-90,30,0])
				nut(r = NutR, h = NutH);
		translate([0,ClampW - WasherInset,0])
			rotate([-90,0,0])
				cylinder(r = WasherR, h = 3);
	}
}


module nut(d = 0, r = 0, h) {
	realr =  ((d > 0) ? d / 2 : r) / cos (180 / 6);
	cylinder(r = realr, h = h, $fn = 6);
}
