PREFIX?=${PWD}

${PREFIX}:
	mkdir -p $@

${PREFIX}/hello.txt: ${PREFIX}
	echo "hello world" > $@

.PHONY: all

all: ${PREFIX}/hello.txt
