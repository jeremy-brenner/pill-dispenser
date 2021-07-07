use <./tapered-cube.scad>;
use <./involute_gears.scad>;

$fn=32;
lockingGear=true;
lidGear=true;
bar=true;

if(bar) {
  lockingBar(0);
}

if(lockingGear) {
  lockingGear();
}

if(lidGear) {
  lidGear();
}

module lock(locked) {
  translate([36.5,0,5]) {
    pos=locked?21:5;
    rot=locked?0:-67.4;
    lockingBar(pos);
    rotate([0,0,180]) lockingBar(pos);
   // translate([0,0,5]) rotate([0,0,rot]) lockingGear();
    translate([58,-28.5,5]) lidGear();
  }
}

module lidGear() color("orange") {
  cw=10.5*sqrt(2)/2;

 
  translate([0,0,-10]) difference() {
    union() {
      translate([0,0,10]) rotate([0,0,4.2]) gear(number_of_teeth=50,
 				circular_pitch=3,
				hub_diameter=8,
        hub_thickness=4,
				rim_thickness=4,
				gear_thickness=4,
				rim_width=3);
      cylinder(r=10,h=10);
    }
    translate([0,0,-0.1]) taperedCube(cw,11.1,-2);
    translate([0,0,-1]) cylinder(r=3.2,h=50);

  }

}

module lockingGear() {
  color("blue") difference() {
    //cylinder(r=40,h=4);

    gear (number_of_teeth=85,
 				circular_pitch=3,
				hub_diameter=8,
        hub_thickness=4,
				rim_thickness=4,
				gear_thickness=4,
				rim_width=3);

    translate([0,0,-0.1]) cylinder(r=3.2,h=10);
  }
  color("green") translate([0,26,-6]) cylinder(r=1.9,h=10);
  color("green") translate([0,-26,-6]) cylinder(r=1.9,h=10);
}

module lockingBar(pos) {
  trackLen=24;
  bw=9.5;
  translate([-bw/2,pos,0]) {
    difference() {
      union() {
        translate([0,5,0]) cube([bw,37,4.5]);
        
        translate([0,42,4.5/2]) rotate([0,90,0]) difference() {
          cylinder(r=4.5/2,h=bw);
          translate([-4.5/2,0,-3]) rotate([7,0,0]) cube([4.5,4.5,3]);
          translate([-4.5/2,0,bw]) rotate([-7,0,0]) cube([4.5,4.5,3]);
        }
        translate([5,5,0]) cylinder(r=5,h=4.5);
        translate([5,0,0]) cube([trackLen,10,4.5]);
        translate([trackLen+5,5,0]) cylinder(r=5,h=4.5);
      }
      translate([5,3,-0.1]) {
        translate([0,2,0]) cylinder(r=2,h=6.5);
        cube([trackLen,4,6.5]);
        translate([trackLen,2,0]) cylinder(r=2,h=6.5);
      }
    }
  }
}
