TEMP_RSVP = "tempRSVP"
RSVP_STEP = "rsvpEnbled"
RSVP_STATUS = "rsvpStatus"
ERROR_FIELDS = "errorFields"
ERROR_MSG = "errorMessage"
checkPwd = ->
  $field = $ ".rsvpPwd"
  pwd = $field.val()
  Meteor.call "checkPassword", pwd, (err, success) ->
    if err or not success
      Session.set ERROR_MSG, "Please try again or contact us to get the password"
    else
      Session.set ERROR_MSG, null
      Session.set RSVP_STEP, 1

updateSession = (field, value) ->
  tempRSVP = (Session.get TEMP_RSVP) || {}
  tempRSVP[field] = value
  Session.setPersistent TEMP_RSVP, tempRSVP

Template.rsvp.events
  'change input[name="name"]': (e, tpl) ->
    updateSession "name", $(e.target).val()
  'change input[name="email"]': (e, tpl) ->
    updateSession "email", $(e.target).val()
  'change input[name="address"]': (e, tpl) ->
    updateSession "address", $(e.target).val()
  'change select[name="rsvp"]': (e, tpl) ->
    rsvp_status = $(e.target).val() == "true"
    updateSession "rsvp", rsvp_status
    Session.set RSVP_STATUS, rsvp_status
  'change select[name="rsvpWith"]': (e, tpl) ->
    guests = $(e.target).val()
    updateSession "rsvpWith", guests
  'change select[name="vegetarian"]': (e, tpl) ->
    guests = $(e.target).val()
    updateSession "vegetarian", guests
  'change textarea[name="note"]': (e, tpl) ->
    updateSession "note", $(e.target).val()
  'click .btn-submit': (e, tpl) ->
    fields = $(find 'input, select, textarea')
    fields.trigger('change')
    tempRSVP = (Session.get TEMP_RSVP) || {}
    e.preventDefault()
    e.stopPropagation()
    RSVP.insert tempRSVP, (err, id) ->
      if err
        console.error err
        Session.set ERROR_FIELDS, err.invalidKeys
        Session.set ERROR_MSG, err.message
      else
        Session.set ERROR_MSG, null
        Session.set ERROR_FIELDS, null
        Session.setPersistent TEMP_RSVP, null
        Session.set RSVP_STEP, 2
    # console.dir RSVP.simpleSchema().namedContext().validate tempRSVP

  'keyup .rsvpPwd': (e, tpl) ->
    if e.keyCode is 13
      checkPwd()
  'click .rsvpPwd-btn': (e, tpl) ->
    checkPwd()


Template.rsvp.onRendered () ->
  rsvpEle = @find ".rsvp"
  rsvpEle._uihooks =
    insertElement: (node, next) ->
      $node = $ node
      if (next)
        $node
          .insertBefore next
          .hide()
          .fadeIn 400
      else
        $node.appendTo $(rsvpEle)
          .hide()
          .fadeIn 400
    removeElement: (node, next) ->
      $node = $ node
      $node.fadeOut () ->
        $node.remove()

Template.rsvp.onDestroyed () ->
  Session.set RSVP_STEP, null
  Session.set ERROR_MSG, null

Template.rsvp.helpers
  tempRSVP: () ->
    Session.get TEMP_RSVP
  hasError: () ->
    if Session.get ERROR_MSG then "has-error" else ""
  errorMessage: () ->
    Session.get ERROR_MSG
  errorFieldClass: (inputField) ->
    fields = Session.get ERROR_FIELDS
    isError = _.find fields, (field) ->
      return field.name == inputField
    if isError then "has-error" else ""
  rsvpEnabled: () ->
    (Session.get RSVP_STEP) is 1
  rsvpDone: () ->
    (Session.get RSVP_STEP) is 2
  rsvpNO: () ->
    not Session.get RSVP_STATUS
