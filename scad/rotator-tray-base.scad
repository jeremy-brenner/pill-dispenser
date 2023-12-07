module rotatorTrayBase(r,h,sections,centerHoleR,skipOne=1,top=false,bottom=false) {
  dAngle=360/sections;
  difference() {
    union() {
      cylinder(r=r+2,h=h);
      for ( i = [0 : sections-1] ){
        rotate([0, 0, i*dAngle])
          translate([r+2,0,0]) {
            cylinder(r=4,h=h);
            translate([-4,-4,0]) cube([4,8,h]);
            if(i != skipOne){
              cylinder(r=1.8,h=h+2);
              if(top) {
                translate([0,0,h]) sphere(r=4);
              }else{
                translate([0,0,h+2]) sphere(r=1.8);
              }
            
            }
          }
      }
    }

    translate([0,0,2]) cylinder(r=r-2,h=h);
    translate([0,0,-1]) {
      cylinder(r=centerHoleR,h=4);
  
      if(!bottom) {
        for ( i = [0 : sections-1] ){
          if(i != 0 || skipOne == false) {
            rotate([0, 0, i*dAngle])
            translate([r+2,0,0]) cylinder(r=2.2,h=6);
          }
        }
      }
    }
  }
}
