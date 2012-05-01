/*
 * Wide Fan Duct
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
 * My Prusa uses a fairly wide nut to hold the hotend against the 
 * extruder. It means most "fan duct" don't work at all. The only
 * one that fit was pretty dreadful and required over 3 meters of
 * plastic.
 * 
 * Anyway, here's mine. It fits nicely around the hotend and
 * cable, and sends the air as a slight vortice around the hotend.
 * 
 * It prints fairly easily, apart from the very top of the torus
 * that definitely need a fan. Other than that, it's easy.
 *
 */

E = 0.001;
DistanceFanNozzle = 50;
RadiusAroundNozzle = 64 / 2;
FanOutterSize = 40;
FanHolesInset = (40 - 32) / 2;
FanHolesR = 1.6; // M3

FanFaceThickness = 2.7;
TorusWallThickness = 1.8;
TorusRadius = 6;
TorusFaceCount = 24;
TorusHoleCount = 20;
TorusHoleRadius = 2;
TorusHoleAngle = 70;
TorusHoleVortexAngle = 10;
TorusBaseClip = TorusWallThickness / 2;

MagicOffsetY = 18;
MagicOffsetZ = 5;

ExtraOpeningWidth = FanOutterSize * 1;
DuctDepth = (DistanceFanNozzle-RadiusAroundNozzle+(TorusRadius/2));
DuctRadius = 6;

difference() {
	difference() {
		union() {
			FanHeadOutside();
			translate([FanOutterSize / 2, DistanceFanNozzle, 0])
				TorusOutside();
			translate([(FanOutterSize/2), E, E])
				DuctOutside();
		}
		difference() {
			union() {
				translate([0,-E,0])
					FanHeadInside();
				translate([FanOutterSize / 2, DistanceFanNozzle, 0])
					TorusInside();
				difference() {
					translate([(FanOutterSize/2), 0, TorusWallThickness/2])
						DuctOutside(TorusWallThickness * 0.8);			
				}	
			}
			// poke screw holes 
			translate([0,FanFaceThickness*2, 0], $fn=16) {
				difference() {
					union() {
						rotate([90,0,00])
							cylinder(r = FanHolesInset*2.3, h = (FanFaceThickness*2) + E, $fn=32);
						translate([FanOutterSize, 0, 0])
							rotate([90,0,00])
								cylinder(r = FanHolesInset*2.3, h = (FanFaceThickness*2) + E, $fn=32);
					}
					translate([FanHolesInset,1,FanHolesInset]) {
						rotate([90,0,00])
							cylinder(r = FanHolesR, h = (FanFaceThickness*2) + 2);
						translate([FanOutterSize-(2*FanHolesInset),0,0]) rotate([90,0,00])
							cylinder(r = FanHolesR, h = (FanFaceThickness*2) + 2);
			
					}
				}
			}
		}
	}
}

/*
translate([0,-50,0]) difference() {
	DuctOutside();
	translate([0,-E,TorusWallThickness/2])
		DuctOutside(TorusWallThickness*0.8);
}
*/
module DuctOutside(inset=0) {
	assign(h = (TorusRadius-(TorusWallThickness/2)-(inset/2))*2)
	translate([-(ExtraOpeningWidth-(inset*2))/2, DuctDepth, -h-inset])
	difference() {
		rotate([90,0,0])
			roundrect_fit(size=[ExtraOpeningWidth-(inset*2), h*2, DuctDepth/2], r=DuctRadius);
		translate([-1, -50, -1])
			cube(size=[ExtraOpeningWidth+2, 100, h + inset + 1]);
	}
}

module FanHead() {
	difference() { FanHeadOutside(); FanHeadInside(); }
}
module FanHeadOutside() {
	difference() {
		union() {
			cube(size=[FanOutterSize, FanFaceThickness, FanOutterSize]);
			translate([FanOutterSize/2,-MagicOffsetY,MagicOffsetZ]) {	
				// big fat torus
				rotate([90,0,90])
					rotate_extrude($fn=30) 
						translate([FanOutterSize/2, 0, 0])
							circle(r = (FanOutterSize / 2) - E);				
			}
		}

		translate([FanOutterSize/2,-MagicOffsetY,MagicOffsetZ]) {	
			// trim bottom of fat torus
			translate([-(FanOutterSize + 2)/2,-(FanOutterSize + 2),0]) {
				translate([0,0,-FanOutterSize - 1])
					cube(size=[FanOutterSize + 2, (FanOutterSize + 2)*2, FanOutterSize + 2 - TorusRadius ]);
				translate([0,0,-TorusRadius])
					cube(size=[FanOutterSize + 2, (FanOutterSize * 2) - (FanOutterSize-MagicOffsetY)+2+E, FanOutterSize + 1 + TorusRadius]);
			}
		}
	}
}

module FanHeadInside() {
	translate([0,-0.01,0]) difference() {
		union() {
			translate([FanOutterSize/2,-MagicOffsetY,MagicOffsetZ]) {	
				// big fat torus
				rotate([90,0,90])
					rotate_extrude($fn=30) 
						translate([FanOutterSize/2,0,0])
							circle(r = (FanOutterSize / 2) - TorusWallThickness);				
			}
			// poke screw holes 
			translate([0,FanFaceThickness+1,FanOutterSize-FanHolesInset], $fn=16) {
				translate([FanHolesInset, 0, 0])
					rotate([90,0,00])
						cylinder(r = FanHolesR, h = FanFaceThickness + 2);
				translate([FanOutterSize-FanHolesInset, 0, 0])
					rotate([90,0,00])
						cylinder(r = FanHolesR, h = FanFaceThickness + 2);
			}
		}

		translate([FanOutterSize/2,-MagicOffsetY,MagicOffsetZ]) {	
			// trim bottom of fat torus
			translate([-(FanOutterSize + 2)/2,-(FanOutterSize + 2),0]) {
				translate([0,0,-FanOutterSize - 1])
					cube(size=[FanOutterSize + 2, (FanOutterSize + 2)*2, FanOutterSize + 2 - TorusRadius + (TorusWallThickness/2)]);
				translate([0,0,-TorusRadius])
					cube(size=[FanOutterSize + 2, (FanOutterSize * 2) - (FanOutterSize-MagicOffsetY)+2, FanOutterSize + 1 + TorusRadius]);
			}
		}
	}
}


module Torus(){
	difference() {
		TorusOutside();
		TorusInside();
	}
}
module TorusOutside() {
	translate([0,0,TorusRadius - TorusBaseClip])
	difference() {
		rotate_extrude($fn=100) 
			translate([RadiusAroundNozzle,0,0])
				circle($fn = TorusFaceCount, r = TorusRadius);

		// clip bottom and top to get a wider first layer, and save height
		assign(w = (RadiusAroundNozzle + TorusRadius + 1)) {
			translate([-w,-w,-TorusRadius])
				cube([w * 2, w * 2, TorusBaseClip]); 
			translate([-w,-w,TorusRadius-TorusBaseClip])
				cube([w * 2, w * 2, TorusBaseClip]); 
		}

	}
}
module TorusInside() {
	translate([0,0,TorusRadius - TorusBaseClip])
	union() {
		rotate_extrude($fn=100) 
			translate([RadiusAroundNozzle,0,0])
				circle($fn = TorusFaceCount, r = TorusRadius - TorusWallThickness);

		for (i = [0:TorusHoleCount])	
			rotate([0, 0, i * (360 / TorusHoleCount)])
				translate([RadiusAroundNozzle - TorusRadius, 0, -TorusRadius/2.5])
					rotate([TorusHoleVortexAngle,TorusHoleAngle,0])
						cylinder(r = TorusHoleRadius, h = TorusRadius, $fn=12);

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
