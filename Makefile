PACKAGE = fs_dict

all: clean test build

build: 
	echo "Compiling ./src/*.coffee"
	coffee -c ./src/*.coffee
	
test:
	coffee -c ./test/*.coffee
	nodeunit ./test/test.js

clean:
	rm ./test/*.js
	rm ./src/*.js

.PHONY: test build all
