/*
 * Laser Module ballhead mount
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
 * This is a small ballhead with a mount for a laser module. This will
 * print, despite the snafu Slic3r might make by starting in thin air 
 * in a couple of places.
 * The ballhead works, you need to clean it first with a knife, and then
 * "play" it quite a lot to make it smoother once mounted in the socket
 * It does get a lot better with a bit of practicing.
 */

FilamentThickness = 0.45;
LayerHeight = 0.20;
E=0.01;

$fn= 48;

WallW = 6 * FilamentThickness;
PointerR = 12 / 2;
PointerH = 15;
PonterSnapH = PointerR / 2;

BaseW = 25;
BaseH = 10 * LayerHeight;

BallR = 15 / 2;

LinkH = 8;
LinkR = 8/2;
CutoutW = 2;

TotalHeadH = PointerR + WallW + LinkH + BallR + PonterSnapH;

ball();

translate([0, -PointerH-2, TotalHeadH])
	rotate([0,180,0])
		head();
assign(basew=33,basel=50)
translate([-basew/2, -12-basel/2, 0])
#cube([basew, basel, LayerHeight/2]);

module ball() {
	translate([-BaseW / 2, -BaseW / 2, 0])
		cube([BaseW, BaseW, BaseH]);
	
	translate([0,0,BaseH - E])
		cylinder(r = LinkR, h = LinkH + (BallR / 2));
		
	translate([0,0,BaseH + LinkH + BallR])
		sphere(r = BallR);
}

module head() {
	difference() { 
		union() {
			translate([0,0,PonterSnapH])
				rotate([90,0,0])
					cylinder(r = PointerR + WallW, h = PointerH);

			translate([0, -PointerH/2, PointerR + WallW-2 ])
				cylinder(r1 = LinkR + WallW+1.2, r2 = LinkR, h = LinkH);

			translate([0, -PointerH/2, PointerR + WallW + LinkH + BallR])
				sphere(r = BallR + WallW);				
			
		}
		translate([0,10,PonterSnapH])
			rotate([90,0,0])
#				cylinder(r = PointerR, h = PointerH+20);

		translate([0, -PointerH/2, PointerR + WallW + LinkH + BallR])
			sphere(r = BallR);

		translate([0, -PointerH/2, TotalHeadH]) {
			translate([-25,-25,0])
				cube([50,50,10]);
			translate([-CutoutW/2,-25,-5])
				cube([CutoutW, 50, 10]);
			translate([-25,-CutoutW/2,-5])
				cube([50, CutoutW, 10]);
		}
		
		translate([-25,-25,-10])
			cube([50,50,10]);
	}
}
