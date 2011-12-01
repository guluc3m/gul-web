require 'erb'
require 'pp'
require 'lib'
require 'twitter'

include Lib
include Twitter

@sections = read_sections
@timeline = read_conditionally timeline_path
@timeline = @timeline.split("\n")

def get_story(*path)
  category = ""
  id = ""
  if path.length == 1
    path = path.first.split("/")
  end
  
  category = path.first
  id = path.last
  
  contents = read_conditionally(STORIES_DIR + category + "/" + id)
  return nil unless contents
  meta = []
  body = []
  state = 0
  contents.each_line do |line|
    if state == 0
      if line == "\n"
        state = 1
      else
        line.gsub! "\n", ""
        line = line.split("=")
        line = ":" + line.first + " => " + line.last
        meta << line
      end
    else
      body << line
    end
  end
  
  meta = eval("{" + meta.join(",") + "}")
  short = meta[:short] || "#{body.first[0..20]}..."
  
  { :meta => meta, 
    :title => meta[:title], 
    :body => body, 
    :short => short, 
    :section => category, 
    :id => id
  }
end

@timeline.collect! { |line| get_story(line) }

@announce = read_conditionally "announce.txt"

template = ERB.new(File.new("index.erb").read)
puts template.result(binding)











