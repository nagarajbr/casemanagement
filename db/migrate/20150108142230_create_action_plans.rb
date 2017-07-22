class CreateActionPlans < ActiveRecord::Migration
  def change
    create_table :action_plans do |t|
       t.references :client, index: true, null:false
       t.references :household, index: true, null:false
       t.references :program_unit, index: true, null:false
       t.integer :action_plan_type
       t.integer  :action_plan_status
       t.integer  :required_participation_hours
       t.date     :start_date
       t.date     :end_date
       t.date     :client_agreement_date
       t.text     :notes
       t.integer :created_by , null:false
       t.integer :updated_by , null:false
       t.timestamps
    end
  end
end
