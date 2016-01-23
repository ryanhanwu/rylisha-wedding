Meteor.publish 'wall', () ->
  [
    RSVP.find rsvp: true
    Photo.find()
    Settings.find()
  ]
Meteor.publish 'rsvp', () ->
  RSVP.find rsvp: true

Meteor.publish 'photo', () ->
  Photo.find()

Meteor.publish 'settings', () ->
  Settings.find()
