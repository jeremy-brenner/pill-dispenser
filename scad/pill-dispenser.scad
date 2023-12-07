use <./rotator-tray-base.scad>;
use <./rotator-tray-cap.scad>;
use <./rotator-singles.scad>;
use <./rotator-tray-singles.scad>;
use <./ratchet-tray.scad>;
use <./ratchet.scad>;
use <./rack-and-pinion.scad>
use <./lock-pole.scad>;
use <./center-shaft.scad>;
use <./rotator-gear.scad>;
use <./bottom-tray.scad>;
use <./bend.scad>;
use <./servo.scad>;
use <./pill.scad>;
use <./cpu.scad>;
use <./lock.scad>;


renderCap=true;
renderRotator=true;
renderRotatorTray=true;
renderRatchetTray=true;
renderRatchetTrayLid=true;
renderBottomTray=true;
renderRotatorGear=true;
renderRatchetArmWRack=true;
renderRatchetArmWHole=true;
renderLockPole=true;
lockPoleLen=1; 
renderPinionServo=true;
renderPinion=true;
renderLock=true;
lockPosition=4; // [4:Unlocked, 8:Middle, 20:Locked]

/* [Hidden] */

pr=4;
// pr=3.75; //original

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

ratchetTrayH=10.4;

bottomTrayH=26.75; //22.75
servoWingT=3;

lockPoleBaseLen=46;

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
  
  if(renderCap) {
   rotate([0,0,-angle]) translate([0,0,trayH*2]) rotatorTrayCap(trayR,10+2,pillsPerRow,rotatorSinglesIr+0.3,angle);
  }

  if(renderRotator) {
    rotate([0,0,angle]) translate([0,0,2.5]) rotatorSingles(pillsPerRow,rowDistances,pr,ph,t,rotatorSinglesIr);
  }

  if(renderRotatorTray) {
    rotatorTraySingles(trayR,trayH,rotatorSinglesIr+0.3,pillsPerRow,pr,rowDistances,angle);
  }
  // translate([0,0,trayH]) rotatorTraySingles(trayR,trayH,rotatorSinglesIr+0.3,pillsPerRow,pr,rowDistances,angle);
  
  if(renderRatchetTrayLid) {
    // intersection() {
      translate([0,0,0]) ratchetTrayLid(t, trayR-2.3,rotatorSinglesIr+0.3,pr,rowDistances,angle,ratchetTrayH); 
    //  mirror([0,0,1]) rotate([0,0,angle*-12]) mirror([0,1,0]) translate([27.5,-21.5,-1])  cylinder(r=5,h=100);
    //  }

  }

  if(renderRatchetTray) {
    
    translate([0,0,-ratchetTrayH]) ratchetTray(trayR,ratchetTrayH,rotatorSinglesIr+0.3,pillsPerRow,pr,ph,rowDistances,angle,t,servoWingT);  
  }
  
  if(renderBottomTray) {
    translate([0,0,-ratchetTrayH-bottomTrayH-2.2]) {
    //  intersection() {
       bottomTray(bottomTrayH,trayR,pr,ph,pillsPerRow,rowDistances,angle); 
        // rotate([0,0,-angle]) translate([-trayR-10,-8.5,-3]) cube([20,17,17]);
      // }
    }
    // powerHoleNutDriver();
  }

  if(renderRotatorGear) {
    translate([0,0,-2.2]) rotate([0,0,angle]) rotatorGear(rotatorSinglesIr);
  }


  rotate([0,0,-angle*12]) translate([0,0,-8]) {
    if(renderRatchetArmWHole) {
      rotate([0,0,-90]) ratchetArmHole();
    }
    if(renderRatchetArmWRack) {
      translate([4.5,0,0])  ratchetArmRack();
    }
  }

  if(renderLockPole) {
    lockPoleH =lockPoleBaseLen+trayH*lockPoleLen;
    //  lockPoleLen==1 ? lockPoleBaseLen+trayH : trayH;
    translate([0,0,-16]) lockPole(r=9.2,h=lockPoleH, bottomInterlock=false);
  }

  translate([-18.5,-8,-ratchetTrayH]) rotate([0,90,0]) rotate([0,90,0]) {
    if(renderPinionServo) {
      servo();
    }
    if(renderPinion) {
      translate([6,6,27]) rotate([0,0,-15]) pinion();
    }
  }

  
  lockO=-trayR+lockPosition;

  translate([-7.5/2,lockO,-ratchetTrayH-bottomTrayH-2.2]) {
    if(renderLock) lock();
  }
 
//  color("gray") translate([25,-14,-28]) rotate([0,0,-angle-45]) cube([8,13,25]);
  // translate([0,-37,-11]) rotate([0,0,-angle-45]) rotate([0,90,0]) cpu();

  // rotate([0,0,180]) translate([0,-37,-11]) rotate([0,0,-angle-45]) rotate([0,90,0]) cpu();
}

module lockPoleBottomTest() {
  lockPole(r=9.2,h=20, topInterlock=false, bottomInterlock=false);
}

module lockPoleTopTest() {
  lockPole(r=9.2, h=25, topInterlock=true, bottomInterlock=true);
}





