
metacube_clamp();
translate([10,0,0])
	metacube_clamp();
translate([10,10,0])
	metacube_clamp();
translate([0,10,0])
	metacube_clamp();

module metacube_clamp() {

	difference() {
		cube([9,9, 6]);
		translate([7.5/2, 7.5/2, -1])
			cylinder(r = 1.6, h = 10);
	
		translate([9, 9, 2])
			cylinder(r = 5, h = 10);	
		translate([9+0.001, 9+0.001, -10])
			rotate([0,0,180])
				roundcorner(3);
	}
}

module roundcorner(diameter){
	difference(){
		cube(size = [diameter,diameter,99], center = false);
		translate(v = [diameter, diameter, 0]) cylinder(h = 100, r=diameter, center=true);
	}
}
