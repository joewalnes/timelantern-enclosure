// TimeLantern
// ========
// This is the base piece. Designed to be CNC milled from metal.
// - Joe Walnes (original design by Andrew Kim)

// TODO: Screw threads

include <dimensions.scad>;
use <shape-rounded-cube.scad>;

module base() {

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
			cube([usb_width, usb_depth + inches(0.1) /* extra bit */, usb_height]);
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
	
		translate([-standoff_width, standoff_width, -standoff_height]) {
			rounded_edge(standoff_corner_radius, standoff_height, 0);
		}
		translate([standoff_width, -standoff_width, -standoff_height]) {
			rounded_edge(standoff_corner_radius, standoff_height, 0);	
		}
		
		extra_bit = inches(0.1); // ensures no edges remain after difference()
		difference() {
			translate([-standoff_width, -standoff_width, -standoff_height]) cube([standoff_width * 2, standoff_width * 2, standoff_height]);			
			translate([standoff_width, standoff_width, -standoff_height]) {
				rotate([0, 0, 180]) {
					rounded_edge(standoff_corner_radius, standoff_height, extra_bit);
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

base();
