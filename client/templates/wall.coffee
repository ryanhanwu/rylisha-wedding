Template.wall.onRendered () ->
  $win = $(window)
  container = @find '.pic-container'
  $container = $ container
  container._uihooks =
    insertElement: (node, next) ->
      $node = $ node
      if (next)
        $node.appendTo $container
          .hide()
          .insertBefore next
          .fadeIn 300
      else
        $node.appendTo $container
          .hide()
          .fadeIn 300
    removeElement: (node) ->
      $(node).fadeOut () ->
        $(this).remove()
  @screen =
    width: $win.width()
    halfWidth: $win.width() / 2
    height: $win.height()
  @autorun () =>
    @photos = Photo.find().fetch()
    setTimeout () ->
      $("html, body").animate
        scrollTop: $(document).height()
    , 1000

Template.wall.helpers
  photoUrl: (url) ->
    if url
      url.replace 'https://rylisha.s3-ap-northeast-1.amazonaws.com', 'http://cloudfront.rylisha.com'

  photoUrlShort: (url) ->
    url.replace 'https://rylisha.s3-ap-northeast-1.amazonaws.com', 'http://cf.rylisha.com'

  photosOdd: () ->
    tpl = Template.instance()
    photos = tpl.data
    partialPhotos = _.filter photos, (photo, index) ->
      index % 2 is 0
    partialPhotos

  photosEven: () ->
    tpl = Template.instance()
    photos = tpl.data
    partialPhotos = _.filter photos, (photo, index) ->
      index % 2 isnt 0
    partialPhotos

  width: (dimension) ->
    tpl = Template.instance()
    tpl.screen.halfWidth - 150

  highlight: () ->
    highlight = Settings.findOne name: 'highlight'
    highlight.data.url

  showFullScreen: (type) ->
    layout = Settings.findOne name: 'layout'
    layout.type is "highlight"

