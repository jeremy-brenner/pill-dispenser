
module pill() {
  r=3.25;
  l=17.75;
  hull() {
    sphere(r);
    translate([0,0,l-r*2]) sphere(r);
  }
}
