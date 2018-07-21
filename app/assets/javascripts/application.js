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
//= require jquery-ui
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

var estimate_price = function(selector_id,arrival_date_id,departure_date_id)
{
  var slideDuration = 500  
  var number_of_people = document.getElementById(selector_id).value;
  number_of_people     = number_of_people.replace("people", "");
  number_of_people     = number_of_people.replace("person", "");  
  var arrival_date     = document.getElementById(arrival_date_id).value;
  var departure_date   = document.getElementById(departure_date_id).value;
  var price_estimate_field = document.getElementById("price_estimate")
  
  if(arrival_date.replace(/\s/g,"") != "" && departure_date.replace(/\s/g,"") != "")
  {
    $.ajax({
      type: "GET", 
      url: "/price_estimation",
      data: 
      {
        number_of_people: number_of_people,
        arrival_date:     arrival_date,
        departure_date:   departure_date,
        authenticity_token: window._token
      },
      success: function(data, textStatus, jqXHR) 
      {
        var highlight_cost = function(init_delay)
        {
          var original_size = $("#price_estimate").find("span").css('font-size')
          var original_colour = $("#price_estimate").find("span").css('color')
          $("#price_estimate").find("span").delay(init_delay).animate({
            fontSize: "16px",
            color: "#f48c42"
          }, 100,"linear",function()
          {
            $("#price_estimate").find("span").delay(500).animate({
              fontSize: original_size,
              color: original_colour
            }, 250, "linear") 
          })
        }
        if (price_estimate_field == null)
        {
          $("#price_estimate").stop(true, true).fadeIn({ duration: slideDuration, queue: false }).css('display', 'none').slideDown(slideDuration);          
        }
        else
        {
          highlight_cost(0)
        }

      },
      error: function(jqXHR, textStatus, errorThrown)
      {
        
      }
    })
  } 
  else
  {
    $("#price_estimate").stop(true, true).fadeOut({ duration: slideDuration, queue: false }).slideUp(slideDuration);
  }
}

var scroll_to = function(element)
{
  $([document.documentElement, document.body]).animate({
        scrollTop: $(element).offset().top
  }, 1500);
}

$(document).one('click','body *',function()
{
    $(".customer_form_error").fadeOut()  
});

var slideIndex = 1;
var timer;

function fill()
{
  var nav_bar    = document.getElementById("customer_navigation_bar");
  var nav_fillers = document.getElementsByClassName("nav_bar_filler");
  var side_bar_fillers = document.getElementsByClassName("side_bar_filler");
  if(nav_fillers != null && nav_fillers.length > 0)
    for(var i = 0; i < nav_fillers.length; i++)
      nav_fillers[i].style.height = nav_bar.offsetHeight.toString() + "px";    
  if (side_bar_fillers != null && side_bar_fillers.length > 0)
    for(var i = 0; i < side_bar_fillers.length; i++)
      side_bar_fillers[i].style.height = (nav_bar.offsetHeight.toString() - 45) + "px";    
}

$(document).ready(function() 
{  
  if (window.location.pathname == "/")
  {
    var gallery = document.getElementById("home_gallery_body");
    gallery.style.display = "none";
    if (!supportsVideo()) 
      showImages(); 
    else
      $("#background_video").fadeIn(400);
  }
});

$(window).resize(function () 
{ 
  fill(); 
});

function supportsVideo()
{
   var v = document.createElement('video');
   if(v.canPlayType && v.canPlayType('video/mp4').replace(/no/, '')) 
   {
       return true;
   }
   return false;
} 
