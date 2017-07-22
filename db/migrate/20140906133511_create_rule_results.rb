class CreateRuleResults < ActiveRecord::Migration
  def change
    create_table :rule_results do |t|
    	 t.references :rule, index: true,null:false
    	  t.references :client, index: true,null:false
    	  t.integer :service_program_id
    	  t.integer :member_client_id
    	  t.integer :rule_type
    	  t.integer :rule_category
    	  t.date    :execution_date
    	  t.integer :execution_results
    	  t.integer :srvc_prog_result
          t.integer :client_results
          t.text    :information_used
          t.integer :service_program_type
          t.integer :created_by , null:false
	      t.integer :updated_by , null:false
	      t.timestamps
    end
  end
end
