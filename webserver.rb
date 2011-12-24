# http://tuxradar.com/content/code-project-create-web-server-ruby

WWWROOT="html"

require 'socket'
webserver = TCPServer.new('0.0.0.0', 8080)
while (session = webserver.accept)
   request = session.gets
   puts request
   session.print "HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n"
   trimmedrequest = request.gsub(/GET\ \//, '').gsub(/\ HTTP.*/, '')
   filename = trimmedrequest.chomp
   if filename == ""
      filename = "index.html"
   end
   begin
      displayfile = File.open("#{WWWROOT}/#{filename}", 'r')
      content = displayfile.read()
      session.print content
   rescue Errno::ENOENT
      session.print "File not found"
   end
   session.close
end
