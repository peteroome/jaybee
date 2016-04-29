Template.now_playing.events
  "click a.favorite": (event) ->
    event.preventDefault()
    track_id = event.currentTarget.dataset.trackId
    player.favourite track_id
    return

  "click a.favorited": (event) ->
    event.preventDefault()
    track_id = event.currentTarget.dataset.trackId
    player.unFavourite track_id
    return

  "click [data-control=upvote]": (event) ->
    event.preventDefault()
    console.log "upvote click"
    Meteor.call "upVote"

  "click [data-control=downvote]": (event) ->
    event.preventDefault()
    console.log "downVote click"
    Meteor.call "downVote"

Template.now_playing.helpers
  now_playing: ->
    return PlaylistTracks.findOne {now_playing: true},
      sort: [["created_at", "asc"]]

  elapsed: ->
    return Session.get "local_elapsed_time"

  length: ->
    return player.track_length @duration

  avatar_url: ->
    return @added_by.services.profile.name

  favourited: ->
    accessTokenDep.depend()

    favorites = Session.get 'sc.favorites'
    track = $.inArray @track_id, favorites

    return if track > -1 then "favorited" else "favorite"

  total_upVotes: ->
    return @upVotes.length

  total_downVotes: ->
    return @downVotes.length

  track_image_url: (track) ->
    if track.artwork_url
      return track.artwork_url
    else
      return "http://fillmurray.com/g/50/50"