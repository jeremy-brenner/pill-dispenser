
lw=0.4;
mt=lw*4;

//bracketTest();
//translate([10,-2,mt*2+6]) rotate([-90,0,0]) 
buttonCap();


module bracketTest() {
  difference() {
    cube([20,mt*2,18]);
    translate([10,-0.1,mt*2+6]) rotate([-90,0,0]) cylinder(r=3.75,h=5,$fn=32);
  }
  cube([20,18,mt*2]);
  translate([0,mt*2,mt*2]) buttonBracket();
}

module buttonBracket() {
  difference() {
    union() {
      translate([5,7,0]) cube([10,3,12]);
      translate([4,0,0]) cube([12,3,12]);
      translate([2,0,0]) cube([2,5,12]);
      translate([16,0,0]) cube([2,5,12]);

    }
    translate([10,-0.1,6]) rotate([-90,0,0]) union() {
      cylinder(r=3.75,h=5,$fn=32);
      translate([-3.75,-8,0]) cube([7.5,8,4]);
    }
  }
}

module buttonCap() {
  //translate([-6,-6,0]) cube([12,12,1.5]);
  cylinder(r=3.5,h=mt*2+0.5,$fn=32);
  translate([0,0,mt*2+0.5]) {
    flange();
    rotate([0,0,90]) flange();
    rotate([0,0,180]) flange();
    rotate([0,0,270]) flange();

  }
}

module flange() {
  fDist=3.9;
  translate([fDist/2,-3.5/2,0]) {
    translate([0.1,0,2.55]) rotate([-90,0,0]) cylinder(r=0.4,h=3.5,$fn=32);
    cube([1,3.5,3.2]);
  }
}