# Collections
#
@PlaylistTracks = new Meteor.Collection("playlist_tracks")
@PlayedTracks = new Meteor.Collection("played_tracks")
@Masters = new Meteor.Collection("masters")

# Subscribes
if Meteor.isClient
  @accessTokenDep = new Deps.Dependency

  # Init custom classes
  @player = new Player
  @search = new Search

  # Subscriptions
  # Docs: https://www.meteor.com/try/11
  Meteor.subscribe "masters"
  Meteor.subscribe "playlist_tracks"
  Meteor.subscribe "played_tracks"
  Meteor.subscribe "userPresence"

  # Try Mopidy
  $.getScript 'http://192.168.1.50:6680/mopidy/mopidy.min.js', () ->
    # create a mopidy websocket connection
    mopidy = new Mopidy
      webSocketUrl: 'ws://192.168.1.50:6680/mopidy/ws/'
    mopidy.on(console.log.bind(console))  # Log all events
    console.log(mopidy)    

  # Register logged in/active user
  UserPresence.data = ->
    return {
      avatar: Session.get("userAvatar")
      name: Session.get("userName")
    }

  Meteor.subscribe 'SC.OAuth', ->
    if Meteor.user()
      # Set user on session
      Session.set "userAvatar", Meteor.user().profile.name
      Session.set "userName", Meteor.user().profile.name

      # Set Access Token
      accessToken = Meteor.user().services.slack.accessToken
      if accessToken
        accessTokenDep.changed()
        SC.accessToken accessToken

        # Get and set favorites
        player.getFavorites()

      # Set NowPlaying Track
      # Sometimes there is one in the playlist, but it's
      # not set on the UI.
      # This sets it on the UI.
      Meteor.call "nowPlaying", (error, track) ->
        if track
          Meteor.call "markAsNowPlaying", track

          # Set play position, add 2 seconds for
          # possible delay in loading.
          @player.play track

  # Track shit to publish to everyone! \o/
  Tracker.autorun ->
    PlaylistTracks.find().observeChanges
      changed: (id, fields) ->
        if fields.now_playing?
          Meteor.call "nowPlaying", (error, track) ->
            if track
              @player.play track

    Masters.find().observe
      added: (master) ->
        if Meteor.user() and master.user_id == Meteor.user()._id
          Session.set "muted", true
      removed: (master) ->
        if Meteor.user() and master.user_id == Meteor.user()._id
          Session.set "muted", false
      changed: (newMaster, oldMaster) ->
        Session.set "volume", newMaster.volume

if Meteor.isServer
  Meteor.startup ->
    # Set indexes
    @PlayedTracks._ensureIndex { randomizer: "2d" }
