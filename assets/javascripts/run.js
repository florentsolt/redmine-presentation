$(function() {
  if ($('body.controller-wiki.action-show #content section').length > 0) {
    var first_p = $('#content .wiki-page').children().first();
    if (first_p.text() == '' && first_p.prop("tagName") == 'p') {
      first_p.remove();
    }

    var url = window.location.pathname + '/presentation';
    $("body.controller-wiki.action-show #content .contextual")
      .append($('<a>').attr('href', url).addClass('icon icon-test').text('Presentation'));
  }
});
