# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(window).scroll ->
  headeroffset = 191
  treewrapperheight = 190
  scrolltop= $(this).scrollTop()
  topposition = $("#lesson-tree-anchor").offset().top
  bottomposition = $("#lesson-bottom-anchor").offset().top
  tree = $("#lesson-tree")

  if (scrolltop > topposition - headeroffset) and (scrolltop < bottomposition - (headeroffset+treewrapperheight))
    tree.css
      position: "fixed"
      top: "191px"

  else
    tree.css
      position: "relative"
      top: ""