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

module Scope
  def self.send(*args)
    Example.subscribers.each { |s| s.send(*args) }
  end

  def self.puts(*args)
    args.each { |str| send str.to_s }
    nil
  end

  def self.binding
    Kernel.binding
  end
end

class Example < Sinatra::Base
  enable :inline_templates, :logging, :static
  set :public, File.expand_path('../public', __FILE__)
  set :subscribers => [], :scope => Scope.binding, :line => 1

  def escape(data)
    EscapeUtils.escape_html(data).gsub("\n", "<br>").
      gsub("\t", "    ").gsub(" ", "&nbsp;")
  end

  get '/events.es' do
    content_type request.preferred_type("text/event-stream", "text/plain")
    body EventSource.new
    settings.subscribers << body
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
        result = eval("_ = (#{params[:code]})", settings.scope, "(irb)", settings.line)
        settings.line += 1
      end
      stdout << "=> " << result.inspect
    rescue Exception => e
      stdout = [e.to_s, *e.backtrace.map { |l| "\t#{l}" }].join("\n")
    end
    source = escape stdout
    Scope.send source
    ''
  end
end

__END__

@@ script

$(document).ready ->
  input   = $("#input")
  log     = $("#log")
  history = []
  count   = 0
  output  = (str) ->
    log.append str
    log.append "<br>"
    input.attr scrollTop: input.attr("scrollHeight")

  input.bind "keydown", (e) ->
    if e.keyCode == 38 or e.keyCode == 40
      count += e.keyCode - 39
      count = 0 if count < 0
      count = input.length + 1 if count > input.length
      input.val history[count]
      false
    else
      true

  $("#form").live "submit", (e) ->
    value = input.val()
    history.push value
    count++
    $.post '/run', code: input.val()
    output "&gt;&gt; #{value}"
    input.val ""
    input.focus()
    e.preventDefault()

  src = new EventSource('/events.es')
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
