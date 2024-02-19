a: a.o

a.o: a.c

${PREFIX}/custom_bin_path/a: a ${PREFIX}/custom_bin_path
	cp $< $@

${PREFIX}/custom_bin_path:
	mkdir $@

all: ${PREFIX}/custom_bin_path/a

.PHONY: all