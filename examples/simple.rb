#! /usr/bin/env ruby
#
# This example only shows how optimus
# will handle the definition of your
# options.
# As you can see, the external interface
# is completely customizable. You can use
# both block syntax or define your options
# via plain methods.
# It's also eaisily hackable, probably in
# the future i'll write some interfaces
# to do things in different ways. Emulate
# the interface of any other option parser
# is quite simple.

require 'optimus'

opt = Optimus.new do |opt|

    opt.set(
        :name   => 'verbose',
        :short  => 'c',
        :desc   => 'be verbose',
    ).execute do
        puts "I'm oh so verbose."
    end

    opt.set(
        :name   => 'config',
        :short  => 'c',
        :desc   => 'config file' 
    ).args do |arg|
        arg.lol
        arg.set ( Hash[
            :name => 'config file',
            :desc => 'set configuration file path'
        ])
    end.attach_code do |config|  # attach_code and execute are aliases
        puts "Config file is #{config}"
    end

end

opt._data.to_hash.each_pair do |i, e|
    puts "#{i} => #{e}"
    e.code.call ''
end
