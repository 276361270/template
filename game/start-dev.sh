#!/bin/sh
cd `dirname $0`
mkdir -p log/sasl
erl -name '{{projectid}}@127.0.0.1' -pa $PWD/apps/{{projectid}}/ebin $PWD/deps/*/ebin -boot start_sasl -config {{projectid}}.config -s reloader -s {{projectid}} 
