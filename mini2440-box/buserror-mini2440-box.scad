/*
 * MINI2440 Enclosure for reprap 3D printers
 * (C) 2011 Michel Pollet <buserror@gmail.com>
 *
 * This enclosure should contains a mini2440 without screen in a nice, compact box
 * Most of the sizes are parameters you can tweak to adapt to your material.
 * This design assume your printer can print bridges for the various ports, if not,
 * You will have to adapt by adding 'support material' and clip it off later.
 * 
 * This file contains both bottom and top, before exporting, you will need to set
 * one, then the other two variables bellow to 0/1 and export them separately.
 */
SHOWTOP=0;
SHOWBOTTOM=1;

// if you set that to one, it'll take forever to generate the CGAL. You're warned
AIRFLOW=0;

// "error constant". This is used in difference() to make sure 
// intersections do not suffer from floating point precision 
E=0.001;

LayerHeight = 0.25;
ExtrusionThickness = 0.39; // for 0.25mm layer

// thickness of bottom and walls
BottomThickness = 8 * LayerHeight;
WallThickness = ExtrusionThickness * 6;
TopThickness = 10 * LayerHeight;
Trim=2*ExtrusionThickness;	// remove some thickness of the botton/walls

// radius of the round corners
BoxRadius=4;
// "space" between inside border and the PCB
WallSpace=0.0;
// PCB height
PCBH = 2.1;
// Space added at the top, over the ports
TopH = 2.5;
// PCB standoff height & drills
StandoffH = 3.5;
StandoffW = 3;
StandoffDrill = 1.5;
// Screw top corners
ScrewTopH = 8;
ScrewTopW = 3;
ScrewTopDrill = 1.5;

// Wall height. "13" is the minimum, correspond to LAN port height
WallH = StandoffH + PCBH + 13 + TopH;

$fn = 40;

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

module airflow(yc = 4, xc = 20, w = 100, h = WallH, r = 1, m = 3) {
	for (y = [0:yc]) for (x = [0:xc]) {
		translate([m + (x * ((w - (2*m)) / xc)), -WallThickness/2, m + (y * ((h-(2*m)) / yc))])
			translate([-r,0,-r]) cube(size=[r*2, WallThickness*2, r*2]);
//			 rotate([-90,0,0])	 cylinder(h = WallThickness*2, r = r);
	}
}

module mini2440bottom() {
	difference() {
		union() {
			// true bottom of the box
			translate([-50+WallSpace,-50+WallSpace, 0]) difference() {
				roundrect(size = 
					[100-(2*WallSpace), 
					 100-(2*WallSpace), 
					(BottomThickness + WallH)/2], r = BoxRadius);
				translate([WallThickness, WallThickness, BottomThickness])
					roundrect(size = 
						[100-(2*WallSpace)-(2*WallThickness), 
						 100-(2*WallSpace)-(2*WallThickness), 
						(BottomThickness + WallH)/2], r = BoxRadius);
			}
			for (a = [0:3]) {
				rotate([0,0,a*90]) translate([-50, -50, 0])  {
			
					// pcb standoffs
					translate([4, 4, BottomThickness-E])
						difference() {
							cylinder(h = StandoffH+E+E, r=StandoffW);
							cylinder(h = StandoffH+1, r=StandoffDrill);
						}
					
					// screw top cylinder
					translate([WallSpace, WallSpace, BottomThickness + WallH - ScrewTopH]) {
						// cylinder to get the hole later
						cylinder(h = ScrewTopH, r = ScrewTopW);
						// cylinder support thingy
						translate([-ScrewTopW/2, -ScrewTopW/2, 0]) {
							for (i = [1:5]) {
								translate([((ScrewTopW/5)*i)/2, ((ScrewTopW/5)*i)/2, -ScrewTopH+2+i-E])
									cylinder(h=1+E+E, r1 = ((ScrewTopW/5)*i)*0.85, r2 = ((ScrewTopW/5)*i)*1.0);		
							}
						}
					}
				}
			}
		}
		// now go around and drill the cover holes
		for (a = [0:3]) {
			rotate([0,0,a*90]) translate([-50, -50, 0])  {
				// screw top cylinder
				translate([WallSpace, WallSpace, BottomThickness + WallH - ScrewTopH-1]) {
					difference() {
						translate([0,0,-1])
							cylinder(h = ScrewTopH*2, r = ScrewTopDrill);
					}
				}
			}
		}
		// Remove 1mm of the bottom of the box
		if (Trim > 0) {
			translate([-50+WallSpace,-50+WallSpace, 0]) difference() {
				translate([WallThickness*5, WallThickness*5, BottomThickness-Trim])
					roundrect(size = 
						[100-(2*WallSpace)-(10*WallThickness), 
						 100-(2*WallSpace)-(10*WallThickness), 
						BottomThickness], r = BoxRadius);
			}
		}

		/*
		 * cutouts
		 */
		for (a = [0:3]) {
			rotate([0,0,a*90]) translate([-50, -50-BoxRadius+(WallSpace*2), BottomThickness]) render() {
				if (a == 0) { // front						
					translate([0, -WallThickness/2, StandoffH + PCBH]) {
						// USB port	
						translate([78, 0, 1])
							roundrect(size=[16, WallThickness*2, 7.1], 
									a = [-90,0,0],
									h = WallThickness*2, r=0.3);
						// SD card slot
						translate([50, 0, 0.5])
							roundrect(size=[25, WallThickness*2, 2.5],
									a = [-90,0,0], h = WallThickness*2, r = 0.3);
					}	
				} else if (a == 2) { // back 		
					translate([0, -WallThickness/2, StandoffH + PCBH]) {
						
						// audio jack
						translate([9, 0, 7]) rotate([-90,0,0])
							cylinder(h = WallThickness*2, r = 7/2);
						// USB
						translate([16, 0, 0])
							cube(size=[12, WallThickness*2, 11.5]);
						// ethernet
						translate([30, 0, 0])
							cube(size=[16, WallThickness*2, 13]);
						// serial
						translate([48, 0, 0])
							cube(size=[31, WallThickness*2, 12.5]);

						// power jack
						translate([86.5, 0, 2.5]) rotate([-90,0,0])
							cylinder(h = WallThickness*2, r = 6/2);

					}
				} else if (a == 3) { // left side
					translate([0, -WallThickness/2, StandoffH + PCBH]) {
						// reset button
						translate([33, 0, 2]) rotate([-90,0,0])
							cylinder(h = WallThickness*2, r = 0.5);
					}
					if (Trim > 0)
						translate([10, WallThickness-1, 6])
							roundrect(size=[100-20, WallThickness, WallH-12], a=[-90,0,0],r=2);

					if (AIRFLOW==1)
						render() airflow();
				} else {
					if (Trim > 0)
						translate([10, WallThickness-1, 6])
							roundrect(size=[100-20, WallThickness, WallH-12], a=[-90,0,0],r=2);
					if (AIRFLOW==1)
						render() airflow();
				}
			}
		}
	}
	
}

module mini2440top() /*render() */ {
	difference() {
		translate([-50+WallSpace,-50+WallSpace, 0])
			roundrect(size = 
				[100-(2*WallSpace), 
				 100-(2*WallSpace), 
				(TopThickness)/2], r = BoxRadius);
		for (a = [0:3]) {
			rotate([0,0,a*90]) translate([-50, -50, 0])  {
				translate([0,0,-1])
					cylinder(h = TopThickness+2, r = ScrewTopDrill);
				translate([0,0,TopThickness-2.60])
					cylinder(h = 2.60+E, r1 = ScrewTopDrill, r2 = ScrewTopDrill*2.1);
			}
		}
		translate([0,0,TopThickness-1])
			linear_extrude(file = "mini2440-box-logo.dxf", height = 2);
	}
}

if (SHOWBOTTOM==1) {
	mini2440bottom();
	// fake PCB for reference
//	translate([0,0, BottomThickness + StandoffH + (PCBH/2)])
//		%cube(size=[100,100,PCBH], center=true);
}
if (SHOWTOP==1) {
	translate([0,0,SHOWBOTTOM*40])
		mini2440top();
}


