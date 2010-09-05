#  Copyright (C) 2010 tilde  [tilde AT autistici DOT org]
#
#  This file is part of optimus.
#  
#  optmus is free software: you can redistribute it and/or modify
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

require 'optimus/mini'
require 'optimus/parser'
require 'optimus/data'

class Optimus

    def initialize
        @_parser = Parser.new
        
        if block_given
            yield @_parser
        end
    end

    def parse ary=nil

        if block_given
            yield @_parse_opts
        end

    end

    def parse!
    end

    @_parse_opts = OpenStruct.new {
        :separator  = '-',
        :max_opts   = 0,
        :max_args   = 0, # max amount of arguments, per opt
        :del_parsed = false
    }

end
