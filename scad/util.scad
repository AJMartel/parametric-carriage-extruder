include <config.scad>;

function accurate_diam(diam,sides=16) = 1 / cos(180 / sides) * diam;

module hole(diam,height,sides=16) {
  diam = accurate_diam(diam,sides);

  cylinder(r=diam/2,h=height,center=true,$fn=sides);
}

module motor() {
  module body() {
    translate([0,0,-motor_len/2]) {
      cube([motor_side,motor_side,motor_len],center=true);

      // shaft
      translate([0,0,motor_len/2+motor_shaft_len/2+motor_shoulder_height])
        cylinder(r=5/2,h=motor_shaft_len,center=true,$fn=16);

      // shoulder
      translate([0,0,motor_len/2+motor_shoulder_height/2])
        cylinder(r=motor_shoulder_diam/2,h=motor_shoulder_height,center=true); // shoulder

      // short shaft
      translate([0,0,-motor_len/2-motor_short_shaft_len/2])
        cylinder(r=5/2,h=motor_short_shaft_len,center=true);
    }
  }

  module holes() {
    // mount holes
    for (side=[left,right]) {
      for(end=[top, bottom]) {
        translate([motor_hole_spacing/2*side,motor_hole_spacing/2*end,0]) {
          hole(3,motor_len*3,12);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}

module hotend() {
  module body() {
    height_groove_and_above = hotend_clamped_height;
    height_below_groove = hotend_length - height_groove_and_above;

    translate([0,0,-hotend_height_above_groove/2]) {
      hole(hotend_diam,hotend_height_above_groove,90);
    }
    translate([0,0,-hotend_height_above_groove-hotend_groove_height/2]) {
      hole(hotend_groove_diam,hotend_groove_height,90);
    }
    translate([0,0,-height_groove_and_above-height_below_groove/2]) {
      hole(hotend_diam,height_below_groove,90);
    }
  }

  module holes() {
    hole(filament_diam,hotend_length*3,8);
  }

  difference() {
    body();
    holes();
  }
}

module hotend_hole() {
  hotend_clearance = 0.15;

  hotend_res = resolution/2;

  above_height = hotend_height_above_groove+hotend_clearance*2;

  rotate([0,0,180/hotend_res]) {
    translate([0,0,-hotend_clamp_height]) {
      hole(hotend_groove_diam+hotend_clearance,hotend_clamp_height*2,hotend_res);
    }

    translate([0,0,-above_height/2+hotend_clearance]) {
      hole(hotend_diam+hotend_clearance,above_height,hotend_res);
    }

    translate([0,0,-hotend_clamped_height-10+hotend_clearance]) {
      hole(hotend_diam,20,hotend_res);
    }

    hole(filament_diam+1,200,hotend_res);
  }
}
