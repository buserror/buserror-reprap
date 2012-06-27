// Y bearing Idler bracket(s) with belt tensioner
// Michel Pollet <buserror@gmail.com>
// 
// inspired by http://www.thingiverse.com/thing:12299
// inspired by http://www.thingiverse.com/thing:12148

E = 0.01;
bar_width = 18;
bar_thickness = 5;
bushing_diameter = 18;
m8_diameter = 8;

double_bearings_and_washer = 17.1;

total_thickness = (bar_thickness + (double_bearings_and_washer/2)) * 2;

echo("total_thickness", total_thickness);

// don't change these
bar_x_offset = 3.4 + 26;
bar_y_offset = 30.05 + 21;

top_bar_to_bearing_distance = (bar_y_offset / 2) * 1.15;
motor_inset_offset = -3;
motor_angle = 10;

bottom_angle = atan((bar_y_offset-top_bar_to_bearing_distance) / bar_x_offset);
bottom_bar_length = bar_x_offset / cos(bottom_angle);
echo("bottom angle", bottom_angle, bottom_bar_length);

demo = 0;
spikey_first_layer_support = 1;
use_brass_insert_for_tension = 0;
use_m3_nut_for_tension = 1;

motor_inter_screw = 31.5;

brass_insert_diameter = 4;
m3_diameter = 3;
m3_nut_diameter = 5.7;
m3_nut_height = 2.5;
m3_bolt_head_thickness = 4; // with washer
m3_washer_diameter = 7;

smallbar_width = bar_width - 6;
angle1 = 180 + 10;
angle2 = 102.3;
length_top_bar = 43;
length_bot_bar = 44;
support_column_diameter = 5.5*2;
bridged_holes_layer = 0.25;
motor_pulley_hole_diameter = 22.4;

top_bar_origin = [3, 0, 0];
bottom_bar_origin = [3, 0, 0];


mirror([1,0,0]) {
	if (demo == 1) {
		translate([0,0,60])
		rotate([90,0,0])
			ybract();
	} else {
		translate([0,0,total_thickness])
		rotate([0,180,0])
		difference() {
			union() {
				ybract();
				if (spikey_first_layer_support == 1) {
					translate([-8,0,total_thickness-bridged_holes_layer])
						cylinder(r=7,h=bridged_holes_layer);
					translate([-bar_x_offset, -bar_y_offset, 0])
					translate([-8,0,total_thickness-bridged_holes_layer])
						cylinder(r=7,h=bridged_holes_layer);
				}
			}
			translate([-60,-80, -1])
				cube([100, 100, 1+(total_thickness / 2)]);
		}
		translate([10,35,0])
		rotate([0,0,30])
		difference() {
			union() {
				ybract();
				if (spikey_first_layer_support == 1) {
					translate([-8,0,0])
						cylinder(r=7,h=bridged_holes_layer);
					translate([-bar_x_offset, -bar_y_offset, 0])
					translate([-8,0,0])
						cylinder(r=7,h=bridged_holes_layer);
				}
			}
			translate([-60,-80, total_thickness / 2])
				cube([100, 100, 1+(total_thickness / 2)]);
		}
	}
}
	

module ybract() difference() {
	union() {
		// top circle
		cylinder(r=bushing_diameter/2, h=total_thickness);
		// a washer to ensure clearance is there
		 if (demo == 1) % translate([0,0,-1.5]) cylinder(r = 16/2, h = 1.5);

		for (z = [0:1])
			translate([0, 0, z * (total_thickness - bar_thickness)])
	  		hull() {
				cylinder(r=bushing_diameter/2, h=bar_thickness);
				translate(top_bar_origin)
					cylinder(r=bushing_diameter/2, h=bar_thickness);
			}
	
		// bottom circle
		translate([-bar_x_offset, -bar_y_offset, 0]) {
			cylinder(r=bushing_diameter/2, h=total_thickness);
			// a washer to ensure clearance is there
		 	if (demo == 1) % translate([0,0,-1.5]) cylinder(r = 16/2, h = 1.5);

			rotate([0, 0, angle2]) {
				translate([-bushing_diameter/2, -length_bot_bar, 0]) {				
					for (z = [0:1])
						translate(bottom_bar_origin)
						translate([0, 0, z * (total_thickness - bar_thickness)]) 	
							cube([smallbar_width, length_bot_bar, bar_thickness]);					
				}
				// screw support one
				translate([-bushing_diameter/3,-length_bot_bar + 10,0])
					translate(bottom_bar_origin)
						cylinder(r = support_column_diameter/2, h = total_thickness);
			}
		}
	
		// middle circle
	//	translate([0,  - top_bar_to_bearing_distance, 0])
	//		cylinder(r=bushing_diameter/2, h=bar_thickness);

		translate(top_bar_origin)
		rotate([0,0,angle1]) {
			for (z = [0:1])
				translate([0, 0, z * (total_thickness - bar_thickness)]) {
			
					translate([-bushing_diameter/2, 0, 0])
						cube([smallbar_width, length_top_bar, bar_thickness]);
					translate([-(bushing_diameter/2)+(smallbar_width/2), length_top_bar, 0])
						cylinder(r=smallbar_width/2, h=bar_thickness);
				}
			// screw support two
			translate([-bushing_diameter/3,length_top_bar-10,0])
				cylinder(r = support_column_diameter /2, h = total_thickness);

		}
	}

	translate(top_bar_origin)
	rotate([0,0,angle1]) {
		// screw support two
		translate([-bushing_diameter/3,length_top_bar-10, -1]) {
			nut(r = m3_nut_diameter, h = 1 + m3_nut_height);
			polyhole(d = m3_washer_diameter, h = 1 + m3_bolt_head_thickness);
			translate([0,0,1 + m3_bolt_head_thickness + bridged_holes_layer])
				polyhole(d = m3_diameter, h = total_thickness + 2);
		}
	}
	translate([-bar_x_offset, -bar_y_offset, 0]) {
		rotate([0, 0, angle2]) {
			// screw support one
			translate([-bushing_diameter/3,-length_bot_bar+10, -1]) 
			translate(bottom_bar_origin) {
				polyhole(d = m3_washer_diameter, h = 1 + m3_bolt_head_thickness);
				translate([0,0,1 + m3_bolt_head_thickness + bridged_holes_layer])
					polyhole(d = m3_diameter, h = total_thickness + 2);
			}
		}
	}
	translate([0,0,-1])
		cylinder(r=m8_diameter/2, h=total_thickness + 2);
	translate([-bar_x_offset,-bar_y_offset,-1])
		cylinder(r=m8_diameter/2, h=total_thickness + 2);

	translate([motor_inset_offset, 0 - top_bar_to_bearing_distance, -1]) {
//		cylinder(r=m8_diameter/2, h=total_thickness + (2*E));
		 hull() {
			cylinder(r = (motor_pulley_hole_diameter/2)*1.1, h = total_thickness+2);
			translate([-50,0,0])
				cylinder(r = (motor_pulley_hole_diameter/2)*1.1, h = total_thickness+2);
		}
		// this cuts part of the bottom support to make a bit more room for the
		// belt, and also possibly allow installing a teflon tab to reduce belt vibration
		translate([-10,0,bar_thickness+1 +E]) assign(mh = total_thickness-(2*bar_thickness)-(2*E)) {
			 hull() {
				cylinder(r = (motor_pulley_hole_diameter/2)*1.3, h = mh);
				translate([-50,0,0])
					cylinder(r = (motor_pulley_hole_diameter/2)*1.3, h = mh);
			}			
		}
		rotate([0, 0, motor_angle])
			motor();
	}
	
	// make slots
	translate([-bushing_diameter, - m8_diameter/2, -1])
		cube([bushing_diameter, m8_diameter, total_thickness + 2]);
	
	translate([-bar_x_offset - bushing_diameter, -bar_y_offset - m8_diameter/2, -1])
		cube([bushing_diameter, m8_diameter, total_thickness + 2]);

}

module motor() {
//	stepper_motor_mount(17);
	translate([0,0,-E]) {
		if (demo == 1) %union() {
			cylinder(r = motor_pulley_hole_diameter/2, h = total_thickness - 5);		
			translate([-20,-20,-20])
				cube([40,40,20]);
		}
		hull() {
			cylinder(r = motor_pulley_hole_diameter/2, h = total_thickness + 10);
			translate([-10,10,0])
				cylinder(r = motor_pulley_hole_diameter /2, h = total_thickness + 10);
		}
		for (y = [-1,1])
			for (x=[-1,1])
				translate([x * (motor_inter_screw/2), y * (motor_inter_screw/2), 0]) {
					cylinder(r = m3_diameter / 2, h = bar_thickness+2);
					
					// holes to put the alen key in
					translate([0,0,bar_thickness+2]) {
						cylinder(r = (m3_washer_diameter / 2) * 0.8, h = total_thickness);
					}
				}
	}
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
