FAN_RADIUS=30;
FAN_INNER_RADIUS=12;

BEARING_OUTER_DIA=12.7; // 1/2 inch
BEARING_INNER_DIA=6.36;  // 1/4 inch

NOSE_LENGTH=17;

// Single fan blade
module fan_blade(angle, width)
{  
  linear_extrude(height=FAN_RADIUS+5, twist=angle,slices=30)
    square([width+10,1.5]); 
}

module driveShaft(dsRad)
{
  // shaft for bearing / next fan
  translate([19,0,0,])
    rotate(a=90,v=[0,1,0])
      cylinder(h=15,r=dsRad);

  // offset bearing
  translate([19,0,0,])
    rotate(a=90,v=[0,1,0])
    cylinder(h=2,r=dsRad+.5);
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



// Uncomment 1 at a time to print

// fanNose();
// fanDrive1();
 fanDrive2();



$fn=1000;


