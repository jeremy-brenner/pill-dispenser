use <./center-shaft.scad>;
use <./ratchet.scad>;

module rotatorGear(rotatorSinglesIr) {
  centerShaft(4,rotatorSinglesIr,false);
  translate([0,0,-4]) difference() {
    translate([0,0,0]) mirror([0,1,0]) ratchetGear();
    translate([0,0,-0.1]) cylinder(r=9.8,h=8);
  }
}