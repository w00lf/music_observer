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
    $.getJSON("api_search?query=" + query, (data) ->
      items = []
      if data.length > 0
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
      else
        $("#artists_search_results").html("Nothing found by request")
      unsetLoading()
    ).fail (data)->      
      $("#artists_search_results").html("Unexpected server error" + data.statusText)
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

  $("#api_library")
  .bind "ajax:success", (event, data, status, xhr)->
    $("#response").show()
    $("#response").html(data)

  $('#add_from_own_library').click (e)->
    e.preventDefault()
    $("#api_id").val('')
    $("#api_library").submit()

  $('#add_library_button').click ->
    $('#api_library').toggle()

  $('.select_all').click ->
    if ($(this).hasClass('allChecked'))
      $('#artist_table tr input:checkbox').prop('checked', false);
      $(this).removeClass('allChecked')
    else
      $('#artist_table tr input:checkbox').prop('checked', true);
      $(this).addClass('allChecked')

  $('#pack_track, #pack_track_none').click ->
    if $('#artist_table tr input:checkbox:checked').length > 0
      if (this.id == 'pack_track_none')
        $('#pack_track_form input[name=track]').val('false')
      $('#artist_table tr input:checkbox:checked').each ->
        $('#pack_track_form').append( $('<input>', { value: this.id, type: 'hidden', name: 'artists[]' }) )
      $('#pack_track_form').submit()
    else
      alert('Вы не выбрали ни одного исполнителя!')
    


