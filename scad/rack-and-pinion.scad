use <./gears.scad>


Module = 0.8;
teeth=12;


rack_length = 13.8;
rack_height=3.5;
bore=5.5;
width=5;
final_hub_thickness=0;
final_hub_diameter=0;
pressure_angle=20;
finalHelixAngle=0;
assembled=true;
optimized=false;

$fn=64;
pinion();

// rack();

module rack() {
  translate([0,rack_height,0]) zahnstange(modul=Module, laenge=rack_length, hoehe=rack_height, breite=width, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle);
}  




module pinion() {
  stirnrad (modul=Module, zahnzahl=teeth, breite=width, bohrung=bore, nabendurchmesser=final_hub_diameter, nabendicke=final_hub_thickness, eingriffswinkel=pressure_angle, schraegungswinkel=finalHelixAngle, optimiert=optimized);
  difference() {
    cylinder(r=3,h=4.5);
    cylinder(r=1.25,h=6);
    translate([0,0,3.5]) cylinder(r=2.75,h=1.6);
    translate([0,0,-0.1]) cylinder(r=2.1,h=2.6);
    a=24;
    for ( i = [0 : 360/a-1] ){
      rotate([0,0,i*a]) translate([0,2,0]) rotate([0,0,45]) translate([-0.75/2,-0.75/2,-0.1]) cube([0.75,0.75,2.6]);
    }
  }  
}