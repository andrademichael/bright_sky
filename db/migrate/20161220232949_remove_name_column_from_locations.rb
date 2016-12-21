class RemoveNameColumnFromLocations < ActiveRecord::Migration[5.0]
  def change
    remove_column(:locations, :name, :string)
  end
end
