


module hexGrid(hexInradius,height,supportThickness,xLen,yLen,skipCells,cappedCells,color) {

  center=true;

  xu = hexCircumradius(hexInradius-supportThickness/2)*1.5;
  yu = hexInradius*2-supportThickness;
  eu = hexInradius-supportThickness/2;
 
  xdist = center ? -xu*xLen/2+xu/2 : 0;
  ydist = center ? -yu*yLen/2 : 0;

  translate([xdist,ydist,0]) {
    for ( ix = [0 : xLen-1] ){ 
      even=ix%2;
      x = xu*ix; 
      for ( iy = [0 : yLen-even] ){ 
        y = yu*iy+eu*even;

        shouldSkip = skipCells[search([[ix,iy]], skipCells)[0]] != undef;
        shouldCap = cappedCells[search([[ix,iy]], cappedCells)[0]] != undef;
        
        if(!shouldSkip) {
          color(color, shouldSkip ? 0.1 : 1) translate([x,y,0]) hex(hexInradius,supportThickness,height,shouldCap);
        }
      }
    }
  }
}

module hex(hexInradius,supportThickness,height,shouldCap) {
  zMove = shouldCap ? 1.6 : -1;
  difference() {
    cylinder(r=hexCircumradius(hexInradius),h=height,$fn=6);
    translate([0,0,zMove]) cylinder(r=hexCircumradius(hexInradius-supportThickness),h=height+2,$fn=6);
  }
}

module label(x,y,ix,iy,hexInradius) {
  translate([x,y,0]) rotate([$vpr[0],$vpr[2],$vpr[1]]) text(text = str("[",ix,",",iy,"]"), size = hexInradius/3, halign = "center", valign = "center");
}

function hexCircumradius(hexInradius) = hexInradius/sqrt(3)*2;