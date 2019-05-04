build:
	cp src/Main.html out/Main.html
	elm make src/Main.elm --debug --output=out/Main.html
.PHONY: build

watch:
	./watch.sh
.PHONY: watch
