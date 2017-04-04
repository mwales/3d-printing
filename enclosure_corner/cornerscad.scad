GLASS_THICKNESS=2.45;
WALL_THICK=5;
WALL_LENGTH=30;

CORNER_ENTIRE_WIDTH=2*WALL_THICK + GLASS_THICKNESS;
echo("CORNER_ENTIRE_WIDTH=", CORNER_ENTIRE_WIDTH);

SCREW_OFFSET = (WALL_LENGTH-CORNER_ENTIRE_WIDTH) / 2 + CORNER_ENTIRE_WIDTH;
echo("SCREW_OFFSET=", SCREW_OFFSET);

SCREW_HEAD_DIAMETER=7.1;
SCREW_THREAD_DIAMETER=4;
SCREW_NUT_WIDTH=7;

module screwHole(screwLength, holeDiameter, nutWidth, headDiameter, recessDepth)
{
  // Hole
  translate([0,0,-.1])
  cylinder(screwLength+.2, holeDiameter / 2, holeDiameter/2, $fn=20);
  
  // Screw head
  translate([0,0,-.1])
  cylinder(recessDepth+.1, headDiameter / 2, headDiameter/2, $fn=20);
  
  // Nut
  translate([0,0,screwLength-recessDepth])
  cylinder(recessDepth+.1, nutWidth / 2, nutWidth/2, $fn=6);
  
  
  
}


module joint() {  
  
  difference()
  {
    cube([WALL_LENGTH, WALL_LENGTH, WALL_LENGTH]);  

    // Remove the large chunk from the middle to form the walls
    translate([CORNER_ENTIRE_WIDTH, CORNER_ENTIRE_WIDTH, CORNER_ENTIRE_WIDTH])
      cube([WALL_LENGTH, WALL_LENGTH, WALL_LENGTH]);
    
    // Remove parts for the acyrlic to slide in
    translate([CORNER_ENTIRE_WIDTH, WALL_THICK, WALL_THICK])  
      cube([WALL_LENGTH, GLASS_THICKNESS, WALL_LENGTH]);
    
    translate([CORNER_ENTIRE_WIDTH, CORNER_ENTIRE_WIDTH, WALL_THICK])
      cube([WALL_LENGTH, WALL_LENGTH, GLASS_THICKNESS]);
    
    translate([WALL_THICK, CORNER_ENTIRE_WIDTH, WALL_THICK])
      cube([GLASS_THICKNESS, WALL_LENGTH, WALL_LENGTH]);
    
    // Make a bottom for print to sit on
    rotate(-45, [0,0,1])
    translate([-WALL_THICK, -WALL_THICK, -1])
    cube([WALL_THICK*2, WALL_THICK*2, WALL_LENGTH + 2]);
    
    // Knock down sharp corders on other exposed sides
    rotate(45, [0,1,0])
      translate([-WALL_THICK/2, -1, -WALL_THICK/2])
        cube([WALL_THICK, WALL_LENGTH + 2, WALL_THICK]);
    rotate(45, [1,0,0])
      translate([-1,-WALL_THICK/2, -WALL_THICK/2])
        cube([WALL_LENGTH+2, WALL_THICK, WALL_THICK]);
        
    translate([SCREW_OFFSET, 0, SCREW_OFFSET])
    rotate(90,[-1,0,0])
    screwHole(CORNER_ENTIRE_WIDTH, SCREW_THREAD_DIAMETER, SCREW_NUT_WIDTH, SCREW_HEAD_DIAMETER, 1);
   
    translate([0, SCREW_OFFSET, SCREW_OFFSET])
    rotate(90,[0,1,0])
    screwHole(CORNER_ENTIRE_WIDTH, SCREW_THREAD_DIAMETER, SCREW_NUT_WIDTH, SCREW_HEAD_DIAMETER, 1);
    
    translate([SCREW_OFFSET, SCREW_OFFSET, 0])
    screwHole(CORNER_ENTIRE_WIDTH, SCREW_THREAD_DIAMETER, SCREW_NUT_WIDTH, SCREW_HEAD_DIAMETER, 1);
    
   
  }
}

//screwHole(CORNER_ENTIRE_WIDTH, SCREW_THREAD_DIAMETER, SCREW_NUT_WIDTH, SCREW_HEAD_DIAMETER, 1);


// Rotate for printing
rotate(-90,[-1,1,0])
joint();


    