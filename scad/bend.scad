
module bend(sl,r1,r2) {
  res=16;
  sliceSize=90/(res-1);
  cs=r2*2;
  hull() {
    translate([-1,-cs/2,-1]) cube([1,cs,1]);
    translate([-sl,0,0]) translate([-r1,0,-0.1]) cylinder(r=r2,h=0.1,$fn=32);
    translate([0,0,-sl]) rotate([0,-90,0]) translate([-r1,0,-0.1]) cylinder(r=r2,h=0.1,$fn=32);
    translate([-sl,0,-sl]) for ( i = [0 : res-1] ){
      rotate([0,sliceSize*-i,0]) translate([-r1,0,-0.1]) cylinder(r=r2,h=0.1,$fn=32);
    }
  }
}