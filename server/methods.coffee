Meteor.methods
  addRSVP: (rsvp) ->
    Register.insert rsvp

  checkPassword: (password) ->
    password is 'rylishaWedding2016' #Just for preventing fraud

