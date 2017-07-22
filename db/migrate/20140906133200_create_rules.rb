class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|

      t.text :class_name , limit:60
      t.text :description
      t.text :rule_title
      t.integer :rule_type
      t.integer :rule_criteria
      t.integer :rule_operator
      t.integer :rule_operand
      t.integer :usage
      t.integer :rule_freq_type
      t.integer :rule_standard_type
      t.integer :rule_second_operator
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
