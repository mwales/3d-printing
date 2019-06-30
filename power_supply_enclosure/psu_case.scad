WIDTH = 72;
HEIGHT=39.5;
PANEL_WALL = 2.5;

TAB_HEIGHT=12.5;
TAB_WIDTH=1.5;

BINDING_POST_DIAM = 7.7;

module panel_cutouts()
{
  translate([-WIDTH/2 - TAB_WIDTH + 0.1, -TAB_HEIGHT/2, 0])
    cube([TAB_WIDTH, TAB_HEIGHT, 10]);
  
  translate([WIDTH/2 - 0.1, -TAB_HEIGHT/2, 0])
    cube([TAB_WIDTH, TAB_HEIGHT, 10]);
  
  translate([-WIDTH/2, -HEIGHT/2,0])
    cube([WIDTH,HEIGHT,10]);
}

module shell(width, height, depth)
{
  difference()
  {
    cube([width, height, depth]);
    
    translate([2,2,2])
      cube([width - 4, height - 4, depth - 4]);
  }
}

module screwBracket(height, holeDiameter)
{
  difference()
  {
    linear_extrude(7.5 + 6)
      polygon([[0,0], [height,0], [height/2 + 3, 7.5], [height/2 - 3, 7.5], [0,0]]);
    
    translate([-1, -1, 3])
      cube([height / 2 - 2, 10, 7.5]);
    
    translate([height / 2 + 3, -1, 3])
      cube([height, 10, 7.5]);
    
    translate([height / 2 - 4, 7.5 / 2, 7.5 / 2 + 3])
      rotate(90, [0,1,0])
        cylinder(h=8, r = 1.5);
  }
}

module caseScrewBracket()
{
  translate([45, 55/2, 0])
    rotate(90, [0,0,-1])
      screwBracket(55);
}

module fullPsuCase()
{
  translate([-.1,0,0])
    caseScrewBracket();

  rotate(180, [0,0,1])
    translate([-.1,0,0])
      caseScrewBracket();

  translate([-.1, 0, 70 - 7.5 - 6])
    caseScrewBracket();

  translate([0, 0, 70 - 7.5 - 6])
    rotate(180, [0,0,1])
      translate([-.1,0,0])
        caseScrewBracket();

  difference()
  {
  
    //translate([-45,-30,0])
    //cube([90,60,PANEL_WALL]);
  
    translate([-90/2, -55/2, 0])
      shell(90, 55, 70);
  
    translate([0,0,-1])
      panel_cutouts();
  
    translate([-25, -55/2 + 4, 55])
      rotate(90, [1,0,0])
        cylinder(h=10, r=BINDING_POST_DIAM/2);

    translate([25, -55/2 + 4, 55])
      rotate(90, [1,0,0])
        cylinder(h=10, r=BINDING_POST_DIAM/2);
    
    // Hole for wire
    translate([0,0,65])
      cylinder(h=10, d=3.2);
  }
  
  
}

module topCase()
{
  difference()
  {
    fullPsuCase();
    
    translate([-100,0,-1])
      cube([200,200,200]);
  }
}

module bottomCase()
{
  difference()
  {
    fullPsuCase();    
    
    translate([-100,-200,-1])
      cube([200,200,200]);
  }
}
  
//bottomCase();

translate([0,-4,0])
  topCase();

$fn=100;