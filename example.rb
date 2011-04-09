require 'sinatra/base'
require 'capture_stdout'
require 'escape_utils'
require 'slim'
require 'sass'
require 'coffee-script'
require 'eventmachine'

class EventSource
  include EventMachine::Deferrable

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

class Example < Sinatra::Base
  scope, line, subscribers = binding, 1, []
  enable :inline_templates, :logging, :static
  set :public, File.expand_path('../public', __FILE__)

  def escape(data)
    EscapeUtils.escape_html(data).gsub("\n", "<br>").
      gsub("\t", "    ").gsub(" ", "&nbsp;")
  end

  get '/events.es' do
    content_type request.preferred_type("text/event-stream", "text/plain")
    body EventSource.new
    subscribers << body
    EM.next_tick { env['async.callback'].call response.finish }
    throw :async
  end

  get('/events') { slim :html }
  get('/events.js') { coffee :script }
  get('/events.css') { sass :style }

  post '/run' do
    begin
      result = nil
      stdout = capture_stdout do
        result = eval("_ = (#{params[:code]})", scope, "(irb)", line)
        line += 1
      end
      stdout << "=> " << result.inspect
    rescue Exception => e
      stdout = [e.to_s, *e.backtrace.map { |l| "\t#{l}" }].join("\n")
    end
    source = escape stdout
    subscribers.each { |s| s.send source, line }
    ''
  end
end

__END__

@@ script

$(document).ready ->
  input  = $("#input")
  log    = $("#log")
  output = (str) ->
    log.append str
    log.append "<br>"
    input.attr scrollTop: input.attr("scrollHeight")

  $("#form").live "submit", (e) ->
    value = input.val()
    $.post '/run', code: input.val()
    output "&gt;&gt; #{value}"
    input.val ""
    input.focus()
    e.preventDefault()

  src = new EventSource('http://localhost:9090/events.es')
  src.onmessage = (e) -> output e.data

@@ html
html
  head
    title brirb
    link href="/events.css" rel="stylesheet" type="text/css"
    script src="/jquery.min.js" type="text/javascript"
    script src="/events.js" type="text/javascript"
  body
    #log
    form#form
      | &gt;&gt;&nbsp;
      input#input type='text'

@@ style
body
  font:
    size: 200%
    family: monospace
  input#input
    font-size: 100%
    font-family: monospace
    border: none
    padding: 0
    margin: 0
    width: 80%
    &:focus
      border: none
      outline: none
