module Lib
  STORIES_DIR = "stories/"

  def read_conditionally(name) 
    case
    when File.exist?(name) : File.new(name).read
    else nil
    end
  end

  def meta_path(category) 
    STORIES_DIR + category.to_s + "/meta"
  end

  def timeline_path
    STORIES_DIR + "timeline"
  end
  
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

  def section_name_for(story)
    story[:section]
  end
  
  def section_with_name(name) 
    @sections.find { |s| s[:id] == name }    
  end
  
  def section_for(story) 
    name = section_name_for story
    section_with_name name
  end

  def color_for(story) 
    section_for(story)[:color]
  end
  
  def rgb(color)
    color = color.gsub("#", "")
    r = color[0..1].to_i(16)
    g = color[2..3].to_i(16)
    b = color[4..5].to_i(16)
    {:red => r, :green => g, :blue => b}
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
