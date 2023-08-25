use <./rotator-tray-base.scad>;
use <./rotator-tray-cap.scad>;
use <./rotator-singles.scad>;
use <./rotator-tray-singles.scad>;
use <./ratchet-tray.scad>;
use <./ratchet.scad>;
use <./lock-pole.scad>;
use <./center-shaft.scad>;
use <./rotator-gear.scad>;
use <./bottom-tray.scad>;
use <./bend.scad>;
use <./servo.scad>;
use <./pill.scad>;
use <./cpu.scad>;
use <./lock.scad>;

pr=3.75;
ph=21;
t=1.2;

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
rotatorTrayCenterHoleR=rotatorIr+0.3;

ratchetTrayH=8.4;

bottomTrayH=22.75;
servoWingT=2.8;


$fn=64;

$t=0.125;


singles();




module singles() {
  rotatorSinglesIr=16;
  rowDistances=[25.25,33.25];

  pillsPerRow=16;
  totalPills = len(rowDistances) * pillsPerRow;
  angle = 360/totalPills;



  trayH=ph+3;
  trayR=max(rowDistances)+pr+4.5;
  
  translate([0,0,trayH*2]) rotatorTrayCap(trayR,10+2,pillsPerRow,rotatorSinglesIr+0.3,angle);

  rotate([0,0,angle]) translate([0,0,2.5]) rotatorSingles(pillsPerRow,rowDistances,pr,ph,t,rotatorSinglesIr);
  
  rotatorTraySingles(trayR,trayH,rotatorSinglesIr+0.3,pillsPerRow,pr,rowDistances,angle);
  translate([0,0,trayH]) rotatorTraySingles(trayR,trayH,rotatorSinglesIr+0.3,pillsPerRow,pr,rowDistances,angle);
  translate([0,0,-ratchetTrayH]) ratchetTray(trayR,ratchetTrayH,rotatorSinglesIr+0.3,pillsPerRow,pr,ph,rowDistances,angle,t,servoWingT);  
  
  translate([0,0,-ratchetTrayH-bottomTrayH-2.2]) bottomTray(bottomTrayH,trayR,pr,ph,pillsPerRow,rowDistances,angle,servoWingT) ;



     translate([0,0,-2.2]) rotate([0,0,angle]) rotatorGear(rotatorSinglesIr);
    rotate([0,0,-angle*12]) translate([0,0,-6]) {
       ratchetArmHole();
    translate([4.5,0,0])  ratchetArmRack();
    }




  //  rotate([0,0,angle]) translate([0,0,-16]) lockPole(r=9.2,h=102, topInterlock=true, bottomInterlock=false);
  rotate([0,0,angle]) translate([0,0,-16]) lockPole(r=9.2,h=101-trayH, topInterlock=true, bottomInterlock=false);
   translate([-18.5,-8,-ratchetTrayH]) rotate([0,0,90]) rotate([0,90,0]) motor();


  // cpu();


lockO=-trayR+24;
//  lockO=-trayR+16;
//  lockO=-trayR+8;
rotate([0,0,-angle]) translate([-7.5/2,lockO,-ratchetTrayH-bottomTrayH-2.2]) {
  color("red") lock();
}








 
}

module lockPoleBottomTest() {
  lockPole(r=9.2,h=20, topInterlock=false, bottomInterlock=false);
}

module lockPoleTopTest() {
  lockPole(r=9.2, h=25, topInterlock=true, bottomInterlock=true);
}





