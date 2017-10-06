GLASS_THICKNESS=2.45;
WALL_THICK=5;
WALL_LENGTH=30;

CORNER_ENTIRE_WIDTH=2*WALL_THICK + GLASS_THICKNESS;
echo("CORNER_ENTIRE_WIDTH=", CORNER_ENTIRE_WIDTH);

module joint() {  
  
  difference()
  {
    cube([CORNER_ENTIRE_WIDTH + 3, WALL_LENGTH / 2, CORNER_ENTIRE_WIDTH + 6]);  

    // Remove the large chunk from the middle to form the walls
    translate([CORNER_ENTIRE_WIDTH, -0.01, CORNER_ENTIRE_WIDTH])
      cube([WALL_LENGTH, WALL_LENGTH + 0.02 , WALL_LENGTH]);
   
    translate([CORNER_ENTIRE_WIDTH, -0.01 , WALL_THICK])
      cube([WALL_LENGTH, WALL_LENGTH + 0.02, GLASS_THICKNESS]);
    
    translate([WALL_THICK, -0.01, WALL_THICK])
      cube([GLASS_THICKNESS, WALL_LENGTH + 0.02, WALL_LENGTH]);
    
    // Knock down sharp corders on other exposed sides
    rotate(45, [0,1,0])
      translate([-WALL_THICK/2, -1, -WALL_THICK/2])
        cube([WALL_THICK, WALL_LENGTH + 2, WALL_THICK]);
   
  }
}


// Rotate for printing
rotate(-90,[1,0,0])
joint();


    