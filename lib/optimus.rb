#  Copyright (C) 2010 tilde  [tilde AT autistici DOT org]
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

require 'optimus/mini'
require 'optimus/parser'
require 'optimus/data'

class Optimus

    attr_reader :_data

    def initialize ary=nil
        ary ||= ARGV
        #@_parser = Parser.new ary 
        @_data    = Data.new

        if block_given?
            yield @_data
        end
    end

    def parse ary=nil
        if block_given?
            yield @_parse_opts
        end
    end

    def parse
    end
end
