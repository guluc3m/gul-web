require 'erb'
require 'pp'
require 'lib'
require 'twitter'

include Lib
include Twitter

@sections = read_sections
@timeline = get_timeline
@announce = read_conditionally "announce.txt"
@story = @timeline.last
@photos = @timeline.collect do |story|
  story.pictures
end
@photos.flatten!

template = ERB.new(File.new("index.erb").read)
puts template.result(binding)


