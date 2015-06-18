Template.controls.events
  "click [data-control=play]": (event) ->
    event.preventDefault()
    Meteor.call "nowPlaying", (error, track) ->
      if track
        player.play track
      else
        player.playNext()

  "click [data-control=next]": (event) ->
    event.preventDefault()
    player.playNext()

  "click [data-control=volume-up]": (event) ->
    event.preventDefault()
    
    volume = Session.get "volume"
    newVolume = volume + 10
    if volume < 100
      Meteor.call "setMasterVolume", newVolume

  "click [data-control=volume-down]": (event) ->
    event.preventDefault()
    
    volume = Session.get "volume" || 0
    newVolume = volume - 10

    if volume > 0
      Meteor.call "setMasterVolume", newVolume

Template.controls.helpers
  volume: ->
    return Session.get "volume"