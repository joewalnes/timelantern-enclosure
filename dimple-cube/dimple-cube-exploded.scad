// TimeLantern
// ========
// Dimple cube design. This shows the 3 parts exploded apart.
// - Joe Walnes (original design by Andrew Kim)

use <part-pcb.scad>;
use <part-base.scad>;
use <part-lid.scad>;

explosion_distance = inches(0.6);

pcb();
translate([0, 0, -explosion_distance]) base();
translate([0, 0, explosion_distance]) lid();
