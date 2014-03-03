# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
window.notify = (type, title, message, hide) ->
  $.pnotify 
    title: title,
    text: message,
    width: "30%",
    hide: hide,
    history: false,
    type: type,
    animation: 
      effect_in: 'show',
      effect_out: 'slide'
window.toggleLoading = (selector)->
  if(selector) 
    target = $(selector)
  else
    target = $(this)

  if target.prop('disabled') == true
    target.prop('disabled', false)
    target.find('button, input:submit').button('reset')
  else
    target.prop('disabled', true)
    target.find('button, input:submit').button('loading')

$ ->
  $('.long').click ->
    $(this).toggleClass('truncated')
    
  $("#date_from").datepicker
    defaultDate: "+1w"
    changeMonth: true
    numberOfMonths: 1
    dateFormat: 'dd-mm-yy'
    showOtherMonths: true
    selectOtherMonths: true
    onClose: (selectedDate) ->
      $("#date_to").datepicker "option", "minDate", selectedDate

  $("#date_to").datepicker
    defaultDate: "+1w"
    changeMonth: true
    numberOfMonths: 1
    dateFormat: 'dd-mm-yy'
    showOtherMonths: true
    selectOtherMonths: true
    onClose: (selectedDate) ->
      $("#date_from").datepicker "option", "maxDate", selectedDate

  $.pnotify.defaults.delay = 5000

  $('#flash').hide().find('div').each ->
    node = $(this)
    notify(node[0].className, node.data('title'), node.text(), false)

  $(".simple_remote")
  .bind('ajax:beforeSend', toggleLoading)
  .bind "ajax:success", (event, data, status, xhr) ->
    if data.error
      notify('error', data.error['title'], data.error['message'], false)
    else
      notify('success', data['title'], data['message'], true)
    
  $('form').each ->
    message = $(this).data('loadingText')
    $(this).find('input').data('loadingText', message)

  if ((reset_button = $('#q_reset')).length > 0)
    reset_button.hide()
    reset_button.each ->
      current_res_but = $(this)
      current_res_but.parents('form').find('input:text').each ->
        if ($(this).val().length > 0)
          current_res_but.show()
      current_res_but.click (e)->
        e.preventDefault()
        $(this).parents('form').find('input:text').val('').end().submit()

  $('.nav-pills a').click (e)->
    e.preventDefault()
    element_id = $(this)[0].id.split('_')[1]
    parent_li = $(this).parents('li')
    parent_ul = $(this).parents('ul')
    if (parent_li.hasClass('active'))
      parent_li.toggleClass('active')
      parent_ul.find('input').each ->
        if($(this).val() == element_id)
          $(this).remove()
    else
      parent_ul.find('input:first').clone().val(element_id).appendTo(parent_ul)
      parent_li.addClass('active')




