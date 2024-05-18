module graphicLogo()
{
  resize([40,40,20])
  intersection()
  {
    translate([0,0,50])
      surface(file="si-2d-grey.png", invert=true);
    
    cube([100,100,10]);
  }
}

resize([20,20,5])
  graphicLogo();