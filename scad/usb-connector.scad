bottom();
// translate([0,0,6.1]) mirror([0,0,1]) top();

// top();

translate([-1,0,1.5]) rotate([0,-90,0]) top();

module bottom() {
  difference() {
    cube([13,12.5,4.5]);
    translate([-0.1,1,1.5]) cube([2.6,10.5,3.1]);
    translate([2.4,1.75,1.5]) cube([3.7,9,3.1]);
    translate([6,2.5,1.5]) cube([10,7.5,3.1]);
    translate([8.9,2.5,0.75]) cube([1.1,2,0.76]);
    translate([8.9,8,0.75]) cube([1.1,2,0.76]);
    translate([4.25,3,0.5]) cube([4,6.5,1.76]);

    translate([3.5,-0.1,-0.1]) {
      cube([6,1.1,5]);
      cube([6,2.1,1.1]);
    }
    translate([3.5,12.6,-0.1]) mirror([0,1,0]) {
      cube([6,1.1,5]);
      cube([6,2.1,1.1]);
    }
  }
}

module top() {
  difference() {
    translate([-1.5,0,0]) {
      cube([14.5,12.5,1.5]);
      translate([1.25,2,0]) cube([2.5,8.5,2.25]);
      cube([1.25,12.5,3]);
      translate([5.25,0,0]) clip();
      translate([5.25,12.5,0]) mirror([0,1,0]) clip();
    }
    translate([8.9,4.5,0.75]) cube([1.1,3.5,0.76]);
    translate([4.25,2,0.5]) cube([4,8.5,1.76]);
  }
}

module clip() {
  translate([0,-0.25,0]) cube([5.5,1,6.75]);
  translate([5.5,0.75,5.25]) rotate([0,-90,0]) linear_extrude(height = 5.5 ) polygon(points=[[0,0],[1.5,0],[0,1]]);
}
