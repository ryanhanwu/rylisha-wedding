Array::remove = (element) ->
  @filter (el) -> el isnt element

$.fn.preloadImages = (cb) ->
  checklist = this.toArray()
  this.each () ->
    $('<img/>').attr({ src: this.toString() }).load () ->
      checklist = checklist.remove $(this).attr 'src'
      if checklist.length is 0
        cb()

Template.layout.onRendered () ->
  $scene = $("#scene").parallax()
  $scene.parallax 'enable'

Template.navi.helpers
  isTemplate: (template) ->
    currentName = Router.current().route.getName()
    if currentName && template is currentName then 'active' else ''

Template.layout.onCreated () ->
  imgs = [
    "http://cdn3.rylisha.com/images/branchLeft.png"
    "http://cdn3.rylisha.com/images/branchRight.png"
    "http://cdn3.rylisha.com/images/logo.png"
    "/images/elishaRyan.png"
    "http://cdn2.rylisha.com/images/smFlowerBg.png"
    "http://cdn2.rylisha.com/images/midFlowerBg.png"
    "http://cdn2.rylisha.com/images/bigFlowerBg.png"
    "http://cdn3.rylisha.com/images/devider.png"
  ]

  $(imgs).preloadImages () ->
    $("img[data-src]").each () ->
      $ele = $(this)
      $ele.attr({ src: $ele.data("src") })
    $('#splash, .splash-logo').addClass("done").delay(4000).queue (next) ->
      $('#splash, #logo-splash').remove()
      $(".logo").addClass("done")
      next()


Template.layout.events
  'click #language .en': () ->
    TAPi18n.setLanguage "en"

  'click #language .zh': () ->
    TAPi18n.setLanguage "zh"
