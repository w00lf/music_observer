# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#artist_table a.refuse').on('ajax:success', (event, data, status, xhr)->
    container = $(this).closest('tr')
    container.fadeOut 1000, ->
      container.remove()
  )
  .on "ajax:beforeSend", ->
    $(this).button('loading')

  $('.more_button').click ->
    $('.nav-pills li').slice(13, -1).toggle()

  if ($('.nav-pills li').length > 12)
    $('.nav-pills li').slice(13, -1).toggle()
    $('.more_button').show()

