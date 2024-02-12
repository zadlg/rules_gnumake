PREFIX ?= ${PWD}

${PREFIX}:
	mkdir -p $@

${PREFIX}/out.txt: ${PREFIX}
	echo "hello world" > $@

all: ${PREFIX}/out.txt