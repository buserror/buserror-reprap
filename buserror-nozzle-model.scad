/*
 * Thid is only for my reprap simulator in simavr
 */
$fn = 20;

E = 0.01;
blocksize = [12.8, 16, 8.3];
conesize= [0.4, 9.5, 2.5];

translate(-[blocksize[0] / 2, conesize[1] / 2, 0])
	difference() {
		out();
		in();
	//	translate([-E,-E,-E]) cube([blocksize[0]+E+E,conesize[1] / 2,20]);
	}

module out() union() {
	translate([0,0,conesize[2] + 0.5 + 1])
		cube(blocksize);
	
	translate([blocksize[0] / 2, conesize[1] / 2, 0]) {
		cylinder(r = conesize[0], h = 0.5 + E, $fn = 8);
		translate([0,0,0.5]) {
			cylinder(r1 = conesize[0], r = conesize[1]/2, h = conesize[2] + E);
			translate([0,0,conesize[2]]) 
				cylinder(r = conesize[1]/2, h = 15);
		}
	}
}	

module in() union() {
	translate([blocksize[0] / 2, conesize[1] / 2, -E]) {
	//	cylinder(r = conesize[0]/2, h = 2);
		translate([0,0,0.5+0.5]) {
			cylinder(r1 = conesize[0], r = (conesize[1]-1.5)/2, h = conesize[2] + 0.5+E);
			translate([0,0,conesize[2]+0.5]) 
				cylinder(r = (conesize[1]-1.5)/2, h = 15);
		}
	}
	translate([-1, blocksize[1] - 4, 
			conesize[2] + 0.5 + 1 + (blocksize[2]/2)]) {
		rotate([0,90,0])
		 cylinder(r = 6/2, h = blocksize[0] + 2);
	}
}