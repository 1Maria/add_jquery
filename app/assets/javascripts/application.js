// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require d3
//= require_tree .


$(function() {
  hideRow();
  $(".new-association").on("click", addRow);
  $("#update_button").on("click", disableButton);
  $(".delete-association").on("click", hideDeleted);
});


function disableButton() {
  setTimeout(function() {
    $("#update_button").attr("disabled", "disabled")
  }, 1);
}


function hideRow() {
  var row = $("#show_hide_row").children().last();
    row.hide();
}

function addRow() {
  var row = $("#show_hide_row").children().last();
    row.show();
}

function hideDeleted(event) {
  $(event.target).closest(".association").hide();
}

function smoothScrolling() {

}
