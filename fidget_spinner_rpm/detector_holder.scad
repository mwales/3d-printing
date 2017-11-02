// Creates a small holder for a phototransistor and laser bought off Adafruit.
// Going to spin a fidget spinner in-between them and measure its RPM


LASER_LENGTH = 10;
LASER_DIAMETER = 10;

DETECTOR_DIAMETER = 5;
DETECTOR_LENGTH = 4.3;

VOID_WIDTH=30;
VOID_HEIGHT = 13;

PLATFORM_HEIGHT=5;
PLATFORM_DEPTH = 30;

module_length = LASER_LENGTH + VOID_WIDTH + DETECTOR_LENGTH;
module_height = VOID_HEIGHT + PLATFORM_HEIGHT;
module_depth = 30;

difference()
{
  cube([module_length, module_depth, module_height]);
  
  translate([LASER_LENGTH, -1, PLATFORM_HEIGHT])
  cube([VOID_WIDTH, module_depth + 2, VOID_HEIGHT + 1]);
  
  translate([-1, PLATFORM_DEPTH / 2, PLATFORM_HEIGHT + VOID_HEIGHT / 2])
  rotate(90, [0,1,0])
  cylinder(h=LASER_LENGTH+2, d=LASER_DIAMETER);
  
  translate([LASER_LENGTH + VOID_WIDTH -1, PLATFORM_DEPTH / 2, PLATFORM_HEIGHT + VOID_HEIGHT / 2])
  rotate(90, [0,1,0])
  cylinder(h=DETECTOR_LENGTH+2, d=DETECTOR_DIAMETER);
  
}

// Makes the render smoother for circles
$fn=150;

