class CreateOutcomes < ActiveRecord::Migration
  def change
    create_table :outcomes do |t|
       t.integer :outcome_entity
       t.integer :reference_id
       t.integer :outcome_code
       t.text     :notes
       t.integer :recorded_worker
       t.integer :created_by , null:false
       t.integer :updated_by , null:false
       t.timestamps
    end
  end
end
