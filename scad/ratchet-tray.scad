use <./rotator-tray-singles.scad>;
use <./ratchet.scad>;

module ratchetTray(trayR,ratchetTrayH,ir,pillsPerRow,pr,ph,rowDistances,angle,t,servoWingT) {
  cw=(pr+1.2)*2;
  cl=ph/2+4;
  
  oa=-angle*12;

  rotate([0,0,oa]) mirror([0,1,0]) {
    difference() {

      rotate([0,0,oa]) rotatorTraySingles(trayR,ratchetTrayH,ir,pillsPerRow,pr,rowDistances,angle,1);

      color("red") {
      translate([-31,18.8,-0.1]) cube([19.5,6.5,4]);
      translate([-30.6,7.2,-0.1]) cube([12.5,servoWingT,4]);
      translate([-30.5,-14,-0.1]) cube([10,12,4]);
      }
      color("blue") {
        rotate([0,0,135+angle]) mirror([0,1,0]) {
          translate([-28.1,-15.8,-0.1]) cube([12.5,servoWingT,4]);
          translate([-26,-32.5,-0.1]) cube([12,10,4]);
        }

      }

      translate([27.5,-21.5,-0.1]) cylinder(r=1.6,h=6);
      rotate([0,0,90]) translate([27.5,-21.5,-0.1]) cylinder(r=1.6,h=6);
      rotate([0,0,218]) translate([27.5,-21.5,-0.1]) cylinder(r=1.6,h=6);
    }
    translate([0,0,1.4]) difference() {
      cylinder(r=20.4,h=7);
      translate([0,0,-0.1]) {
        cylinder(r=19.2,h=7.2);
        rotate([0,0,90]) translate([-1,-50,0]) cube([10,50,7.2]);
        translate([-9,0,0]) cube([15,50,7.2]);
        translate([-20,6,0]) cube([3,6,7.2]);
        rotate([0,0,-42+angle]) translate([14,-18,0]) cube([4,5,7.2]);
      }
    }
    

    rotate([0,0,90]) translate([0,-trayR+0.5,2.2]) springPeg();
    rotate([0,0,180]) translate([0,-trayR+0.5,2.2]) springPeg();
  } 
}


module ratchetTrayLid(t,r,holeR,pr,rowDistances,angle,ratchetTrayH) {
  mirror([0,0,1]) rotate([0,0,-angle])  difference() {
    union() {
      cylinder(r=r,h=2);
      translate([rowDistances[0],0,2]) cylinder(r=pr+t+0.4,h=ratchetTrayH-4);
      translate([rowDistances[1],0,2]) cylinder(r=pr+t+0.4,h=ratchetTrayH-4);
      rotate([0,0,angle*-11]) mirror([0,1,0]) {
        color("red") rotate([0,0,90])  translate([27.5,-21.5,2]) {
          cylinder(r=4.5,h=3);
            intersection() {
              difference() {
                cylinder(r=7,h=ratchetTrayH-4);
                translate([0,0,-0.1]) cylinder(r=4.5,h=ratchetTrayH-4+0.2);
                translate([0,0,-5.1])  rotate([0,0,140]) cube([100,100,100]);
                
              }
              translate([-27.5,21.5,-0.2]) cylinder(r=r,h=ratchetTrayH);
           }
        }
        color("green") translate([27.5,-21.5,2]) cylinder(r=4.5,h=ratchetTrayH-4);
        color("blue") rotate([0,0,218]) translate([27.5,-21.5,2]) cylinder(r=4.5,h=ratchetTrayH-4);
      }

    }
    translate([0,0,-0.1]) { 
      cylinder(r=holeR,h=2.2);
      translate([rowDistances[0],0,0]) cylinder(r=pr+0.4,h=ratchetTrayH+0.2);
      translate([rowDistances[1],0,0]) cylinder(r=pr+0.4,h=ratchetTrayH+0.2);
      translate([0,0,2.1]) cylinder(r=20.6,h=ratchetTrayH);

      rotate([0,0,angle*-11]) mirror([0,1,0]) {
        color("red") translate([27.5,-21.5,0]) {
          cylinder(r=3.2,h=2.6,$fn=6);
          cylinder(r=1.6,h=ratchetTrayH);
        }
        color("green") rotate([0,0,90]) translate([27.5,-21.5,0]) {
          cylinder(r=3.2,h=2.6,$fn=6);
          cylinder(r=1.6,h=ratchetTrayH);
        }

        color("blue") rotate([0,0,218]) translate([27.5,-21.5,0]) {
          cylinder(r=3.2,h=2.6,$fn=6);
          cylinder(r=1.6,h=ratchetTrayH);
        }
      }

    }
  }

}
