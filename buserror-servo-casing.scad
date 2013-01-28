/*
 * Wing Servo Casing
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
 */
E=0.01;

servo_body_size = [ 23.2, 20, 13 ];
servo_head_size = [ 33, 3, 13 ];
servo_cable_position = 12.5;

bottom_thickness = 1;
wall_thickness = 0.44 * 4;
hole_r = 1.1;

servo_body_out = [ 
	servo_body_size[0] + (2 * wall_thickness),
	servo_body_size[1] + (1 * wall_thickness),
	servo_body_size[2] + bottom_thickness];
servo_head_out = [
	servo_head_size[0] + (2 * wall_thickness),
	servo_head_size[1] + (2 * wall_thickness)-E,
	servo_head_size[2] + bottom_thickness];

servo_holder();
translate([servo_body_out[0],-12,0])
rotate([0,0,180])
	servo_holder();

module servo_holder() {
	difference() {
		outside();
		inside();
	}
}

module outside() {
	
	cube(servo_body_out);
	translate([(servo_body_out[0]/2)-(servo_head_out[0]/2), 
			-servo_head_out[1]+wall_thickness, 0])
		cube(servo_head_out);
	
	translate([0, wall_thickness, 0])
		cylinder(r = 4, h = servo_body_out[2]);
	translate([servo_body_out[0], wall_thickness, 0])
		cylinder(r = 4, h = servo_body_out[2]);
}

module inside() {
	translate([wall_thickness, -E, bottom_thickness + E])
		cube(servo_body_size);
	translate([servo_body_size[0], servo_cable_position,  bottom_thickness * 3])
		cube([wall_thickness * 4, 3, servo_body_out[2]]);
	translate([(servo_body_out[0]/2)-(servo_head_size[0]/2),
				-servo_head_size[1],bottom_thickness+E]) {
		cube(servo_head_size);
		translate([3,-servo_head_size[1]+E,0])
			cube([servo_head_size[0]-6, servo_head_size[1], servo_head_size[2]]);
	}

	translate([-hole_r/4, wall_thickness+(hole_r/2), bottom_thickness*2])
		cylinder(r = hole_r, h = servo_body_out[2]);
	translate([servo_body_out[0]+(hole_r/4), wall_thickness+(hole_r/2), bottom_thickness*2])
		cylinder(r = hole_r, h = servo_body_out[2]);

}
