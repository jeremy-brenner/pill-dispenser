use <./pill.scad>;

$fn=32;



chuteHole(4.4,8);



module pillChute(cr,dist) {
  difference() {
    chuteBlock(cr);
    chuteHole(cr,dist);
  }

}

module chuteBlock(cr) {
  translate([0,(cr*2+4)/-2,-25]) cube([15,cr*2+4,32.75]);
  translate([0,0,-25]) cylinder(r=cr+2,h=32.75);
}


module chuteHole(cr,dist) {
  pillBend(cr,20);
  translate([dist,0,0]) pillBend(cr,24,4);

  cylinder(r=cr,h=10);
  translate([dist,0,0]) cylinder(r=cr,h=10);
  
  translate([19.9,0,-20]) rotate([0,90,0]) cylinder(r=cr,h=5);
  
}

module pillBend(cr,o,s=0) {
  steps = 10;
  a = 90;
  translate([o,0,0]) for ( ia = [0 : steps-1-s]) {
    ib=ia+1;
    hull() {  
      rotate([0,-a/steps*ia,0]) translate([-o,0,0]) cylinder(r=cr,h=0.1); //sphere(r=cr);
      rotate([0,-a/steps*ib,0]) translate([-o,0,0]) cylinder(r=cr,h=0.1); //sphere(r=cr);
    }
  }
}
