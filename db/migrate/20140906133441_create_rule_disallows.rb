class CreateRuleDisallows < ActiveRecord::Migration
  def change
    create_table :rule_disallows do |t|
      t.references :rule, index: true,null:false
      t.integer :rule_grouping_id
      t.integer :code_table_id
      t.integer :codetable_items_id
      t.integer :disregard_value
      t.integer :disregard_amt_code
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
