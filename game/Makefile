all: clean build package

clean:
	rebar clean

deps:
	rebar get-deps

build: deps
	rebar compile

package: build
	cd rel&&rebar generate -f

console: package
	rel/{{projectid}}/bin/{{projectid}} console

console_clean: package
	rel/{{projectid}}/bin/{{projectid}} console_clean

