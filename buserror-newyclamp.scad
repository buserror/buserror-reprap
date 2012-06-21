/*
 * New Y Clamp
 *
 * (C) Michel Pollet <buserror@gmail.com>
 *
 * This clamp is made to replace the existing prusa ones; the prusa ones have a tendency to break,
 * and they also make positioning the Y smooth rods very difficult as the rod moves when you turn
 * the M8 nuts on each side. Also, when you break one, you need to disassemble the whole frame to
 * replace it.
 *
 * This one is made to be a bit squat, the 2 rods are in contact with each others so there is no
 * plastic to flex. You can also clip it directly on the rod without disassembling the frame, and
 * once the smooth rod is in, it prevents any unclipping. It also allows you to position the clamp
 * secure one end, and tighened the other with negligeable rod movement.
 *
 * To print, make sure your slicer makes the walls "solid" otherwise it might flex too much. It's
 * also a good idea to print a set of 4, or print slowly to make sure the "bridge" and overhang
 * print nicely..
 *
 * This part is not for commercial distribution without a commercial license acquired from the
 * author. Distribution on a small scale basis (< 50 units) in the Reprap spirit is free of
 * charge on the basis of mentioning the Author with the bill of material, any wider
 * distribution requires my explicit, written permission.
 */
$fn = 62;

// for 0.20mm layer, 0.35mm nozzle 00 this ensures "solid walls"

extrusionSize = 0.44;	// for 0.20mm layer
shell = 6 * extrusionSize;
m8rod = 7.80 / 2;
m8smooth = 8.0 / 2;

smoothwidth = (m8smooth + shell) * 2;
rodW = (m8rod + shell) * 2;

demo=0;
four=0;
raft=1;	// add easy to cut support underneath

if (four==0) {
	rotate(demo == 1 ? [0,90,0] : [0,0,0]) {
		if (raft == 1 && demo == 0) {
			linear_extrude(height=0.20) difference() {
				scale([1.6,1.6,0])
					projection(cut = true) hull() clamp();
				scale([0.99,0.99,1.01])
					projection(cut = true) hull() clamp();
			}
		}
		clamp(demo=demo);
	}
} else {
	for (row = [0:1]) {
		if (raft == 1) {
			translate([-2 + (row*25),-10,0])	cube([4, 35, 0.20]);
			translate([-10 ,-2 + (row*16),0])	cube([50, 4, 0.20]);
		}
		for (col = [0:1])
			translate([row * 25, col * 16, 0])
				clamp();
	}
}

module clamp(demo=0) 
//translate([-m8rod+2,0,0])
difference() {
	union() {
		cylinder(r = m8rod + shell, h = smoothwidth);
		translate([0, -(m8rod + shell), 0])
			cube(size=[m8rod + m8smooth, rodW, smoothwidth]);
		translate([m8rod + m8smooth, rodW / 2, smoothwidth / 2])
			rotate([90,0,0])
				cylinder(r = m8smooth + shell, h = rodW);
	}

	if (demo==1) % union() {
		assign(WasherR = 16/2,
			WasherH = 1.6,
			NutH = 6.5,
			NutD = 13) {
		translate([0,0,-15])
			cylinder(r = m8rod, h = smoothwidth + 30);
		translate([0,0,-WasherH])
			cylinder(r = WasherR, h = WasherH);
		translate([0,0,-WasherH-NutH])
			nut(d = NutD, h = NutH, horizontal=false);
		}
	}	
	translate([0,0,-1])
		cylinder(r = m8rod, h = smoothwidth + 2);	
	translate([m8rod + m8smooth, (rodW / 2) + 1, smoothwidth / 2])
		rotate([90,0,0]) {
				cylinder(r = m8smooth, h = rodW + 2);
			if (demo==1) translate([0,0,-8])
				% cylinder(r=m8smooth, h =30);
		}

	translate([m8rod -0.5, -1, -1]) {
		rotate([0,0,60])
			cube(size=[rodW, m8rod * 1.8, smoothwidth + 2]);
		rotate([0,0,90])
			cube(size=[rodW, m8rod * 1.2, smoothwidth + 2]);
	}

	translate([m8rod,-m8rod,m8smooth+shell-0.1]) rotate([90,0,0]) scale(0.7)
      linear_extrude( height = 30, center = true)
            polygon(points = [[3.00,-5.00],[3.00,5.00],[-3.00,0.00]], paths = [[0,1,2]]);
}

/*
 * This is used only for demo screenshots, and thus
 * does not infect the main code
 */
// PRUSA Mendel  
// Functions used in many files
// GNU GPL v3
// Josef Průša
// josefprusa@me.com
// prusadjs.cz
// http://www.reprap.org/wiki/Prusa_Mendel
// http://github.com/prusajr/PrusaMendel


module nut(d,h,horizontal=true){
cornerdiameter =  (d / 2) / cos (180 / 6);
cylinder(h = h, r = cornerdiameter, $fn = 6);
if(horizontal){
for(i = [1:6]){
	rotate([0,0,60*i]) translate([-cornerdiameter-0.2,0,0]) rotate([0,0,-45]) cube(size = [2,2,h]);
}}
}
