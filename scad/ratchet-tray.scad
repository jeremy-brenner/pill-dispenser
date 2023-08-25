use <./rotator-tray-singles.scad>;
use <./ratchet.scad>;

module ratchetTray(trayR,ratchetTrayH,ir,pillsPerRow,pr,ph,rowDistances,angle,t,servoWingT) {
  cw=(pr+1.2)*2;
  cl=ph/2+4;
  
  oa=-angle*12;

  rotate([0,0,oa]) mirror([0,1,0]) {
    difference() {

      rotate([0,0,oa]) rotatorTraySingles(trayR,ratchetTrayH,ir,pillsPerRow,pr,rowDistances,angle,1);

      translate([-31,18.8,-0.1]) cube([19.5,6.5,4]);
      translate([-30.6,7.2,-0.1]) cube([12.3,servoWingT,4]);
      translate([-27.5,-14,-0.1]) cube([6,12,4]);
 
      rotate([0,0,135+angle]) {
        translate([-28.1,-15.8,-0.1]) cube([12.3,servoWingT,4]);
        translate([-25,-29.5,-0.1]) cube([15,7,4]);
      }
      translate([27.5,-21.5,-0.1]) cylinder(r=1.6,h=6);
    }
    translate([0,0,1.4]) difference() {
      cylinder(r=20.4,h=7);
      translate([0,0,-0.1]) {
        cylinder(r=18.9,h=7.2);
        translate([-1,-50,0]) cube([10,50,7.2]);
        translate([-9,0,0]) cube([15,50,7.2]);
        translate([-20,6,0]) cube([3,6,7.2]);
        rotate([0,0,-42+angle]) translate([15,11,0]) cube([4,5,7.2]);
      }
    }

    rotate([0,0,oa+angle]) difference() {
      translate([trayR-t*2+0.5-cl,-cw/2,0]) { 
        cube([cl,cw,ratchetTrayH]);
        translate([0,pr+1.2,0]) cylinder(r=pr+1.2,h=ratchetTrayH);
      }
      translate([0,0,-0.1]) pillHole(pr+0.4,rowDistances,ratchetTrayH*4+0.2);
    }
    translate([0,-trayR+0.5,ratchetTrayH-6.2]) springPeg();
    rotate([0,0,180]) translate([0,-trayR+0.5,ratchetTrayH-6.2]) springPeg();
  } 
}

