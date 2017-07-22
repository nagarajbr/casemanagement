class CreateActionPlanDetails < ActiveRecord::Migration
  def change
    create_table :action_plan_details do |t|
      t.references :action_plan, index: true, null:false
      t.references :barrier, index: true, null:false
      t.references :provider, index: true
      t.integer :reference_id
      t.integer :activity_classfication
      t.integer :activity_type, null:false
      t.integer :component_type
	    t.integer :entity_type, null:false
      t.integer  :activity_status, null:false
      t.integer  :hours_per_day, null:false
      t.date     :start_date, null:false
      t.date     :end_date
      t.date     :client_agreement_date
      t.text     :notes
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
