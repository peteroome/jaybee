# Publications
# Docs: https://www.meteor.com/try/11
Meteor.publish 'SC.OAuth', () ->
  return Meteor.users.find Meteor.userId, 
    fields: 
      'services.soundcloud': 1

Meteor.publish "masters", ->
  return Masters.find()

Meteor.publish "played_tracks", ->
  return PlayedTracks.find()

Meteor.publish "playlist_tracks", ->
  return PlaylistTracks.find {}, 
    sort: [["created_at", "asc"]]

Meteor.publish "userPresence",  ->
  return UserPresences.find {
    state: "online", 
    "data.avatar": 
      $ne: null
  }