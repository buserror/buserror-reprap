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
shell = 2.7;
m8rod = 7.80 / 2;
m8smooth = 8.0 / 2;

smoothwidth = (m8smooth + shell) * 2;
rodW = (m8rod + shell) * 2;

for (row = [0:1]) for (col = [0:1]) {
	translate([row * 25, col * 15, 0])
		clamp();
}

module clamp() difference() {
	union() {
		cylinder(r = m8rod + shell, h = smoothwidth);
		translate([0, -(m8rod + shell), 0])
			cube(size=[m8rod + m8smooth, rodW, smoothwidth]);
		translate([m8rod + m8smooth, rodW / 2, smoothwidth / 2])
			rotate([90,0,0])
				cylinder(r = m8smooth + shell, h = rodW);
	}

	translate([0,0,-1])
		cylinder(r = m8rod, h = smoothwidth + 2);	
	translate([m8rod + m8smooth, (rodW / 2) + 1, rodW / 2])
		rotate([90,0,0])
				cylinder(r = m8smooth, h = rodW + 2);

	translate([m8rod -0.5, -1, -1]) {
		rotate([0,0,60])
			cube(size=[rodW, m8rod * 1.8, rodW + 2]);
		rotate([0,0,90])
			cube(size=[rodW, m8rod * 1.2, rodW + 2]);
	}

	translate([m8rod,-m8rod,m8smooth+shell-0.1]) rotate([90,0,0]) scale(0.7)
      linear_extrude( height = 30, center = true)
            polygon(points = [[3.00,-5.00],[3.00,5.00],[-3.00,0.00]], paths = [[0,1,2]]);
}


