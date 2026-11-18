SCAD = jbod-drive-cage.scad
OSC = openscad --backend=Manifold

STL = sled_f1 sled_f2 sled_f3 sled_f4 roof fanwall_l fanwall_r fan_gasket slot_cover esp_tray washers
PLATES = grommets sleeves

all: $(STL:%=stl/%.stl) $(PLATES:%=stl/%.3mf)

stl/%.stl: $(SCAD)
	@mkdir -p stl
	$(OSC) -o $@ -D 'part="$*"' $<

stl/%.3mf: $(SCAD)
	@mkdir -p stl
	$(OSC) -o $@ -D 'part="$*"' $<

preview.png: $(SCAD)
	$(OSC) -o $@ --imgsize=1600,1000 --camera=211,190,0,50,0,340,950 --colorscheme=Tomorrow $<

clean:
	rm -rf stl preview.png

.PHONY: all clean
