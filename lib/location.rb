class Location < ActiveRecord::Base
  validates :city, presence: true
  validates :city, uniqueness: true
  validates :state, presence: true
end
