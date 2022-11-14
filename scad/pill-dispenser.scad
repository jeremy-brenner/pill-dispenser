use <./rotator.scad>;
use <./rotator-tray.scad>;
use <./rotator-tray-base.scad>;
use <./rotator-tray-cap.scad>;
use <./rotator-singles.scad>;
use <./rotator-tray-singles.scad>;
use <./lock-pole.scad>;
use <./motor.scad>;
use <./center-shaft.scad>;

use <./pill.scad>;

rotatorH=10;
rotatorT=2;
rotatorFinT=4;
rotatorSections=8;

rotatorHoleSize=20;

rotatorIr=18;
rotatorOr=rotatorIr+rotatorHoleSize+rotatorT*2;
dAngle=360/rotatorSections;

holeOr=rotatorOr-rotatorT;
holeIr=rotatorIr+rotatorT;

rotatorTrayR=rotatorOr+3;
rotatorTrayH=rotatorH+3;
rotatorTrayCenterHoleR=rotatorIr+0.3;

t=1.2;

$fn=64;

$t=0.125;

singles();




module singles() {
  rotatorSinglesIr=16;

  rowDistances=[25.25,33.25];
  pillsPerRow=16;
  totalPills = len(rowDistances) * pillsPerRow;
  angle = 360/totalPills;

  pr=3.75;
  ph=21;

  trayR=max(rowDistances)+pr+3.5;
  //color("red") cylinder(r=20.25,h=20);
 // rotate([0,0,angle]) translate([0,0,2.5]) rotatorSingles(pillsPerRow,rowDistances,pr,ph,t,rotatorSinglesIr);
  
  //rotatorTraySingles(trayR,ph+3,rotatorSinglesIr+0.3,pillsPerRow,pr,rowDistances);

  rotate([0,0,angle]) {
    centerShaft(3,rotatorSinglesIr,false);
    translate([0,0,-3]) {
      difference() {
        union() {
         cylinder(r=rotatorSinglesIr+3,h=3);
        }
        translate([0,0,-0.1]) cylinder(r=9.8,h=4.2);
      }
    }
  }
  // translate([0,0,-ph-3.5-5]) union() {
  // difference() {
  //   rotatorTrayBase(trayR,ph+3,pillsPerRow,trayR-2,false);
  //   translate([trayR-10,-10,2]) cube([20,20,ph+5]);
  // }
  // translate([rotatorSinglesIr+0.3,-10,0]) cylinder(r=10,h=ph);
  // }
  // translate([rotatorSinglesIr+0.3,-10,0]) cube([20,20,ph+3]);

//  translate([0,0,ph+3.5]) rotatorTrayCap(trayR,10+2,pillsPerRow,rotatorSinglesIr+0.3,angle);

  
  //  rotate([0,0,angle]) translate([0,0,-16]) lockPole(r=9.2,h=60, topInterlock=true, bottomInterlock=true);
//translate([0,0,19.5]) lockPole(r=9.2, h=60, topInterlock=true, bottomInterlock=true);
  //translate([0,0,25-9.5]) lockPole(r=9.2, h=25, topInterlock=true, bottomInterlock=true);
  // translate([0,0,-30]) motor();

}


//rotator(rotatorT,rotatorFinT,rotatorSections,rotatorH,rotatorOr,rotatorIr);
// rotatorTray(rotatorTrayR,rotatorTrayH,rotatorTrayCenterHoleR,holeOr,holeIr,rotatorSections);

//  test($t);

module test(t) {
  // translate([rotatorIr+rotatorT,-1,20]) cube([rotatorHoleSize,2,2]);

  rotate([0,0,t*360])  {
    translate([0,0,2.5]) { 
      color("white") rotator(rotatorT,rotatorFinT,rotatorSections,rotatorH,rotatorOr,rotatorIr);
      // translate([rotatorIr+6,3.3,0]) pill();
      // translate([rotatorIr+6,-3.3,0]) pill();
    }
    
    translate([0,0,2.5+rotatorH+3]) { 
      color("white") rotator(rotatorT,rotatorFinT,rotatorSections,rotatorH,rotatorOr,rotatorIr);
      translate([rotatorIr+6,3.3,0]) pill();
      translate([rotatorIr+6,-3.3,0]) pill();
    }
  }


  color("blue") rotatorTray(rotatorTrayR,rotatorTrayH,rotatorTrayCenterHoleR,holeOr,holeIr,rotatorSections);
  color("red") rotate([0,0,dAngle]) translate([0,0,rotatorH+3])rotatorTray(rotatorTrayR,rotatorTrayH,rotatorTrayCenterHoleR,holeOr,holeIr,rotatorSections);


}
