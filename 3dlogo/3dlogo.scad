CUBE_SIZE=60;
LETTER_THICK=10;


// Letter will go up in +Z, out in +Y, thick in -X
module LetterL(letterHeight, letterWidth, letterThick, curveRadius)
{
  // Straight length parts (not the curve, not the rounded end)
  straightLengthBottom = letterWidth - curveRadius - letterThick / 2;
  straightLengthTop    = letterHeight - curveRadius - letterThick / 2;
  
  // Bottom part
  translate([-letterThick, curveRadius, 0])
    cube([letterThick, straightLengthBottom, letterThick]);
  
  translate([-letterThick, curveRadius + straightLengthBottom, letterThick / 2])
    rotate(a=90, v=[0,1,0])
      cylinder(h=letterThick, r=(letterThick / 2)); 
  
  // Top part
  translate([-letterThick, 0, curveRadius])
    cube([letterThick, letterThick, straightLengthTop]);
  
  translate([-letterThick, letterThick / 2, curveRadius + straightLengthTop])
    rotate(a=90, v=[0,1,0])
      cylinder(h=letterThick, r=(letterThick / 2));
  
  // Big radius
  intersection()
  {
    translate([-letterThick, 0, 0])
      cube([letterThick, curveRadius + .0001, curveRadius + .0001]);
    
    difference()
    {
    translate([-letterThick, curveRadius, curveRadius])
      rotate(a=90, v=[0,1,0])
        cylinder(h=letterThick, r=curveRadius);
      
    translate([-letterThick-.5, curveRadius, curveRadius])
      rotate(a=90, v=[0,1,0])
        cylinder(h=letterThick+1, r=curveRadius - letterThick);
      
    }
    
  }
}


module LetterC(letterSize, letterThick, curveRadius) 
{
  // Letter will be in Y and Z planes.  Thickness from X=0 towards negative X.
  bottomHeight = letterSize / 2 + letterThick;
  LetterL(bottomHeight, letterSize, letterThick, curveRadius);
  
  translate([-letterThick, 0, letterSize])
    rotate(a=180, v=[0,1,0])
      LetterL(bottomHeight, letterSize, letterThick, curveRadius);
  
}


LetterC(CUBE_SIZE, LETTER_THICK, 20);

//translate([LETTER_THICK*2, 0, 0])
//  LetterL(CUBE_SIZE, CUBE_SIZE, LETTER_THICK, 20);