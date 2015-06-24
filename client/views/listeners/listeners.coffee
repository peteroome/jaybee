# Listeners
# - User marks their player as master
# - Sound is unmuted if user is a master
# - Sound is muted if user is not a master
Template.listeners.events
  "click [data-control=master]": (event) ->
    event.preventDefault()
    
    button = $(event.currentTarget)
    user_id = $(button).data("user-id")

    if Masters.findOne {user_id: user_id}
      Meteor.call "removeMaster", user_id
    else
      Meteor.call "addMaster", user_id

Template.listeners.helpers
  muted: (user_id) ->
    master = Masters.findOne {user_id: user_id}
    return if master? then true else false

  listeners: ->
    return UserPresences.find { state: "online" }
