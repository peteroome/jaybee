# Masters
# - User marks their player as master
# - Player only plays sound if user is a master

Template.header.events
  "click [data-controle=delete-masters]": (event) ->
    event.preventDefault()
    button = event.currentTarget
    Meteor.call "destroyMasters"
    console.log "Destroying"

  "click [data-control=master]": (event) ->
    event.preventDefault()
    button = event.currentTarget

    if $(button).hasClass 'master'
      Meteor.call "removeMaster", ->
        $(button).removeClass "master"
    else
      Meteor.call "addMaster", ->
        $(button).addClass "master"

Template.header.helpers
  masters: ->
    return Masters.find()

  listening: ->
    # Masters.findOne({user_id: '8gRyFggpGuWJDiLuT'}, {}, function(error, master){console.log(error, master)})
    return PlaylistTracks.findOne {user_id: Meteor.user()._id}, 
      sort: [["created_at", "asc"]]
