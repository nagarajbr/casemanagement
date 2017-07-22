class CreateDisabilities < ActiveRecord::Migration
  def change
    create_table :disabilities do |t|
      t.references :client, index: true,null:false
      t.integer :disiability_type
      t.date :review_expiration_date
      t.integer :created_by , null:false
	    t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
