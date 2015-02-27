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

E=0.01;
$fn = 96;

ScrewR=5.5/2; // M5
ScrewHeadR= 9.5/2;	// Screw head thickness
ScrewHeadH= 1.5; //2.8;
ScrewL=25;
ScrewLLost=5;	// what needs to be embedded in T-nut

MountT=10; // Mount thickness
ScrewHeadMargin=2;
MountH=(ScrewHeadR*2) + (ScrewHeadMargin * 2);	// mount height
SpindleRadius=65.2	/2;

VSlotWidth=60;
VSlotMargin=10;

ClampW = 16;
ClampL = 20;

CNC=0;
M3TAPS=1;

if (CNC==1) {
	assign(half=SpindleRadius + MountT + E + (ClampL/2)) {
		difference() {
			mount();
			translate([-half, -half, MountH/2]) 
				cube([half * 2, half * 2, MountH]);
		}
	
		difference() {
			translate([3 + (SpindleRadius + MountT + E)*2, 0, MountH]) {
				rotate([180, 0, 180])
					mount();
			}
				translate([-10+half, -half, MountH/2]) 
					cube([half * 2, half * 2, MountH]);
		}
	}
} else {
	mount();

}
module mount() {
	difference() {
		union() {
			cylinder(r = SpindleRadius + MountT, h = MountH);
	
			translate([SpindleRadius - MountT, -VSlotWidth/2, 0])
				cube([MountT * 2, VSlotWidth, MountH]);
	
	
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
	
		// split between the two clamps
		translate([-1/2,SpindleRadius - 1,-E])
			cube([1, MountT+ClampL, MountH+(2*E)]);
	
	
		/* Screw head and nut head cutouts */
		translate([-(ClampL/2 + 10), SpindleRadius + ClampL - ScrewHeadR - ScrewHeadMargin, MountH/2])
			translate([ScrewHeadH*2, 0, 0])
			rotate([0, 90, 0])
				cylinder(r = ScrewHeadR *1.2, h = 9);
		translate([ClampL/2 , SpindleRadius + ClampL - ScrewHeadR - ScrewHeadMargin, MountH/2])
			translate([1-ScrewHeadH*2, 0, 0])
			rotate([0, 90, 0])
				cylinder(r = ScrewHeadR *1.2, h = 9);
	
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
