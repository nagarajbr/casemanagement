class CreateScreeningEngines < ActiveRecord::Migration
  def change
    create_table :screening_engines do |t|
      t.references :rule, index: true,null:false
      t.date       :effective_begin_date
      t.integer    :rule_category
      t.integer    :service_program_id
      t.date       :effective_end_date
      t.integer    :rule_set_type
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
