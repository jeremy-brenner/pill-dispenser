

boardMount(9,0,false);
boardMount(0,10,true);

module boardMount(ht,bb,usbHole) {
  w1=26;
  t1=1.20;
 
  w2=32.5;
  t2=1.65;
 
  d=12;

  m=w1+5+d/2;
  
  hr=5.1;


  

  translate([-m,0,0]) {
    boardStand(w1,t1,bb,usbHole);
    translate([w1+4+d,0,0]) boardStand(w2,t2);
    translate([w1+4,0,1]) cube([d,5,8.5]);
  }
    


  translate([17.15,ht,hr*sqrt(3)/2+1]) rotate([90,0,0]) intersection() {
    cylinder(r=hr,h=4,$fn=6);
    translate([-hr,-hr+0.69,0]) cube([hr*2,2,4]);
  }
  translate([-17.15,ht,hr*sqrt(3)/2+1]) rotate([90,0,0]) intersection() {
    cylinder(r=hr,h=4,$fn=6);
    translate([-hr,-hr+0.69,0]) cube([hr*2,2,4]);
  }
}


module boardStand(bw,bt,bb=0,usbHole=false) {
  difference() {
    translate([0,0,1]) union() {
      cube([bw+4,5,2]);
      cube([4.5,5,8.5]);
      cube([2,5,19]);
      translate([bw-0.5,0,0]) cube([4.5,5,8.5]);
      translate([bw+2,0,0]) cube([2,5,19]);
    }
    translate([2,(5-bt)/2,3]) cube([bw,bt+bb,20]);
    if(usbHole) {
      translate([bw/2-3,2.5,-1]) cube([10,3.5,20]);
    }
   translate([4,0,-2]) rotate([0,-135,0]) translate([0,-1,0]) cube([10,20,10]);
      translate([bw+14,0,-2]) rotate([0,-135,0]) translate([0,-1,0]) cube([10,20,10]);

  }
}
