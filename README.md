# redis-tooling

Tools to work with redis

redis-cache-fill.rb

massively fill up redis database

example usage: 

Generate 1 million entries in redis:

ruby redis-cache-fill.rb -b 0 -c 1000000 |redis-cli --pipe
