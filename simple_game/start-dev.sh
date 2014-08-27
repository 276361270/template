rebar clean
rebar co
erl -name '{{projectid}}@127.0.0.1' -pa $PWD/apps/{{projectid}}/ebin $PWD/deps/*/ebin -boot start_sasl -s {{projectid}} 
