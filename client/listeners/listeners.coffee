# Listeners
# - User marks their player as master
# - Sound is unmuted if user is a master
# - Sound is muted if user is not a master
Template.listeners.events
  "click [data-control=master]": (event) ->
    event.preventDefault()

    if Session.get "muted"
      Meteor.call "removeMaster"
    else
      Meteor.call "addMaster"

Template.listeners.helpers
  muted: ->
    return Session.get "muted"

  listeners: ->
    return Meteor.users.find({ "profile.online": true }).fetch()