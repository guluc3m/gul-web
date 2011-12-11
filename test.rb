require 'erb'
require 'pp'
require 'lib'
require 'twitter'

include Lib
include Twitter

@sections = read_sections
@timeline = get_timeline

