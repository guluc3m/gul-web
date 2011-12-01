require 'erb'
require 'pp'
require 'lib'

include Lib

@sections = read_sections

template = ERB.new(File.new("css.erb").read)
puts template.result(binding)














