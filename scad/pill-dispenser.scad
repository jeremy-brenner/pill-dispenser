

use <./hex-grid.scad>;
use <./involute_gears.scad>;
use <./board-mount.scad>;
use <./motor.scad>;
use <./button.scad>;
use <./lock.scad>;
use <./tapered-cube.scad>;

carouselCap=true;
motorGear=true;
carouselMotor=true;
bigGear=true;
carousel=true;
bearingPost=true;
mountRing=true;
mainMount=true;
bottomLayer=true;
case=true;
lid=true;
lidInner=true;
lidMotorMount=true;
lidMotor=true;
lidMotorPost=true;

lock=true;
locked=true;

/* [Hidden] */

$fn=32;

lw=0.4;
t=lw*2;

teethPerPill=3;
pillsPerRotation=8;

pr=3.6;  //30mg
spr=3.1; //20mg

c_or=53.5;
c_ir=46.025; // for second pill

ph=21;

hexR=4.5;

bearingOuterR=11;

pillHoles=36;
a=10;
d=52;

pitch=3.5;
hub_thickness=4;
rim_thickness=4;
gear_thickness=2;

motorDistance=66;
motorAngle=45;

mt=lw*4;
mr=63;
bl=60;
lr=mr-1;

if(carouselCap) {
  translate([0,0,35]) rotate([180,0,0]) carouselCap();
}

if(motorGear) {
  motorPosition() translate([8,0,13.25]) motorGear();
}

if(carouselMotor) {
  motorPosition() translate([0,0,-10]) rotate([0,0,90]) motor();
}

translate([0,0,11.5]) {
  if(carousel) {
    carousel();
  }
  if(bigGear) {
    bigGear();
  }
}

if(bearingPost) {
  bearingPost();
}

translate([100,-34,-14.5]) {
  if(lidMotorMount) {
    lidMotorMount();
  }
  if(lidMotor) {
    translate([0,0,4.5]) rotate([0,0,-135]) motor();
  }
  if(lidMotorPost) {
    lidMotorPost();
  }
}

if(mountRing) {
  translate([0,0,8.25]) mountRing();  
}

if(mainMount) {
  mainMount();
}

if(bottomLayer) {
  translate([0,0,-14.75]) color("grey") bottomLayer();
}

if(case) {
  translate([0,0,-16.25]) {
    case();
  }
}

translate([0,0,34]) {
  if(lid) {
    lid();
  }

  if(lidInner) {
    lidInner();
  }
  if(lock) {
    lock(locked);
  }
}

module lidMotorPost() {
  cw=10*sqrt(2)/2;
  translate([-5.5,5.5,26]) difference() {
    union() {
      cylinder(r=5,h=22);
      translate([0,0,22]) taperedCube(cw,10,-2);
    }
    translate([0,0,-0.1]) cylinder(r=2.7,h=2.61);
    translate([0,0,2.5]) motorPegHole();
  }
}

module lidInner() {
  ir=lr-2.5;
  iir=lr-4.5;
  
  difference() {
    union() {
      difference() {
        union() {
          translate([0,0,0]) cylinder(r=ir,h=15);
          translate([0,-ir+6,0]) cube([ir+bl,ir*2-12, 15]);
        }
        translate([0,0,2]) {
          cylinder(r=iir,h=17);
          translate([0,-iir+6,0]) cube([iir+bl,iir*2-12, 17]);
          translate([94.5,-28.5,0]) cylinder(r=26,h=20);
        }
      }
      translate([94.5,-28.5,2]) cylinder(r=15,h=7.8);
      translate([26,32,0]) {
        cube([20,20,4.98]);
        translate([0,0,0]) cube([20,8,9.8]);
      }
      translate([26+20,0,0]) rotate([0,0,180]) translate([0,32,0]) {
        cube([20,20,4.98]);
        translate([0,0,0]) cube([20,8,9.8]);
      }
      

    }
    translate([26,42,0]) {
        translate([0,0,5]) cube([23,20,11]);
    }

      translate([26,-62,0]) {
        translate([0,0,5]) cube([23,20,11]);
    }
    translate([36.5,0,-2]) cylinder(r=3.2,h=11);

    translate([94.5,-28.5,-1]) cylinder(r=10.5,h=30);

    translate([mr/2,-(mr+mt+1),4.99]) cube([10,(mr+mt+1)*2,5.01]);
  }
  translate([36.5,0,2]) {
    difference() {
      cylinder(r=6,h=8); 
      translate([0,0,-1]) cylinder(r=3.2,h=11);
    }
  }
}

module lid() {
  ir=lr-2;
  r=pr+0.5+t*2.6;

  difference() {
    union() {
      difference() {
        union() {
          translate([0,0,0]) cylinder(r=lr,h=15);
          translate([0,-lr+6,0]) cube([lr+bl,lr*2-12, 15]);
        }
        translate([0,0,-0.1]) cylinder(r=ir,h=16);
        translate([0,-ir+6,-0.1]) cube([ir+bl,ir*2-12, 16]);
      }

      translate([37,0,0]) {
        translate([-10,34,5]) cube([20,20,10]);
        rotate([0,0,180]) translate([-10,34,5]) cube([20,20,10]);
      }

      difference() {
        union() {
          cylinder(r=mr+mt*2,h=15+mt);
          translate([0,-(mr+mt*2),0]) cube([mr+bl+mt*4,(mr+mt*2)*2, 15+mt]);
        }
        translate([0,0,-1]) cylinder(r=mr+mt+0.5,h=16);
        translate([0,-(mr+mt+0.5),-1]) cube([mr+bl+mt*2+1,(mr+mt+0.5)*2, 16]);
      }
    }
    translate([mr/2,-(mr+mt+1),4.99]) cube([10,(mr+mt+1)*2,5.01]);
    translate([36.5,0,0]) cylinder(r=43,h=15);
  }
  translate([36.5,0,0]) {
    difference() {
      cylinder(r=3,h=15); 
      translate([0,0,-1]) cylinder(r=1.5,h=16); 
    }
    translate([0,0,14]) cylinder(r=10,h=1); 
  }
  translate([94.5,-28.5,10]) {
    cylinder(r=3,h=4); 
    translate([0,0,4]) cylinder(r=10,h=1); 
  }
}

module case() {
  mh=65;
  r=pr+0.5+t*2.6;

  difference() {
    union() {
      difference() {
        union() {
          cylinder(r=mr+mt,h=mh);
          translate([0,-(mr+mt),0]) cube([mr+bl+mt*2,(mr+mt)*2, mh]);
        }
        translate([0,0,mt]) cylinder(r=mr,h=mh);
        translate([0,-mr+6,mt]) cube([mr+bl,mr*2-12, mh]);
      }

      translate([0,0,mt]) cylinder(r=9.4,h=4,$fn=6);
      translate([-61-mt,-15,0]) cube([mt,30,16+mt]);
      translate([-57-mt,0,0]) tray();

      translate([45,50,0]) stepperBoardMount();
      translate([81.5,50,0]) arduinoBoardMount();
      translate([45,-55, 0]) stepperBoardMount();
      translate([114.5,-36,mt]) rotate([0,0,-135]) {
        cube([17.5,5,5]);
        translate([17.5/2,-11.6,0]) cylinder(r=14.5,h=4.5);
      }
      translate([122.9,10,mt]) rotate([0,0,90]) buttonBracket();

    }
    translate([-mr+3,0,r+mt]) rotate([0,-90,0]) cylinder(r=r,h=10);
    translate([mr/2,-(mr+mt+1),mh-10]) cube([10,(mr+mt+1)*2,5]);
    translate([mr+bl-1,0,10]) powerHole();   
    translate([mr+bl-1,20,mt+6]) rotate([0,90,0]) cylinder(r=3.75,h=10);  
  }
}

module lidMotorMount() {
  intersection() {
    rotate([0,0,-135]) difference() {
      union() {
        translate([0,0,15]) motorMount();
        cylinder(r=22,h=15);
      }
      translate([0,0,-0.5]) cylinder(r=14.5,h=25);
      translate([-50,-104,-1]) cube([100,100,100]);
      translate([-50,-96,-1]) cube([100,100,16.1]);
      translate([-9,-3,-0.5]) cube([18,20,16.5]);
    }
    translate([-81,-19,-1]) cube([100,100,100]);
  }
}
module powerHole() {
  rotate([0,90,0]) cylinder(r=5.3,h=10);
}

module tray() {
  r=pr+0.5+t*2.6;

  translate([0,-20,r]) 
  rotate([0,-90,0])
  difference() {
    union() {
      cylinder(r=r,h=20-r);
      translate([0,0,20-r]) sphere(r=r);
      translate([0,40,0]) cylinder(r=r,h=20-r);
      translate([0,40,20-r]) sphere(r=r);
      translate([0,0,20-r]) rotate([-90,0,0]) cylinder(r=r,h=40);
      translate([-r,0,0]) cube([r,40,20-r]);
    }
    translate([0,0,-1]) cylinder(r=r-t,h=20-r+1);
    translate([0,0,20-r]) sphere(r=r-t);
    translate([0,0,-1]) translate([0,40,0]) cylinder(r=r-t,h=20-r+1);
    translate([0,40,20-r]) sphere(r=r-t);
    translate([0,0,20-r]) rotate([-90,0,0]) cylinder(r=r-t,h=40);
    translate([0,-100,-1]) cube([100,200,101]);
    translate([-r+t,0,-1]) cube([r,40,20-r+1]);
  }
}

module bottomLayer() {
  or=pr+0.5+t*2.5;
  ir=pr+0.5+t*1.5;

  translate([0,0,1.5]) rotate([0,0,45]) ring(4,90,52) {
    cylinder(r=3,h=13);
    translate([0,0,13]) cylinder(r=1.8,h=3.8);
  }
  translate([-c_or-8.5,-or,0]) {
    difference() {
      cube([20.5,or*2,14.5]);
      translate([21-or,or,15.5]) union() {
        cylinder(r=ir,h=5);
        sphere(r=ir);
        rotate([0,-122,0]) {
          cylinder(r=ir,h=30);
          translate([0,-ir,0]) cube([100,ir*2,20]);
        }

      }
    }
  }
  track(3);
  intersection() {
    hexGrid(10,3,t*2,11,11,[],[]);
    translate([0,0,-1]) cylinder(r=55.5,h=10.5);
  }
}

module track(h) {
  br=c_or+pr*0.66;
  lr=c_ir-spr*0.66;
  difference() {
    cylinder(r=br,h=h);
    translate([0,0,-0.5]) cylinder(r=lr,h=h+1);
  } 
}

module mountRing() {
    skipCells=[
    [10,5],[10,6],
    [11,4],[11,5],[11,6],
    [12,4],[12,5],[12,6],[12,7],

    [3,1],[9,1],
    [4,1],[4,2],[5,2],[6,3],[7,2],[8,1],[8,2],
    [5,1],[5,0],
    [6,2],[6,1],
    [7,1],[7,0],

    [3,9],
    [4,9],[4,10],
    [5,8],[5,9],[5,10],
    [6,8],[6,9],[6,10],
    [7,8],[7,9],[7,10],
    [8,9],[8,10],
    [9,9],

    [2,5],[2,6],
    [1,4],[1,5],[1,6],
    [0,4],[0,5],[0,6],[0,7],
  ];
  intersection() {
    translate([0,0,0]) hexGrid(5.35,3.5,t,13,11,skipCells,[]);
    difference() {
      cylinder(r=55.5,h=10.5);
      translate([0,0,-0.1]) cylinder(r=15,h=10.7);
    }
  }
  translate([0,0,-4.5]) bearingHole();
  difference() {
    union() {
      track(3.5);
      hull() {
        translate([-c_or,0,0]) cylinder(r=pr+0.5+t*2,h=3.5);
        translate([-c_ir,0,0]) cylinder(r=spr+0.5+t*2,h=3.5);
      }
    }
    hull() {
      translate([-c_or,0,-0.5]) cylinder(r=pr+0.5+t,h=9);
      translate([-c_ir,0,-0.5]) cylinder(r=spr+0.5+t,h=9);
    }
    translate([0,-9,-0.5]) cube([100,18,1.5]);
  }
  translate([0,0,-3.8]) rotate([0,0,45]) ring(4,90,52) cylinder(r=1.8,h=3.8);
}

module torus(r1,r2) {
  rotate_extrude(convexity = 10, $fn=$fn)
    translate([r1, 0, 0])
    circle(r = r2, $fn=$fn/2);
}

module mainMount() {
  intersection() {
    difference() { 
      union() {
        translate([-c_or,0,0]) cylinder(r=pr+0.5+t*2,h=8);
        translate([-c_ir,0,0]) cylinder(r=spr+0.5+t*2,h=8);
        track(8);
      }
      translate([0,0,-1]) cylinder(r=bearingOuterR+4,h=10);
      motorPosition() translate([0,0,-1]) cylinder(r=22,h=11);
      hull() {
        translate([-c_or,0,-0.5]) cylinder(r=pr+0.5+t,h=9);
        translate([-c_ir,0,-0.5]) cylinder(r=spr+0.5+t,h=9);
      }
      translate([0,0,-0.5]) rotate([0,0,45]) ring(4,90,52) cylinder(r=2,h=9);
      translate([35,-4,4.5]) cube([20,8,5]);
    }
    cw=95;
    translate([-100,-cw/2,0]) cube([200,cw,10]);
  }

  motorPosition() rotate([0,0,90]) motorMount();
}



module motorGear() {
		rotate([0,0,180/(teethPerPill*pillsPerRotation)]) difference() {
        gear (number_of_teeth=teethPerPill*pillsPerRotation,
				circular_pitch=pitch,
				hub_diameter=8,
        hub_thickness=hub_thickness,
				rim_thickness=rim_thickness,
				gear_thickness=gear_thickness,
				rim_width=3);
        translate([0,0,-0.5]) motorPegHole();
      }
}

module bigGear() {
  gr=61.5;
	difference() {
    union() {
    cylinder(r=gr,h=1);
      translate([0,0,1]) gear (number_of_teeth=teethPerPill*pillHoles,
			 	circular_pitch=pitch,
	   	 	hub_diameter=15,
        hub_thickness=hub_thickness,
			 	rim_thickness=rim_thickness + 0.5,
			 	gear_thickness=1,
			 	rim_width=15);
    
    translate([0,0,rim_thickness+1.5])    cylinder(r=gr,h=1);

    } 
    translate([0,0,-1]) cylinder(r=c_or,h=10);
    translate([0,0,-1]) ring(pillHoles,360/pillHoles,c_or) cylinder(r=pr+0.6+t,h=ph+2);
  }

}


module motorPegHole() {
  pw=3.2;
  pr=2.7;
  ph=7;

  intersection() {
    cylinder(r=pr,h=ph);
    translate([-pw/2,-pr,0]) cube([pw,pr*2,ph]);
  }
}

module ring(c,a,d) {
  for ( i = [0 : c] ) rotate([0,0,i*a]) translate([d,0,0]) children();
}

module motorPosition() {
  translate([motorDistance,0,0]) children();
}

module carouselCap() {
  difference() {
    ring(pillHoles,360/pillHoles,52) cylinder(r=pr+0.6+t*2,h=8);
    translate([0,0,t]) ring(pillHoles,360/pillHoles,52) cylinder(r=pr+0.6+t,h=ph+2);
    translate([0,0,t]) cylinder(r=52,h=8);

  }
}


module carousel() {
  difference() {
    union() {
      ring(pillHoles,360/pillHoles,c_or) cylinder(r=pr+0.5+t,h=ph);
      ring(pillHoles,360/pillHoles,c_ir) cylinder(r=spr+0.5+t,h=ph);

      intersection() {
        hexGrid(hexR,4,t,15,13,[],[]);
        cylinder(r=c_or,h=10);
      }
    }
    translate([0,0,-1]) ring(pillHoles,360/pillHoles,c_or) cylinder(r=pr+0.5,h=ph+2);
    translate([0,0,-1]) ring(pillHoles,360/pillHoles,c_ir) cylinder(r=spr+0.5,h=ph+2);
  }
}


module bearingPost() translate([0,0,3.8]) intersection() {
  union() {
    cylinder(r=4,h=8);
    translate([0,0,8]) cylinder(r=5,h=0.8);

    translate([0,0,8.8]) cylinder(r=hexCircumradius(hexR-t),h=5,$fn=6);
  }
  translate([-50,0.1,0]) cube([100,100,100]);
}

module bearingHole() {
  difference() {
    cylinder(r=bearingOuterR+5,h=8);
    translate([0,0,-1]) cylinder(r=bearingOuterR+0.75,h=10);
  }
  ring(7,45,bearingOuterR+0.75) cylinder(r=1,h=8);
}

module motorMount() {
  difference() {
    cylinder(r=22,h=8);
    
    translate([-9,-3,-0.5]) cube([18,20,10]);
    translate([-4,-3,4.5]) cube([8,25,10]);
    translate([35/2,0,0]) screwHole();
    translate([-35/2,0,0]) screwHole();
    translate([0,0,-0.5]) cylinder(r=14.5,h=10);
  }
 
}

module screwHole() {
  translate([0,0,-0.5]) {
    cylinder(r=2,h=10);
    rotate([0,0,90]) cylinder(r=3.1,h=3,$fn=6);
  }
}