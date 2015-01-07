class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :created_by

      t.timestamps null: false
    end
    add_index :events, :name
    add_index :events, :address
    add_index :events, :created_by
  end
end
