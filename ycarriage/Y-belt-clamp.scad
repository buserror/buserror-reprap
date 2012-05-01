belt_pitch = 5;
belt_width = 6.2;
belt_height = 3.8;

hole_spacing = 18;

ram_length = 1.5;

m3_diameter = 3 / cos(180 / 8) + 0.4;
m3_radius = m3_diameter / 2;

m3_nut_diameter = 5.5 / cos(180 / 6) + 0.4;
m3_nut_radius = m3_nut_diameter / 2;

m3_nut_depth = 2.5;

wall = 3;
extrusion_width = 0.4;

clamp_height = 3.5;
belt_depth = 2;

ram_height = 7;

module clamp(h=10) {
	translate([-wall - m3_radius, 0, 0])
	difference() {
		intersection() {
			translate([0, belt_width / -2 - m3_diameter - wall - extrusion_width * 2 - ((hole_spacing-10)/2), 0]) cube([wall * 2 + m3_diameter, belt_width + m3_diameter * 2 + wall * 2 + extrusion_width * 4 + (hole_spacing-10), h]);
			union() {
				translate([wall + m3_radius, belt_width / 2 + m3_radius + extrusion_width + ((hole_spacing-10)/2), 0]) cylinder(r=wall + m3_radius, h=h + 1, $fn=32);
				translate([wall + m3_radius, -belt_width / 2 - m3_radius - extrusion_width - ((hole_spacing-10)/2), 0]) cylinder(r=wall + m3_radius, h=h + 1, $fn=32);
				translate([0, -belt_width / 2 - m3_radius - extrusion_width - ((hole_spacing-10)/2), 0]) cube([wall * 2 + m3_diameter, belt_width + m3_diameter  + extrusion_width * 2 + (hole_spacing-10), h + 1]);
			}
		}
		translate([wall + m3_radius, hole_spacing/2, -1]) cylinder(r=m3_radius, h=h + 2, $fn=16);
		translate([wall + m3_radius, -hole_spacing/2, -1]) cylinder(r=m3_radius, h=h + 2, $fn=16);
	}
}

module clamp_base() {
	difference() {
		clamp(belt_height + m3_nut_diameter);

		translate([-1 - wall - m3_radius, -belt_width / 2, m3_nut_diameter]) cube([wall * 4, belt_width, belt_height + 1]);
		translate([-1 - wall - m3_radius, 0, m3_nut_radius]) rotate([0, 90, 0]) rotate([0, 0, 180 / 8]) cylinder(r=m3_radius, h=wall * 4, $fn=8);
		translate([-1 - wall - m3_radius, 0, m3_nut_radius]) rotate([0, 90, 0]) rotate([0, 0, 180 / 6]) cylinder(r=m3_nut_radius, h=1 + m3_nut_depth, $fn=6);
	}
}

module clamp_top() {
	difference() {
		clamp(clamp_height);
		translate([ - belt_pitch / 3.8, -belt_width / 2, wall - 1]) cube([belt_pitch / 1.9, belt_width, 5]);
		translate([- belt_pitch / 3.8 + belt_pitch, -belt_width / 2, wall - 1]) cube([belt_pitch / 1.9, belt_width, 5]);
		translate([- belt_pitch / 3.8 - belt_pitch, -belt_width / 2, wall - 1]) cube([belt_pitch / 1.9, belt_width, 5]);
	}
}

module clamp_trap() {
	difference() {
		clamp(clamp_height);
		translate([0, hole_spacing/2, max(clamp_height - m3_nut_depth, 1)]) cylinder(r=m3_nut_radius, h=m3_nut_depth + 1, $fn=6);
		translate([0, -hole_spacing/2, max(clamp_height - m3_nut_depth, 1)]) cylinder(r=m3_nut_radius, h=m3_nut_depth + 1, $fn=6);
	}
}

module ram() {
	difference() {
		union() {
			cylinder(r=m3_nut_radius, h=ram_height, $fn=32);
			translate([0, -m3_nut_radius, 0]) cube([ram_length + 0.1, m3_nut_diameter, ram_height]);
		}
		translate([ram_length, -m3_nut_radius - 1, -1]) cube([m3_nut_diameter + 2, m3_nut_diameter + 2, ram_height + 2]);
		translate([-0.5, 0, ram_height / 2]) rotate([0, 90, 0]) rotate([0, 0, 180 / 8]) cylinder(r=m3_radius, h=2 + ram_length, $fn=8);
	}
}

clamp_base();
translate([wall * 2 + m3_diameter + 2, 0, 0]) clamp_top();
translate([-wall * 2 - m3_diameter - 2, 0, 0]) clamp_trap();
translate([wall * 4 + m3_diameter * 2 + 3, -belt_width, 0]) ram();
translate([wall * 4 + m3_diameter * 2 + 3, belt_width, 0]) ram();