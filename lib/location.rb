class Location < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :latitude, presence: true
  validates :longitude, presence: true
end
