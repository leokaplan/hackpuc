console.log "aaaaaa"

$ ->
  $('#search-form').ajaxForm
    dataType: 'json',
    success : (response) ->
      console.log response
