// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

$(document).ready(function() {
  $('.underscore').each(function() {
    var elem = $(this);
    setInterval(function() {
        if (elem.css('visibility') == 'hidden') {
            elem.css('visibility', 'visible');
        } else {
            elem.css('visibility', 'hidden');
        }    
    }, 775);
  });
  $('#edit').click(function(){
    $('textarea').toggle();
    $('input[type="text"]').toggle();
    $('input[type="submit"]').toggle();
    $('.links').toggle();
    $('.title').toggle();
    $('.text').toggle();
  })
  // variable to hold request
  var request;
  // bind to the submit event of our form
  $(".edit_article").submit(function(event){
      // abort any pending request
      if (request) {
          request.abort();
      }
      // setup some local variables
      var $form = $(this);
      // let's select and cache all the fields
      var $inputs = $form.find("input, textarea");
      // serialize the data in the form
      var serializedData = $form.serialize();

      // fire off the request to /form.php
      var request = $.ajax({
          url: "/articles/1",
          type: "post",
          data: serializedData
      });

      // callback handler that will be called on success
      request.done(function (response, textStatus, jqXHR){
          $(".title").load("/articles/1 .title");
          $(".text").load("/articles/1 .text");
          $('textarea').toggle();
          $('input[type="text"]').toggle();
          $('input[type="submit"]').toggle();
          $('.links').toggle();
          $('.title').toggle();
          $('.text').toggle();
      });

      // prevent default posting of form
      event.preventDefault();
  });
});