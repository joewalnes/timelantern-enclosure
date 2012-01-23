// TimeLantern
// ========
// Dimple cube design. This shows the 3 parts together.
// - Joe Walnes (original design by Andrew Kim)

use <part-pcb.scad>;
use <part-base.scad>;
use <part-lid.scad>;

// For an exploded view, set this value to be greater than zero.
explosion_distance = inches(0.6);
//explosion_distance = 0;

pcb();
translate([0, 0, -explosion_distance]) base();
translate([0, 0, explosion_distance]) lid();
