#!/bin/env ruby
# Copyright (c) 2017, Finalsite, LLC.  All rights reserved.
# Author: Darryl Wisneski <darryl.wisneski@finalsite.com>
# Redistribution and use in source and binary forms, with or without 
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#    2. Redistributions in binary form must reproduce the above copyright notice,
#       this list of conditions and the following disclaimer in the documentation
#          and/or other materials provided with the distribution.
#          THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#          ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#          WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#          DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
#          ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#          (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#          LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#          ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#          (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#          SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# redis-cache-fill.rb
# massively fill up redis database
# practical usage
# bin/redis-cache-fill.rb -b 14000000 -c 19000000 |redis-cli -a 'password' --pipe
require 'optparse'

# getredisproto method mostly taken from redis documentation, with no license noted there.
def getredisproto(*args)
    proto = [] 
    proto.push("*"+args.length.to_s+"\r\n")
    args.each{|arg|
        proto.push("$"+arg.to_s.bytesize.to_s+"\r\n")
        proto.push(arg.to_s+"\r\n")
    }
    proto
end

def getoptions(argv = ARGV)
  ARGV << '-h' if ARGV.empty?

  options = {}
  OptionParser.new do |opts|
    opts.banner = "generate output suitable to fill redis database"
    opts.on("-b FIRST") { |o| options[:first] = o }
    opts.on("-c LAST") { |o| options[:last] = o }
    opts.on('-h', '--help', 'Displays Help') do
      puts opts
      exit
    end
  end.parse!
  return options
end

options = getoptions(ARGV)

first=options[:first].to_i
last=options[:last].to_i
last=last++1

(first...last).each{|number|
  puts getredisproto("SET","Key#{number}","Value#{number}")
}
