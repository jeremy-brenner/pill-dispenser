
use <./center-shaft.scad>;


module rotator(t,ft,sections,h,or,ir) {
  dAngle=360/sections;

  difference() {
    cylinder(r=or,h=h);
    translate([0,0,-1]) cylinder(r=or-t,h=h+2);
  }

  difference() {
    cylinder(r=ir+t,h=h);
    translate([0,0,-1]) cylinder(r=ir,h=h+2);
  }

  for ( i = [0 : sections-1] ){
    rotate([0, 0, i*dAngle+dAngle/-2])
      translate([ir+t/2,-ft/2,0]) 
      cube([or-ir-t,ft,h]);    
  }
  
  centerShaft(h+3,ir);
}
