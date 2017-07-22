class CreateEmploymentReadinessPlans < ActiveRecord::Migration
  def change
    create_table :employment_readiness_plans do |t|
      t.references :client_assessment, index: true
      t.integer :core_hours
      t.integer :non_core_hours
      t.integer :supportive_services_hours
      t.integer :other_hours
      t.text :comments
      t.integer :created_by , null:false
	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
