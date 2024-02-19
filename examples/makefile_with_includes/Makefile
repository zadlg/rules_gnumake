${PREFIX}/custom_include_dir/mylib/myheader.h: myheader.h ${PREFIX}/custom_include_dir/mylib
	cp $< $@

${PREFIX}/custom_include_dir/mylib: ${PREFIX}/custom_include_dir
	mkdir $@

${PREFIX}/custom_include_dir:
	mkdir $@

all: ${PREFIX}/custom_include_dir/mylib/myheader.h

.PHONY: all