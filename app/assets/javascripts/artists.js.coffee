# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  setLoading = ->
    $('#submit_artists').hide()
    $("#response").hide()
    $('#search_artist').button('loading')
    $('#artists_search_results ul').addClass('loading')

  unsetLoading = ->
    $('#search_artist').button('reset')
    $('#artists_search_results ul').removeClass('loading')    

  $("#artists_search_results").hide()
  $("#search_artist").click ->
    setLoading()
    $("#artists_search_results").show()
    query = $("#name").val()
    $.getJSON "api_search?query=" + query, (data) ->
      items = []
      $.each data, (key, val) ->
        artist = JST["templates/artist"](
          image: val.image
          name: val.name
          listeners: val.listeners
          mbid: val.mbid
        )
        items.push artist

      $("#artists_search_results").html $("<ul/>",
        class: "my-new-list"
        html: items.join("")
      )
      unsetLoading()
    false

  $(document.body).on "click", "#artists_search_results li", (e) ->
    target = $(this)
    target.parent("ul").addClass("gloom").find("li").removeClass "selected"
    target.addClass "selected"
    name = target.find(".artist_name").text()
    mbid = target.find(".artist_mbid").text()
    image = target.find(".artist_image").attr("src")
    $("#name").val name
    $("#mbid").val mbid
    $("#image").val image
    $('#submit_artists').show()

  toggleLoading = ->
    artists_controlls = $('#artists_form input, #artists_form button')
    if artists_controlls.prop('disabled') == true
      artists_controlls.prop('disabled', false)
      $('#submit_artists input').button('reset')
    else
      artists_controlls.prop('disabled', true)
      $('#submit_artists input').button('loading')

  $("#artists_form")
  .bind('ajax:beforeSend', toggleLoading)
  .bind("ajax:complete", toggleLoading)
  .bind "ajax:success", (event, data, status, xhr)->
    $("#response").show()
    $("#response").html(data)
    $("#name").val('')


