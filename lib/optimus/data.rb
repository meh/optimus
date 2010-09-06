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

require 'ostruct'

class Optimus

    class Data < OpenStruct
        # opt_name
        # |_code 
        # |_name 
        # |_other_opts 
        # |_arguments 
        #   |_arg_namee
        #   | |_name
        #   | |_other_opts
        #   |_arg2_name
        #     |_ecc
        #
        # opt2_name
        # |_ecc

        attr_accessor :_context

        def initialize start_opts=nil, context=nil
            super()
            if start_opts.respond_to? :marshal_dump
                marshal_load(start_opts.marshal_dump)
            end
            @_context = context
        end

        def args
            if !block_given?
                raise "A block is required."
            else
                create_args
                marshal_load((yield Args.new(self, @_context)).marshal_dump)
            end
            self
        end

        def set hash_opts, opt=nil
            opt ||= @_context
            if !hash_opts.has_key? :name
                raise 'Options must have a :name.'
            end
            if !respond_to?(hash_opts[:name])
                create_opt hash_opts[:name]
            end
            hash_opts.each_pair do |opt_name, opt_value|
                add_opt opt_name, opt_value
            end
            self
        end

        def set_args hash_args, affected_opt=nil
            affected_opt ||= @_context
            if !hash_opts.has_key? :name
                raise 'Options must have a :name.'
            end
            if send(affected_opt).arguments.methods.include? hash_args[:name]
                raise "You cannot set #{hash_args[:name]} as args opt name."
            end
            hash_args.each_pair do |opt_name, opt_value|
                add_arg opt_name, opt_value
            end
            self
        end

        def create_opt opt
            if opt.empty?
                raise "Fatal error."
            end
            if methods.include? opt
                raise "You cannot set #{opt} as opt name."
            end
            if !respond_to?(:opt)
                new_ostruct_member opt
            end
            send "#{opt}=", OpenStruct.new(:code=>nil) 
            @_context = opt
            self
        end

        private :create_opt

        def add_opt option, value, affected_opt=nil
            affected_opt ||= @_context
            send(affected_opt).send("#{option}=", value)
            self
        end

        def create_args affected_opt=nil
            affected_opt ||= @_context
            if affected_opt.empty?
                raise "Fatal error."
            end
            if !send(affected_opt).respond_to? :arguments
                send(affected_opt).send("arguments=", OpenStruct.new)
            end
            self
        end
        
        private :create_args

        def add_arg option, value, affected_opt=nil
            affected_opt ||= @_context
            send(affected_opt).arguments.send("#{option}=", value)
            self
        end

        def execute affected_opt=nil, &block
            affected_opt ||= @_context
            if block.nil?
                raise "this needs a block."
            end
            send(affected_opt).code = block
            self
        end

        alias attach_code execute

        def merge other
        end

        def to_hash
            #TODO better this.
            marshal_dump
        end
    end

    class Args < Data
        alias set set_args
    end

end

