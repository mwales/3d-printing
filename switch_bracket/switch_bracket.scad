// Rough drawing of bracket shape I'm trying to make
//
//    -----
//    |    \
//    ---   \
//      |    \
//      |     \
//    ---      \
//    |        |
//    ---      |
//       \     |
//        \    |
//        |    ----
//        |       |
//        ---------

LEVITON_HOLE_SPACING_VERT = 25;
LEVITON_HOLE_SPACING_HORZ = 75;
LEVITON_HOLE_DIA = 6;  // Measured Leviton coax splitter hole at 5.9mm
LEVITON_HOLE_HEIGHT = 2;

BRACKET_THICKNESS = 4;
BRACKET_GRABBER_LEN = 15;
BRACKET_WIDTH = LEVITON_HOLE_SPACING_HORZ + 15 * 2;

SWITCH_LEVITATE_HEIGHT = 10;
SWITCH_HEIGHT = 45;
SWITCH_WIDTH = 150;

module AngleBracket(bracketToHoleDist)
{
   linear_extrude(BRACKET_THICKNESS)
   polygon([ [0,0],
             [-BRACKET_GRABBER_LEN - BRACKET_THICKNESS, SWITCH_LEVITATE_HEIGHT + 1],
             [-1, SWITCH_LEVITATE_HEIGHT + 1],
             [-1, SWITCH_LEVITATE_HEIGHT + SWITCH_HEIGHT + 2 * BRACKET_THICKNESS],
             [0, SWITCH_LEVITATE_HEIGHT + SWITCH_HEIGHT + 2 * BRACKET_THICKNESS],
             [bracketToHoleDist + 15, BRACKET_THICKNESS],
             [bracketToHoleDist + 15, 0] ]);
}

module MiddleSupport()
{
   linear_extrude(BRACKET_WIDTH) 
   polygon([ [0,0],
             [-8, SWITCH_LEVITATE_HEIGHT + 1],
             [0, SWITCH_LEVITATE_HEIGHT + 1],
             [0, SWITCH_LEVITATE_HEIGHT ],
             [5, BRACKET_THICKNESS],
             [5, 0] ]);
}

module Grabber()
{
   
   FULL_GRABBER_HEIGHT = SWITCH_HEIGHT + BRACKET_THICKNESS * 2;

   difference()
   {

      cube([BRACKET_WIDTH,
           BRACKET_GRABBER_LEN + BRACKET_THICKNESS,
           FULL_GRABBER_HEIGHT]);

      translate([-1, BRACKET_THICKNESS, BRACKET_THICKNESS])
      cube([BRACKET_WIDTH + 2,
            SWITCH_HEIGHT,
            FULL_GRABBER_HEIGHT - (BRACKET_THICKNESS * 2)]); 

      translate([2 * BRACKET_THICKNESS,
                 -1,
                 2 * BRACKET_THICKNESS])
      cube([BRACKET_WIDTH - 4 * BRACKET_THICKNESS,
            BRACKET_THICKNESS * 2,
            SWITCH_HEIGHT - 2 * BRACKET_THICKNESS]);
            

   }
}

// Holes at 15 mm above bottom of mount
module Mount(bracketLen)
{
   translate([0,-bracketLen, 0])
   difference()
   {
      cube([BRACKET_WIDTH, bracketLen, BRACKET_THICKNESS]);

      translate([15, 15, -1])
      cylinder(h = BRACKET_THICKNESS + 2,d = LEVITON_HOLE_DIA);
      
      translate([15, 15, 2])
      cylinder(h = BRACKET_THICKNESS, d=LEVITON_HOLE_DIA + 4);

      translate([15 + LEVITON_HOLE_SPACING_HORZ, 15, -1])
      cylinder(h = BRACKET_THICKNESS + 2,d = LEVITON_HOLE_DIA);

      translate([15 + LEVITON_HOLE_SPACING_HORZ, 15, 2])
      cylinder(h = BRACKET_THICKNESS + 2,d = LEVITON_HOLE_DIA + 4);
   }
}

module Bracket(distFromHoleToSwitch)
{
   
   translate([0,0,SWITCH_LEVITATE_HEIGHT])
   Grabber();

   translate([BRACKET_THICKNESS, 0, 0])
   rotate(a=90, v=[0,-1,0]) 
   rotate(a=-90, v=[0,0,1])
   AngleBracket(distFromHoleToSwitch - BRACKET_THICKNESS);

   translate([BRACKET_WIDTH, 0, 0])
   rotate(a=90, v=[0,-1,0]) 
   rotate(a=-90, v=[0,0,1])
   AngleBracket(distFromHoleToSwitch - BRACKET_THICKNESS);

   // Middle support if needed
   // I broke my first print in half trying to remove supports, hoping this will make
   // it stronger so it doesn't happen again.
   translate([BRACKET_WIDTH, 0, 0])
   rotate(a=90, v=[0,-1,0]) 
   rotate(a=-90, v=[0,0,1])
   MiddleSupport();

   Mount(distFromHoleToSwitch - BRACKET_THICKNESS + 15);
}

$fn=100;

Bracket(22);



