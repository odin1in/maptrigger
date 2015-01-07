json.array!(@events) do |event|
  json.extract! event, :id, :name, :address, :latitude, :longitude
  json.creator event.user.name
  json.url event_url(event, format: :json)
end
