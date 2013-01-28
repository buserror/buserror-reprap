/*
 * Arduino / Olymexino tray and/or case
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

OnlyTray = 0;

/*
 * IMPORTANT!!
 */
LayerHeight = 0.25;

// layer heigh 0.25mm, FilamentThickness = 0.39mm
// layer heigh 0.20mm, FilamentThickness = 0.45mm
FilamentThickness = 0.39;

E=0.01;
$fn = 16;

WallW = 4 * FilamentThickness;
PlaneThickness = (OnlyTray ? 4 : 6) * LayerHeight;
CutoutThickness = (OnlyTray ? 4.1 : 2) * LayerHeight; 

sizePCB = [ 55.8, 53.5, 1.6];

sizeExtraBottom = 3;
sizeExtraFront = 0.5;
sizeExtraBack = 0.5;
sizeExtraSide = 2.8;

sizeExtraMinimumTop = 11.5 + (3 * LayerHeight);	// power connector is highest
sizeExtraTop = sizeExtraMinimumTop;	
sizeExtraShield = 0;

sizeInside = [
	sizeExtraFront + sizePCB[0] + sizeExtraBack,
	sizeExtraSide + sizePCB[1] + sizeExtraSide,
	sizeExtraBottom + sizePCB[2] + sizeExtraTop + sizeExtraShield ];

sizeOutside = [
	sizeInside[0] + (2 * WallW),
	sizeInside[1] + (2 * WallW),
	sizeInside[2] + (2 * PlaneThickness) ];

psuSize = [ 0, 9.5, 11.5];
psuPos = [0, 9.1, (psuSize[2] / 2) - 0.2];
batSize = [0, 6.5, 6 ];
batPos = [0, psuPos[1] + 7.4, batSize[2] / 2];
vccSize = [0, 8.6, 3];
vccPos = [0, psuPos[1] + 14.6, vccSize[2] / 2];
usbSize = [ 0, 9, 5 ];
usbPos = [0, 37.3, usbSize[2] / 2];
uextSize = [0, 21.5, 9.8];
uextPos = [ 0, 7.5 + ((35.5 - 7.5) / 2), uextSize[2] / 2];

holeR = 3/2;
holeInset = 2.5;
holeExtraH = (OnlyTray == 1 ? 3 : 1) * LayerHeight;
holePos = [
	[holeInset, holeInset, -E],
	[holeInset, sizePCB[1] - holeInset, -E],
	[sizePCB[0] - holeInset, 8, -E],
	[sizePCB[0] - holeInset, 8 + 28, -E]
];

/*
 * The whole volume is split into 2 parts, top and bottom
 */
sliceHeight = PlaneThickness + sizeExtraBottom + sizePCB[2] +
	(OnlyTray ? vccSize[2] - 0.15 : holeExtraH);

clipSize = [1.5+(4*FilamentThickness), 1.5, 5];
clipBottomPos = 0.1 + sliceHeight + ((clipSize[0]-clipSize[1])/2);
clipPos = [
	[10, WallW-(clipSize[1]/2), clipBottomPos],
	[sizeOutside[0]-10, WallW-(clipSize[1]/2), clipBottomPos],
	[10, sizeOutside[1]-WallW+(clipSize[1]/2), clipBottomPos],
	[sizeOutside[0]-10, sizeOutside[1]-WallW+(clipSize[1]/2), clipBottomPos]
];
clipRot = [
	[0, 90, 0],
	[0, 90, 0],
	[0, 90, 180],
	[0, 90, 180],
];

/* "bottom" part */
translate([-sizeOutside[0]/2, (sizeOutside[1]/2) + 1, 0])
union() {
	difference() {
		dino();
		translate([-1,-1,sliceHeight])
			cube([sizeOutside[0]+2, sizeOutside[1]+2, sizeOutside[2]]);
	}
	if (OnlyTray != 1) {
		// this are the extra bumps for the clips
		for (i = [0:3])
			translate(clipPos[i]) rotate(clipRot[i])
				translate([0,0,clipSize[2]/4]) {
					difference() {
						ring(r1 = clipSize[0], r2 = clipSize[1], h = clipSize[2]);
						translate([-clipSize[0]*0.20,-clipSize[0]*0.65,-clipSize[2]/8])
							rotate([0,0,-18])
							cube([clipSize[0]*2, clipSize[0]*2, clipSize[2] + 2],center=true);
						translate([-clipSize[0]*2.5,0,-clipSize[0]])
							cube([clipSize[0]*2, clipSize[0]*2, clipSize[0]*2]);
					}
				}
	}
}

if (OnlyTray == 0) {
	/* "top" part */
	translate([(-sizeOutside[0]/2), (sizeOutside[1]/2-1), sizeOutside[2]])
	rotate([180,0,0])
	union() {
		difference() {
			union() {
				dino();
				for (i = [0:3])
					translate(clipPos[i]) rotate(clipRot[i])
						translate([0,-0.05,clipSize[2]/4]) {
							ring(r1 = clipSize[1], r2 = 0, h = clipSize[2]);
						}
						
				/*
				 * these are the pads that press on the pcb
				 */
				translate([0, WallW + sizeExtraSide, 
						sliceHeight ]) {		
					for (i = [0:1])
						translate([+1.8,holePos[i][1],0.8])
							rotate([0,-32,0])
								cube([1.8,3,3.5], center=true);

					for (i = [2:3])
						translate([sizeOutside[0]-1.8,holePos[i][1],0.8])
							rotate([0,32,0])
								cube([1.8,3,3.5], center=true);
				}
				
			}
			translate([-1,-1,-sizeOutside[2]+sliceHeight])
				cube([sizeOutside[0]+2, sizeOutside[1]+2, sizeOutside[2]]);
			
		}
	}
}

module dino() {
	difference() {
		dino_outside();
		dino_inside();
	}
}

module dino_outside() union() {
	roundrect(size=sizeOutside, r = WallW+1);
}

module dino_inside() union() {
	difference() {
		translate([WallW, WallW, PlaneThickness+E]) {
			difference() {
				roundrect(size=sizeInside, r = 1);
			
				// draw the bottom pilars, the pcb 'trap' and the
				// top pilars
				translate([sizeExtraFront, sizeExtraSide, -E]) 
				assign(fn=8, extra = 0.2) 
				for (i = [0:3]) {
					translate(holePos[i]) {
						cylinder(r = holeR+(3.5*extra), h = sizeExtraBottom, $fn = fn);
						translate([0,0,sizeExtraBottom - E]) {
							cylinder(r = holeR, h = sizePCB[2]+holeExtraH, $fn = fn);
						}
					}
				}
			}
		}
	}
	// bottom cutout
	translate([sizeExtraFront + (sizePCB[0] / 2), 
				WallW + sizeExtraSide + (sizePCB[1] / 2), 
				PlaneThickness + sizeInside[2] + ((CutoutThickness-(2*E)) / 2)])
		roundrect(size=[sizePCB[0] * 0.8, sizePCB[1] * 0.8, CutoutThickness+E], r = 8, center=1);
	// top cutout
	translate([sizeExtraFront + (sizePCB[0] / 2), 
				WallW + sizeExtraSide + (sizePCB[1] / 2), 
				PlaneThickness - ((CutoutThickness-(2*E)) / 2)])
		roundrect(size=[sizePCB[0] * 0.8, sizePCB[1] * 0.8, CutoutThickness+E], r = 8, center=1);
	
	// cut front holes
	assign(cut=WallW + 1, pcb = PlaneThickness + sizeExtraBottom + sizePCB[2]) {
		translate([WallW / 2, WallW + sizeExtraSide, pcb - 0.1]) {
			translate(psuPos)
				cube([cut, psuSize[1], psuSize[2]], center = true); 
			translate(usbPos)
				cube([cut, usbSize[1], usbSize[2]], center = true); 
			translate(batPos)
				cube([cut, batSize[1], batSize[2]], center = true); 
			translate(vccPos)
				cube([cut, vccSize[1], vccSize[2]], center = true); 
		}
		translate([sizeOutside[0] - (WallW / 2), WallW + sizeExtraSide, pcb - 0.1]) {
			translate(uextPos)
				cube([cut, uextSize[1], uextSize[2]], center = true); 
		}
	}
}

/*
 * Utilities
 */
module roundrect(size=[0,0,0], r=1, center=0, fit=1) {
	assign(sx = size[0] - (fit * (2 * r)), sy = size[1] - (fit * (2 * r)))
	translate([-center * (size[0] / 2), -center * (size[1] / 2), -center * (size[2] / 2)])
	linear_extrude(height=size[2], slices=1)
	hull() {
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
			if (r2 < r1)
				circle(r = r2);
		}
}
