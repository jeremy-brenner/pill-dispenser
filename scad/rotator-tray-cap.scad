use <./rotator-tray-base.scad>;
use <./lock-pole.scad>;

module rotatorTrayCap(r,h,sections,centerHoleR,angle) {
  difference() {
    union() {
      rotatorTrayBase(r,h,sections,centerHoleR,false,true);
      translate([0,0,2]) cylinder(r=r,h=10);
      translate([0,0,12]) cylinder(r1=r, r2=r*0.8,h=10);
      
    }
    cylinder(r=14,h=10);
    cylinder(r=16.5,h=3);
    cylinder(r=9,h=21);
    rotate([0,0,angle]) translate([0,-1000,-1]) cube([2000,2000,1000]);
  }
  translate([0,0,10]) rotate([0,0,angle]) lockPole(r=9.2, h=12, topInterlock=false, bottomInterlock=true);
}