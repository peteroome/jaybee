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
  muted: (user_id) ->
    master = Masters.findOne {user_id: user_id}
    return if master? then true else false

  listeners: ->
    # return Meteor.users.find({ "profile.online": true }).fetch()
    return UserPresences.find { state: "online" }
