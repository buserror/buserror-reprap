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
NutR = 5.7 /2;
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

	translate([0, 0, FloorH])
	%	cylinder(r = BearingR, h = BearingH);
	
	
	translate([0, 0, -1])
		cylinder(r = BearingInsideR, h = TotalH + 2);

	translate([RodDistance,0,-1])
		cylinder(r = RodR, h = TotalH + 2);		

	translate([RodDistance,-(ClampW/2) + WallW, -1])
		cube([ClampL + 1, ClampW-(2*WallW), TotalH +2]);

	translate([RodDistance + ScrewOffset, -(ClampW/2), TotalH / 2]) {
		translate([0,-1,0])
			rotate([-90,0,0])
#				cylinder(r = ScrewR, h = ClampW + 2, $fn = 16);
		translate([0,-NutH + NutInset,0])
			rotate([-90,30,0])
				nut(d = NutR*2, h = NutH);
		translate([0,ClampW - WasherInset,0])
			rotate([-90,0,0])
				cylinder(r = WasherR, h = 3);
	}
	//nut
}


module nut(d,h,horizontal=true){
cornerdiameter =  (d / 2) / cos (180 / 6);
cylinder(h = h, r = cornerdiameter, $fn = 6);
if(horizontal){
for(i = [1:6]){
	rotate([0,0,60*i]) translate([-cornerdiameter-0.2,0,0]) rotate([0,0,-45]) cube(size = [2,2,h]);
}}
}
