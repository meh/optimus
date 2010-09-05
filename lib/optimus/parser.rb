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

require 'optimus/data'
require 'ostruct'

class Optimus

    class Parser

        attr_accessor :_parse_opts

        def initialize ary, parse_opts
            @_ary        = ary
            @_parse_opts = parse_opts
            @resp        = Data.new
        end

        def parse ary=nil, parse_opts=nil
            @ary        = ary || @_ary
            @parse_opts = parse_opts || @_parse_opts

            self.tokenize
        end

        def tokenize
            ary = @ary
            active = ''
            ary.each do |i|
                if i.match(/^#{Regexp.escape(@_parse_opts.separator)}/)
                    opt = i.delete @_parse_opts.separator
                    active = opt
                    @resp.add_opt opt
                else
                    @resp.add_arg active, i
                end
            end
            @resp
        end
    end
end

