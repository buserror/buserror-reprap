/*
 * 65mm CNC Spindle Clamp (All Parametric)
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
 */
/*
 * This is a spindle clamp adapted for the OpenBuilds OX V-SLot. There are the
 * modes to make this:
 * 1) 3D Printed, the camp was printed and works perfectly well, however, being 
 *    plastic I decided also to make it my own 'first cut' part for the CNC 
 *    itself by cutting out of... 5MM aluminium plate.
 * 2) So by setting 'CNC' variable and 'M3TAPS' you can have that same mount 
 *    layed out as a ready-to-cut sandwitch, with extra holes to attach them 
 *    together. Note that the M3 holes are not the same size, one side is made 
 *    to have the screws go thru, and the other side is meant to be taped with 
 *    a M3 thread.
 *    > You then screw both halves together and you're done! <
 * 3) You can also add a laser pointer holder on one of the mount, for mounting
 *    one of these fancy cross laser to position your origin. Note that is 
 *    hasn't been tested yet, and will require you to drill and tap for a grub
 *    screw in the case of aluminium, or press-fit a M3 insert in the plastic 
 *    if you print it.
 */

CNC=0;

M3TAPS=CNC==1? 1 : 0; // dont' need taps on the printed version

E=0.01;
$fn = 96;

ScrewR=5.5/2; 		// M5
ScrewHeadR= 9.5/2;	// Screw head thickness
ScrewHeadH= 1.5; 	//
ScrewL=25;
ScrewLLost=5;	// what needs to be embedded in T-nut

MountT= CNC==1 ? 8 : 10; // Mount thickness
ScrewHeadMargin=2;
MountH=	CNC==1 ?
		8 /* 2 layers of 4mm Aluminium plate */:
		(ScrewHeadR*2) + (ScrewHeadMargin * 2);	// mount height
		
/* this one is the KEY variable. Too small, and the spindle won't fit, or the
 * gap between the jaws to secure it will be too big for your screw..
 * Too small, and the jaw will touch before securing the spindle. Bad idea.
 * 
 * This is specialy important for the 3d printer part, as the PLA doesn't like
 * mecanical stress, so you need to make sure it's secure, but as closed to
 * 'closed jaws' as you can.
 */
SpindleRadius= 65.2	/ 2;	

VSlotWidth=60;
VSlotMargin=10;

ClampW = 16;
ClampL = 20;

/* 
 * You can have a laser pointer mount by fiddling with these 
 */
LaserR = 12/2; // Set to non zero if you want a lazor pointer mount (Ex: 12/2)
/* This WILL require tweaking if you chance the spindle diameter significantly.
 * it is hard coded so that you know /exactly/ what the offset will be compared
 * to the spindle center, to enter into the CAM program
 */
LaserOffsetR = 30;	// hard coded value, to make sure the offset stays constant in CAM

if (CNC==1) {
	half=SpindleRadius + MountT + E + (ClampL);
	difference() {
		union() {
			mount(1);
			translate([3 + (SpindleRadius + MountT + E)*2, 0, MountH]) {
				rotate([180, 0, 180])
					mount(0);
			}
		}
		translate([-half, -half, MountH/2]) 
			cube([half * 3.2, half * 2, MountH]);
	}	
} else {
	mount(0);
}


/* this is 2D on purpose, as it's 'offset'ed for round corners */
module rawMountOutline(BaseW) union() {
	circle(r = SpindleRadius + MountT);

	translate([SpindleRadius - MountT, -VSlotWidth/2, 0])
		square([BaseW * 2, VSlotWidth]);
	translate([-ClampW/2, SpindleRadius , 0])
		square([ClampW, ClampL]);
	laserout();
}

module mount(tap = 1) {
	BaseW = CNC == 1? MountT : MountT;
	difference() {
		/* this bit is the 'additive' part, add all the outside shapes
		 * together, and the second part will 'carve' bits out
		 */
		union() {
			linear_extrude(height=MountH) {
				union() {
					offset(r = -8)
					offset(r = 16)
					offset(r = -8)
						rawMountOutline(BaseW);
					rawMountOutline(BaseW);					
				}
			}
		}
	
		translate([0,0,-E])
			cylinder(r = SpindleRadius, h = MountH + (2*E));
	
		translate([SpindleRadius - MountT - ScrewHeadR, -((VSlotWidth/2)-VSlotMargin), MountH/2])
			rotate([0, 90, 0]) union() {
				cylinder(r = ScrewR + E, h = ScrewL);
				cylinder(r = ScrewHeadR * 1.15, h = MountT + ScrewHeadR);
			}
		translate([SpindleRadius - MountT - ScrewHeadR, ((VSlotWidth/2)-VSlotMargin), MountH/2])
			rotate([0, 90, 0]) union() {
				cylinder(r = ScrewR + E, h = ScrewL);
				cylinder(r = ScrewHeadR * 1.15, h = MountT + ScrewHeadR);
			}
		// middle screw is a bit deeper
		translate([SpindleRadius - MountT - ScrewHeadR, 0, MountH/2])
			rotate([0, 90, 0]) union() {
				cylinder(r = ScrewR + E, h = ScrewL);
				cylinder(r = ScrewHeadR * 1.15, h = MountT + ScrewHeadR + ScrewHeadH);
			}
	
		// screw path for clamp screw
		translate([-(2*E) -ClampW/2, SpindleRadius + ClampL - ScrewHeadR - ScrewHeadMargin, MountH/2])
			rotate([0, 90, 0]) {
				cylinder(r = ScrewR + (2*E), h = ClampW * 1.2 );
			}
	
		/* split between the two clamps. It is bigger for the CNC one
		 * but is kept as a min for the 3D plastic to prevent breakage */
		{
			SplitW = CNC == 1 ? 3 : 1;
			translate([-SplitW / 2, SpindleRadius - 1,-E])
				cube([SplitW, MountT+ClampL, MountH+(2*E)]);
		}
	
		/* Screw head and nut head cutouts */
		translate([-(ClampL/2 + 10), SpindleRadius + ClampL - ScrewHeadR - ScrewHeadMargin, MountH/2])
			translate([ScrewHeadH*2, 0, 0])
			rotate([0, 90, 0])
				cylinder(r = ScrewHeadR *1.2, h = 9);
		translate([ClampL/2 , SpindleRadius + ClampL - ScrewHeadR - ScrewHeadMargin, MountH/2])
			translate([1-ScrewHeadH*2, 0, 0])
			rotate([0, 90, 0])
				cylinder(r = ScrewHeadR *1.2, h = 9);	

		laserin();

		/* if applicable, punch some holes for M3 screws */
		if (M3TAPS==1) {
			rpos = SpindleRadius + (MountT/2);
			for (a = [60, 20]) {
				xo = rpos * cos(a); yo = rpos * sin(a);				
				for (y = [-1, 1]) 
				translate([xo, y * yo, -E])
					cylinder(r = tap ? 1 : 1.5, h = MountH+(2*E));
			}
			for (a = [60, 20]) {
				xo = rpos * cos(a); yo = rpos * sin(a);				
				for (y = [-1, 1]) 
				translate([-xo, y * yo, -E])
					cylinder(r = tap ? 1 : 1.5, h = MountH+(2*E));
			}
		}
	}

	/* DEBUG display screws */
	%translate([SpindleRadius - ScrewHeadH, (-VSlotWidth/2)+VSlotMargin, MountH/2])
		rotate([0, 90, 0])
			screw();
	
	%translate([-(2*E) -ClampW/2, SpindleRadius + ClampL - ScrewHeadR - ScrewHeadMargin, MountH/2])
		translate([-ScrewHeadH*2, 0, 0])
		rotate([0, 90, 0])
			screw();

}
/* outter shape fo the laser mount, in 2D */
module laserout() {
	if (LaserR > 0) {
		translate([-LaserOffsetR, LaserOffsetR])
			hull() {
				circle(r = LaserR + (CNC==1 ? 2 : 3));
				translate([5,-5])
					circle(r = LaserR + 3);
			}
	}
}
/* inner shape of the laser mount (the hole!) */
module laserin() {
	if (LaserR > 0) {
		translate([-LaserOffsetR, LaserOffsetR, 0])
			translate([0,0,-E])
				cylinder(r = LaserR, h = MountH+(2*E));
	}
}

/* A M25x20 screw, for debugging and scale */
module screw() {
	cylinder(r = ScrewHeadR, h = ScrewHeadH);
	translate([0,0,-E])
		cylinder(r = ScrewR, h = ScrewL - (ScrewHeadH) + (2*E));
}
