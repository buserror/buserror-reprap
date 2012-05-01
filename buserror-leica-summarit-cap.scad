
$fn=180;

inside = 44.5 / 2;
thickness = 1.2;
height = 7.5;

difference() {
	cylinder(r = inside + thickness, h = height + thickness);
	translate([0,0,thickness])
		cylinder(r = inside, h = height + 1);
}
