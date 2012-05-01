
debug = 1;
//$fn = 60 * ((1-debug) * 0.4);
$fn = 60;

RodDistance = 145;
Tolerance = 0.2;
WallW = 2.1;

BearingR = (15 + Tolerance) / 2;
BearingL = (24 + Tolerance);
RodR = 4;

BedW = 210.4;
BedL = 210.4;
BedHolesInset = 2;
BedHolesR = 1.5;

RightASide = 52.2 + Tolerance;
RightAW = 16.3 + Tolerance;
RightAH = 2;
RightAHole1 = 16;
RightAHole2 = 43;
RightAHoleR = 4.7 / 2;

JoinL = 75.7;
JoinW = 16.1;
JoinH = 1.7;
JoinHole1 = 8;
JoinHole2 = 28.5;
JoinHoleR = 4.7 / 2;

FlatAL = 63.6;
FlatAW = 12.8 + Tolerance;
FlatAH = 2;
FlatAHole1 = 22;
FlatAHoleDistance = 32;
FlatAHole2 = FlatAHole1 + FlatAHoleDistance;
FlatAHoleR = 4.7 / 2;

BeltDistance = 58;
BeltClampWidth = 25;

ScrewR = 1.5 + Tolerance;
WasherR = (6.80+Tolerance) / 2;
StandoffH = 10;

ElongatedCutL = 7;

E=0.001;

CutDepth = 5;
CutRound = 3;

if (debug == 1) {
	ycarryside();
	translate([0, BedL, 0]) color("Cyan", 0.3) rotate([90, 0, 0]) {
		cylinder(r = RodR, h = BedL*1.2);
		translate([RodDistance, 0, 0])
			cylinder(r = RodR, h = BedL*1.2);
	}
	
	translate([0, WallW + Tolerance, BearingR + WallW + StandoffH]) {
		translate([(RodDistance / 2) - (BedW / 2), -FlatAHole2 - BedHolesInset, FlatAH])
			color("Red", 0.2) hotbed();
		translate([(RodDistance / 2) - (BedW / 2) - (FlatAW/2) + BedHolesInset, 0, 0]) rotate([0,0,-90])
			color("Gray", 0.3) flatangle();
	}

*	translate([0,WallW+Tolerance, BearingR + WallW + RightAHole1 + (JoinW / 2)]) {
		translate([(RodDistance / 2) - (BedW / 2), -RightAHole2, 0])
			color("Red", 0.2) hotbed();
		
	translate([(RodDistance / 2) - (BedW / 2), -RightAHole2, -RightAH])
			rotate([0, 0, -90])
				translate([-RightAHole2 - BedHolesInset, -(RightAW / 2) + BedHolesInset, 0])
					color("Gray", 0.5)  {
						rightangle();
						rotate([90,0,90]) translate([(RightAW/2)-JoinHole1, -RightAHole1-(JoinW/2), RightAH])
							joiningplate();
					}
	}
} else {
	rotate([0, 180, 0]) ycarryside();
	standoff();
}


module ycarryside(BeltDistance = BeltDistance) {
	assign(ExtraH = 0, ExtraW = 11)
	difference() {
		union() {
			translate([-BearingR - WallW - (ExtraW/2), -BearingL-WallW, 0])
				roundrect_fit(r = 4, size=[RodDistance + (2* BearingR) + (2 * WallW) + (ExtraW), 
					BearingL + (2 * WallW), (BearingR + WallW + ExtraH) / 2]);
			if (ExtraW > 0) {
				translate([-BearingR - WallW - ExtraW, -ExtraW, 0])
					roundrect_fit(r = 4, size=[RodDistance + (2* BearingR) + (2 * WallW) + (2*ExtraW), 
						FlatAW, (BearingR + WallW + ExtraH) / 2]);
			}
			for (b = [0, 1]) {
				rotate([90,0,0]) translate([b * RodDistance, 0, -WallW])
					cylinder(r = BearingR + WallW, h =  BearingL + (2 * WallW));
			}
		}
		// cut out bearing holes
		rotate([90,0,0]) for (b = [0:1]) translate([b * RodDistance, 0, 0]) {
			translate([0, 0, -WallW -1])
				cylinder(r = BearingR - (WallW/2), h =  BearingL + (2 * WallW) + (2));
				
			// make a hole for the bearing proper
			cylinder(r = BearingR, h =  BearingL);

			// not cut out a groove for the ziptie
			assign(ziph = 2, zipw = 3) { 
				translate([0, 0, (BearingL / 2) /*-(zipw / 1)*/]) difference() {
					cylinder(r = BearingR + WallW + ziph, h = zipw);
					translate([0,0, -1])
						cylinder(r = BearingR + WallW - (ziph/3), h = zipw + 2);
				}
			}
		}
		// cut out underside of bearings
		translate([-BearingR - WallW - E-1, -BearingL - WallW - E-1, -BearingR-WallW-E-1])
			cube(size=[RodDistance + (2* BearingR) + (2 * WallW) + (2*(1+E)), 
				BearingL + (2 * WallW) + (2*(1+E)) , BearingR + WallW]);
		

		translate([BearingR + WallW, WallW + 1, 0]) rotate([90,0,0])
			assign(cutl = BearingL + WallW + 2, 
					cuth = BearingR*2) {
				translate([0,-cuth-cuth+BearingR,0]) {
					// if the ears are present, trim them too
					if (ExtraW > 0) {
						assign (cutw = ExtraW * 2) {
							translate([-((BearingR + WallW)*2) - cutw, 0, 0])
								roundrect_fit(r = CutRound, size=[cutw, cutl, cuth]);
							translate([RodDistance , 0, 0])
								roundrect_fit(r = CutRound, size=[cutw, cutl, cuth]);
						}
					}

					assign (cutw = BeltDistance - (BeltClampWidth / 2))
						roundrect_fit(r = CutDepth, size=[cutw, cutl, cuth]);

					assign (cutw = (RodDistance - BeltDistance) - (BeltClampWidth / 2) - (BearingR*2) - (2*WallW))
						translate([RodDistance - cutw - (BearingR*2) - (2*WallW), 0, 0])
							roundrect_fit(r = CutDepth, size=[cutw, cutl, cuth]);

				}
			}

		// cut the screw elongated holes
		assign(cutl = ElongatedCutL) for (b = [0:1]) translate([b * RodDistance, 0, 0]) {
			translate([-BearingR - WallW - WasherR - cutl, WallW - (FlatAW / 2), 0]) {
				translate([0, 0, 1])
					longcylinder(r = ScrewR, l = cutl, h = 10);
				translate([0, 0, -WallW*2])
					longcylinder(r = WasherR, l = cutl, h = 10);
			}
			translate([BearingR + WallW + WasherR, WallW - (FlatAW / 2), 0]) {
				translate([0, 0, 1])
					longcylinder(r = ScrewR, l = cutl, h = 10);
				translate([0, 0, -WallW*2])
					longcylinder(r = WasherR, l = cutl, h = 10);
			}
		}

	

		// cutout at the front
		assign(middlecut=(BearingL/2)-(3*WallW))
		assign(cutw = RodDistance - (2* (BearingR + WallW)), cutl = BearingL - WallW + 2, cuth = (BearingR*2) + JoinW) {
			translate([BearingR + WallW, -cutl - cutl + WallW + middlecut, -cuth])
					roundrect_fit(r = CutDepth, size=[cutw, cutl, cuth]);
			
			// cut ears cutouts
			translate([-BearingR - WallW - (ExtraW*2), -cutl - FlatAW + WallW, -cuth])
					roundrect_fit(r = CutDepth, size=[ExtraW*2, cutl, cuth]);
			translate([RodDistance + (BearingR + WallW), -cutl - FlatAW + WallW, -cuth])
					roundrect_fit(r = CutDepth, size=[ExtraW*2, cutl, cuth]);
		}
	}
	
}

module standoff() {
	assign(width = (BearingR*2) + (WallW*2) + (ElongatedCutL*2) + (WasherR*2), cutl = ElongatedCutL) {
		difference() {
			roundrect_fit(r = CutRound, size=[width, FlatAW, StandoffH / 2]);

			translate([width/ 2, 0, 0]) {
				translate([-BearingR - WallW - WasherR - ElongatedCutL,  (FlatAW / 2), 0]) {
					translate([0, 0, -1])
				#		longcylinder(r = ScrewR, l = ElongatedCutL, h = StandoffH+2);
				}
				translate([BearingR + WallW + WasherR, (FlatAW / 2), 0]) {
					translate([0, 0, -1])
				#		longcylinder(r = ScrewR, l = ElongatedCutL, h = StandoffH+2);
				}
			}
		}
	}
}

module hotbed() {
	difference() {
		cube(size=[BedW, BedL, 1.5]);
		translate([BedHolesInset, BedHolesInset, -E])
			for (x = [0:1]) for (y = [0:1]) {
				translate([x * (BedW - (2 * BedHolesInset)), y * (BedL - (2 * BedHolesInset)), 0])
				cylinder(r = BedHolesR, 1.5 + (2*E));
			}
	}
}

module rightangle() assign(side = RightASide, width = RightAW, height = RightAH) {
//	translate([-height / 2, -width / 2, -height / 2]) 
	for (y = [0,1]) rotate([0, y * 90, 0])
		union() {
			difference() {
				cube(size = [side, width, height]);
				translate([RightAHole1, width/2, -E])
					cylinder(r = RightAHoleR, h = height + (2*E));
				translate([RightAHole2, width/2, -E])
					cylinder(r = RightAHoleR, h = height + (2*E));
			}
		}
}

module flatangle(length = FlatAL, width = FlatAW, height = FlatAH) union() {
	for (s = [0:1])
		translate([s*FlatAW, 0, 0]) rotate([0,0,s*90]) difference() {
			cube([FlatAL, FlatAW, FlatAH]);	
			translate([FlatAHole1, width/2, -E - 30])
				cylinder(r = FlatAHoleR, h = height + (2*E) + 60);
			translate([FlatAHole2, width/2, -E - 30])
				cylinder(r = FlatAHoleR, h = height + (2*E) + 60);
		}
}

module joiningplate(length = JoinL, width = JoinW, height = JoinH) {
	difference() {
		cube(size=[length, width, height]);
		translate([JoinHole1, width / 2, -1])
			cylinder(r = JoinHoleR, h = height + 2);
		translate([JoinHole2, width / 2, -1])
			cylinder(r = JoinHoleR, h = height + 2);
		translate([length - JoinHole1, width / 2, -1])
			cylinder(r = JoinHoleR, h = height + 2);
		translate([length - JoinHole2, width / 2, -1])
			cylinder(r = JoinHoleR, h = height + 2);
	}
}

module roundrect(size = [1,1,1], r = 1, a=[0,0,0], h = 0) {
	minkowski() {
		cube(size=size);
		rotate(a)
			if (h == 0)
				cylinder(r=r, h=size[2]);
			else
				cylinder(r=r, h=h);
	}
}

module roundrect_fit(size = [1,1,1], r = 1, a=[0,0,0], h = 0) {
	translate([r, r, 0])
		roundrect(size = [size[0] - (2*r), size[1] - (2*r), size[2]], a=a, r=r, h=h);
}


module longcylinder(r, h, l) union() {
	cylinder(r = r, h = h);
	translate([l, 0, 0])
		cylinder(r = r, h = h);
	translate([0, -r, 0])
		cube(size=[l, 2*r, h]);
}
