servoMount();
translate([0,-5,0]) servoMountClip();

module servoMount() {
  difference() {
    cube([16,6,5]);
    translate([1.75,1.75,-0.1]) cube([12.5,2.5,5.2]);
    translate([8,-1,2.5]) rotate([-90,0,0]) cylinder(r=1,h=10, $fn=32);
  }

  translate([0,0,-4]) cube([16,20,4]);
  translate([0,18,0]) cube([16,2,5]);
}

module servoMountClip() {
  difference() { 
    cube([18,2,3.5]);
    translate([9,-1,1.75]) rotate([-90,0,0]) cylinder(r=1,h=10, $fn=32);
  }
}