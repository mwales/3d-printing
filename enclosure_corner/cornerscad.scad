GLASS_THICKNESS=2.4;
WALL_THICK=5;
WALL_LENGTH=30;

CORNER_ENTIRE_WIDTH=2*WALL_THICK + GLASS_THICKNESS;
echo("CORNER_ENTIRE_WIDTH=", CORNER_ENTIRE_WIDTH);


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
  }
}



// Rotate for printing
rotate(-90,[-1,1,0])
joint();


    