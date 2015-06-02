include <util.scad>
include <config.scad>

geared_stepper_mount_diam      = 36;
geared_stepper_mount_height    = 26;
geared_stepper_shoulder_diam   = 22;
geared_stepper_shoulder_height = 2;
geared_stepper_screw_spacing   = 28;
geared_stepper_screw_diam      = 3;
geared_stepper_shaft_diam      = 8;
geared_stepper_shaft_len       = 20;
geared_stepper_body_side       = 42;
geared_stepper_body_len        = 34;

idler_shaft_support   = 4;

filament_opening = filament_diam + 0.5;

plate_thickness = motor_shoulder_height;
plate_thickness = 4;
filament_pos_x  = (hobbed_effective_diam/2+filament_compressed_diam/2)*left;
filament_pos_y  = 0;
filament_pos_z  = 0;
idler_nut_pos_z = motor_shoulder_height + extrusion_height + idler_nut_thickness/2;
idler_pos_x     = filament_pos_x - (filament_compressed_diam/2+idler_bearing_outer/2);
idler_pos_z     = idler_nut_pos_z + idler_nut_thickness/2 + idler_shaft_support + idler_bearing_height/2;

hinge_space_width = 1.5;
hinge_space_pos_x = filament_pos_x - filament_opening/2 - extrusion_width*2 - hinge_space_width/2;
hinge_pos_y       = - motor_hole_spacing/2;

hotend_pos_y      = -motor_hole_spacing/2-motor_screw_head_diam/2;

idler_screw_pos_y = motor_side/2-wall_thickness-m3_nut_diam/2;
idler_washer_thickness = 1;

echo("Idler screw length at least ", idler_shaft_support*2 + 1 + idler_bearing_height + 3);

groove_mount_wings = true;
groove_mount_wings = false;
groove_mount_wings_hole_spacing = 50;
groove_mount_wings_hole_diam    = 4.1;
groove_mount_wings_nut_diam     = 4.1;
groove_mount_wings_thickness    = 8;
groove_mount_wings_thickness    = (motor_side-motor_shoulder_diam)/2;

bowden_nut_diam      = 11;
bowden_nut_thickness = 5;
bowden_tubing_diam   = 6; // 0.25inch threaded diam

module geared_stepper_motor() {
  module body() {
    translate([0,0,-geared_stepper_mount_height/2]) {
      hole(geared_stepper_mount_diam,    geared_stepper_mount_height,    resolution);
    }
    hole(geared_stepper_shoulder_diam, geared_stepper_shoulder_height*2, resolution);
    hole(geared_stepper_shaft_diam,geared_stepper_shaft_len*2);

    translate([0,0,-geared_stepper_mount_height-geared_stepper_body_len/2]) {
      cube([geared_stepper_body_side,geared_stepper_body_side,geared_stepper_body_len],center=true);
    }
  }

  module holes() {
    for(r=[0,1,2,3]) {
      rotate([0,0,45+r*90]) {
        translate([geared_stepper_screw_spacing/2,0,0]) {
          hole(geared_stepper_screw_diam,100);
        }
      }
    }
  }

  difference() {
    body();
    holes();
  }
}


module geared_direct_drive() {
  body_wall_thickness       = geared_stepper_screw_diam/2 + extrusion_width*6;
  body_diam                 = geared_stepper_screw_spacing + body_wall_thickness*2;
  height                    = geared_stepper_shaft_len;
  idler_bolt_head_thickness = 3;

  hobbed_outer   = 12.7;
  hobbed_opening = hobbed_outer + 1;
  hobbed_diam    = 11.4;
  hobbed_height  = 13.1;

  filament_x     = hobbed_diam/2 + filament_diam/2;
  filament_z     = height - 1 - filament_opening/2;

  idler_pos_x    = hobbed_diam/2 + filament_diam + idler_bearing_outer/2;
  idler_pos_z    = filament_z - filament_opening/2 - 1.25 + idler_bearing_height/2;

  idler_screw_diam      = 3.1;
  idler_screw_pos_y     = body_diam/2 + idler_screw_diam/2 + 1;
  idler_screw_pos_z     = filament_z - filament_opening/2 - extrusion_height - m3_diam;
  idler_screw_body_diam = 9;
  idler_screw_body_len  = idler_pos_x + idler_bearing_outer/2-1;

  idler_gap_width       = 2;
  idler_gap_x           = filament_x + filament_diam/2 + extrusion_width*2 + idler_gap_width/2;
  idler_gap_x           = idler_pos_x - idler_bearing_inner/2 - 3 - idler_gap_width/2;

  idler_hinge_thickness = 2;
  idler_hinge_pos_x     = idler_pos_x-idler_bearing_inner/2-idler_gap_width/2;

  bowden_tubing_diam          = 6.5;
  bowden_retainer_inner       = 11; // FIXME:  not correct -- it needs to include diameter of retainer with PTFE in it
  bowden_retainer_body_diam   = bowden_retainer_inner + 4;
  bowden_retainer_body_height = 8;
  bowden_retainer_pos_y       = idler_screw_pos_y + idler_screw_body_diam/2 + bowden_retainer_body_height/2;

  rotate([0,0,45]) {
    //% geared_stepper_motor();
  }

  translate([idler_pos_x,0,idler_pos_z]) {
    % hole(idler_bearing_outer, idler_bearing_height, resolution);
  }

  translate([0,0,height-hobbed_height/2+0.05]) {
    % hole(hobbed_outer,hobbed_height,resolution);
  }

  module body() {
    rounded_rotation = 30;
    rounded_diam = body_diam/2 - hobbed_opening/2;
    intersection() {
      translate([0,0,height/2]) {
        hull() {
          hole(body_diam,height, resolution);

          translate([idler_pos_x,0,0]) {
            hole(idler_bearing_outer-2, height, resolution);
          }

          translate([idler_pos_x,geared_stepper_screw_spacing/2,0]) {
            hole(body_wall_thickness*2,height,resolution);
          }
          translate([idler_hinge_pos_x,-body_diam/2+idler_hinge_thickness+idler_gap_width/2,0]) {
            hole(idler_hinge_thickness*2+idler_gap_width,height,resolution);
          }
        }
      }

      union() {
        cube([100,100,(height-hobbed_height)*2],center=true);
        for(y=[front,rear]) {
          rotate([0,0,rounded_rotation*y]) {
            translate([50,0,0]) {
              cube([100,100,height*3],center=true);
            }
          }
        }
      }
    }

    for(y=[front,rear]) {
      rotate([0,0,rounded_rotation*y]) {
        translate([0,(body_diam/2-rounded_diam/2)*y,height/2]) {
          hole(rounded_diam,height,resolution);
        }
      }
    }
    hull() {
      translate([idler_screw_body_len/2,idler_screw_pos_y,idler_screw_pos_z]) {
        rotate([0,90,0]) {
          hole(idler_screw_body_diam,idler_screw_body_len,resolution);
        }
      }
      for(x=[idler_pos_x,body_wall_thickness]) {
        translate([x,geared_stepper_screw_spacing/2*y,height/2]) {
          hole(body_wall_thickness*2,height,resolution);
        }
      }
      translate([idler_pos_x,0,height/2]) {
        hole(idler_bearing_outer-2, height, resolution);
      }

      translate([filament_x,idler_screw_pos_y+8,filament_z]) {
        rotate([90,0,0]) {
          //hole(bowden_retainer_body_diam,8,resolution);
        }
      }
    }

    /*
    difference() {
      translate([0,0,40]) {
        hole(bowden_retainer_body_diam,8,resolution);
      }
      # translate([0,0,35]) {
        translate([0,0,10]) {
          hole(8,20);
        }

        hull() {
          translate([0,0,2]) {
            hole(bowden_retainer_inner,4);
          }
          translate([0,0,7]) {
            translate([0,0,-1]) {
              hole(8,2);
            }
          }
        }
      }
    }
    */

    hull() {
      translate([filament_x,0,0]) {
        translate([0,idler_screw_pos_y,idler_screw_pos_z]) {
          rotate([0,90,0]) {
            hole(idler_screw_body_diam,bowden_retainer_body_diam,resolution);
          }
        }
        translate([0,0,filament_z]) {
          rotate([90,0,0]) {
            hole(filament_opening+2,1,resolution);
          }
        }
        translate([0,bowden_retainer_pos_y,filament_z]) {
          rotate([90,0,0]) {
            hole(bowden_retainer_body_diam,bowden_retainer_body_height,resolution);
          }
        }
        translate([0,body_diam/2+1,filament_z]) {
          rotate([90,0,0]) {
            hole(bowden_retainer_body_diam,2,resolution);
          }
        }

        // bind to bottom plate
        translate([0,bowden_retainer_pos_y+bowden_retainer_body_height/2-bowden_retainer_body_diam/2-2,1]) {
          hole(bowden_retainer_body_diam,2,resolution);
        }
        translate([0,0,1]) {
          cube([bowden_retainer_body_diam-6,1,2],center=true);
        }
      }
    }
  }

  module holes() {
    for(r=[1,2,3]) {
      rotate([0,0,r*90]) {
        translate([geared_stepper_screw_spacing/2,0,height/2]) {
          hole(geared_stepper_screw_diam,height+1);

          translate([0,0,height]) {
            hole(7,height);
          }
        }
      }
    }

    // overhang the shoulder and main opening
    hull() {
      hole(geared_stepper_shoulder_diam,geared_stepper_shoulder_height*2,resolution);
      hole(hobbed_opening,(idler_pos_z-idler_bearing_height-1)*2,resolution);
    }
    hole(hobbed_opening,50,resolution);

    // filament path
    translate([filament_x,0,filament_z]) {
      rotate([90,0,0]) {
        % hole(filament_diam,60);
        hole(filament_diam+0.5,100,8);
      }
    }

    // bowden retainer cavity
    translate([filament_x,bowden_retainer_pos_y+bowden_retainer_body_height/2-8,filament_z]) {
      translate([0,0,bowden_retainer_body_diam/2]) {
        //cube([bowden_retainer_body_diam+1,100,bowden_retainer_body_diam],center=true);
      }
      rotate([-90,0,0]) {
        hole(bowden_tubing_diam,bowden_retainer_body_height*2.5,8);
        translate([0,0,10]) {
          hole(8,20);
        }

        hull() {
          translate([0,0,2]) {
            hole(bowden_retainer_inner,4);
          }
          translate([0,0,7]) {
            translate([0,0,-1]) {
              hole(8,2);
            }
          }
        }
      }
    }

    // idler gap
    translate([50,0,idler_pos_z+0.05+20]) {
      cube([100,12,idler_bearing_height+2+40],center=true);
    }

    // idler screw
    for(y=[0,-1]) {
      translate([0,idler_screw_pos_y+y,idler_screw_pos_z]) {
        translate([idler_screw_body_len,0,0]) {
          rotate([0,90,0]) {
            hole(idler_screw_diam,100,6);
            hole(m3_nut_diam,3,6);
          }
        }
        translate([-10,0,0]) {
          rotate([0,90,0]) {
            hole(6,20,6);
          }
        }
      }
    }

    translate([0,0,height+extrusion_height]) {
      hull() {
        translate([idler_gap_x,idler_bearing_inner/2+idler_gap_width/2,0]) {
          hole(idler_gap_width,height*2);
        }
        translate([idler_pos_x,idler_screw_pos_y+idler_screw_body_diam/2,0]) {
          hole(idler_gap_width,height*2);
        }
      }
    }
    translate([0,0,height/2+extrusion_height]) {
      hull() {
        translate([idler_gap_x,idler_bearing_inner/2+idler_gap_width/2,0]) {
          hole(idler_gap_width,height+1);
        }
        translate([idler_gap_x,-idler_bearing_inner/2-idler_gap_width/2,0]) {
          hole(idler_gap_width,height+1);
        }
      }
    }
    translate([0,0,height/2]) {
      hull() {
        translate([idler_gap_x,-idler_bearing_inner/2-idler_gap_width/2,0]) {
          hole(idler_gap_width,height+1);
        }
        translate([idler_hinge_pos_x,-body_diam/2+idler_hinge_thickness+idler_gap_width/2,0]) {
          hole(idler_gap_width,height+1);
        }
      }
    }
  }

  module idler_holes() {
    translate([idler_pos_x,0,0]) {
      hole(idler_bearing_inner, height*3, 12);
      hole(idler_nut_diam,idler_bolt_head_thickness*2,6);

      translate([0,0,idler_pos_z+0.05]) {
        hole(idler_bearing_outer+2,idler_bearing_height+2,resolution);
      }
    }
  }

  module bridges() {
    res = 12;
    translate([idler_pos_x,0,idler_pos_z-idler_bearing_height/2]) {
      difference() {
        hull() {
          translate([0,0,-1]) {
            hole(idler_bearing_inner+extrusion_width*4,2,res);
          }
          translate([0,0,-3]) {
            hole(idler_bearing_inner+extrusion_width*8,3,res);
          }
        }

        hole(idler_bearing_inner,30,res);
      }
    }

    translate([idler_pos_x,0,0]) {
      translate([0,0,idler_bolt_head_thickness+extrusion_height/2]) {
        hole(idler_bearing_inner+1,extrusion_height,6);
      }
      translate([0,0,idler_bolt_head_thickness/2]) {
        hole(idler_bearing_inner-1,idler_bolt_head_thickness);
      }
      translate([0,0,extrusion_height/2]) {
        hole(idler_nut_diam-2,extrusion_height);
      }
    }
  }

  difference() {
    body();
    holes();

    idler_holes();
  }

  bridges();
}

geared_direct_drive();
//assembly();
