# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).ready ->
  $(".entry .task-text").tipsy gravity: "nw" 
  $(".display-form").click ->
    $("div##{$(this).attr('id')}").show()
