/*
 * 65mm CNC Spindle Clamp
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
 * This is a spindle clamp adapted for the OpenBuilds OX V-SLot. There are two
 * modes to make this:
 * 1) 3D Printed, the camp was printed and works perfectly well, however, being plastic
 *    I decided also to make it my own 'first cut' part for the CNC itself by cutting
 *    out of... 5MM aluminium plate
 * 2) So by setting 'CNC' variable and 'M3TAPS' you can have that same mount layed out
 *    as a ready-to-cut sandwitch, with extra holes to attach them together. Note that
 *    the M3 holes are not the same size, one side is made to have the screws go thru,
 *    and the other side is meant to be taped with a M3 thread
 * You then screw both halves together and you're done!
 */

CNC=1;

M3TAPS=CNC==1? 1 : 0;

E=0.01;
$fn = 96;

ScrewR=5.5/2; // M5
ScrewHeadR= 9.5/2;	// Screw head thickness
ScrewHeadH= 1.5; //2.8;
ScrewL=25;
ScrewLLost=5;	// what needs to be embedded in T-nut

MountT= CNC==1 ? 8 : 10; // Mount thickness
ScrewHeadMargin=2;
MountH=(ScrewHeadR*2) + (ScrewHeadMargin * 2);	// mount height
SpindleRadius=65.2	/2;

VSlotWidth=60;
VSlotMargin=10;

ClampW = 16;
ClampL = 20;

if (CNC==1) {
	assign(half=SpindleRadius + MountT + E + (ClampL)) {
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
	}
} else {
	mount(0);
}
module mount(tap = 1) assign(BaseW = CNC == 1? MountT : MountT) {
	difference() {
		union() {
			cylinder(r = SpindleRadius + MountT, h = MountH);
	
			translate([SpindleRadius - MountT, -VSlotWidth/2, 0])
				cube([BaseW * 2, VSlotWidth, MountH]);
	
			translate([-ClampW/2, SpindleRadius , 0])
				cube([ClampW, ClampL , MountH]);
	
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
	
		// split between the two clamps. It is bigger for the CNC one
		// but is kept as a min for the 3D plastic to prevent breakage
		assign(SplitW = CNC == 1 ? 3 : 1)
		translate([-SplitW / 2, SpindleRadius - 1,-E])
			cube([SplitW, MountT+ClampL, MountH+(2*E)]);
	
	
		/* Screw head and nut head cutouts */
		translate([-(ClampL/2 + 10), SpindleRadius + ClampL - ScrewHeadR - ScrewHeadMargin, MountH/2])
			translate([ScrewHeadH*2, 0, 0])
			rotate([0, 90, 0])
				cylinder(r = ScrewHeadR *1.2, h = 9);
		translate([ClampL/2 , SpindleRadius + ClampL - ScrewHeadR - ScrewHeadMargin, MountH/2])
			translate([1-ScrewHeadH*2, 0, 0])
			rotate([0, 90, 0])
				cylinder(r = ScrewHeadR *1.2, h = 9);	

		if (M3TAPS==1) {
			for (x = [-1, 1]) for (y = [-1,1]) 
			assign(rpos = SpindleRadius + (MountT/2), a = x == 1 ? 60 : 45)
			assign(xo = rpos * cos(a), yo = rpos * sin(a))
			{
				translate([x * xo, y * yo, -E])
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




module screw() {
	cylinder(r = ScrewHeadR, h = ScrewHeadH);
	translate([0,0,-E])
		cylinder(r = ScrewR, h = ScrewL - (ScrewHeadH) + (2*E));
}
