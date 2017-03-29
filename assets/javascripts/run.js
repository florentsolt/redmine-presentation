$(function() {
  $('body.controller-wiki.action-show #content section p:empty').remove();

  var url = window.location.pathname + '/presentation';
  $("body.controller-wiki.action-show #content .contextual").first()
    .append($('<a>').attr('target', '_blank').attr('href', url).addClass('icon icon-test').text('Presentation'));
});

