use <./rotator-tray-base.scad>;

module rotatorTray(r,h,centerHoleR,holeOr,holeIr,sections) {
  difference() {
    rotatorTrayBase(r,h,sections,centerHoleR);
    translate([0,0,-1]) pillHole(r,holeOr,holeIr,360/sections);
  }
}

module pillHole(r,holeOr,holeIr,dAngle) {
  intersection() {
    difference() {
      cylinder(r=holeOr-0.25,h=4);
      translate([0,0,-1]) cylinder(r=holeIr+0.25,h=6);
    }
    rotate([0,0,-dAngle/2]) translate([-r,4,0]) cube([r*2,r,4]);
    rotate([0,0,dAngle/2]) translate([-r,-r-4,0]) cube([r*2,r,4]);
  } 
}