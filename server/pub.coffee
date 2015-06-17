# Publications
# Docs: https://www.meteor.com/try/11
Meteor.publish 'SC.OAuth', () ->
  return Meteor.users.find Meteor.userId, 
    fields: 
      'services.soundcloud': 1

Meteor.publish "masters", ->
  return Masters.find()

Meteor.publish "playlist_tracks", ->
  return PlaylistTracks.find {now_playing: false}, 
    sort: [["created_at", "asc"]]


Meteor.publish "userPresence",  ->
  return UserPresences.find { state: "online" }