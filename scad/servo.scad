bd=[22.5,12,22.3];
fd=[32.3,12,3];
bcr=bd[1]/2;
bch=4.3;
scr=2.87;

pr=2.45;
ph=3.25;

$fn=64;

servo();


module servo() {
  body();
  post();
  wires();
}

module body() {
  color("blue") {
    cube(bd);
    translate([(-fd[0]+bd[0])/2,0,bd[2]-fd[2]-4]) difference() {
      cube(fd);
      translate([2.5,fd[1]/2,-0.1]) cylinder(r=1.25,h=fd[2]+0.2);
      translate([-0.1,fd[1]/2-0.5,-0.1]) cube([2.5,1,fd[2]+0.2]);

      translate([fd[0]-2.5,fd[1]/2,-0.1]) cylinder(r=1.25,h=fd[2]+0.2);
      translate([fd[0]-2.4,fd[1]/2-0.5,-0.1]) cube([2.5,1,fd[2]+0.2]);

    }
    translate([bcr,bcr,bd[2]]) cylinder(r=bcr,h=bch);
    translate([12,bcr,bd[2]]) cylinder(r=scr,h=bch);
  }
}

module post() {
  color("white") translate([bcr,bcr,bd[2]+bch]) difference() {
    cylinder(r=pr,h=ph);
    translate([0,0,-0.1]) cylinder(r=0.875,h=ph+0.2);
  }
}

module wires() {
  translate([0,bd[1]/2,4]) rotate([0,-90,0]) {
    color("orange") translate([0,0.6*2,0]) cylinder(r=0.6,h=10);
    color("red") cylinder(r=0.6,h=10);
    color("brown") translate([0,-0.6*2,0]) cylinder(r=0.6,h=10);
  }
}