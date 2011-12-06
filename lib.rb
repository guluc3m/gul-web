module Lib
  STORIES_DIR = "stories/"

  #
  # ceturns contents of a file, or nil if it doesn't exist
  #
  def read_conditionally(name) 
    case
    when File.exist?(name) : File.new(name).read
    else nil
    end
  end

  #
  # Returns the relative path of a category identified by its ID
  #
  def meta_path(category) 
    STORIES_DIR + category.to_s + "/meta"
  end

  #
  # Returns the relative path of the timeline file
  #
  def timeline_path
    STORIES_DIR + "timeline"
  end
  
  #
  # Returns an array of the existing sections (i.e. stories/*)
  #
  def read_sections 
    sections = []
    Dir.entries(STORIES_DIR).sort.each do |c|
      if c != "." && c != ".." && c != "timeline"
        meta = meta(c)
        sections << meta
      end
    end
    sections
  end

  # 
  # Returns a category's metadata, which is extraced from stories/category/meta
  #
  def meta(category) 
    contents = read_conditionally meta_path(category)
    contents = contents || ""
    result = "{"
    contents.each_line do |l| 
      tokens = l.split("=")
      result = result + ":" + tokens.first + " => " + tokens.last.gsub("\n", "") + ","
    end
    result = result + "}"
    result = eval(result)
    result[:id] = category
    result
  end

  #
  # Given a story, returns its section name
  #
  def section_name_for(story)
    story[:section]
  end
  
  #
  # Given a section's name, returns a hash containing the section metadata
  #
  def section_with_name(name) 
    @sections.find { |s| s[:id] == name }    
  end
  
  #
  # Given a story, returns the section metadata it belongs to
  #
  def section_for(story) 
    name = section_name_for story
    section_with_name name
  end

  #
  # Given a story, return its category's color in html format
  #
  def color_for(story) 
    section_for(story)[:color]
  end
  
  #
  # Given a color in html format, returns its RGB components
  #
  def rgb(color)
    color = color.gsub("#", "")
    r = color[0..1].to_i(16)
    g = color[2..3].to_i(16)
    b = color[4..5].to_i(16)
    {:red => r, :green => g, :blue => b}
  end
  
  #
  # Given a story path, splits in category and story ID
  #
  # split("category/story") => ["category", "story"]
  # split("category", "story") => ["category", "story"]
  #
  def split(*path) 
    category = ""
    id = ""
    if path.length == 1
      path = path.first.split("/")
    end
    [path.first, path.last]
  end
  
  #
  # Given a story path, returns a hash with metadata, title, body, etc.
  #
  def get_story(*path)
    path = split(*path)
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
      :id => id, 
      :path => "/#{category}/#{id}"
    }
  end
  
  def get_timeline
    timeline = read_conditionally timeline_path
    timeline = timeline.split("\n")
    timeline.collect! { |line| get_story(line) }    
  end
  
  def partial(name) 
    contents = read_conditionally "_#{name}.erb" || ""
    template = ERB.new(contents)
    puts template.result(binding)
  end
end

class Array 
  def in_groups_of(n)
    (size % n).times { self << nil }
    result = []
    slice = []
    i = 0
    self.each do |e|
      slice << e
      i = i + 1
      i = i % n
      if i == 0
        result << slice
        slice = []
      end
    end
    result
  end
end
