include <config.scad>;

filament_x = hobbed_effective_diam/2 + filament_compressed_diam/2;
filament_y = filament_from_gears;

idler_screw_from_shaft = bearing_outer/2+idler_screw_nut_diam/2+2;
idler_x = filament_x + filament_compressed_diam/2 + idler_bearing_outer/2;
idler_y = filament_y;

// bearing helps provide clearance for motor mount screws
gear_side_bearing_y     = bearing_height/2-m3_socket_head_height+1;
carriage_side_bearing_y = filament_y + hobbed_depth/2 + bearing_height/2;

main_body_height_below_shaft = bearing_outer/2 + min_material_thickness*3;

// motor position
motor_z = bottom*(main_body_height_below_shaft) + motor_side/2 + min_material_thickness;
motor_y = mount_plate_thickness;
motor_x = -sqrt(pow(gear_dist,2)-pow(motor_z,2));

module position_motor() {
  translate([motor_x,motor_y,motor_z]) child(0);
}

main_body_width_motor_side = -motor_x - motor_side/2;
main_body_width_idler_side = hobbed_effective_diam/2 + filament_diam + min_material_thickness;
main_body_width  = main_body_width_motor_side + main_body_width_idler_side;
main_body_depth  = motor_len + mount_plate_thickness;
main_body_height_above_shaft = idler_screw_from_shaft + idler_screw_diam/2 + min_material_thickness;
main_body_height = main_body_height_above_shaft + main_body_height_below_shaft;

main_body_x = left*main_body_width/2+main_body_width_idler_side;
main_body_y = main_body_depth/2;
main_body_z = bottom*main_body_height/2+main_body_height_above_shaft;

//total_width = (main_body_width - filament_diam/2 - min_material_thickness) * 2;
total_width = carriage_hole_spacing + m3_nut_diam + min_material_thickness*4;

hotend_z = (main_body_height_below_shaft+min_material_thickness) * bottom;

carriage_hole_z = hotend_z - hotend_height_above_groove - hotend_groove_height;
