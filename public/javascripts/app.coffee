$ ->
  defer = (fn) -> setTimeout 500, fn
  gridster = $('.grid').gridster().data('gridster')

  $('#publish-btn').click -> console.log 'publish'

  $('#search-btn').click ->
    $.get '/search/' + encodeURIComponent($('#search-box').val()), (data) ->
      gridster.add_widget data
