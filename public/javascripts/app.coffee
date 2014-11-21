$ ->
  defer = (fn) -> setTimeout 500, fn
  gridster = $('.grid').gridster().data('gridster')

  $('#publish-btn').click -> console.log 'publish'

  $('#search-btn').click ->
    $.get '/widget/' + encodeURIComponent($('#search-box').val()), (data) ->
      gridster.add_widget data
  
  $( "#search" ).autocomplete { source: "/search", minLength: 3, select: ( event, ui ) -> 
                                 log( if ui.item then "Selected: " + ui.item.value + " aka " + ui.item.id else "Nothing selected, input was " + this.value )} 
