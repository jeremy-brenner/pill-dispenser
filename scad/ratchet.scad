use <./rack-and-pinion.scad>
use <./servo.scad>

$fn=64;

//  color("green") cylinder(r=20,h=0.1);
// difference() {
//   color("green") ratchet(10,32,4);
//   translate([0,0,-0.1]) cylinder(r=1.6,h=4.2);
// }

ad=19;
aad=6;
aa=10;

t=6;

// color("blue") 
  //translate([-3.3,0,0]) translate([aad,-ad,0]) rotate([0,0,aa]) translate([-aad,ad,0]) 

//translate([3.5,0,-0.2])
//    mirror([0,1,0]) mirror([1,0,0])  {
//     powl(10,32,4, false);
//     translate([23,-19,2]) rotate([90,0,0]) rack();
//    }

//  powl(10,32,4, false);


// plate();

// translate([-32,-8,4]) rotate([-90,0,0]) rotate([0,0,-90]) motor();
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

module motor() {
  servo();
  translate([6,6,27]) rotate([0,0,-15]) pinion();
}

module plate() {
color("orange") difference() {
  translate([-35,-41,-2]) cube([60,82,2]);
  translate([-32,7.25,-2.1]) cube([12.25,3,2.2]);
}
translate([-32,10.25,0]) cube([12.25,2,4]);
translate([-32,0.25,0]) cube([12.25,7,4]);
translate([-34,0.25,0]) cube([2,12,20]);
// translate([-19.75,0.25,0]) cube([2,12,20]);


translate([-20,17,0]) cube([10,2,5]);
translate([3.6,20,0]) cube([2,4,5]);

translate([0,-41,0]) {
    cube([6,2,6]);
    translate([3,4,3]) rotate([90,0,0]) cylinder(r=2,h=2);
}
mirror([0,1,0]) mirror([1,0,0]) translate([0,-41,0]) {
    cube([6,2,6]);
    translate([3,4,3]) rotate([90,0,0]) cylinder(r=2,h=2);
}

cylinder(r=1.4,h=6);
translate([20.5,-21.5,0]) cylinder(r=1.4,h=6);
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
      translate([22-2.5,2.5,-0.1]) cylinder(r=1.6,h=t+02);
      translate([22-2.5,2.5,t/2])  cylinder(r=3.6,h=t/2+0.1);
    }
  }

  translate([0,-14-r,0]) {
    cube([6,2,6]);
    translate([3,0,3]) rotate([90,0,0]) cylinder(r=2,h=2);
  }

}