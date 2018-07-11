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

var delete_contents = function(id)
{
  var element = document.getElementById(id);
  element.innerHTML = '';
}

var set_width = function(id,width)
{
  document.getElementById(id).style.width = width;
}

var change_visibility = function(id, visibility)
{
  var element = document.getElementById(id)
  element.style.visibility = visibility
  if(visibility != "hidden")
  {
    element.style.height = "auto";
  }
  else
  {
    element.style.height = "0px";
  }
}

var invert_button_enabled = function(button_id, checkbox_id)
{
  var checkbox = document.getElementById(checkbox_id);  
  var button = document.getElementById(button_id)
  button.disabled = !checkbox.checked
}

var set_form_value = function(field_id,value)
{
  document.getElementById(field_id).value = value
}

var set_text_value = function(id, value)
{
  document.getElementById(id).textContent = value
}

var highlight_date_elements = function(check_in_date, end_date)
{
  check_in_date     = new Date(check_in_date)
  end_date          = new Date(end_date)
  var start_date    = new Date(end_date.getFullYear(), end_date.getMonth(), 1)  
  
  var date_elements = document.getElementsByClassName("check_out_unblocked")
  for(var i = 0; i < date_elements.length; i++)
  {
    var current_element = date_elements[i]
    var current_date = new Date(end_date.getFullYear(), end_date.getMonth(),current_element.textContent.replace(/\s/g,''),9,30)
    if ((current_date.getTime() != check_in_date.getTime()) && (current_date > start_date && current_date < end_date))
    {
      current_element.classList.add("check_out_highlight")
    }
    else
    {
      current_element.classList.remove("check_out_highlight")
    }
    
    if (current_date.getTime() === end_date.getTime())
    {
      current_element.classList.add("check_out_date_highlight")
    }
    else
    {
      current_element.classList.remove("check_out_date_highlight")
    }
  }
}