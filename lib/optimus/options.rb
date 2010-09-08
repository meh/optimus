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

require 'optimus/option'

class Optimus
    class Options
        attr_reader :implementation

        def self.parse (options, values, implementation, parserOptions=nil)
            result = Options.new(implementation)

            options.each {|option|
                result.set(option)
            }

            implementation.parser.parse(result, values, parserOptions)
        end

        def initialize (implementation)
            @implementation = implementation
        end

        def parse (values, options=nil)
            @implementation.parser.parse(self, values, options)
        end

        def method_missing (method, *args, &block)
            @implementation.interface.send(method, *args, &block)
        end
    end
end

