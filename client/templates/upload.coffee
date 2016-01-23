UPLOADER_NUM = "UploadedNumber"

getDateTaken = (fileObj, callback) ->
  LoadImage.parseMetaData fileObj, (data) ->
    today = new Date()
    if (data.exif)
      exif = data.exif.getAll()
      date = exif.DateTimeOriginal or exif.DateTimeDigitized or exif.DateTime
      if !!date
        m = moment(date, "YYYY:MM:DD hh:mm:ss")
        callback m.toDate()
      else
        callback today
    else
      callback today

Template.upload.onCreated () ->
  @uploader = new Slingshot.Upload CONSTANTS.UPLOADER
  Accounts.config
    forbidClientAccountCreation : true

Template.upload.onRendered () ->
  num = Session.get UPLOADER_NUM
  if not num
    Session.setPersistent UPLOADER_NUM, 0

Template.upload.helpers
  uploadedCount: () ->
    Session.get UPLOADER_NUM

  username: () ->
    Session.get CONSTANTS.UPLOADER_NAME

  error: (field) ->
    Meteoris.FormValidation.error Photo, field

  progress: () ->
    tpl = Template.instance()
    uploader = tpl.uploader
    progress = uploader.progress()
    NProgress.set progress

Template.upload.events
  'change #uploadUser': (e, tpl) ->
    $input = $ e.target
    name = $input.val()
    Session.setPersistent CONSTANTS.UPLOADER_NAME, name

  'click .submit': (e, tpl) ->
    $inputs = $ tpl.findAll "input, button"
    $inputs.attr "disabled", true
    $uploadUser = $ tpl.find '#uploadUser'
    username = $uploadUser.val() || "Anonymous"
    fileObj = document.getElementById('uploadBtn').files[0]


    if not fileObj
      $(".form-group.fileupload").addClass "has-error"
    else
      $(".form-group.fileupload").removeClass "has-error"
      NProgress.start()
      getDateTaken fileObj, (dateTaken) ->
        Resizer.resize fileObj, {width: 1920, height: 1920, cropSquare: false}, (err, file) ->
          tpl.uploader.send file, (error, downloadUrl) ->
            if (error)
              console.error 'Error uploading', tpl.uploader.xhr.response
              eteoris.FormValidation.error Photo, "url"
            else
              Photo.insert
                name: username
                url: downloadUrl
                takenAt: dateTaken
              , (err) ->
                if err
                  console.error err
                $("input[type='file']").val("")
                NProgress.done()
                uploadedNum = Session.get UPLOADER_NUM
                uploadedNum++
                Session.setPersistent UPLOADER_NUM, uploadedNum

    $inputs.attr "disabled", false
    # Should clean $input.attr "disabled" flase

