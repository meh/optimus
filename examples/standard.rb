#! /usr/bin/env ruby
require 'optimus'

opt = Optimus.new {|o|
    o.set({
        :long  => 'config',
        :short => 'c'
    })
}

puts "Parameters: #{opt.options.parameters}"
puts "Arguments: #{opt.options.arguments}"
