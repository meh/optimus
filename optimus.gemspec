$LOAD_PATH.unshift 'lib/optmus/version.rb'
require 'optimus/version'

Gem::Specification.new do |s|
    s.name           = 'optimus'
    s.version        = Optimus::Version
    s.author         = 'tilde'
    s.email          = 'tilde@autistici.org'
    s.homepage       = 'http://github.com/tilde/shura'
    s.description    = 'An automated yet fully customizzable command line options parser.'
    s.summary        = 'A command line opt parser.'
    s.require_path   = 'lib'
    s.files          = Dir['lib/**/*.rb']
end
