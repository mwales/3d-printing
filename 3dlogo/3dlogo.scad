CUBE_SIZE=80;
LETTER_THICK=15;


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

module LetterS(letterSize, letterThick, curveRadius) 
{
  // There are 4 L's in an S (top, left, right, bottom)
  // top and bottom are the same size
  // left and right are the same size
  
  TB_width = curveRadius + letterThick / 2 + .1;
  TB_height = letterSize;
  
  translate([0, letterSize, 0])
    rotate(a=90, v=[1,0,0])
      LetterL(TB_height, TB_width, letterThick, curveRadius);
  
  translate([0, 0, letterSize])
    rotate(a=90, v=[-1,0,0])
      LetterL(TB_height, TB_width, letterThick, curveRadius);
  
  LR_width = letterSize / 2 + letterThick / 2 + .001;
  LR_height = curveRadius + letterThick / 2 + .001;
  
  translate([0,0,letterSize/2 - letterThick / 2])
  LetterL(LR_height, LR_width, letterThick, curveRadius);
  
  translate([0, letterSize, letterSize / 2 + letterThick / 2])
  rotate(a=180, v=[1,0,0])
  LetterL(LR_height, LR_width, letterThick, curveRadius);
  
  // There are also little sections that join bottom to the LR, and top to the LR
  littleSectsHeight = (letterSize - ( curveRadius * 4 - letterThick) ) / 2;
  echo("Little Sects Height = ", littleSectsHeight);
  
  translate([-letterThick, letterSize - letterThick, curveRadius])
    cube([letterThick, letterThick, littleSectsHeight]);
    
  translate([-letterThick, 0, letterSize / 2 - letterThick / 2 + curveRadius])
    cube([letterThick, letterThick, littleSectsHeight]);
  
}

// Just goes up +z
module LetterLittleI(letterSize, letterThick)
{
  // Going to have 3/5 of letter be stick part of i
  // Then on top of that a ball
  
  stickLen = letterSize / 5 * 3;
  stickCubeLen = stickLen - letterThick;
  
  // cube part of stick
  translate([-letterThick, 0, letterThick / 2])
    cube([letterThick, letterThick, stickCubeLen]);
  
  // bottom rounded part of stick
  translate([-letterThick, letterThick / 2, letterThick / 2])
    rotate(a=90, v=[0,1,0])
      cylinder(h=letterThick, r=letterThick / 2);
  
  translate([-letterThick, letterThick / 2,  + stickCubeLen + letterThick / 2])
    rotate(a=90, v=[0,1,0])
      cylinder(h=letterThick, r=letterThick / 2);

  translate([-letterThick, letterThick / 2, stickLen + letterThick * 2 / 5])
  rotate(a=90, v=[0,1,0])
    cylinder(h=letterThick, r=letterThick / 2);

}


LetterC(CUBE_SIZE, LETTER_THICK, 20);

translate([-CUBE_SIZE, CUBE_SIZE, CUBE_SIZE - LETTER_THICK])
rotate(a=90, v=[0,1,0])
rotate(a=90, v=[1,0,0])
LetterLittleI(CUBE_SIZE, LETTER_THICK);

translate([0, CUBE_SIZE, 0])
  rotate(a=90, v=[0,0,1])
    LetterS(CUBE_SIZE, LETTER_THICK, 20);