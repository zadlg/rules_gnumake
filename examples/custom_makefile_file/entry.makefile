PREFIX?=${PWD}

${PREFIX}/hello.txt:
	echo "hello world" > $@

.PHONY: all

all: ${PREFIX}/hello.txt
