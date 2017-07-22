class CreateRuleAdjustments < ActiveRecord::Migration
  def change
    create_table :rule_adjustments do |t|
      t.references :rule, index: true,null:false
      t.integer :rule_grouping_id
      t.integer :code_table_id
      t.integer :codetable_items_id
      t.integer :adjust_value
      t.text    :as_resource_ind , limit:1
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
 