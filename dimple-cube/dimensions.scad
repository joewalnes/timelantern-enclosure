// TimeLantern
// ======
// This file contains all the dimensions used in the TimeLantern.
// -Joe Walnes

// Magic OpenSCAD variable to improve the number of segments used 
// in circles.
// High values give smoother curves. Lower values render quickly.
$fn = 48;
//$fn = 96; // Smooth
//$fn = 12; // Fast

function mm(m) = m;
function inches(i) = mm(i) * 25.4; // inches -> mm

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
base_floor_thickness = inches(0.2);

standoff_height = inches(0.3); // leave enough room for USB connector and tallest component
standoff_width = inches(0.1);
standoff_corner_radius = inches(0.1);
standoff_hole_radius = inches(0.02);

light_tube_radius = inches(0.1);
light_tube_hole_radius = inches(0.05);
light_tube_clearance_top = inches(0.1);

// Prototype uses these:
// http://www.amazon.com/gp/product/B003CIR2XU/
foot_pad_radius = inches(0.25) / 2;
foot_pad_height = inches(0.03);

// --- Lid ---

lid_height = inches(1);
lid_thickness = mm(2.1); // thick enough to defuse light, but still leave space for corner PCB screw heads

dimple_radius = inches(0.5);
dimple_height= inches(0.15);

