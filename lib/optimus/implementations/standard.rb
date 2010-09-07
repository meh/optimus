#  Copyright (C) 2010 tilde  [tilde AT autistici DOT org]
#                     meh    [meh.ffff AT gmail DOT com]
#
#  This file is part of optimus.
#  
#  optimus is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with optimus.  If not, see <http://www.gnu.org/licenses/>.

require 'optimus/implementation'
require 'optimus/interface'
require 'optimus/parser'

class Optimus

module Implementations

class Standard < Implementation
    class Parser < Optimus::Parser
        def initialize (implementation, options=nil)
            super(implementation, options)
    
            if !@options[:separators]
                @options[:separators] = {}
            end
    
            if !@options[:separators][:long]
                @options[:separators][:long] = '--'
            end
    
            if !@options[:separators][:short]
                @options[:separators][:short] = '-'
            end
        end
    
        def parse (values, options=nil)
            options = Options.new
            active  = nil
    
            separators = [options[:separators][:long], options[:separators][:short]].sort {|a, b| b.length <=> a.length}
    
            values.each {|value|
                if active
                    separators.first
                end
            }
        end
    end

    class Interface < Optimus::Interface
        def initialize (implementation)
            super(implementation)
        end

        def set (arguments)
            option = Option.new(arguments)
        end

        def get (arguments)
            result = []

            self.each_value {|option|
                add = true

                arguments.each {|key, value|
                    if value.is_a? String
                        if option[key] != value
                            add = false
                            next
                        end
                    elsif value.class == Regexp
                        if option[key].is_a?(String) && !option[key].match(value)
                            add = false
                            next
                        end
                    end
                }

                if add
                    result << option
                end
            }

            result
        end

        def to_hash
            result = self.clone
            
            self.each_value {|option|
                result[option.short] = option if option.short
            }

            result
        end
    end

    def initialize (parserOptions=nil)
        super(Parser.new(self, parserOptions), Interface.new(self))
    end
end

end

end
