$(function() {
  if ($('body.controller-wiki.action-show #content section').length > 0) {
    var url = window.location.pathname + '/presentation';
    $("body.controller-wiki.action-show #content .contextual")
      .append($('<a>').attr('href', url).addClass('icon icon-test').text('Presentation'));
  }
});
