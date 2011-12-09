module Lib

  class Story 
    attr_accessor :meta, :title, :body, :short, :section, :identifier, :path
  end

  class Section
    attr_accessor :identifier, :name, :color
    def ==(other)
      self.identifier == other.identifier
    end
  end

  SECTIONS = {}
  STORIES = {}

  STORIES_DIR = "stories/"
  READING_METADATA = 0
  READING_BODY = 1

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
        sections << get_section(c)
      end
    end
    sections
  end

  # 
  # Returns a category's metadata, which is extraced from stories/section_identifier/meta
  #
  def get_section(identifier) 
    cached = SECTIONS[identifier]
    return cached if cached

    contents = read_conditionally meta_path(identifier)
    contents = contents || ""
    result = "{"
    contents.each_line do |l| 
      tokens = l.split("=")
      result = result + ":" + tokens.first + " => " + tokens.last.gsub("\n", "") + ","
    end
    result = result + "}"
    result = eval(result)
    section = Section.new
    section.identifier = identifier
    section.name = result[:name]
    section.color = result[:color]
    SECTIONS[identifier] = section
  end

  #
  # Given a section's name, returns a hash containing the section metadata
  #
  def section_with_name(name) 
    @sections.find { |s| s.identifier == name }    
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
    section = path.first
    id = path.last
    cached = STORIES["#{section}/#{id}"]
    return cached if cached
    contents = read_conditionally(STORIES_DIR + section + "/" + id)
    return nil unless contents
    meta = {:photo => []}
    body = []
    state = READING_METADATA
    contents.each_line do |line|
      if state == READING_METADATA
        if line == "\n"
          state = READING_BODY
        else
          line.gsub! "\n", ""
          regexp = /(\w+)\s*[=:]\s*(.*)/
          matches = regexp.match line
          if matches
            key = matches[1].to_sym
            value = eval(matches[2])
            if meta[key]
                value = [meta[key], value].flatten
            end
            meta[key] = value
          end
        end
      else
        body << line
      end
    end
    short = meta[:short] || "#{body.first[0..20]}..."

    story = Story.new
    story.meta = meta
    story.title = meta[:title]
    story.body = body
    story.short = short
    story.identifier = id
    story.path = "/#{section}/#{id}"
    story.section = get_section(section)
    STORIES["#{section}/#{id}"] = story
  end
  
  def get_timeline
    timeline = read_conditionally timeline_path
    timeline = timeline.split("\n")
    timeline.collect! { |line| get_story(line) }    
  end
  
  def partial(name) 
    contents = read_conditionally "_#{name}.erb" || ""
    template = ERB.new(contents)
    template.result(binding)
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
