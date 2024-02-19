a.so: a.o
	clang -shared -o $@ $^

a.o: a.c

${PREFIX}/custom_shared_libs/a.so: a.so ${PREFIX}/custom_shared_libs
	cp $< $@

${PREFIX}/custom_shared_libs:
	mkdir $@

all: ${PREFIX}/custom_shared_libs/a.so

.PHONY: all