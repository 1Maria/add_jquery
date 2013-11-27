# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# --------------------------------
# Sticky Tree

$(window).scroll ->
  tree = $("#lesson-tree")
  if tree.length > 0
    headeroffset = 190
    treewrapperheight = 190
    scrolltop = $(this).scrollTop()
    topposition = $("#lesson-tree-anchor").offset().top
    bottomposition = $("#lesson-bottom-anchor").offset().top

    if (scrolltop > topposition - headeroffset) and (scrolltop < bottomposition - (headeroffset+treewrapperheight))
      tree.css
        position: "fixed"
        top: "#{headeroffset}px"

    else
      if tree.css('position') is "fixed"
        if (scrolltop <= topposition - headeroffset)
          tree.css
            position: "relative"
            top: ""
        else
          tree.css
            position: "relative"
            top: "#{bottomposition-topposition-treewrapperheight}px"


# --------------------------------
# Smooth scrolling

$(document).on "click", ".smooth-nav a", ->
  $("html, body").animate
    scrollTop: $($.attr(this, "href")).offset().top
  , 700
  false


