class Event < ActiveRecord::Base
  belongs_to :user, class_name: "User", foreign_key: "created_by"
  geocoded_by :address
  after_validation :geocode
end
