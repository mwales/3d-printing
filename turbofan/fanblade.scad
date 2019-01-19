
module fan_blade(angle, width)
{
  
    
    
    linear_extrude(height=35, twist=angle,slices=30)
      square([width,1.5]);
  
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
    cylinder(h=20,r=15);

  driveShaft(3.18);

  intersection()
  {
    rotate(a=90,v=[0,1,0])
    cylinder(h=width, r=35);
  

    for(i = [spacing:spacing:360])
    {
      translate([-4,0,0])
      rotate(a=i, v=[1,0,0])  
        fan_blade(blade_angle, 15+8);
    }
  
  }

}

difference()
{
  fan(45, 20, 15);
 
  translate([-20,0,0])
  driveShaft(3.25);
}

//$fa=.3;

