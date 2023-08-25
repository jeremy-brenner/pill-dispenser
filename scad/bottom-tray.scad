use <./rotator-tray-base.scad>;
use <./bend.scad>;
use <./rotator-tray-singles.scad>;


module bottomTray(bottomTrayH,trayR,pr,ph,pillsPerRow,rowDistances,angle,servoWingT) {
    cw=(pr+1.2)*2;
    cl=ph/2+4;

    difference() {
      union() {
        rotatorTrayBase(trayR,bottomTrayH,pillsPerRow,trayR-2,0);
        translate([0,0,-6]) cylinder(r=trayR+6,h=6);
        
        rotate([0,0,-angle]) translate([-cl+trayR-2,-cw/2,0]) {
          cube([cl,cw,bottomTrayH]);
          translate([0,pr+1.2,0]) cylinder(r=pr+1.2,h=bottomTrayH);          
        }
        rotate([0,0,-angle]) {
          difference() {
            cylinder(r=14,h=10);
            translate([-5,-20,0]) cube([10,10,10.1]);
          }
          translate([-5,-trayR,0]) cube([10,trayR,2]);
        }
      }
      rotate([0,0,-angle]) {
        translate([0,0,-4]) intersection() {
          cylinder(r=9.8,h=20);
          translate([-10,-5,-0.1]) cube([20,10,20.2]);
        }
       translate([-4,-39.5,0]) cube([8,50.5,6]);
      }
      rotate([0,0,-angle]) translate([-trayR+2.5,0,5.5]) rotate([0,-90,0]) cylinder(r=6.5,h=10);
      
      rotate([0,0,-angle]) { 
        translate([trayR-2,0,0]) rotate([0,90,0]) cylinder(r=pr+0.4,h=30);
        translate([0,0,bottomTrayH-10]) pillHole(pr+0.4,rowDistances,10.1);
        translate([trayR-2,0,-8.2]) translate([0.1,0,bottomTrayH]) bend(4,ph/2,pr+0.4);
        translate([-15.8,-28.15,-5]) cube([servoWingT,12.3,5.1]);
        translate([-31.5,-28.5,0]) cube([10,10,50]);
      }
      
      rotate([0,0,-angle*12]) mirror([0,1,0]) translate([-30.6,7.2,-5]) cube([12.3,servoWingT,5.1]);

      translate([0,0,-4]) intersection() {
        rotate([0,0,-angle]) {
          translate([-100,-10,0]) cube([100,100,5]);
          translate([5,-105,0]) cube([100,100,5]);
        }
        difference() {
          cylinder(r=trayR-2,h=6);
          translate([0,0,-0.1]) cylinder(r=14,h=6.2);

        }
      }

    }

    rotate([0,0,-angle]) translate([-trayR+2.5,0,5.5]) rotate([0,-90,0]) difference() {
      cylinder(r=6.5,h=4.5);
     translate([0,0,-0.1]) cylinder(r=5.5,h=4.7);
    }
}


