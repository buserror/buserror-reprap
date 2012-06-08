// Used for mounting tiny microswitches with no lever
// Michel Pollet <buserror@gmail.com>
// Inspired by
// Ian Stratford <ginjaian@gmail.com>

// for 0.20mm layer, 0.35mm nozzle 00 this ensures "solid walls"
extrusionSize = 0.44;	// for 0.20mm layer

E = 0.01;

ms_size = [13, 5.8, 6.6]; // exact size = 12.8, 5.8, 6.6

m8_diameter = 8.2;
m3_diameter = 3.5;
m3_nut_diameter = 6.8; // normally 6.2mm

WallW = 4 * extrusionSize;
BottomH = 1;

DistanceSwitchM8 = WallW / 2;
DistanceM3M8 = 0.5;	// the smaller, the better really
NutTrapDepth = 1.5;

ExtraLength = 
	m8_diameter + DistanceM3M8 + 
	(m3_nut_diameter/2) + WallW + 
	DistanceSwitchM8 + 1;

ms_outside_pos = [0,-ExtraLength,0];
ms_outside_size = [
	ms_size[0] + (2*WallW), 
	ms_size[1] + (2*WallW) + ExtraLength, 
	ms_size[2] + BottomH ];
ms_inside_size = [ms_size[0], ms_size[1], ms_size[2] + E];
ms_inside_pos = [
	(ms_outside_size[0] / 2) - (ms_inside_size[0]/2),
	WallW + (ms_size[1] / 2) - (ms_inside_size[1]/2),
	BottomH ];

ms_pin_slot_size = [
	ms_inside_size[0],
	ms_inside_size[1] - 2,
	BottomH + (2*E)];
ms_pin_slot_pos = [
	(ms_outside_size[0] / 2) - (ms_pin_slot_size[0]/2),
	WallW + (ms_size[1] / 2) - (ms_pin_slot_size[1]/2),
	-E];

rod_position = [ ms_outside_size[0] / 2, -DistanceSwitchM8-(m8_diameter / 2), -E ];

m3_position = [-E, 
	-DistanceSwitchM8 - m8_diameter - DistanceM3M8 - (m3_diameter / 2),
	ms_outside_size[2] / 2];
	
difference() {
	outside();
	inside();
}

module outside() {
	translate(ms_outside_pos)
		cube(ms_outside_size);
}

module inside() {
	translate(ms_inside_pos)
		cube(ms_inside_size);
	translate(ms_pin_slot_pos)
		cube(ms_pin_slot_size);
	
	translate(rod_position) hull() {
	#	cylinder(r = m8_diameter / 2, h = ms_outside_size[2] + (2*E));
		translate([0,-20,0])
			cylinder(r = m8_diameter / 2, h = ms_outside_size[2] + (2*E));
	}
	translate(m3_position) rotate([0,90,0]) {
		cylinder(r = m3_diameter / 2, h = ms_outside_size[0] + (2*E));
		// cut the nut trap
//		translate([0,0, ms_outside_size[0]-NutTrapDepth])
		rotate([0,0,30])
		cylinder(r = m3_nut_diameter / 2, h = NutTrapDepth, $fn = 6);
	}
}
