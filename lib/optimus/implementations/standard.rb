#  Copyright (C) 2010 tilde  [tilde AT autistici DOT org]
#           meh  [meh.ffff AT gmail DOT com]
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

require 'forwardable'
require 'date'

require 'optimus/option'
require 'optimus/options'

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
  
    def parse (result, values, options=nil)
      options = @options.merge(options) if options.is_a? Hash
      active  = nil
      type    = nil
  
      values.each {|value|
        if active
          if value.match(/^#{Regexp.escape(@options[:separators][:long])}|#{Regexp.escape(@options[:separators][:short])}\w/)
            result.data[:parameters][active] = { :type => type, :value => true }
          else
            result.data[:parameters][active] = { :type => type, :value => value }
          end

          active = nil
        else
          if matches = value.match(/^#{Regexp.escape(@options[:separators][:long])}(\w+)$/)
            active = matches[1].to_sym
            type = :long
          elsif matches = value.match(/^#{Regexp.escape(@options[:separators][:short])}(\w+)$/)
            if matches[1].length == 1
              active = matches[1].to_sym
              type = :short
            else
              matches[1].chars.each {|char|
                result.data[:parameters][char.to_sym] = { :type => :short, :value => true }
              }
            end
          else
            result.data[:arguments] << value
          end
        end
      }

      result.normalize
      result
    end
  end

  class Interface < Optimus::Interface
    attr_reader :parameters, :arguments, :options, :data

    alias params parameters
    alias args   arguments

    extend Forwardable

    def_delegators :@options, :each_value, :merge!

    alias each each_value

    def initialize (implementation)
      super(implementation)

      @options = {}

      @data = {
        :parameters => {},
        :arguments  => []
      }

      @internal = {}
    end

    def merge (hash)
      result = self.clone
      result.merge! hash
      result
    end

    def set (arguments)
      if !arguments[:long]
        raise 'You have to pass at least :long.'
      end

      arguments[:long]  = arguments[:long].to_sym
      arguments[:short] = arguments[:short].to_sym if arguments[:short]

      option    = Option.new(arguments)
      option.name = arguments[:long]

      @options[option.name] = option
    end

    def get (name)
      @options[name]
    end

    def normalize
      @parameters = {}
      @arguments  = @data[:arguments]

      @options.each_value {|option|
        if option.default
          @parameters[option.long]  = option.default
          @parameters[option.short] = option.default
        end
      }

      @data[:parameters].each {|key, value|
        if value[:type] == :long
          if @options[key]
            @parameters[@options[key].long]  = value[:value]
            @parameters[@options[key].short] = value[:value]
          end
        else
          @options.each_value {|option|
            if option.short == key
              @parameters[option.long]  = value[:value]
              @parameters[option.short] = value[:value]
            end
          }
        end
      }

      @options.each_value {|option|
        case option.type
          when :numeric
            value = @parameters[option.long]
            value = (value.to_i == value.to_f) ? value.to_i : value.to_f

          when :boolean
            value = @parameters[option.long] == 'true'

          when :date
            value = Date.parse(@parameters[option.long])

          when :array
            value = (@parameters[option.long] || '').split(/,/)

          when :hash
            value = Hash[(@parameters[option.long] || '').split(/,/).split(/=/)]
          
          else
            value = @parameters[option.long]
        end

        @parameters[option.long]  = value
        @parameters[option.short] = value
      }
    end
  end

  def initialize (parserOptions=nil)
    super(Parser.new(self, parserOptions), Interface.new(self))
  end
end

end

end
