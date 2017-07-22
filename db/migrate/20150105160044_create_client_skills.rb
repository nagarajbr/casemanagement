class CreateClientSkills < ActiveRecord::Migration
  def change
    create_table :client_skills do |t|

      t.references :client, index: true
      t.integer :skill_type
      t.date    :identfied_date
      t.integer :skill_identfied_by
      t.string  :referral_source
      t.date     :end_date
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
