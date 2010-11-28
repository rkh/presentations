# replace generic title in title slide with actual title of the talk
$('.title').live "showoff:show", (e) ->
  $(e.target).find("h1").text document.title

