
module taperedCube(w,h,a) {
  difference() {
    translate([-w/2,-w/2,0]) cube([w,w,h]);
    translate([w/2,-w/2,0]) rotate([0,a,0]) cube([w,w,h+1]);
    rotate([0,0,90]) translate([w/2,-w/2,0]) rotate([0,a,0]) cube([w,w,h+1]);
    rotate([0,0,180]) translate([w/2,-w/2,0]) rotate([0,a,0]) cube([w,w,h+1]);
    rotate([0,0,270]) translate([w/2,-w/2,0]) rotate([0,a,0]) cube([w,w,h+1]);
  }
}