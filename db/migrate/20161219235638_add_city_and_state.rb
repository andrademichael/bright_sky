class AddCityAndState < ActiveRecord::Migration[5.0]
  def change
    add_column(:locations, :city, :string)
    add_column(:locations, :state, :string)
  end
end
