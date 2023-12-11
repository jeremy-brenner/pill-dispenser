
module lock() {
  l=30;
  t=5.5;
  w=7.5;
  difference() {
    hull() {
      cube([w,l,t]);
      translate([t/2,l,t/2]) sphere(r=t/2);
      translate([w-t/2,l,t/2]) sphere(r=t/2);
    }  
    translate([3,2,-0.1]) cube([4.6,7.5,7.5]);
  }
  cube([7.5,2,8]);
  translate([0,9.5,0]) cube([7.5,2,8]);
}

