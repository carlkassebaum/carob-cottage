// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery 
//= require jquery_ujs
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

//If the given field has the same type as the original type, hide it and replace it with the next type. 
var hide_content = function(field, original_type, new_type, colour) 
{
  if (field.type === original_type) 
  {
    field.type = new_type;
    field.value = '';
    field.style.color = colour
  }
};

var restore_default = function(field, original_type, original_content, colour)
{
    if(field.value === '')
    {
        field.type = original_type
        field.value = original_content
        field.style.color = colour
    }
}

var fade_flash_notifications_out = function()
{
  $("#flash").delay(3000).fadeOut(2000);
}

var change_image = function(element, new_src)
{
  element.src = new_src;
}

var delete_parent_contents = function(child_id)
{
  parent = document.getElementById(child_id).parentElement
  parent.innerHTML = ''
  parent.style.width = "0px"
}
