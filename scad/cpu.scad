cpu(); 

module cpu() {
  color("teal") cube([26,35,1.25]);
  color("black") translate([5,0,1.25]) cube([16,24,0.75]);
  color("silver") translate([7,7.5,2]) cube([12,15,2.5]);
  color("silver") translate([(26-7.75)/2,35-5.7,-2.6]) cube([7.75,5.7,2.6]);


  translate([0,6.4,-2.6]) pins();
  translate([26-2.6,6.4,-2.6]) pins();
}

module pins() {
  d=17.5/7;
  o=(2.6-0.65)/2;
  color("silver") 
  for( i = [ 0: 7]) {
    translate([o,i*d+o,-5.8]) cube([0.65,0.65,11.5]);
  }
  color("black") translate([0,0,0]) cube([2.6,20,2.6]);
}