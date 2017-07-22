class CreateRuleDateParamDetails < ActiveRecord::Migration
  def change
    create_table :rule_date_param_details do |t|
      t.references :rule, index: true,null:false
      t.integer :rule_grouping_id
      t.integer :code_table_id
      t.integer :date_add_substract
      t.integer :date_modifier_code
      t.integer :date_rounding_code
      t.integer :date_status_code
      t.date    :date_user_fixed
      t.text    :date_unique_ind, limit:1
      t.integer :created_by , null:false
	  t.integer :updated_by , null:false
	  t.timestamps
    end
  end
end
