# Makefile converts all .scad files to .stl and creates a .zip.
# 'openscad' must be installed and in your path.

# Usage:
#   make            -- create any .stls that need to be recreated
#   make clean      -- delete all build results and start fresh

# -Joe Walnes

dimple-cube.zip: part-base.stl part-lid.stl part-pcb.stl dimple-cube-exploded.stl
	rm -f $@
	zip $@ $^

%.stl: %.scad
	openscad -s $@ -d $@.deps $<

clean:
	rm -f $(wildcard *.zip) $(wildcard *.stl) $(wildcard *.deps)
.PHONY: clean

-include $(wildcard *.deps)
