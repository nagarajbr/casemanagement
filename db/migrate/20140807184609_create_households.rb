class CreateHouseholds < ActiveRecord::Migration
  def change
    create_table :households do |t|
      t.string     :name
      t.integer    :household_status
      t.date       :close_date
      t.integer    :created_by , null:false
      t.integer    :updated_by , null:false
      t.timestamps
    end
  end
end
