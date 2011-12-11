module Twitter
  def for (user) 
    erb = <<-EOF
      <script src="http://widgets.twimg.com/j/2/widget.js"></script>
      <script>
      new TWTR.Widget({
        version: 2,
        type: 'profile',
        rpp: 4,
        interval: 30000,
        width: 250,
        height: 100,
        theme: {
          shell: {
            background: 'transparent',
            color: '#666666'
          },
          tweets: {
            background: 'transparent',
            color: '#666666',
            links: '#007688'
          }
        },
        features: {
          scrollbar: false,
          loop: false,
          live: true,
          behavior: 'all'
        }
      }).render().setUser('<%= user %>').start();
      </script>
      EOF
      template = ERB.new(erb)
      template.result(binding)
  end

  module_function :for
end
