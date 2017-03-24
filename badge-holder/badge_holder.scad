
BORDER_THICK=2;
WALL_THICK=4;

OUTER_PIN_RADIUS = 7;
INNER_PIN_RADIUS = 3;

// And area to subtract from to allow the badge to be held inside of a solid block and to
// allow it to be viewed
module cardWindow(cardWidth, cardHeight, cardThick) {
    // This is the actual card        
    cube([cardWidth, cardHeight, cardThick], [cardWidth / 2, cardHeight / 2, cardThick / 2]);
    
    // Windows for card
    WINDOW_OVERHANG = 4;
    windowSizeX = cardWidth - WINDOW_OVERHANG * 2;
    windowSizeY = cardHeight - WINDOW_OVERHANG * 2;
    windowSizeZ = CARD_THICK + 2 * BORDER_THICK + 2;
    translate([WINDOW_OVERHANG, WINDOW_OVERHANG, -BORDER_THICK - 1])
        cube([windowSizeX, windowSizeY, windowSizeZ], [cardWidth / 2, cardHeight / 2, cardThick / 2]);
}

// This creates a whole frame that totally surrounds the badge.  Later on we will remove each half before
// adding the hinges and stuff
module cardFrame(cardWidth, cardHeight, cardThick) {
    holderSizeX = cardWidth + 2 * WALL_THICK;
    holderSizeY = cardHeight + 2 * WALL_THICK;
    holderSizeZ = cardThick + 2 * BORDER_THICK;
    
    difference() {
        translate([-WALL_THICK, -WALL_THICK, -BORDER_THICK])
            cube([holderSizeX, holderSizeY, holderSizeZ], [cardWidth / 2, charHeight / 2, cardThick / 2]);
        
        cardWindow(cardWidth, cardHeight, cardThick);        
        
    }
}

module leftFrame(cardWidth, cardHeight, cardThick) {
    difference() {
        cardFrame(cardWidth, cardHeight, cardThick);
        
        // Mask off the right side of the frame
        maskSizeX = cardWidth;
        maskSizeY = cardHeight + 2 * WALL_THICK + 2;
        maskSizeZ = cardThick + 2 * BORDER_THICK + 2;
        
        translate([cardWidth / 2, -WALL_THICK-1, -BORDER_THICK-1])
            cube([maskSizeX, maskSizeY, maskSizeZ], [cardWidth / 2, charHeight / 2, cardThick / 2]);
        
        // Remove material interfering with the hinge area
        translate([cardWidth / 2, - OUTER_PIN_RADIUS, -BORDER_THICK])
            cylinder(frameHeight, OUTER_PIN_RADIUS, OUTER_PIN_RADIUS);        
        
        translate([cardWidth / 2, cardHeight + OUTER_PIN_RADIUS, -BORDER_THICK])
            cylinder(frameHeight, OUTER_PIN_RADIUS, OUTER_PIN_RADIUS);
    };
    
    frameHeight = cardThick + 2 * BORDER_THICK;
    
    // Create part of the hinge at the bottom
    translate([cardWidth / 2, - OUTER_PIN_RADIUS, -BORDER_THICK])
        difference() {
            cylinder(frameHeight, OUTER_PIN_RADIUS, OUTER_PIN_RADIUS);
            
            translate([0,0,BORDER_THICK])
            cylinder(cardThick, OUTER_PIN_RADIUS, OUTER_PIN_RADIUS);
            
            cylinder(frameHeight, INNER_PIN_RADIUS+.1, INNER_PIN_RADIUS+.1);
        }
    
    // Create the hook at the top of the badge    
    translate([cardWidth / 2, cardHeight + OUTER_PIN_RADIUS, 0])
        difference() {
            cylinder(cardThick, OUTER_PIN_RADIUS-.1, OUTER_PIN_RADIUS-.1);
            cylinder(frameHeight, INNER_PIN_RADIUS+.1, INNER_PIN_RADIUS+.1);
        }
            
        
}

module rightFrame(cardWidth, cardHeight, cardThick) {
    difference() {
        cardFrame(cardWidth, cardHeight, cardThick);
        
        // Mask off the left side of the frame
        maskSizeX = cardWidth;
        maskSizeY = cardHeight + 2 * WALL_THICK + 2;
        maskSizeZ = cardThick + 2 * BORDER_THICK + 2;
        
        translate([-cardWidth / 2 , -WALL_THICK-1, -BORDER_THICK-1])
            cube([maskSizeX, maskSizeY, maskSizeZ], [cardWidth / 2, charHeight / 2, cardThick / 2]);
        
        // Remove material interfering with the hinge area
        translate([cardWidth / 2, - OUTER_PIN_RADIUS, -BORDER_THICK])
            cylinder(frameHeight, OUTER_PIN_RADIUS, OUTER_PIN_RADIUS);
        
        translate([cardWidth / 2, cardHeight + OUTER_PIN_RADIUS, -BORDER_THICK])
            cylinder(frameHeight, OUTER_PIN_RADIUS, OUTER_PIN_RADIUS);
    };
    
    frameHeight = cardThick + 2 * BORDER_THICK;
    
    // Create part of the hinge at the bottom
    translate([cardWidth / 2, - OUTER_PIN_RADIUS, 0])
        union() {
            translate([0,0,.05])
                cylinder(cardThick-.1, OUTER_PIN_RADIUS-.1, OUTER_PIN_RADIUS-.1);
            translate([0,0,-BORDER_THICK])
                cylinder(frameHeight, INNER_PIN_RADIUS, INNER_PIN_RADIUS);
        }
    
    // Create the hook at the top of the badge    
    translate([cardWidth / 2, cardHeight + OUTER_PIN_RADIUS, -BORDER_THICK])
        difference() {
            cylinder(frameHeight, OUTER_PIN_RADIUS, OUTER_PIN_RADIUS);
            
            translate([0,0,BORDER_THICK])
            cylinder(cardThick, OUTER_PIN_RADIUS, OUTER_PIN_RADIUS);
            
            cylinder(frameHeight, INNER_PIN_RADIUS+.1, INNER_PIN_RADIUS+.1);
        }
            
        
}

CARD_WIDTH=50;
CARD_HEIGHT=80;
CARD_THICK=2;

$fa=1;

leftFrame(CARD_WIDTH, CARD_HEIGHT, CARD_THICK);

// There is a bunch of translation back and forth here to get the hinge on the origin when the right side gets rotate
translate([CARD_WIDTH/2, -OUTER_PIN_RADIUS, 0])
rotate(-10, v=[0,0,1])
translate([-CARD_WIDTH/2, OUTER_PIN_RADIUS, 0])
rightFrame(CARD_WIDTH, CARD_HEIGHT, CARD_THICK);

//translate([CARD_WIDTH, -INNER_RADIUS, 0])


