all:
	openscad -m make -o output/main_plate.stl output/main_plate.scad
	openscad -m make -o output/gear_plate.stl output/gear_plate.scad
	openscad -m make -o output/assembly.stl   output/assembly.scad
