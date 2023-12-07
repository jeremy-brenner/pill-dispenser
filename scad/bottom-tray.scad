use <./rotator-tray-base.scad>;
use <./bend.scad>;
use <./servo-mount.scad>;
use <./pill-chute.scad>;

module bottomTray(bottomTrayH,trayR,pr,ph,pillsPerRow,rowDistances,angle) {
    cw=(pr+1.2)*2;
    cl=ph/2+4;
    difference() {
      union() {
        rotatorTrayBase(trayR,bottomTrayH,pillsPerRow,trayR-2,0,false,true);
        translate([0,0,-6]) cylinder(r=trayR+6,h=6);
        rotate([0,0,-angle]) translate([min(rowDistances),0,19]) chuteBlock(pr+0.4);

        rotate([0,0,-angle]) {
          difference() {
            cylinder(r=14,h=14);
            translate([-5,-20,0]) cube([10,10,14.1]);
          }
          translate([-5,-trayR,0]) cube([10,trayR,6]);
          
        }
        
      }
      rotate([0,0,-angle]) translate([min(rowDistances),0,19]) chuteHole(pr+0.4,max(rowDistances)-min(rowDistances));
      rotate([0,0,-angle]) translate([-20.8,-10,-4]) cube([10,20,30]);

      rotate([0,0,-angle]) {
        translate([0,0,0]) intersection() {
          cylinder(r=9.8,h=20);
          translate([-10,-5,-0.1]) cube([20,10,20.2]);
        }
        translate([-4,-39.5,4]) cube([8,50.5,6]);
         translate([0,-trayR/2-1.5,5]) rotate([0,90,0]) scale([0.2,1,1]) cylinder(r=9.5,h=4);
      }

      // power hole
      rotate([0,0,-angle]) translate([-trayR+3.5,0,5.5]) rotate([0,-90,0]) cylinder(r=7,h=11);
      
      rotate([0,0,-angle]) translate([21.5,-28.5,0]) cube([10,10,50]);

      translate([0,0,-4]) intersection() {
        rotate([0,0,-angle]) {
          translate([-100,-10,0]) cube([101,100,5]);
          translate([0,6.5,0]) cube([100,100,5]);
          translate([5,-106.5,0]) cube([100,100,5]);
          translate([-105,-106,0]) cube([100,100,5]);
        }
        difference() {
          cylinder(r=trayR-2,h=6);
          translate([0,0,-0.1]) cylinder(r=14,h=6.2);
        }
      }

    }

   color("blue") rotate([0,0,-angle-90]) translate([14,11.4,-1.5]) servoMount();

    color("blue") rotate([0,0,-angle*12]) translate([-32.5,-11.6,-1.5]) servoMount();


    // rotate([0,0,-angle]) translate([-15,-38,-4]) color("green") cube([1.2,80,bottomTrayH+4]);

    rotate([0,0,-angle]) translate([-14,-38,-4]) cube([1.2,5,bottomTrayH+4]);
    rotate([0,0,-angle]) mirror([0,1,0]) translate([-14,-38,-4]) cube([1.2,5,bottomTrayH+4]);

    // power hole
    rotate([0,0,-angle]) translate([-trayR+2.7,0,5.5]) rotate([0,-90,0]) difference() {
      cylinder(r=8,h=8.7);
      translate([0,0,-0.1]) intersection() {
        cylinder(r=6,h=9.7);
        translate([-5.5,-6,-0.1]) cube([11,12,10]);
      }
    }

    translate([0,0,14]) difference() {
      cylinder(r=10.8,h=12.75);
      translate([0,0,-0.1]) cylinder(r=9.8,h=13.2);
    }
    // rotate([0,0,-angle]) translate([-10.8,-40,-4])  cube([1,80,bottomTrayH+4]);
}


module powerHoleNutDriver() {
  difference() {
    union() {
      cylinder(r=8.5,h=5);
      translate([0,0,4]) for( i = [0:16] ) {
        rotate([0,0,(360/16)*i]) translate([7.2,0,0]) cylinder(r=2,h=2);
      }
    }
    translate([0,0,-0.1]) cylinder(r=6,h=9.7);
    translate([0,0,-0.1]) cylinder(r=8,h=2.1,$fn=6);
  }

}

