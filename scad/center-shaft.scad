
module centerShaft(h,r,bottomHole=true) {
  t=2;
  difference() {
    union() {
      cylinder(r=r,h);
      translate([0,0,h]) cylinder(r1=r-t-0.3, r2=r-t-0.7, h=7.5, $fn=6);
    }
    if(bottomHole) { 
      translate([0,0,-0.01]) difference() {
        cylinder(r1=r-t, r2=r-t-0.5, h=8, $fn=6);
        translate([0,-1,0]) cube([100,2,8]);
      }
    }
    translate([0,0,-1]) cylinder(r=sqrt(3)*(r-t*2-0.7)/2,h=h+8+2);
    translate([0,-1.5,h]) cube([100,3,8]);
  }
  
}

