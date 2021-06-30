$fn=32;

motor();

module motor() {
  color("silver") mainMotorBody();
 
  color("#4287f5") plasticPart(); 
  translate([0,-8,19.5]) {
    color("white") cylinder(r=4.5,h=1.75);
    translate([0,0,1.75]) motorPeg();
  }

  translate([0,17,17.5]) rotate([-90,0,0]) cables();
}

module mainMotorBody(bh=19.5) {
  cylinder(r=14,h=bh); 
  translate([-15/2,17-6,5]) cube([15,5,bh-5]); 
  translate([0,0,bh-1]) screwBar();
}

module plasticPart() {
  difference() {
    translate([-17/2,17-6,2.5]) cube([17,6,17.1]); 
    translate([0,0,-1]) mainMotorBody(30);
  }
}

module cables() {
  colors = ["yellow", "orange", "red", "pink", "blue"];
  cr=0.5;
  translate([len(colors)*-cr,0,0]) {
    for (i = [ 0 : len(colors) - 1 ]) {
      translate([i*cr*2+cr,0,0]) color(colors[i]) cylinder(r=cr,h=5);
    }   
  }
}

module screwBar() {
  translate([-35/2,0,0]) difference() {
    union() {
      cylinder(r=3.5,h=1);
      translate([0,-7/2,0]) cube([35,7,1]);
      translate([35,0,0]) cylinder(r=3.5,h=1);
    }
    translate([0,0,-0.5]) cylinder(r=2,h=2);
    translate([35,0,-0.5]) cylinder(r=2,h=2);
  }
}

module motorPeg() {
  intersection() {
    cylinder(r=2.5,h=8);
    translate([-2.5,-1.5,0]) cube([5,3,8]);
  }
  cylinder(r=2.5,h=2);
}