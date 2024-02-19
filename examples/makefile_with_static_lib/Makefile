a.a: a.o
	clang -static -o $@ $^

a.o: a.c

${PREFIX}/custom_static_libs/a.a: a.a ${PREFIX}/custom_static_libs
	cp $< $@

${PREFIX}/custom_static_libs:
	mkdir $@

all: ${PREFIX}/custom_static_libs/a.a

.PHONY: all