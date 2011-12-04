require 'erb'
require 'pp'
require 'lib'

include Lib

file = ARGV[0]

@story = get_story(file) || exit
@sections = read_sections
@section = section_for @story
@timeline = get_timeline.select do |story|
  story[:section] == @section[:id]
end
@announce = read_conditionally "announce.txt"

template = ERB.new(File.new("story.erb").read)
puts template.result(binding)











