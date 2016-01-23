Schemas = {}
Schemas.RSVP =
  name:
    type: String
  email:
    type: String
    regEx: SimpleSchema.RegEx.Email
  rsvp:
    type: Boolean
  rsvpWith:
    type: Number
    optional: true
    custom: () ->
      shouldBeRequired = @field('rsvp').value is true
      if shouldBeRequired
        if !this.operator
          if (!this.isSet || this.value is null || this.value is "")
            return "required"
        else if this.isSet
          if this.operator is "$set" && this.value is null || this.value is ""
            return "required"
          if this.operator is "$unset"
            return "required"
          if this.operator is "$rename"
            return "required"
  address:
    type: String
    optional: true
    custom: () ->
      shouldBeRequired = @field('rsvp').value is true
      if shouldBeRequired
        if !this.operator
          if (!this.isSet || this.value is null || this.value is "")
            return "required"
        else if this.isSet
          if this.operator is "$set" && this.value is null || this.value is ""
            return "required"
          if this.operator is "$unset"
            return "required"
          if this.operator is "$rename"
            return "required"

  note:
    type: String
    optional: true
  status:
    type: Number
    defaultValue: 0
  vegetarian:
    type: Number
    optional: true
    custom: () ->
      shouldBeRequired = @field('rsvp').value is true
      if shouldBeRequired
        if !this.operator
          if (!this.isSet || this.value is null || this.value is "")
            return "required"
        else if this.isSet
          if this.operator is "$set" && this.value is null || this.value is ""
            return "required"
          if this.operator is "$unset"
            return "required"
          if this.operator is "$rename"
            return "required"
  createdAt:
    type: Date
    autoValue: () ->
      if this.isInsert
        new Date
      else if this.isUpsert
        $setOnInsert: new Date
      else
        this.unset()

Schemas.Photo =
  name:
    type: String
  url:
    type: String
  type:
    type: String
    optional: true
  takenAt:
    type: Date
    optional: true
  createdAt:
    type: Date
    autoValue: () ->
      if this.isInsert
        new Date
      else if this.isUpsert
        $setOnInsert: new Date
      else
        this.unset()

Schemas.Settings =
  name:
    type: String
  type:
    type: String
  data:
    type: Object
    blackbox: true
    optional: true

@RSVP = new Mongo.Collection('rsvp')
@Photo = new Mongo.Collection('photo')
@Settings = new Mongo.Collection('settings')

RSVP.attachSchema Schemas.RSVP
Photo.attachSchema Schemas.Photo
Settings.attachSchema Schemas.Settings

RSVP.allow
  insert: (userId, doc) -> true
  update: (userId, doc, fieldNames, modifier) -> false

RSVP.deny
  insert: (userId, doc) -> false
  update: (userId, doc, fieldNames, modifier) -> false
  remove: (userId, doc) -> false

Photo.allow
  insert: (userId, doc) ->
    !!userId
  update: (userId, doc, fieldNames, modifier) -> false
  remove: (userId, doc) ->
    !!userId

Photo.deny
  insert: (userId, doc) -> false
  update: (userId, doc, fieldNames, modifier) -> false
  remove: (userId, doc) -> false

Settings.allow
  insert: (userId, doc) ->
    !!userId
  update: (userId, doc, fieldNames, modifier) ->
    !!userId

