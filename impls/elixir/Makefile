all:
	mix compile

dist: mal

mal: lib/**.ex
	mix escript.build

clean:
	mix clean
	rm -f mal

.PHONY: clean
