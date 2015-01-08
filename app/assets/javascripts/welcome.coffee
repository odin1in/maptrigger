# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class CustomMarkerBuilder extends Gmaps.Google.Builders.Marker
  create_marker: ->

    options = _.extend @marker_options(), @rich_marker_options()

    if options.content.innerHTML == ''
      super()
    else
      @serviceObject = new RichMarker options

  rich_marker_options: ->
    marker = document.createElement("div")
    marker.setAttribute('class', 'custom_marker_content')
    marker.innerHTML = this.args.custom_marker
    { content: marker }

window.Welcome =
  current_position: undefined
  gmap_handler: undefined
  current_content: ''

  init: ->
    Welcome.init_google_map()

    $("#map").css "height", $(window).height()
    $("#map").css("width", $(window).width())
    $(window).resize ->
      $("#map").css("height", $(window).height())
      $("#map").css("width", $(window).width())

  init_google_map: ->
    Welcome.gmap_handler = Gmaps.build('Google', builders: { Marker: CustomMarkerBuilder });
    Welcome.gmap_handler.buildMap { provider: {zoom: 19, maxZoom: 19, minZoom: 19, disableDoubleClickZoom: false, panControl: false, scaleControl: false, scrollwheel: false, zoomControl: false, streetViewControl: false, draggable: false}, internal: {id: 'map'}}, ->
      Welcome.gmap_handler.map.centerOn({ lat: 24.956901, lng: 121.242803 })

      if(navigator.geolocation)
        navigator.geolocation.watchPosition (position) ->
          Welcome.center_marker(position)


  removeCurrentMarker: ->
    if Welcome.current_position
      Welcome.removeMarker Welcome.current_position

  removeMarker: (marker) ->
    Welcome.gmap_handler.removeMarker marker

  addMarker: (position) ->
    $.ajax
      url: '/events/near'
      dataType: "json"
      async: false
      data:
        latitude: position.coords.latitude
        longitude: position.coords.longitude
      success: (d) ->
        if d.length > 0
          Welcome.current_content = d[0].creator + ": " + d[0].name
        else
          Welcome.current_content = ''

    marker = Welcome.gmap_handler.addMarker
      lat: position.coords.latitude
      lng: position.coords.longitude
      custom_marker: Welcome.current_content


  center_marker: (position) ->
    Welcome.removeCurrentMarker()
    Welcome.current_position = Welcome.addMarker(position)
    Welcome.gmap_handler.map.centerOn(Welcome.current_position);
    Welcome.gmap_handler.fitMapToBounds();


$ ->
  Welcome.init()

$(document).on 'click', '#removemarker', (e) ->
  e.preventDefault()
  Welcome.removeCurrentMarker()








