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

require 'optimus/options'

class Optimus
    attr_reader :options, :implementation

    # Initialize Optimus with an array of options or ARGV
    def initialize (*args)
        if !block_given?
            options = args.shift || []
        end

        values         = args.shift || ARGV
        implementation = args.shift || Implementations::Standard.new

        if block_given?
            yield @options = Options.new(implementation)
            @options.parse(values)
        else
            @options = Options.parse(options, values, implementation)
        end

        @implementation = implementation
    end

    # Parse additional options and merge them to the Optimus object
    def parse (values, parserOptions=nil)
        options = Options.parse(@options.options, values, @implementation, parserOptions)

        if block_given?
            yield options
        end

        @options.merge!(options)

        return options
    end
end
