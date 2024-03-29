globals = require "./../model/globals.coffee"

class GPS
  constructor : ->
  getPosition: (cb) ->
    navigator.geolocation.getCurrentPosition(
      (position)->
        globals.lastposition = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
        cb(null, position)
      (error) -> cb(error, null))
  getLatLng: (cb) ->
    @getPosition((err,position)->
      cb(new google.maps.LatLng(position.coords.latitude, position.coords.longitude));
    )
  every : (num, cb) ->
    setInterval (() =>
      this.getPosition(cb)
    ), num

module.exports.GPS = GPS;