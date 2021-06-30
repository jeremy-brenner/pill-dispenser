

use <./hex-grid.scad>;
use <./involute_gears.scad>;
use <./board-mount.scad>;
use <./motor.scad>;

carouselCap=true;
motorGear=true;
carouselMotor=true;
bigGear=true;
carousel=true;
bearingPost=true;
boardMount1=true;
boardMount2=true;
mountRing=true;
mainMount=true;
bottomLayer=true;
case=true;

/* [Hidden] */

$fn=32;

lw=0.4;
t=lw*2;

teethPerPill=3;
pillsPerRotation=8;

pr=3.5;
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

if(carouselCap) {
  translate([0,0,35]) rotate([180,0,0]) carouselCap();
}

if(motorGear) {
  motorPosition() translate([8,0,13.25]) motorGear();
}

if(carouselMotor) {
  motorPosition() translate([0,0,-10]) rotate([0,0,90]) motor();
}

translate([0,0,12]) {
  if(carousel) {
    translate([0,0,21]) rotate([180,0,0]) carousel();
  }
  if(bigGear) {
    bigGear();
  }
}

if(bearingPost) {
  bearingPost();
}

translate([0,19.3,14]) rotate([0,180,0]) rotate([90,0,0]) {
  if(boardMount1) {
    boardMount(9,0,false);
  }
  if(boardMount2) {
    translate([0,5,40]) rotate([180,0,0]) boardMount(0,10,true);
  }
}

if(mountRing) {
  translate([0,0,8.25]) mountRing();  
}

if(mainMount) {
  mainMount();
}

if(bottomLayer) {
  translate([0,0,-14.75]) bottomLayer();
}

if(case) {
  translate([0,0,-16.25]) case();
}

module case() {
  mh=60;
  mr=63;
  mt=lw*4;
  r=pr+0.5+t*2.6;
  difference() {
    union() {
      cylinder(r=mr+mt,h=mh);
      translate([0,-(mr+mt),0]) cube([mr+30+mt,(mr+mt)*2, mh]);
    }
    translate([0,0,mt]) cylinder(r=mr,h=mh);
    translate([-mr+3,0,r+mt]) rotate([0,-90,0]) cylinder(r=r,h=10);
    translate([0,-mr,mt]) cube([mr+30,mr*2, mh]);
  }
  
  translate([0,0,mt]) cylinder(r=9.5,h=4,$fn=6);

  translate([-61-mt,-15,0]) difference() {
    cube([mt,30,16+mt]);
    translate([3,15,r+mt]) rotate([0,-90,0]) cylinder(r=r,h=10);
  }
  translate([-57-mt,0,0]) tray();
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
  translate([0,0,1.5]) rotate([0,0,45]) ring(4,90,52) {
    cylinder(r=3,h=13);
    translate([0,0,13]) cylinder(r=1.8,h=3.8);
  }
  difference() {
    union() {
      translate([-60.5,0,14.5]) rotate([90,0,0]) intersection() {
        difference() {
          torus(8.5,pr+0.5+t*2.5);
          translate([0,0,-50]) cylinder(h=100,r=8.5);
        }
        translate([0,-100,-50]) cube([100,100,100]);
      }
      track(3);
      intersection() {
        hexGrid(10,3,t*2,11,11,[],[]);
        translate([0,0,-1]) cylinder(r=55.5,h=10.5);
      }
    }
    translate([-60.5,0,14.5]) rotate([90,0,0]) torus(8.5,pr+0.5+t*1.5);
  }
 
}

module track(h) {
  difference() {
    cylinder(r=55.5,h=h);
    translate([0,0,-0.5]) cylinder(r=49,h=h+1);
  } 
}

module mountRing() {
  difference() {
    union() {
      track(3.5);
      translate([-52,0,0]) cylinder(r=pr+0.5+t*2,h=3.5);
    }
    translate([-52,0,-0.5]) cylinder(r=pr+0.5+t,h=9);
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
  difference() { 
    union() {
      intersection() {
        translate([0,0,4]) hexGrid(5.35,4,t,13,11,skipCells,[]);
        cylinder(r=55.5,h=10.5);
      }
      translate([-52,0,0]) cylinder(r=pr+0.5+t*2,h=8);
      track(8);
    }
    translate([0,0,-1]) cylinder(r=bearingOuterR+4,h=10);
    motorPosition() translate([0,0,-1]) cylinder(r=22,h=11);
    translate([-52,0,-0.5]) cylinder(r=pr+0.5+t,h=9);
    translate([0,0,-0.5]) rotate([0,0,45]) ring(4,90,52) cylinder(r=2,h=9);
  }

  bearingHole();

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
    translate([0,0,-1]) cylinder(r=52,h=10);
    translate([0,0,-1]) ring(pillHoles,360/pillHoles,52) cylinder(r=pr+0.6+t,h=ph+2);
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
      ring(pillHoles,360/pillHoles,52) cylinder(r=pr+0.5+t,h=ph);

      intersection() {
        hexGrid(hexR,4,t,15,13,[],[]);
        cylinder(r=52,h=10);
      }
    }
    translate([0,0,-1]) ring(pillHoles,360/pillHoles,52) cylinder(r=pr+0.5,h=ph+2);
  }
}


module bearingPost() intersection() {
  union() {
    cylinder(r=4,h=8);
    translate([0,0,8]) cylinder(r=5,h=21);

    translate([0,0,29]) cylinder(r=hexCircumradius(hexR-t),h=5,$fn=6);
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