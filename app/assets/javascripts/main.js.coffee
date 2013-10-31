# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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