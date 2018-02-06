WALL_THICK=6;

OUTER_RADIUS = 89;
PLATFORM_WIDTH = 45;
  
INNER_RADIUS = OUTER_RADIUS - WALL_THICK;

PHONE_WIDE = 80.2;
PHONE_THICK = 16;
PHONE_HEIGHT = 155;

SLOP = 1;

module headphoneRing()
{
  
  
  
  // Need to make the lip on the front  
  difference()
  {
    cylinder(h=(PLATFORM_WIDTH + WALL_THICK), r=(OUTER_RADIUS + WALL_THICK));
    
    translate([0,0,-1])
      cylinder(h=PLATFORM_WIDTH + 1, r = (OUTER_RADIUS + WALL_THICK + 1)); 
    
    translate([0,0,-1])
      cylinder(h=(PLATFORM_WIDTH + WALL_THICK + 2), r = INNER_RADIUS);
  }  
  
  // Now making the main holder body
  difference()
  {
    cylinder(h=(PLATFORM_WIDTH + 1), r = OUTER_RADIUS);
    
    translate([0,0,-1])
      cylinder(h=(PLATFORM_WIDTH + 3), r = INNER_RADIUS);
  }  
    
  
}

module headphoneHolder()
{
  rotate(a=45, v=[0,0,1])
  
  difference()
  {
    headphoneRing();
    
    translate([0,0,-1])
    difference()
    {
      cylinder(h=(PLATFORM_WIDTH + WALL_THICK + 5), r = (OUTER_RADIUS + WALL_THICK + 3));
      cube([OUTER_RADIUS + WALL_THICK + 5, 
            OUTER_RADIUS + WALL_THICK + 5, 
            PLATFORM_WIDTH + WALL_THICK + 8]);
      
    }
  }

}

module androidLogo(thick)
{
  translate([0,0,-1])
  difference()
  {  
    translate([-53/2,0,thick + 1])
      resize([53,64,thick + 1])
        //cube([1,1,1])
        surface(file="android-logo.png", invert=true);
    
    translate([-100,-1,-1])
      cube([200, 65, 3]);
  }
}

module phoneHolderShell()
{
  SHELL_WIDTH = PHONE_WIDE + WALL_THICK * 2 + SLOP * 2;
  SHELL_HEIGHT = PHONE_HEIGHT;
  SHELL_THICK = PHONE_THICK + WALL_THICK * 2 + SLOP * 2;
  
  difference()
  {
    intersection()
    {
      translate([-SHELL_WIDTH / 2,0,0])
        cube([SHELL_WIDTH, SHELL_HEIGHT, SHELL_THICK]);
  
      translate([0,0,-1])
        cylinder(h=SHELL_THICK + 2, r = INNER_RADIUS + 1);
    }
    
    translate([0,10,WALL_THICK + PHONE_THICK - 2 + SLOP * 2])
      androidLogo(WALL_THICK + 4);
    
    translate([-PHONE_WIDE / 4, -1, -1])
      cube([PHONE_WIDE / 2, WALL_THICK + 2, SHELL_THICK + 2]);
  }
  
}

module phoneCavity()
{
  CAVITY_WIDTH = PHONE_WIDE + SLOP * 2;
  CAVITY_HEIGHT = PHONE_HEIGHT;
  CAVITY_THICK = PHONE_THICK + SLOP * 2;
  
  translate([-CAVITY_WIDTH / 2, WALL_THICK, WALL_THICK])
     cube([CAVITY_WIDTH, CAVITY_HEIGHT, CAVITY_THICK]);
  
}

module wallmount()
{
  HOLE_DIA = 4.5;
  
  HEAD_DIA = 9;
  HEAD_DEPTH = 2.5;
  
  difference()
  {
    cylinder(r=HOLE_DIA / 2 + WALL_THICK, h=WALL_THICK);
    
    translate([0,0,-1])
      cylinder(r=HOLE_DIA / 2, h = WALL_THICK + 2);
    
    translate([0,0, WALL_THICK - HEAD_DEPTH])
      cylinder(r=HEAD_DIA / 2, h = WALL_THICK + 1);
  }
}

module wholeModel()
{
  difference()
  {
    union()
    {
      headphoneHolder();
      phoneHolderShell();
    }
  
    phoneCavity();
  }

  translate([0,OUTER_RADIUS + WALL_THICK - 2,0])
    wallmount();

  
}

module bottomPrintable()
{
  CAVITY_WIDTH = WALL_THICK + PHONE_WIDE + SLOP * 2;
  
  difference()
  {
    wholeModel();
    
    translate([-CAVITY_WIDTH/2, WALL_THICK/2, WALL_THICK + SLOP * 2 + PHONE_THICK - .01])
      cube([CAVITY_WIDTH, 100, 100]);
    
    translate([-100,58,WALL_THICK + SLOP * 2 + PHONE_THICK - .01])
      cube([200, 100, 100]);
  }
}

module topPrintable()
{
  CAVITY_WIDTH = WALL_THICK + PHONE_WIDE + SLOP * 2;
  
  intersection()
  {
    wholeModel();
    
    union()
    {
      translate([-CAVITY_WIDTH/2, WALL_THICK/2, WALL_THICK + SLOP * 2 + PHONE_THICK])
        cube([CAVITY_WIDTH, 100, 100]);
    
      translate([-100,58,WALL_THICK + SLOP * 2 + PHONE_THICK])
        cube([200, 100, 100]);
    }
  }
}

module printerConstraints()
{
  // I have a monoprice mini, with 120x120x120 build platform
  translate([-55,-1,0])
    cube([110,110,110]);
}


$fa=1;

intersection()
{
  printerConstraints();
  
  // Determines what to show / print.  Uncomment 1 of the following lines
  // wholeModel();
  // topPrintable();
  bottomPrintable();  
  
}

