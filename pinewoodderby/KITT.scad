LED_STRIP_WIDTH=51+2;
LED_STRIP_HEIGHT=10.2+1;
LED_STRIP_THICK=6; // with wires attached

WHEEL_WIDTH=10.8;
WHEEL_DIA=30.15;

module strip_keepout()
{
  rotate(45,[1,0,0])
  translate([0,0, -100+LED_STRIP_HEIGHT])
  cube([LED_STRIP_WIDTH,5,100]);

  rotate(45,[1,0,0])
  translate([LED_STRIP_WIDTH/2 - 7.5, -49,0])
  cube([15,50,7]);
}

module strip_keepout2(extra_depth)
{
  cube([6+3+extra_depth, LED_STRIP_WIDTH, LED_STRIP_HEIGHT]);
}

CAR_LENGTH=177;
CAR_HEIGHT=32;
CAR_HEIGHT_MODDED=15;
CAR_WIDTH=44.5;
CAR_W_FENDERS_WIDTH=CAR_WIDTH + 2 * WHEEL_WIDTH;

AXLE_HEIGHT=2;
AXLE_FRONT_DIST=24;
AXLE_REAR_DIST=135;

TIRE_DIA=30.1;

module base_keepout()
{
  cube([CAR_LENGTH,CAR_WIDTH,CAR_HEIGHT_MODDED]);
  
  translate([AXLE_FRONT_DIST,.1,2])
  rotate(90,[1,0,0])
  cylinder(h=20, r=TIRE_DIA/2+4);
  
  translate([AXLE_REAR_DIST,.1,2])
  rotate(90,[1,0,0])
  cylinder(h=20, r=TIRE_DIA/2+4);
  
  translate([AXLE_FRONT_DIST,CAR_WIDTH+20-.1,2])
  rotate(90,[1,0,0])
  cylinder(h=20, r=TIRE_DIA/2+4);
  
  translate([AXLE_REAR_DIST,.1,2])
  rotate(90,[1,0,0])
  cylinder(h=20, r=TIRE_DIA/2+4);
  
  translate([AXLE_REAR_DIST,CAR_WIDTH+20-.1,2])
  rotate(90,[1,0,0])
  cylinder(h=20, r=TIRE_DIA/2+4);
}

WALL_THICK=3;
FEATHER_LENGTH=51;
FEATHER_WIDTH=23;
FEATHER_HEIGHT=10;
FEATHER_BOARD_ONLY_HEIGHT=1.6;

COMPUTER_BOX_HEIGHT = 2*WALL_THICK + FEATHER_WIDTH+2;


module front_body(width)
{
  
  translate([0,width,0])
  rotate(90,[1,0,0])
  translate([-40,0,0])
  linear_extrude(width)
  polygon(points=[ [0,0], 
                   [40, CAR_HEIGHT_MODDED+COMPUTER_BOX_HEIGHT], 
                   [100, CAR_HEIGHT_MODDED+COMPUTER_BOX_HEIGHT], 
                   [100, CAR_HEIGHT_MODDED], 
                   [40, CAR_HEIGHT_MODDED], 
                   [40,0]] );
  
  //polygon(points=[[0,0],[100,0],[130,50],[30,50]]);
}

module front_body_keepouts()
{
  
  translate([0,44.5-4,0])
  rotate(90,[1,0,0])
  translate([-40,0,0])
  linear_extrude(44.5-4)
  polygon(points=[ [6,3], 
                   [6,1000], 
                   [97, 1000], 
                   [97, CAR_HEIGHT_MODDED+3],
                   [85, CAR_HEIGHT_MODDED+3],
                   [85, 0],
                   [45, 0],
                   [45, CAR_HEIGHT_MODDED+3], 
                   [37, CAR_HEIGHT_MODDED+3],
                   [37,3]] );
  
}

module front_body_keepouts2()
{
  
  translate([0,CAR_W_FENDERS_WIDTH-6,0])
  rotate(90,[1,0,0])
  translate([-40,0,0])
  linear_extrude(CAR_W_FENDERS_WIDTH-6)
  polygon(points=[ [6,3], 
                   [6,1000], 
                   [97, 1000], 
                   [97, CAR_HEIGHT_MODDED+9], 
                   [37, CAR_HEIGHT_MODDED+9],
                   [37,3]] );
  
  //polygon(points=[[0,0],[100,0],[130,50],[30,50]]);
}

module roof_parts(width)
{
  
  translate([0,width,0])
  rotate(90,[1,0,0])
  translate([-40,0,0])
  linear_extrude(width)
  polygon(points=[ [9,3],
                   [6,3],
                   [6,200],
                   [100,200],
                   [100,CAR_HEIGHT_MODDED+COMPUTER_BOX_HEIGHT-3],
                   [40, CAR_HEIGHT_MODDED+COMPUTER_BOX_HEIGHT-3]] );
  
  //polygon(points=[[0,0],[100,0],[130,50],[30,50]]);
}


SPEAKER_DIA = 28;


module speaker_keepout()
{
  cylinder(h=5,r=SPEAKER_DIA/2);
}

module speaker_mount()
{
  difference()
  {
    cylinder(h=5,r=SPEAKER_DIA/2+2.5);
    
    // Knock middle out
    translate([0,0,-1])
    cylinder(h=7, r=SPEAKER_DIA/2);
    
    // No ring around 1/4
    translate([0,0,-1])
      cube([SPEAKER_DIA, SPEAKER_DIA, 7]);
  }
  
  // Bottom ring to keep speaker from falling out
  difference()
  {
    cylinder(h=3, r=SPEAKER_DIA/2+1.5);
    
    translate([0,0,-1])
    cylinder(h=5, r=SPEAKER_DIA/2-2);
  }
  
  // Cross supports
  translate([-SPEAKER_DIA/2, -1.5, 0])
  cube([SPEAKER_DIA, 3, 3]);
  
  translate([-1.5,-SPEAKER_DIA/2, 0])
  cube([3,SPEAKER_DIA,3]);
}

ALIGNMENT_HOLE_RAD=2.5;

module tall_alignment_hole(height)
{
  support_width=ALIGNMENT_HOLE_RAD*2+3*2;
  
  
  difference()
  {
    translate([-support_width/2, -support_width/2, 0])
      cube([support_width,support_width, height]);
    
    translate([0,0, height-3])
    cylinder(h=3.1, r=ALIGNMENT_HOLE_RAD);
  }
} 

//speaker_mount();

ALIGNMENT_HOLE_RAD=2.5;

module front_clip()
{
  
  difference()
  {
  
    hull()
    front_body(CAR_W_FENDERS_WIDTH);
  
    translate([0,WHEEL_WIDTH+2,0])
    front_body_keepouts();
  
    translate([0,3,0])
      front_body_keepouts2();
  
    translate([0,WHEEL_WIDTH,0])
      base_keepout();
    
    translate([56, (CAR_WIDTH-40)/2 + WHEEL_WIDTH, CAR_HEIGHT_MODDED+6])
    cube([500, 40, COMPUTER_BOX_HEIGHT-5]);
  
    translate([-SPEAKER_DIA/2-3, CAR_W_FENDERS_WIDTH/2, -1])
      speaker_keepout();
    
    // Alignment holes
    translate([-28,8,-1])
    cylinder(h=5, r=ALIGNMENT_HOLE_RAD);
    
    // Alignment holes
    translate([-28,CAR_W_FENDERS_WIDTH-8,-1])
    cylinder(h=5, r=ALIGNMENT_HOLE_RAD);
    
    // Fastener hole
    translate([1, WHEEL_WIDTH + CAR_WIDTH/2, 10])
    rotate(90,[0,-1,0])
    cylinder(h=5, r=ALIGNMENT_HOLE_RAD);
    
    // 
  }
  
  translate([52,CAR_W_FENDERS_WIDTH-7.3,CAR_HEIGHT_MODDED])
    tall_alignment_hole(COMPUTER_BOX_HEIGHT-3);
  
  translate([52,7.3,CAR_HEIGHT_MODDED])
    tall_alignment_hole(COMPUTER_BOX_HEIGHT-3);
  
  translate([-SPEAKER_DIA/2-3, CAR_W_FENDERS_WIDTH/2, 0])
    rotate(135, [0,0,1])
      speaker_mount();
}

// Creates a #3 Logo
module graphicLogo(xSize, ySize, zSize)
{
  resize([xSize,ySize,zSize])
  intersection()
  {
    translate([0,0,50])
      surface(file="car_number.png", invert=true);
  }

}

// This is the whole roof (original design), but it wastes lots of filament
// when printed with required supports
module roof(width)
{
  difference()
  {
    intersection()
    {
    front_body(CAR_W_FENDERS_WIDTH);
    
    translate([0,3,0])
    roof_parts(width);
    }
  
    window_width = (CAR_W_FENDERS_WIDTH - 6 - 6 - 3) / 2;
    window_height = COMPUTER_BOX_HEIGHT - 12;
    
    translate([-40, 6, CAR_HEIGHT_MODDED+6])
    cube([40, window_width, window_height]);
    
    translate([-40, 9 + window_width, CAR_HEIGHT_MODDED+6])
    cube([40, window_width, window_height]);
    
    translate([-35, CAR_W_FENDERS_WIDTH/2 - 30/2, -2])
    rotate(42,[0,-1,0])
    cube([20, 30, 5]);
    
    translate([52,CAR_W_FENDERS_WIDTH-7.3,CAR_HEIGHT_MODDED+COMPUTER_BOX_HEIGHT-3.1])
    cylinder(h=2, r=ALIGNMENT_HOLE_RAD-.1);
  
  translate([52,7.3,CAR_HEIGHT_MODDED+COMPUTER_BOX_HEIGHT-3.1])
    cylinder(h=2, r=ALIGNMENT_HOLE_RAD-.1);

  }

  // Alignment holes
  translate([-28,8,0])
    cylinder(h=10, r=ALIGNMENT_HOLE_RAD-.1);
  
  // Alignment holes
  translate([-28,CAR_W_FENDERS_WIDTH-8,0])
    cylinder(h=10, r=ALIGNMENT_HOLE_RAD-.1);
  
  // Joining surface
  translate([-2, 3, CAR_HEIGHT_MODDED+COMPUTER_BOX_HEIGHT-5.9])
  cube([4, CAR_W_FENDERS_WIDTH-6, 3]);
  
  // scanner shelf
  translate([-30, CAR_W_FENDERS_WIDTH - 16, CAR_HEIGHT_MODDED-7])
  cube([15, 13, 3]);
  
  // scanner shelf
  translate([-30, 3, CAR_HEIGHT_MODDED-7])
  cube([15, 13, 3]);
  
  translate([4,14, CAR_HEIGHT_MODDED+COMPUTER_BOX_HEIGHT])
    graphicLogo(50, CAR_W_FENDERS_WIDTH - 6 - 2 * WHEEL_WIDTH, 3);
}


//roof(CAR_W_FENDERS_WIDTH-6);

module roof1()
{
  difference()
  {
    roof(CAR_W_FENDERS_WIDTH-6);
    
    translate([0, 0, CAR_HEIGHT_MODDED+COMPUTER_BOX_HEIGHT-3.1])
    cube([200, 200, 200]);
  }
}

module roof2()
{
  intersection()
  {
    roof(CAR_W_FENDERS_WIDTH-6);
    
    translate([0, 0, CAR_HEIGHT_MODDED+COMPUTER_BOX_HEIGHT-3.1])
    cube([57, 200, 200]);
  }
  
}

module roof3()
{
  difference()
  {
    roof2();
    
    translate([-3,0,0])
    cube([5,100, 100]);
    
    
    cube([200,3.1,100]);
    
    translate([0,CAR_W_FENDERS_WIDTH - 3.1,100])
    cube([200,3.1,100]);
    
    translate([56.9,0,0])
    cube([100, 100, 200]);
  }
  
}
  
module roofExtender(height)
{
  difference()
  {
    translate([-3,0,0])
    cube([63, CAR_W_FENDERS_WIDTH, height]);
    
    translate([3,3,-1])
    cube([60-6, CAR_W_FENDERS_WIDTH - 6, height+2]);
    
    translate([0, 3, height-3])
    cube([4,CAR_W_FENDERS_WIDTH - 6, 4]);
  }
  
  translate([0,3,-3])
  cube([1.8, CAR_W_FENDERS_WIDTH - 6, height+3.1]);
  
  difference()
  {
    union()
    {
      translate([52,CAR_W_FENDERS_WIDTH-7.3,-3])
        tall_alignment_hole(height);
  
      translate([52,7.3,-3])
        tall_alignment_hole(height);
    }
    
    translate([57,-1,-4])
    cube([100,CAR_W_FENDERS_WIDTH+2, 4]);
    
    translate([40, -1, -4])
    cube([20,4,4]);
    
    translate([40, CAR_W_FENDERS_WIDTH - 3, -4])
    cube([20,4,4]);
  }
  
  translate([0, 2, height-6])
  cube([6, 4, 3]);
  
  translate([0, CAR_W_FENDERS_WIDTH - 6, height-6])
  cube([6, 4, 3]);
  
  // Alignment holes
  translate([52,7.3,-5])
    cylinder(h=height+4, r=ALIGNMENT_HOLE_RAD-.1);  
  translate([52,7.3,height-5])
    cylinder(h=2, r=ALIGNMENT_HOLE_RAD+.1);
  
  // Alignment holes
  translate([52,CAR_W_FENDERS_WIDTH-7.3,-5])
    cylinder(h=height+4, r=ALIGNMENT_HOLE_RAD-.1);  
  translate([52,CAR_W_FENDERS_WIDTH-7.3,height-5])
    cylinder(h=2, r=ALIGNMENT_HOLE_RAD+.1);
        
  //translate([5,3, - COMPUTER_BOX_HEIGHT + 9])
  //cube([3,2, COMPUTER_BOX_HEIGHT + height -9 -3]);
}

// Uncomment each one to render each of the pieces
//roof(CAR_W_FENDERS_WIDTH-6);
// roof1();
// roof2();
// front_clip();
//roofExtender(6);
roof3();


$fn=500;

