class CreateHouseholdMembers < ActiveRecord::Migration
  def change
    create_table :household_members do |t|
      t.references :household, index: true,null:false
      t.references :client, index: true,null:false
      t.integer    :household_member_role, null:false
      t.integer    :household_participation_status, null:false
      t.date       :household_participation_date, null:false
      t.integer    :created_by , null:false
      t.integer    :updated_by , null:false
      t.timestamps
    end
  end
end
