// TimeLantern
// ========
// Transparent lid.
// - Joe Walnes (original design by Andrew Kim)

include <dimensions.scad>;
use <shape-rounded-cube.scad>;
use <shape-dimple.scad>;

// Disable dimple to speed up rendering.
has_dimple = true;

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
		// Hole for dimple
		if (has_dimple) {
			cylinder(r=dimple_radius, h=outer_wall, 100);
		}
	}
	// Dimple
	if (has_dimple) {
		translate([0, 0, lid_height - outer_wall]) {
			dimple(dimple_radius, outer_wall, -dimple_height);
		}
	}
}

lid();