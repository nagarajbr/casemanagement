       class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|

        t.integer :address_type
    	t.string :address_line1, limit: 50
        t.string :address_line2, limit: 50
        t.string :city, limit: 50
        t.integer :state
        t.string :zip, limit: 5
        t.string :zip_suffix, limit: 4
        t.date :effective_begin_date
        t.date :effective_end_date
        t.integer :county
        t.string :in_care_of, limit: 20
        t.integer :created_by , null:false
        t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
