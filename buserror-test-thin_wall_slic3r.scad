
NozzleW = 0.35 / 2;


union() {
	for (step = [1:15]) {
		translate([step * 4, 0, 0])
			cube([1 + (step * 0.1), 10, 1]);
	
		translate([step * 4, -10, 0])
			cube([step * NozzleW, 10, 1]);
	
	}
}
