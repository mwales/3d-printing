// First attempt
// Jig is too high, and too thick.  wire holes all seem in good placement

module wireHoles()
{
    offset = .25;
    
    for(offset = [.25: 1.5: 1.5 * 3 + .25])
    {
    
        translate([offset,0,-1])
            cube([1, 1, 20]);
        
        translate([offset,0,3])
            cube([1,3,20]);
        
        translate([offset,2,-1])
            cube([1, 1, 20]);
        
        
        echo(str("offset = ", offset));
    }
    
}

module wireBox(box_wall_thick)
{
    //box_wall_thick = 1;
    translate([.25 - box_wall_thick, - box_wall_thick ,0])
        cube([box_wall_thick * 2 + 1.5 * 3 + 1,3 + box_wall_thick * 2, 8]);
}

module rearPartKeepout()
{
    translate([-5, 2.9, -.1])
    cube([20, 10, 3]);
}
  
//bottomCase();

module wire_routing_block()
{
    difference()
    {   
        wireBox(1);
        wireHoles();
        rearPartKeepout();
    }
}

//wire_box();
module drill_hole()
{
    translate([1.5 / 2, 1.5 / 2, -10])
        cylinder(h=30, d = 1.5, center=false);    
}

difference()
{
    hole_distance = 17.5 - 3 + 1.5 - 1.3 / 2;
    translate([-2.5, -2.5, 0])
        cube([hole_distance + 2.5 * 2 + 1.3,  6, 2]);
    
    drill_hole();
    
    translate([hole_distance, 0, 0])
        drill_hole();
    
    translate([5.2 - .125, 1.5, -2.5])
        wireBox(.9);
}

translate([5.2 - .125, 1.5, -2.5])
        wire_routing_block();
$fn=100;