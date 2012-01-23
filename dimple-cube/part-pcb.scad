// TimeLantern
// ========
// PCB part. This is just a placeholder for the real PCB so we can see how it looks.
// - Joe Walnes (original design by Andrew Kim)

include <dimensions.scad>;
use <shape-rounded-cube.scad>;

module pcb() {

	translate([-pcb_width / 2, -pcb_width / 2, 0]) {
		difference() {

			// Main board
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


pcb();
