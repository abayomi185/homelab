SCAD = fw-keystone-ears.scad

all: fw-keystone-ear-right.stl fw-keystone-ear-left.stl fw-keystone-ear-insert.stl fw-keystone-ear-test-module.stl fw-keystone-ear-test-flange.stl fw-keystone-ears-plate.3mf

fw-keystone-ear-%.stl: $(SCAD)
	openscad -o $@ -D 'part="$*"' $<

fw-keystone-ears-plate.3mf: $(SCAD)
	openscad -o $@ -D 'part="plate"' $<

preview.png: $(SCAD)
	openscad -o $@ --imgsize=1600,900 --camera=0,-60,40,55,0,340,700 --viewall --autocenter --colorscheme=Tomorrow $<
