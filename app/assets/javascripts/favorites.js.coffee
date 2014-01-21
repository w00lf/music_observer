# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  setLoading = ->
    $('#submit_artists').hide()
    $("#response").hide()
    $('#search_artist').button('loading')
    $('#favorites_search_results ul').addClass('loading')

  unsetLoading = ->
    $('#search_favorite').button('reset')
    $('#favorites_search_results ul').removeClass('loading')    

  $("#favorites_search_results").hide()
  $("#search_favorite").click ->
    setLoading()
    $("#favorites_search_results").show()
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

        $("#favorites_search_results").html $("<ul/>",
          class: "my-new-list"
          html: items.join("")
        )
      else
        $("#favorites_search_results").html("Nothing found by request")
      unsetLoading()
    ).fail (data)->      
      $("#favorites_search_results").html("Unexpected server error" + data.statusText)
      unsetLoading()
    false

  $(document.body).on "click", "#favorites_search_results li", (e) ->
    target = $(this)
    target.parent("ul").addClass("gloom").find("li").removeClass "selected"
    target.addClass "selected"
    name = target.find(".artist_name").text()
    mbid = target.find(".artist_mbid").text()
    image = target.find(".artist_image").attr("src")
    $("#name").val name
    $("#mbid").val mbid
    $("#image").val image
    $('#submit_favorites').show()

  $("#favorites_form")
  .bind('ajax:beforeSend', toggleLoading('#favorites_form input, #favorites_form button'))
  .bind("ajax:complete", toggleLoading('#favorites_form input, #favorites_form button'))
  .bind "ajax:success", (event, data, status, xhr)->
    $("#response").show()
    $("#response").html(data)
    $("#name").val('')

  $('#add_from_own_library').bind 'click', (e)->
    $("#api_id").val('')

  $('#add_library_button').click ->
    $('#api_library').toggle()
    return false

  $('.select_all').click ->
    if ($(this).hasClass('allChecked'))
      $('#favorite_table tr input:checkbox').prop('checked', false);
      $(this).removeClass('allChecked')
    else
      $('#favorite_table tr input:checkbox').prop('checked', true);
      $(this).addClass('allChecked')

  $('#pack_track, #pack_track_none').click ->
    if $('#favorite_table tr input:checkbox:checked').length > 0
      if (this.id == 'pack_track_none')
        $('#pack_track_form input[name=track]').val('false')
      $('#favorite_table tr input:checkbox:checked').each ->
        $('#pack_track_form').append( $('<input>', { value: this.id, type: 'hidden', name: 'artists[]' }) )
      $('#pack_track_form').submit()
    else
      alert('Вы не выбрали ни одного исполнителя!')
    


