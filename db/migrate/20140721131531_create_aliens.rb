class CreateAliens < ActiveRecord::Migration
  def change
    create_table :aliens do |t|
      t.references :client, index: true,null:false
      t.date :alien_DOE
      t.integer :refugee_status
      t.integer :country_of_origin
      t.string :alien_no
      t.integer :non_citizen_type
      t.string :residency, limit: 1
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
