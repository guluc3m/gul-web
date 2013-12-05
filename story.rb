require 'erb'
require 'pp'
require 'lib'
require 'fortunes'

include Lib

file = ARGV[0]

@story = get_story(file) || exit
@sections = read_sections

tl = get_timeline

# stories in the same section
@timeline = tl.select do |story|
  story.section == @story.section && story.body.length > 0
end

@others = tl.select do |story|
  story.section != @story.section
end

# and their pictures
@photos = @timeline.collect do |story|
  story.pictures
end
@photos.flatten!

@announce = read_conditionally "announce.txt"

template = ERB.new(File.new("story.erb").read)
puts template.result(binding)


