# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
// $->
//   if($('#recommendation_search'))
//     $('.nav-pills a').click (e)->
//       e.preventDefault()
//       tag_id = $(this)[0].id.split('_')[1]
//       parent_li = $(this).parents('li')
//       parent_form = $(this).parents('form')
//       if (parent_li.hasClass('active'))
//         parent_li.toggleClass('active')
//         parent_form.find('.tag_select').each ->
//           if($(this).val() == tag_id)
//             $(this).remove()
//       else
//         hidden_field = $('<input>', { type: 'hidden', value: tag_id, name: 'q[artist_tags_id_in][]', 'class' : 'tag_select' })
//         parent_form.append(hidden_field)
//         parent_li.addClass('active')
