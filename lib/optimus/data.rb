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

class Optimus

    class Data

        attr_reader :data

        def initialize
            @data = Hash.new
        end

        def add_opt opt
            if opt.empty?
                return
            end
            @data.store opt, Array.new
        end

        def add_arg opt, arg
            if opt.empty? || arg.empty?
                return
            end
            @data[opt] << arg
        end

        def to_hash
            @data
        end

    end

end

