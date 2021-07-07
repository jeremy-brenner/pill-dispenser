

module arduinoBoardMount() {
  boardMount(26,1.2);
}

module stepperBoardMount() {
  boardMount(32.5,1.65);
}

module boardMount(bw,bt,bb=0,usbHole=false) {
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
  }
}
