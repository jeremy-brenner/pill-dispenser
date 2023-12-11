use <./rack-and-pinion.scad>
use <./servo.scad>

$fn=64;

ad=19;
aad=6;
aa=10;

t=6.5;

module springPeg() {
  cube([6,2,6]);
  translate([3,4,3]) rotate([90,0,0]) cylinder(r=2,h=2);
}

module ratchetGear() {
  ratchet(10,32,t);
}

module ratchetArmHole() {
  mirror([0,1,0]) powl(10,32,t, true);
}
 
module ratchetArmRack() {
  mirror([1,0,0]) {
    powl(10,32,t, false);
    translate([23,-24,0]) rotate([-90,0,0]) rack();
  }
}

module ratchet(r,teeth,t) {
  for ( i = [0 : teeth-1] ) {
    rotate([0,0,i*360/teeth]) translate([0,-r,0]) difference() {
      translate([4.5,0,0]) cylinder(r=r,h=t);
      translate([0,-r-0.1,-0.1]) cube([r*2+0.1,r*2+0.2,t+0.2]);
    }
  }
  cylinder(r=r,h=t);
}

module powl(r,teeth,t,hole=true) {
  a=360/teeth;
  difference() {
    translate([0,-14-r,0]) cube([8,8,t]);
    rotate([0,0,a]) translate([0,-r,0]) translate([4.5,0,-0.1]) cylinder(r=r,h=t+0.2);
  }
  translate([8,-14-r,0]) difference() {
    union() {
      cube([22,5,t]);
      if(hole) {
        translate([22-2.5,2.5,0])  cylinder(r=3.6,h=t/2);
      }
    }
    if(hole) {
      translate([22-2.5,2.5,-0.1]) cylinder(r=1.6,h=t+0.2);
      translate([22-2.5,2.5,t/2])  cylinder(r=5,h=t/2+0.1);
    }
  }

  translate([0,-14-r,0]) {
    cube([6,2,6]);
    translate([3,0,3]) rotate([90,0,0]) cylinder(r=2,h=2);
  }

}