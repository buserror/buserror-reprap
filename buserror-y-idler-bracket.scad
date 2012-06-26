// Y bearing Idler bracket(s) with belt tensioner
// Michel Pollet <buserror@gmail.com>
// 
// inspired by http://www.thingiverse.com/thing:12299
// inspired by http://www.thingiverse.com/thing:12148

E = 0.01;
bar_width = 18;
bar_thickness = 5;
bushing_diameter = 18;

bearing_and_belt_diameter = 28;

m8_diameter = 8;

double_bearings_and_washer = 17.1;

total_thickness = bar_thickness + (double_bearings_and_washer/2);

// don't change these
bar_x_offset = 3.4 + 26;
bar_y_offset = 30.05+21;

top_bar_to_bearing_distance = bar_y_offset / 2;
//top_bar_to_bearing_distance = 12 + (bearing_and_belt_diameter/2);

bottom_angle = atan((bar_y_offset-top_bar_to_bearing_distance) / bar_x_offset);
bottom_bar_length = bar_x_offset / cos(bottom_angle);
echo("bottom angle", bottom_angle, bottom_bar_length);

spikey_first_layer_support = 1;
use_brass_insert_for_tension = 1;
use_m3_nut_for_tension = 1;

brass_insert_diameter = 4;
m3_diameter = 3;
m3_nut_diameter = 5.55;
m3_nut_height = 2.5;
demo = 0;

ybract();

if (demo == 0) {
	translate([-20,10,0]) rotate([0,0,90+30])
		mirror([0,1,0])
			ybract();
	
	if (spikey_first_layer_support) {
		translate([-12, 2, 0])
			cylinder(r=10, h = 0.25);
		translate([-42, -50, 0])
			cylinder(r=10, h = 0.25);
	}
}
if (demo == 1) {
	% translate([0, -top_bar_to_bearing_distance, bar_thickness])
		cylinder(r = bearing_and_belt_diameter / 2, h = 10);
}

module ybract() difference() {
	union() {
	  // top circle
		cylinder(r=bushing_diameter/2, h=total_thickness);
	
		// bottom circle
		translate([-bar_x_offset, -bar_y_offset, 0])
			cylinder(r=bushing_diameter/2, h=total_thickness);
	
		// middle circle
		translate([0,  - top_bar_to_bearing_distance, 0])
			cylinder(r=bushing_diameter/2, h=bar_thickness);
	
		// bar between the circles
		translate([-bar_width/2,-top_bar_to_bearing_distance, 0])
			cube([bar_width, top_bar_to_bearing_distance, bar_thickness]);
	
	//	translate([-(bar_x_offset-(m8_diameter/2)*cos(bottom_angle)), 
	//			-(bar_y_offset - (m8_diameter/2)*sin(bottom_angle)), 0])
		translate([-bar_x_offset, -bar_y_offset, 0])
			rotate(a=[0,0,bottom_angle])
		translate([0,-bar_width/2,0])
			cube([bottom_bar_length, bar_width, bar_thickness]); 
	}

	translate([0,0,-E])
		cylinder(r=m8_diameter/2, h=total_thickness + (2*E));
	translate([0,0, total_thickness / 2])
		rotate([-90,0,-90]) {
			if (use_brass_insert_for_tension == 1)
				polyhole(d = brass_insert_diameter, h = 12);
			if (use_m3_nut_for_tension == 1) {
				polyhole(d = m3_diameter, h = 12);
				rotate([0,0,30]) 
					translate([0,0,(m8_diameter/2)-1])
					nut(d = m3_nut_diameter, h = m3_nut_height + 0.5);
			}
		}
	translate([-bar_x_offset,-bar_y_offset,-E])
		cylinder(r=m8_diameter/2, h=total_thickness + (2*E));
	translate([0,0 - top_bar_to_bearing_distance, -E])
		cylinder(r=m8_diameter/2, h=total_thickness + (2*E));
	
	// make slots
	translate([-bushing_diameter, - m8_diameter/2, -E])
		cube([bushing_diameter, m8_diameter, total_thickness + (2*E)]);
	
	translate([-bar_x_offset - bushing_diameter, -bar_y_offset - m8_diameter/2, -E])
		cube([bushing_diameter, m8_diameter, total_thickness + (2*E)]);

}



module nut(d,h,horizontal=true){
cornerdiameter =  (d / 2) / cos (180 / 6);
cylinder(h = h, r = cornerdiameter, $fn = 6);
if(horizontal){
for(i = [1:6]){
	rotate([0,0,60*i]) translate([-cornerdiameter-0.2,0,0]) rotate([0,0,-45]) cube(size = [2,2,h]);
}}
}

// Based on nophead research
module polyhole(d,h) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}

module roundcorner(diameter){
	difference(){
		cube(size = [diameter,diameter,99], center = false);
		translate(v = [diameter, diameter, 0]) cylinder(h = 100, r=diameter, center=true);
	}
}
