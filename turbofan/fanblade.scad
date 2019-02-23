FAN_RADIUS=30;
FAN_INNER_RADIUS=12;

BEARING_OUTER_DIA=12.7; // 1/2 inch
BEARING_INNER_DIA=6.36;  // 1/4 inch
BEARING_WIDTH=4.76;

NOSE_LENGTH=17;

MOTOR_GEAR_DIA=7;
NUM_TEETH=12;
MOTOR_GEAR_WIDTH=5.5;

// Single fan blade
module fan_blade(angle, width)
{  
  linear_extrude(height=FAN_RADIUS+5, twist=angle,slices=30)
    square([width+10,1.5]); 
}

module driveShaft(dsRad, offset=19, spacerLen=2, shaftLen=15)
{
  // shaft for bearing / next fan
  translate([offset,0,0,])
    rotate(a=90,v=[0,1,0])
      cylinder(h=shaftLen,r=dsRad);

  // offset bearing
  translate([offset,0,0,])
    rotate(a=90,v=[0,1,0])
    cylinder(h=spacerLen,r=dsRad+.5);
}

module fan(blade_angle, spacing, width)
{
  
    
  rotate(a=90,v=[0,1,0])
    cylinder(h=20,r=FAN_INNER_RADIUS);

  driveShaft(3.18);

  intersection()
  {
    rotate(a=90,v=[0,1,0])
    cylinder(h=width, r=FAN_RADIUS);
  

    for(i = [spacing:spacing:360])
    {
      translate([-4,0,0])
      rotate(a=i, v=[1,0,0])  
        fan_blade(blade_angle, 15+8);
    }
  
  }

}

// I created two slightly different fan blades.  The one I determine that
// moves the most air will go behind the other fan
module fanDrive1()
{
  difference()
  {
    fan(50, 20, 15);
 
    translate([-20,0,0])
      driveShaft(3.25);
  }

}

module fanDrive2()
{
  difference()
  {
    fan(60,15, 15);
 
    translate([-20,0,0])
      driveShaft(3.25);
  }

}

module nose_cone()
{
  INCREMENT=.5;
  translate([0,0,NOSE_LENGTH])
  rotate(180,[1,0,0])
  hull()
  {
    for(i = [0: INCREMENT: NOSE_LENGTH - INCREMENT ])
    {
      //echo(i);
      firstRad = 3 * pow(i, .5);
      secondRad  = 3 * pow(i+INCREMENT, .5);

      translate([0,0,i])
      cylinder(h = INCREMENT, r1 = firstRad, r2 = secondRad, center = false);
    }
  }
}


module fanNose()
{
  difference()
  {

  nose_cone();
  
  translate([0,0,-1])
    cylinder(h=7, r=BEARING_INNER_DIA/2 + .1);
  }
  
}

module bearing_outer_holder()
{
  difference()
  {
    union()
    {
    translate([-2.5,0,0])
      cube([5,BEARING_OUTER_DIA/2+15,BEARING_WIDTH]);
    
      translate([0,0,-1])
    cylinder(h=BEARING_WIDTH+1.5, r=BEARING_OUTER_DIA/2+5);
    }
    
    cylinder(h=BEARING_WIDTH+1.5, r=BEARING_OUTER_DIA/2+.1);
    
    translate([0,0,-2])
    cylinder(h=5, r=BEARING_OUTER_DIA/2-1.3);
  }
}

module driveShaftSpacer(width)
{
  difference()
  {
  cylinder(h=width, r=BEARING_INNER_DIA/2+1.5);
    
  translate([0,0,-1])
  cylinder(h=width+2, r=BEARING_INNER_DIA/2+.3);
  }
  
}

// My intent is to use the same shroud on the front and rear of the engine.  I will
// measure and fit a center section to join the two shrouds in the middle
module turbine_shroud_end()
{
  // Set the bearing inside the shroud a little bit
  translate([0,0,10])
    bearing_outer_holder();
  
  translate([-2.5,8,10])
      cube([5,25,BEARING_WIDTH]);
  
  difference()
  {
    cylinder(h=25, r=FAN_RADIUS+5);
    
    translate([0,0,-1])
    cylinder(h=27, r=FAN_RADIUS+2);
  }
  
  // Rounded front edge
  rotate(90,[0,0,1])
  rotate_extrude(convexity=10)  
  translate([FAN_RADIUS+3.5,0,0])  
  circle(r=1.5);
}

module motor_gear()
{
  TEETH_ANGLE=360/NUM_TEETH;
  TOOTH_SIZE = 1.5;
  for(i = [0:TEETH_ANGLE:360-TEETH_ANGLE])
  {
    rotate(i,[0,0,1])
    translate([MOTOR_GEAR_DIA/2+.5,0,0])
    rotate(45, [0,0,1])
    translate([-TOOTH_SIZE/2,-TOOTH_SIZE/2,0])
    cube([TOOTH_SIZE,TOOTH_SIZE,MOTOR_GEAR_WIDTH]);
  }
  
  difference()
  {
    cylinder(h=MOTOR_GEAR_WIDTH,r=MOTOR_GEAR_DIA/2+3);
    
    translate([0,0,-1])
    cylinder(h=MOTOR_GEAR_WIDTH+2,r=MOTOR_GEAR_DIA/2+.5);
    
  }
  
} 

module gear_shaft()
{
  motor_gear();
  translate([0,0,MOTOR_GEAR_WIDTH-.1])
  cylinder(h=2.1, r=MOTOR_GEAR_DIA/2+3);
  
  //translate([0,0,MOTOR_GEAR_WIDTH-.1])
  rotate(90,[0,-1,0])
  driveShaft(3.18, MOTOR_GEAR_WIDTH + 2, 3,22);
}

module shroudCoupler()
{
  JOINT_LEN = 5;
  COUPLER_LEN = 24;
  
  wholeLen = COUPLER_LEN + 2 * JOINT_LEN;
  
  difference()
  {
    hull()
    {
      cylinder(h=wholeLen, r=FAN_RADIUS+8);
      
      translate([-FAN_RADIUS-8,-22,0])
      cube([10,44,wholeLen]);
      
      translate([FAN_RADIUS+5,-11,0])
      cube([3,22,wholeLen]);
    }
    // Main fan area
    translate([0,0,-1])
    cylinder(h=wholeLen+2, r=FAN_RADIUS+2);
    
    // Joint area
    translate([0,0,-1])
    cylinder(h=JOINT_LEN+1, r=FAN_RADIUS+5.1);
    
    // Joint area
    translate([0,0,COUPLER_LEN+JOINT_LEN])
    cylinder(h=JOINT_LEN+1, r=FAN_RADIUS+5.1);
    
    // LED strip area
    LED_WIDTH=10;
    LED_KEEPOUT_WIDTH=LED_WIDTH+2;
    
    translate([0,0,JOINT_LEN + (COUPLER_LEN - LED_KEEPOUT_WIDTH)/2])
    cylinder(h=LED_KEEPOUT_WIDTH, r=FAN_RADIUS+5.5);
    
    // Wiring hole
    translate([-FAN_RADIUS-10,-5,wholeLen/2-5])
    cube([30,10,10]);
    
  }
}

module shroudCouplerBottom()
{
  difference()
  {
    shroudCoupler();
  
    translate([0,-2*FAN_RADIUS, -2 * FAN_RADIUS])
    cube([FAN_RADIUS*2, FAN_RADIUS*6, FAN_RADIUS*6]);
  }
}

module shroudCouplerTop()
{
  difference()
  {
    shroudCoupler();
    
    rotate(180,[0,-1,0])
    translate([0,-2*FAN_RADIUS, -2 * FAN_RADIUS])
    cube([FAN_RADIUS*2, FAN_RADIUS*6, FAN_RADIUS*6]);
  }
}

module halfDonut(inner, outer)
{
  difference()
  {
    cylinder(h=3,r=outer);
    
    translate([0,0,-1])
    cylinder(h=5,r=inner);
    
    translate([.01,-outer-1,-1])
    cube(outer*2+2, outer*2+2, 5);
  }
}

module shroudClip()
{
  difference()
  {
    hull()
    {
      cube([74,3,3]);
    
      translate([74/2-34/2-3,3,0])
        cube([34+6,3,3]);
    };
    
    translate([74/2-34.1/2,-1,-1])
    cube([34.1,4,5]);
  }
  
  translate([0,-1.5,0])
  halfDonut(1.5,4.5);
  
  translate([74,-1.5,0])
  rotate(180,[0,0,1])
  halfDonut(1.5,4.5);
}


MOTOR_HEIGHT=15;
MOTOR_WIDTH=20;
MOTOR_CASE_DEPTH=19;
MOTOR_SHAFT_KEEPOUT_DIA=7.5;

module motorKeepout()
{
  intersection()
  {
    translate([-30/2, -MOTOR_HEIGHT/2+.1, 0])
      cube([30,MOTOR_HEIGHT+.2,  MOTOR_CASE_DEPTH+10]); 
    
    translate([0,0,-1])
    cylinder(h=MOTOR_CASE_DEPTH+12, r=(MOTOR_WIDTH + .2)/2);
  }
  
  translate([-8, -MOTOR_HEIGHT/2-20, 4])
  cube([16,MOTOR_HEIGHT/2+20, MOTOR_CASE_DEPTH+10]);
  
  translate([0,0,-4.5])
  cylinder(h=5, r=MOTOR_SHAFT_KEEPOUT_DIA/2+.1);
}

module motorMount()
{
  difference()
  {
    cylinder(h=19+2.5, r=MOTOR_WIDTH / 2 + 2);
    
    translate([0,0,2.5])
    motorKeepout();
  }
  
  intersection()
  {
    cylinder(h=50, r=MOTOR_WIDTH / 2 + 2);
    
    translate([-6, 8.1, 2.5 + MOTOR_CASE_DEPTH - .1])
    difference()
    {
    
      cube([12, 2.5, 25 - MOTOR_CASE_DEPTH +6]);
    
      translate([2,-1,6.1])
      cube([8, 5, 3]);
    }
  }
}

module motorPin()
{
  
  
  intersection()
  {
    translate([0,0,2.5+19+.1])
    cylinder(h=50, r=MOTOR_WIDTH / 2 + 2);
    
    union()
    {
      translate([-6, 10.7, 2.5 + MOTOR_CASE_DEPTH - .1])
        cube([12,4, 25 - MOTOR_CASE_DEPTH +6]);
    
      translate([-7.8/2, 8.1-2.75, 2.5+25.1]) 
        cube([7.8,10, 2.8]);
    }
  } 
}

module motorMountToCar()
{
  translate([0, 38, 0])
  motorMount();
  
  difference()
  {
    translate([-10, 0, -8])
      cube([20, 6, 12]);
    
    translate([0,38,-10])
      cylinder(h=10, r=35.1);
  }
  
  translate([3,0,0])
  rotate(90, [0,-1,0])
  linear_extrude(6)
  polygon(points=[ [0,0], 
                   [0, 38 - MOTOR_WIDTH / 2 + 2],
                   [6.4, 38 - MOTOR_WIDTH / 2 + 2],
                   [6.4, 20], 
                   [4,0]] );

}


module fanAndMotorPlate()
{
  difference()
  {
     
    cube([43,60,6]);
    
    // Wiring hole
    translate([(43-10)/2,12.3,-1])
    cube([10,10,10]);
  }
}



// Uncomment 1 at a time to print

// fanNose();
// fanDrive1();
// fanDrive2();
// driveShaftSpacer(3);
// turbine_shroud_end();
// gear_shaft();
// shroudCouplerBottom();
// shroudCouplerTop();
// shroudClip();
//motorMountToCar();
fanAndMotorPlate();


//motorPin();

$fn=100;


