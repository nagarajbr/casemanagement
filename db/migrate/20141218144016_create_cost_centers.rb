class CreateCostCenters < ActiveRecord::Migration
  def change
    create_table :cost_centers do |t|

    	 t.integer :service_program_group
    	 t.string  :cost_center
    	 t.string  :internal_order
    	 t.string  :gl_account
    	 t.integer :created_by , null:false
	     t.integer :updated_by , null:false
         t.timestamps


    end
  end
end
