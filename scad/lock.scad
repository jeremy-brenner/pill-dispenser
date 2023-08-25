
module lock() {
  l=30;
  difference() {
    hull() {
      cube([7.5,l,5]);
      translate([2.5,l,2.5]) sphere(r=2.5);
      translate([5,l,2.5]) sphere(r=2.5);
    }  
    translate([-0.1,2,-0.1]) cube([4.1,7.5,7.5]);
  }
  cube([7.5,2,8]);
  translate([0,9.5,0]) cube([7.5,2,8]);
}

