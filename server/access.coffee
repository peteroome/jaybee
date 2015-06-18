Meteor.methods
  addToPlaylist: (track) ->
    check(track, Object)

    PlaylistTracks.insert
      track_id: track.id
      title:    track.title
      username: if track.user then track.user.username else "Unknown"
      duration: track.duration
      artwork_url: track.artwork_url
      permalink_url: track.permalink_url
      position: 0
      now_playing: false
      added_by: Meteor.user()
      upVotes: []
      downVotes: []
      created_at: new Date()

  removeFromPlaylist: (track_id) ->
    PlaylistTracks.remove track_id

  markAsNowPlaying: (track) ->
    # PlaylistTracks.update(track._id, {$set: {now_playing: true}})
    PlaylistTracks.update track._id,
      $set:
        now_playing: true

    return track

  nowPlaying: ->
    # PlaylistTracks.findOne({now_playing: true}, {sort: [["created_at", "asc"]]})
    return PlaylistTracks.findOne {now_playing: true},
      sort: [["created_at", "asc"]]

  nextTrack: ->
    # PlaylistTracks.findOne({now_playing: false}, {sort: [["created_at", "asc"]]})
    return PlaylistTracks.findOne {now_playing: false}, 
      sort: [["created_at", "asc"]]

  upVote: ->
    Meteor.call "nowPlaying", (error, track) ->
      PlaylistTracks.update track._id,
        $addToSet:
          upVotes: Meteor.user()._id
        $pull: 
          downVotes: Meteor.user()._id

  downVote: ->
    Meteor.call "nowPlaying", (error, track) ->
      PlaylistTracks.update track._id,
        $addToSet:
          downVotes: Meteor.user()._id
        $pull: 
          upVotes: Meteor.user()._id

  clearPlaying: ->
    # Mark track as not playing
    Meteor.call "nowPlaying", (error, track) ->
      if track
        PlaylistTracks.remove(track._id)

  addToHistory: ->
    Meteor.call "nowPlaying", (error, track) ->
      if track
        PlayedTracks.insert
          track_id: track.track_id
          added_by: Meteor.user()
          upVotes: track.upVotes
          downVotes: track.downVotes
          created_at: new Date()

  elapsed: (track, position, elapsed_time) ->
    if position > track.position
      PlaylistTracks.update track._id,
        $set:
          elapsed_time: elapsed_time

  addMaster: (user_id) ->
    return Masters.insert
      user_id: user_id
      volume: ->
        master = Masters.findOne({})
        return if master? then master.volume else 50

  removeMaster: (user_id) ->
    return Masters.remove user_id: user_id

  setMasterVolume: (volume) ->
    return Masters.update({}, {$set: {volume: volume}}, { multi: true })
