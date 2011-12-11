require 'pp'

fortunes = []
current_fortune = []

File.new(ARGV[0]).read.each do |line|
  if line =~ /555555.*/
    fortunes << current_fortune
    current_fortune = []
  else
    current_fortune << line
  end
end

i = 0
fortunes.each do |fortune|
   File.open("f#{i}", 'w') do |f|
    f.write(fortune.join)
   end
   i = i + 1
end
