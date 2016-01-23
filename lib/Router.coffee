Router.route 'index',
  path: '/'

Router.route 'registry'

Router.route 'story'

Router.route 'wall',
  layoutTemplate: 'simple'
  waitOn: () ->
    Meteor.subscribe "wall"
  data: () ->
    Photo.find {} , sort: takenAt: 1
    .fetch()

Router.route 'rsvp'
Router.route 'extra'
Router.route 'game'
Router.route 'upload', #For Guests
  layoutTemplate: 'simple'

Router.route '---',
  template: 'ctrl'
  layoutTemplate: 'simple'
  waitOn: () ->
    Meteor.subscribe "wall"
  data: () ->
    Photo.find {} , sort: takenAt: 1
    .fetch()

Router.configure
  #the default layout
  progressSpinner : false
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'



