#! /usr/bin/env ruby
#
# This is an example using the "mini" interface of optimus.
# May be useful for small scripts that do not need a complex
# help management or argument handling.

require 'optimus/mini'

resp = Optimus.parse(ARGV).to_hash # or Optimus.parse(ARGV).to_hash

# ./mini.rb -v -c ~/.config

if resp['v']
    puts "we are verbose!"
end

if resp['c']
    if resp['c'][0]
        puts "the config file is #{resp['c'][0]}"
    else
        puts "the -c option require an argument."
    end
end
