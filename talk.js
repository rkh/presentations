(function() {
  $('.title').live("showoff:show", function(e) {
    return $(e.target).find("h1").text(document.title);
  });
})();
