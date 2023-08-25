module lockPole(r,h,half=true,topInterlock=false,bottomInterlock=false,bottomLock=false) {
  difference() {
    cylinder(r=r,h=h);
    if(topInterlock) {
      translate([0,0,h-10]) difference() {
        cylinder(r=r+1,h=11);
        difference() {
          translate([0,0,-1]) cylinder(r=r-2.7,h=13);
          translate([-r,r-5.6,0]) cube([r*2,3,5.8]);
          translate([-r,-r+2.6,0]) cube([r*2,3,5.8]);
        }
      }
    }
    if(bottomInterlock) {
      translate([0,0,-1]) difference() {
        cylinder(r=r-2.4,h=11);
        translate([-r,r-5.4,0]) cube([r*2,3,5.8]);
        translate([-r,-r+2.4,0]) cube([r*2,3,5.8]);
      }
    }else{ 
      translate([5,-r,-0.1]) cube([r,r*2,14.1]);
      mirror([1,0,0]) translate([5,-r,-0.1]) cube([r,r*2,14.1]);
      translate([-r,-4,3.5]) cube([r*2,8,6]);
    }
    if(half) {
      translate([0,-r,-1]) cube([r,r*2,h+2]);
    }
  }
}