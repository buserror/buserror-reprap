/*
 * Most of the measurements are in mil, straight off the eagle board file
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
 */
$fn = 16;

E=0.01;
mm = 1 / 39.37;

pushbutton_margin = 0.5;	

pcb_size = [ 3705 * mm, 2160 * mm, 20 ];
pcb_thickness = 1.8;

mounting_pos = [100 * mm, 1075 * mm, 0];
mounting_hole_r = 40 * mm;
mounting_tab_r = 138 * mm;
mounting_hole_r = 2;

thickness_side = 6 * 0.44;
thickness_plane = 8 * 0.20;

margin_b = 4;	// for screw inserts
margin_t = 2;
margin_side = 2;

screwtop_pos = [thickness_side, mounting_pos[1], 0];
screwtop_outside_r = 5;
screwtop_outside_h = 10;
screwtop_drill_r = 1.5;
screwtop_screw_head_r = 3.5;

box_inside = [
	pcb_size[0] + (2 * margin_side), 
	pcb_size[1] + pushbutton_margin, 
	pcb_size[2] + margin_b + margin_t ];
box_outside = [
	box_inside[0] + (thickness_side * 2),
	box_inside[1] + (thickness_side * 2),
	box_inside[2] + (thickness_plane * 2)];

demo = 1;

if (demo == 1) {
	bottom();
	translate([0, -10, 10])
		top();
} else {
	translate([0, -box_outside[1]-1, 0])
		bottom();
	translate([box_outside[0],3,box_outside[2]])
		rotate([180,0,180])
			top();
}

//translate([0, -80, 0])
//%	inside();

module top() {
	difference() {
		whole();
		translate([-1, thickness_side, -thickness_plane])
			cube([box_outside[0] + 2, box_outside[1] + 1, box_outside[2]]);
		translate([-1, -1, -1])
			cube([1 + thickness_side + E, box_outside[1] + 2, box_outside[2] + 2]);
		translate([box_outside[0]-thickness_side-E, -1, -1])
			cube([1 + thickness_side + E, box_outside[1] + 2, box_outside[2] + 2]);
		translate([-1, -1, -1])
			cube([box_outside[0] + 2, thickness_side + 2, 1 + thickness_plane + E ]);
	}
}

module bottom() {
	difference() {
		whole();
		translate([thickness_side, -1, box_outside[2] - thickness_plane - E])
			cube([box_inside[0], box_outside[1] + 2, thickness_plane + 1]);
		translate([thickness_side, -1, thickness_plane])
			cube([box_inside[0], thickness_side + 1 + E,  box_outside[2]]);
	}
}


module whole() {
	union() {
		difference() {
			cube(box_outside);
			
			translate([thickness_side, thickness_side, thickness_plane])
				inside();
		}
	}
}

module inside() {
	difference() {
		union() {
			cube(box_inside);
			translate([margin_side, 0, margin_b + pcb_thickness])
			rotate([90, 0, 0])
				frontcuts();
			translate([margin_side, box_inside[1], margin_b + pcb_thickness])
			rotate([90, 0, 0])
				backcuts();

			// screw tapers at the top
			for (offset = [0:1]) assign(x_offset = margin_side + screwtop_pos[0])
			translate([(offset * (box_inside[0] - (2*x_offset))) + x_offset, 
					screwtop_pos[1], box_inside[2] - screwtop_outside_h]) {
				cylinder(r = screwtop_drill_r, 
					h = screwtop_outside_h + thickness_plane + E);

				translate([0, 0, screwtop_outside_h])
					cylinder(r1 = screwtop_drill_r * 1.2, 
							r2 = screwtop_screw_head_r,
							h = thickness_plane + E);
			}
		}
		// mounting holes
		translate([0,0,-E]) {
			for (offset = [0:1]) assign(x_offset = margin_side + mounting_pos[0])
			translate([(offset * (box_inside[0] - (2*x_offset))) + x_offset, 
					mounting_pos[1], mounting_pos[2]]) {
				difference() {
					hull() {
						cylinder(r = mounting_tab_r, h = margin_b);
						translate([(offset ? 1 : -1) * mounting_tab_r * 2, 0, 0])
						cylinder(r = mounting_tab_r, h = margin_b);
					}
					cylinder(r = mounting_hole_r, h = margin_b + E);
				}
			}
		}
		// small tabs at the bottom to keep it neat
		translate([0,-E,-E]) {
			cube([5, thickness_side, thickness_plane]);
			translate([box_inside[0]-5,0,0])
				cube([5, thickness_side, thickness_plane]);
		}
		for (offset = [0:1]) assign(x_offset = margin_side + screwtop_pos[0])
		translate([(offset * (box_inside[0] - (2*x_offset))) + x_offset, 
				screwtop_pos[1], box_inside[2] - screwtop_outside_h]) {
			difference() {
				hull() {
					cylinder(r = screwtop_outside_r, h = screwtop_outside_h + E);
					translate([(offset ? 1 : -1) * screwtop_outside_r * 2, 0, 0])
					cylinder(r = screwtop_outside_r, h = screwtop_outside_h + E);
				}
				cylinder(r = screwtop_drill_r, 
					h = screwtop_outside_h + thickness_plane + E);

				translate([0, 0, 4])
					rotate([0,(offset ? -1 : 1) * 145,0])
						cylinder(r = 10, h = 10);
			}
		}

	}
}

module frontcuts() {
	assign(h = thickness_side + 2*E)
	translate([0,0, -E]) {
		translate([(195 - (360/2)) * mm, 0, 0])
			cube([360 * mm, 460 * mm, h]);
		translate([608 * mm, 290 * mm, 0])	// composite
			cylinder(r = 1.1 * 165 * mm, h = h);
		translate([1052 * mm, 100 * mm, 0])	// audio jack
			cylinder(r = 1.3 * 100 * mm, h = h);
		translate([1467 * mm, 100 * mm, 0])	// audio jack
			cylinder(r = 1.3 * 100 * mm, h = h);
		translate([(1920 - (460/2)) * mm, 0, 0])	{ // sd card slot 
			cube([460 * mm, 120 * mm, h]);
			translate([0, (120/2) * mm, -1])
				rotate([45,0,0])
					cube([460 * mm, 6, 6]);
		}
		translate([(2630 - (610/2)) * mm, 0, 0])
			cube([610 * mm, 650 * mm, h]);
		translate([(3330 - (660/2)) * mm, 0, 0])
			cube([660 * mm, 590 * mm, h]);
	}
}

module backcuts() {
	assign(h = thickness_side + 2)
	translate([0,0, -thickness_side-E]) {
		translate([149 * mm, 150 * mm, 0])
			cylinder(r = 70 * mm, h = h);

		translate([291 * mm, 0, 0])
			cube([(3412 - 291) * mm, 380 * mm, h]);

		translate([3550 * mm, 150 * mm, 0])
			cylinder(r = 70 * mm, h = h);
	}
}
