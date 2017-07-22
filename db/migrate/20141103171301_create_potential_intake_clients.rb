class CreatePotentialIntakeClients < ActiveRecord::Migration
  def change
    create_table :potential_intake_clients do |t|
      t.string  :first_name, null: false , limit: 35
      t.string  :last_name, null: false , limit: 35
      t.date    :date_of_birth
      t.string  :ssn , limit: 9
      t.string  :intake_status, limit: 1 # C = Complete, I = Incomplete
      t.integer :prescreen_household_id
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
