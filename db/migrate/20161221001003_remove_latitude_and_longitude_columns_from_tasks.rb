class RemoveLatitudeAndLongitudeColumnsFromTasks < ActiveRecord::Migration[5.0]
  def change
    remove_column(:locations, :latitude, :float)
    remove_column(:locations, :longitude, :float)
  end
end
