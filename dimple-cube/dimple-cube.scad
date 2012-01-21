$fs = 0.01;

function inches(i) = mm(i) * 25.4; // inches -> mm
function mm(m) = m;

module rounded_cube(width, depth, height, corner_radius) {
	translate([corner_radius, corner_radius, 0]) {
		minkowski() {
			cube([width - corner_radius * 2, depth - corner_radius * 2, height / 2]);	
			cylinder(r=corner_radius, h=height / 2);
		}
	}
}



// --- PCB ---

pcb_width = inches(1.5);
pcb_thickness = inches(0.063);
pcb_corner_radius = inches(0.1);
pcb_hole_radius = inches(0.04);

// --- PCB components ---

lightbox_size = mm(10.16);

usb_width = mm(8.1); // 7.5 + 0.6 for tabs
usb_depth = mm(5);
usb_height = mm(2.8);

sensor_width = mm(4);
sensor_depth = mm(2);
sensor_height = mm(1.05);
sensor_gap_below = mm(1);
second_sensor_offset = inches(0.4);

// --- Base ---

outer_wall = mm(1.2); // take into account max USB male connector protusion. 
lip_height = mm(3);
lip_padding = mm(0.5);

base_height = inches(0.5);
base_floor_thickness = inches(0.1);

standoff_height = inches(0.2); // leave enough room for USB connector and tallest component
standoff_width = inches(0.1);
standoff_corner_radius = inches(0.1);
standoff_hole_radius = inches(0.02);


light_tube_radius = inches(0.1);
light_tube_hole_radius = inches(0.05);
light_tube_clearance_top = inches(0.1);

foot_pad_radius = mm(2.5);
foot_pad_height = mm(0.5);

// --- Lid ---

lid_height = inches(1);
lid_thickness = outer_wall;



module pcb() {

	translate([-pcb_width / 2, -pcb_width / 2, 0]) {
		difference() {
			// Board
			rounded_cube(pcb_width, pcb_width, pcb_thickness, pcb_corner_radius);
			// Corner holes
			translate([pcb_corner_radius, pcb_corner_radius, 0]) cylinder(r=pcb_hole_radius, h=pcb_thickness);
			translate([pcb_width - pcb_corner_radius, pcb_corner_radius, 0]) cylinder(r=pcb_hole_radius, h=pcb_thickness);
			translate([pcb_corner_radius, pcb_width - pcb_corner_radius, 0]) cylinder(r=pcb_hole_radius, h=pcb_thickness);
			translate([pcb_width - pcb_corner_radius, pcb_width - pcb_corner_radius, 0]) cylinder(r=pcb_hole_radius, h=pcb_thickness);
		}
	}
	
	// USB connector
	translate([-usb_width / 2, pcb_width / 2 - usb_depth, -usb_height]) cube([usb_width, usb_depth, usb_height]);

	// Lightbox
	translate([-lightbox_size / 2, -lightbox_size / 2, pcb_thickness]) cube(lightbox_size);

	// Sensors
	translate([-sensor_width / 2, -sensor_depth / 2, -sensor_height]) cube([sensor_width, sensor_depth, sensor_height]);
	translate([-sensor_width / 2, -sensor_depth / 2 - second_sensor_offset, -sensor_height]) cube([sensor_width, sensor_depth, sensor_height]);

}

module base() {
	// Outer walls
	outer_width = pcb_width + outer_wall * 2;
	outer_height = standoff_height + base_floor_thickness;
	pad_offset = pcb_width / 2 - pcb_corner_radius;
	difference() {
		// Solid base, including lip
		translate([-outer_width / 2, -outer_width / 2, -outer_height]) {
			rounded_cube(outer_width, outer_width, outer_height + lip_height, pcb_corner_radius + outer_wall);
		}
		// Hollow out pcb area
		translate([-pcb_width / 2 - lip_padding, -pcb_width / 2 - lip_padding, 0]) {
			rounded_cube(pcb_width + lip_padding * 2, pcb_width + lip_padding * 2, lip_height * 2, pcb_corner_radius + lip_padding);
		}
		// Hollow out standoff area underneath
		translate([-pcb_width / 2, -pcb_width / 2, -standoff_height]) {
			rounded_cube(pcb_width, pcb_width, standoff_height, pcb_corner_radius);
		}
		// Cutout for USB connector
		translate([-usb_width / 2, outer_width / 2 - usb_depth, -usb_height]) {
			cube([usb_width, usb_depth, usb_height]);
		}
		// Bottom holes for sensors
		translate([0, 0, -outer_height]) cylinder(r=light_tube_hole_radius, h=base_floor_thickness);
		translate([0, -second_sensor_offset, -outer_height]) cylinder(r=light_tube_hole_radius, h=base_floor_thickness);
		// Notches in bottom for foot pads
		translate([pad_offset, pad_offset, -outer_height]) cylinder(r=foot_pad_radius, h=foot_pad_height);
		translate([-pad_offset, pad_offset, -outer_height]) cylinder(r=foot_pad_radius, h=foot_pad_height);
		translate([pad_offset, -pad_offset, -outer_height]) cylinder(r=foot_pad_radius, h=foot_pad_height);
		translate([-pad_offset, -pad_offset, -outer_height]) cylinder(r=foot_pad_radius, h=foot_pad_height);
	}

	// Corner standoffs
	module standoff() {
		module rounded_edge(r, h, extra) {
			// extra is additional padding
			translate([r, r, 0]) {
				difference() {
					translate([-r -extra, -r -extra, 0]) cube([r + extra, r + extra, h]);
					cylinder(r=r, h=h);
				}
			}
		}	
	
		extra_bit = inches(0);
		translate([-standoff_width, standoff_width, -standoff_height]) {
			rounded_edge(standoff_corner_radius, standoff_height, 0);
		}
		translate([standoff_width, -standoff_width, -standoff_height]) {
			rounded_edge(standoff_corner_radius, standoff_height, 0);	
		}
		
		difference() {
			translate([-standoff_width, -standoff_width, -standoff_height]) cube([standoff_width * 2, standoff_width * 2, standoff_height]);			
			translate([standoff_width, standoff_width, -standoff_height]) {
				rotate([0, 0, 180]) {
					rounded_edge(standoff_corner_radius, standoff_height, inches(0.1));
				}
			}
			translate([0, 0, -standoff_height]) cylinder(h=standoff_height, r=standoff_hole_radius);
		}
	}
	for (angle = [0:90:270]) {
		rotate([0, 0, angle]) translate([pcb_corner_radius - pcb_width / 2, pcb_corner_radius - pcb_width / 2, 0]) standoff();
	}

	// Sensor light tubes
	translate([0, 0, -standoff_height]) {
		difference() {
			// Solid tube
			cylinder(r=light_tube_radius, h=standoff_height - light_tube_clearance_top);
			// Hollow it out
			cylinder(r=light_tube_hole_radius, h=standoff_height - light_tube_clearance_top);
		}
	}
	translate([0, -second_sensor_offset, -standoff_height]) {
		difference() {
			// Solid tube
			cylinder(r=light_tube_radius, h=standoff_height - light_tube_clearance_top);
			// Hollow it out
			cylinder(r=light_tube_hole_radius, h=standoff_height - light_tube_clearance_top);
		}
	}
	
}

module lid() {
	outer_width = pcb_width + outer_wall * 2;
	lid_lip_height = lip_height - pcb_thickness;
	lid_lip_thickness = mm(0.5); // TODO
	lid_lip_groove = outer_wall - lid_lip_thickness;
	difference() {
		union() {
			// Solid cube, without lip
			translate([-outer_width / 2, -outer_width / 2, pcb_thickness + lid_lip_height]) {
				rounded_cube(outer_width, outer_width,
					lid_height - pcb_thickness - lid_lip_height, pcb_corner_radius + outer_wall);
			}
			// Inner lip
			translate([-outer_width / 2 + lid_lip_groove, -outer_width / 2 + lid_lip_groove, pcb_thickness]) {
				rounded_cube(outer_width - lid_lip_groove * 2, outer_width - lid_lip_groove * 2,
					lid_lip_height, pcb_corner_radius + outer_wall - lid_lip_groove);
			}
		}
		// Hollow it out
		translate([-outer_width / 2 + lid_thickness, -outer_width / 2 + lid_thickness, pcb_thickness]) {
			rounded_cube(outer_width - lid_thickness * 2, outer_width - lid_thickness * 2, 
				lid_height - pcb_thickness - lid_thickness, pcb_corner_radius + outer_wall - lid_thickness);
		}
	}
}

// # %

explosion_distance = inches(0.6);
//explosion_distance = 0;

//pcb();
translate([0, 0, -explosion_distance]) base();
//translate([0, 0, explosion_distance]) lid();


// TODO: Dimple
// TODO: Standoff rendering glitch
// TODO: Screw threads
// TODO: Space for label
// TODO: Verify dimensions for: pads, label, screws