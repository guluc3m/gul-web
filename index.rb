require 'erb'
require 'pp'
require 'lib'
require 'twitter'

include Lib
include Twitter

@sections = read_sections
@timeline = get_timeline
@announce = read_conditionally "announce.txt"

template = ERB.new(File.new("index.erb").read)
puts template.result(binding)











