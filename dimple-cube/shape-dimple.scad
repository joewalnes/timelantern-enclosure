// Draws a dimple
// -Joe Walnes

module dimple(radius, thickness, dent_height, steps=40) {
	module swish() {
		step = radius / steps;
		for(x = [-step:step:radius]) {
			hull() {
				translate([x, 0.5 * dent_height * (1+cos(180 * x/radius)), 0]) circle(r=thickness/2, $fn=0);
				translate([x + step, 0.5 * dent_height * (1+cos(180 * (x + step)/radius)), 0]) circle(r=thickness/2, $fn=0);
			}
		}
	}
	rotate_extrude(convexity = 10) {
		translate([0, thickness / 2, 0]) swish();
	}
}


//translate([0, 0, 4]) cylinder(r=8, h=1);
dimple(8, 1, -3);