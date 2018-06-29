# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

hide_content = (field, original_type, new_type) ->
  if field.type == original_type
    field.type = new_type
    field.value = ''
  return
