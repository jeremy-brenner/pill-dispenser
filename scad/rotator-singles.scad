use <./center-shaft.scad>;

module rotatorSingles(pillsPerRow,rowDistances,pr,h,t,ir) {
  difference() {
    union() {
      rotatorCylinders(pillsPerRow,rowDistances,pr+t,h);
      cylinder(r=max(rowDistances)+pr+t,h=t);
    }
    translate([0,0,-0.1]) {
      cylinder(r=ir,h=4);
      rotatorCylinders(pillsPerRow,rowDistances,pr,h+0.2,true);
    }
  }

  centerShaft(h+3,ir);
}

module rotatorCylinders(pillsPerRow,rowDistances,r,h,bevel=false) {
  angle = 360/pillsPerRow;
  for ( distIdx = [ 0 : len(rowDistances) - 1 ] ) {
    dist = rowDistances[distIdx];
    mod = distIdx%2 * 0.5;

    for ( i = [0 : pillsPerRow-1] )
      rotate([0, 0, (i+mod)*angle])
      translate([dist,0,0]) {
        cylinder(r=r,h=h);
        if(bevel) {
          cylinder(r1=r+0.4, r2=r, h=2);
          translate([0,0,h-2]) cylinder(r1=r, r2=r+0.4, h=2);
        }
      }
  }
}