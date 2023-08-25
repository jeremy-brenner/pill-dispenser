use <./rotator-tray-base.scad>;

module rotatorTraySingles(r,h,centerHoleR,sections,pr,rowDistances,angle,skipOne=1) {
  difference() {
    rotatorTrayBase(r,h,sections,centerHoleR,skipOne);
    translate([0,0,-1]) rotate([0,0,angle]) pillHole(pr+0.4,rowDistances,4);    
  }
}

module pillHole(r,rowDistances,h) {
  hull() {
    translate([min(rowDistances),0,0]) cylinder(r=r,h=h);
    translate([max(rowDistances),0,0]) cylinder(r=r,h=h);
  }
}