# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ -> # TODO finish ajax
  $("#artist_table a.refuse").on "ajax:success", (event, data, status, xhr) ->
    console.log('fooooo')
    $(event.target).parent().fadeOut "slow", () ->
      $(this).remove()
    
