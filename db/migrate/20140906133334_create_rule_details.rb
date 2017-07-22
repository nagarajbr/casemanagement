class CreateRuleDetails < ActiveRecord::Migration
  def change
    create_table :rule_details do |t|
      t.references :rule, index: true,null:false
      t.integer :rule_grouping_id
      t.integer :code_table_id
      t.integer :codetable_items_id
      t.text :criteria_a_ind , limit:1
      t.text :criteria_b_ind , limit:1
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
