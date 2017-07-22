class CreateSanctionDetails < ActiveRecord::Migration
  def change
    create_table :sanction_details do |t|
    	t.references :sanction,null: false, index: true
    	t.date :effective_begin_date
    	t.date :sanction_month
    	t.integer :duration
    	t.date :modified_month
    	t.integer :sanction_indicator
    	t.string :release_indicatior, limit: 1
    	t.string :sanction_served, limit: 1
        t.integer :created_by , null:false
	    t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
