json.array!(@events) do |event|
  json.extract! event, :id, :name, :address, :latitude, :longitude, :created_by
  json.url event_url(event, format: :json)
end
