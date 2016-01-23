Template.ctrl.helpers
  photoUrl: (url) ->
    url.replace 'https://rylisha.s3-ap-northeast-1.amazonaws.com', 'http://cloudfront.rylisha.com'

  photos: () ->
    photos = Photo.find().fetch()
    photos

Template.ctrl.events
  'click .btn-high': (e, tpl) ->
    selectedPhoto = tpl.selected
    if not selectedPhoto
      alert 'please select'
    else
      highlight = Settings.findOne name: 'highlight'
      Settings.update highlight._id, $set : data: selectedPhoto, (err, number) ->
        if (err)
          console.dir err
      layout = Settings.findOne name: 'layout'
      Settings.update layout._id, $set : type: "highlight", (err, number) ->
        if (err)
          console.dir err

  'click .btn-wall': (e, tpl) ->
    selectedPhoto = tpl.selected
    layout = Settings.findOne name: 'layout'
    Settings.update layout._id, $set : type: "wall", (err, number) ->
      if (err)
        console.dir err

  'click .btn-del': (e, tpl) ->
    selectedPhoto = tpl.selected
    Photo.remove selectedPhoto._id

  'click .photo': (e, tpl) ->
    $ele = $ e.target
    $(".photo").removeClass("selected")
    $ele.addClass("selected")
    photo = Blaze.getData e.target
    tpl.selected = photo
