CUBE_SIZE=80;
LETTER_THICK=15;

ANNIVERSARY_COIN_DIAMETER= 44.7;
ANNIVERSARY_COIN_THICK = 3.4;

$fn=150;

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

module CoinHolder(coinDiameter, coinThick)
{
  COIN_WALL_THICK=3.5;
  
  
  
  difference()
  {
    cylinder(h=coinThick + COIN_WALL_THICK, r=coinDiameter / 2 + 2 * COIN_WALL_THICK);
    
    translate([0,0,COIN_WALL_THICK])
    cylinder(h=coinThick + 1, r=coinDiameter / 2);
  }
}

module graphicLogo(xSize, ySize, zSize)
{
  resize([xSize,ySize,zSize])
  intersection()
  {
    translate([0,0,50])
      surface(file="si-2d-grey.png", invert=true);
    
    cube([100,100,10]);
  }
  
  //import("old_logo.stl");
}

module CoinPodium()
{
  translate([-CUBE_SIZE / 2, CUBE_SIZE / 2, 42])
      rotate(a=45, v=[0,0,-1])
        rotate(a=28, v=[-1,0,0])
          CoinHolder(ANNIVERSARY_COIN_DIAMETER, ANNIVERSARY_COIN_THICK);
    
    
    OLD_LOGO_WIDTH=20;
    
    translate([-20,-20,0])
    
    translate([0,CUBE_SIZE,0])
    
    
    rotate(135, [0,0,-1])
    translate([0,OLD_LOGO_WIDTH/2,0])
      rotate(90, [1,0,0])
        graphicLogo(50,50,OLD_LOGO_WIDTH);
  
}

module CoinPodium2(coinDiameter, coinThick)
{
  COIN_ANGLE=28;
  LOGO_SIZE=50;
  
  
  translate([-sin(45)* LOGO_SIZE / 2, -sin(45) * LOGO_SIZE / 2, 40])
      rotate(a=45, v=[0,0,-1])
        rotate(COIN_ANGLE, v=[-1,0,0])
          CoinHolder(coinDiameter, coinThick);
    
    
    OLD_LOGO_WIDTH=20;
    
    //translate([-20,-20,0])
    
    //translate([0,CUBE_SIZE,0])
    
    
    rotate(135, [0,0,-1])
    translate([0,OLD_LOGO_WIDTH/2,0])
      rotate(90, [1,0,0])
        graphicLogo(50,50,OLD_LOGO_WIDTH);
  
}

module Logo3d(printCoinHolder)
{
  if (printCoinHolder != 0)
  {
    CoinPodium();
  }

  LetterC(CUBE_SIZE, LETTER_THICK, 20);

  translate([-CUBE_SIZE, CUBE_SIZE, CUBE_SIZE - LETTER_THICK])
  rotate(a=90, v=[0,1,0])
  rotate(a=90, v=[1,0,0])
  LetterLittleI(CUBE_SIZE, LETTER_THICK);

  translate([0, CUBE_SIZE, 0])
    rotate(a=90, v=[0,0,1])
      LetterS(CUBE_SIZE, LETTER_THICK, 20);
}

// Rotate letter for better printing
//rotate(a=90, v=[-1,0,0])
//resize([35,35,35])
//  Logo3d(0);     // Change the 0 to a 1 to print the coin holder part

//translate([5,5,0])
//translate([0,-40,0])
CoinPodium2(44.7, 3.4);

//graphicLogo();



//rotate(135,[0,0,1])
//translate([0,2.5,0])
//rotate(90,[1,0,0])

        //graphicLogo();