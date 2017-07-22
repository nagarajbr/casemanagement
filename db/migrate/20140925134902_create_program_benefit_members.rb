class CreateProgramBenefitMembers < ActiveRecord::Migration
  def change
    create_table :program_benefit_members do |t|
      t.references :program_wizard, index: true, null:false
    	t.integer  :client_id, null:false
    	t.integer  :member_status
    	 t.integer :created_by , null:false
    	t.integer :updated_by , null:false
       	t.timestamps
    end
  end
end
