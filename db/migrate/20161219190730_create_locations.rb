class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table(:locations) do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
    end
  end
end
