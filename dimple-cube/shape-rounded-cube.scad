// Draws a cube with the vertical edges rounded.
// -Joe Walnes

module rounded_cube(width, depth, height, corner_radius) {
	translate([corner_radius, corner_radius, 0]) {
		minkowski() {
			cube([width - corner_radius * 2, depth - corner_radius * 2, height / 2]);	
			cylinder(r=corner_radius, h=height / 2);
		}
	}
}


// Example
$fn = 96; // Increase resolution of arc segments
rounded_cube(8, 8, 6, 2);