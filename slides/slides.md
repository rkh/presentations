!SLIDE bullets

* ![breaking](breaking.png)

!SLIDE center
![web](ie.png)

!SLIDE center
![ajax](ajax.png)

!SLIDE center
![comet](comet.png)

!SLIDE bullets

* ![real_time](real_time.jpg)

!SLIDE bullets incremental

# Come again? #

* streaming
* server push

!SLIDE bullets

* decide what to send while streaming, not upfront

!SLIDE bullets

* Streaming APIs
* Server-Sent Events
* Websockets

!SLIDE center

# Demo! #

## Not available in PDF ##

!SLIDE bullets

# Rack #

* Ruby to HTTP to Ruby bridge
* Middleware API
* Powers Rails, Sinatra, Ramaze, ...

!SLIDE center

![rack](rack_stack.png)

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    welcome_app = proc do |env|
      [200, {'Content-Type' => 'text/html'},
        ['Welcome!']]
    end

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    welcome_app = Object.new

    def welcome_app.call(env)
      [200, {'Content-Type' => 'text/html'},
        ['Welcome!']]
    end

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    get('/') { 'Welcome!' }

!SLIDE

![pseudo_code](pseudo_code.png)
![stack](handler.png)

    @@@ ruby
    env = parse_http

    status, headers, body =
      welcome_app.call env

    io.puts "HTTP/1.1 #{status}"
    headers.each { |k,v| io.puts "#{k}: #{v}" }
    io.puts ""

    body.each { |str| io.puts str }

    close_connection

!SLIDE

# Middleware #

!SLIDE

![working_code](working_code.png)
![stack](middleware.png)

    @@@ ruby
    # <p>foo</p> => <P>FOO</P>
    class UpperCase
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, body = @app.call(env)
        upper = []
        body.each { |s| upper << s.upcase }
        [status, headers, upper]
      end
    end

!SLIDE large

![working_code](working_code.png)
![stack](something_else.png)

    @@@ ruby
    # set up middleware
    use UpperCase

    # set endpoint
    run welcome_app

!SLIDE

![working_code](working_code.png)
![stack](handler.png)

    @@@ ruby
    status, headers, body =
      welcome_app.call(env)

!SLIDE

![working_code](working_code.png)
![stack](handler.png)

    @@@ ruby
    app = UpperCase.new(welcome_app)

    status, headers, body = app.call(env)

!SLIDE
# Streaming with #each #

!SLIDE

![working_code](working_code.png)
![stack](handler.png)

    @@@ ruby
    my_body = Object.new
    get('/') { my_body }

    def my_body.each
      20.times do
        yield "<p>%s</p>" % Time.now
        sleep 1
      end
    end

!SLIDE bullets

* Let's build a messaging service!

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    subscribers = []

    get '/' do
      body = Subscriber.new
      subscribers << body
      body
    end

    post '/' do
      subscribers.each do |s|
        s.send params[:message]
      end
    end

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    class Subscriber
      def send(data)
        @data = data
        @thread.wakeup
      end

      def each
        @thread = Thread.current
        loop do
          yield @data.to_s
          sleep
        end
      end
    end

!SLIDE bullets incremental

* blocks the current thread
* does not work well with some middleware
* does not work (well) on evented servers<br>(Thin, Goliath, Ebb, Rainbows!)

!SLIDE

# Evented streaming with async.callback #

!SLIDE center
![event loop](eventloop1.png)

!SLIDE center
![event loop - webscale](eventloop2.png)

!SLIDE

![working_code](working_code.png)
![stack](something_else.png)

    @@@ ruby
    sleep 10
    puts "10 seconds are over"
    
    puts Redis.new.get('foo')

!SLIDE

![working_code](working_code.png)
![stack](something_else.png)

    @@@ ruby
    require 'eventmachine'

    EM.run do
      EM.add_timer 10 do
        puts "10 seconds are over"
      end

      redis = EM::Hiredis.connect
      redis.get('foo').callback do |value|
        puts value
      end
    end

!SLIDE

![pseudo_code](pseudo_code.png)
![stack](endpoint.png)

    @@@ ruby
    get '/' do
      EM.add_timer(10) do
        env['async.callback'].call [200,
          {'Content-Type' => 'text/html'},
          ['sorry you had to wait']]
      end

      "dear server, I don't have a  " \
      "response yet, please wait 10 " \
      "seconds, thank you!"
    end

!SLIDE

# With #throw #

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    get '/' do
      EM.add_timer(10) do
        env['async.callback'].call [200,
          {'Content-Type' => 'text/html'},
          ['sorry you had to wait']]
      end

      # will skip right to the handler
      throw :async
    end

!SLIDE

# Status Code #

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    get '/' do
      EM.add_timer(10) do
        env['async.callback'].call [200,
          {'Content-Type' => 'text/html'},
          ['sorry you had to wait']]
      end

      # will go through middleware
      [-1, {}, []]
    end

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    # gem install async-sinatra
    require 'sinatra/async'

    aget '/' do
      EM.add_timer(10) do
        body 'sorry you had to wait'
      end
    end

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    redis = EM::Hiredis.connect

    aget '/' do
      redis.get('foo').callback do |value|
        body value
      end
    end


!SLIDE

![pseudo_code](pseudo_code.png)
![stack](handler.png)

    @@@ ruby
    env = parse_http

    cb = proc do |response|
      send_headers(response)
      response.last.each { |s| send_data(s) }
      close_connection
    end

    catch(:async) do
      env['async.callback'] = cb
      response = app.call(env)
      cb.call(response) unless response[0] == -1
    end


!SLIDE bullets incremental

* that's postponing ...
* ... not streaming

!SLIDE

# EM::Deferrable #

!SLIDE

![working_code](working_code.png)
![stack](something_else.png)

    @@@ ruby
    require 'eventmachine'

    class Foo
      include EM::Deferrable
    end

    EM.run do
      f = Foo.new
      f.callback { puts "success!" }
      f.errback { puts "something went wrong" }
      f.succeed
    end

!SLIDE

![pseudo_code](pseudo_code.png)
![stack](handler.png)

    @@@ ruby
    cb = proc do |response|
      send_headers(response)
      response.last.each { |s| send_data(s) }
      close_connection
    end

!SLIDE

![pseudo_code](pseudo_code.png)
![stack](handler.png)

    @@@ ruby
    cb = proc do |response|
      send_headers(response)
      body = response.last
      body.each { |s| send_data(s) }

      if body.respond_to? :callback
        body.callback { close_connection }
        body.errback { close_connection }
      else
        close_connect
      end
    end

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    # THIS IS NOT EVENTED

    subscribers = []

    get '/' do
      body = Subscriber.new
      subscribers << body
      body
    end

    post '/' do
      subscribers.each do |s|
        s.send params[:message]
      end
    end

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    subscribers = []

    aget '/' do
      body Subscriber.new
      subscribers << body
    end

    post '/' do
      subscribers.each do |s|
        s.send params[:message]
      end
    end

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    class Subscriber
      include EM::Deferrable

      def send(data)
        @body_callback.call(data)
      end

      def each(&blk)
        @body_callback = blk
      end
    end

!SLIDE

![pseudo_code](pseudo_code.png)
![stack](handler.png)

    @@@ ruby
    cb = proc do |response|
      send_headers(response)
      body = response.last
      body.each { |s| send_data(s) }

      if body.respond_to? :callback
        body.callback { close_connection }
        body.errback { close_connection }
      else
        close_connect
      end
    end

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    delete '/' do
      subscribers.each do |s|
        s.send "Bye bye!"
        s.succeed
      end
    end

!SLIDE bullets

# Server-Sent Events #

* [dev.w3.org/html5/eventsource](http://dev.w3.org/html5/eventsource/)

!SLIDE bullets incremental

* Think one-way WebSockets
* Simple
* Resumable
* Client can be implemented in JS
* Degrade gracefully to polling

!SLIDE

![working_code](working_code.png)
![stack](client.png)

    @@@ javascript
    var source = new EventSource('/updates');
    
    source.onmessage = function (event) {
      alert(event.data);
    };

!SLIDE

    HTTP/1.1 200 OK
    Content-Type: text/event-stream

!SLIDE

    HTTP/1.1 200 OK
    Content-Type: text/event-stream

    data: This is the first message.

!SLIDE

    HTTP/1.1 200 OK
    Content-Type: text/event-stream

    data: This is the first message.

    data: This is the second message, it
    data: has two lines.

!SLIDE

    HTTP/1.1 200 OK
    Content-Type: text/event-stream

    data: This is the first message.

    data: This is the second message, it
    data: has two lines.

    data: This is the third message.

!SLIDE

    HTTP/1.1 200 OK
    Content-Type: text/event-stream
    
    data: the client
    id: 1
    
    data: keeps track
    id: 2
    
    data: of the last id
    id: 3

!SLIDE

![working_code](working_code.png)
![stack](endpoint.png)

    @@@ ruby
    class EventSource
      include EM::Deferrable

      def send(data, id = nil)
        data.each_line do |line|
          line = "data: #{line.strip}\n"
          @body_callback.call line
        end
        @body_callback.call "id: #{id}\n" if id
        @body_callback.call "\n"
      end

      def each(&blk)
        @body_callback = blk
      end
    end

!SLIDE bullets

# WebSockets #

* Think two-way EventSource

!SLIDE

![working_code](working_code.png)
![stack](client.png)

    @@@ javascript
    var src = new WebSocket('ws://127.0.0.1/');
    
    src.onmessage = function (event) {
      alert(event.data);
    };

!SLIDE

![working_code](working_code.png)
![stack](client.png)

    @@@ javascript
    var src = new EventSource('/updates');

    src.onmessage = function (event) {
      alert(event.data);
    };

!SLIDE

![working_code](working_code.png)
![stack](client.png)

    @@@ javascript
    var src = new WebSocket('ws://127.0.0.1/');

    src.onmessage = function (event) {
      alert(event.data);
    };

!SLIDE

![working_code](working_code.png)
![stack](client.png)

    @@@ javascript
    var src = new WebSocket('ws://127.0.0.1/');

    src.onmessage = function (event) {
      alert(event.data);
    };

    src.send("ok, let's go");

!SLIDE

![working_code](working_code.png)
![stack](something_else.png)

    @@@ ruby
    options = { host: '127.0.0.1', port: 8080 }
    EM::WebSocket.start(options) do |ws|
      ws.onmessage { |msg| ws.send msg }
    end

!SLIDE bullets incremental

# WebSockets have issues #

* Clients need patching
* Servers need patching
* Proxies need patching
* Rack needs patching

!SLIDE bullets incremental

# SPDY #

* Replacement for HTTPS
* Supports pushing
