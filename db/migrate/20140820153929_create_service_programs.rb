class CreateServicePrograms < ActiveRecord::Migration
  def change
    create_table :service_programs do |t|
      t.string :description, null: false , limit: 250
      t.string :title, null: false , limit: 35
      t.integer :service_type
      t.integer :usage_type
      t.string :schedule_courses, limit: 1
      t.string :auto_referral_task, limit: 1
      t.string :sanction_indicator, limit: 1
      t.integer :svc_pgm_category
      t.integer :created_by , null:false
      t.integer :updated_by , null:false

      t.timestamps
    end
  end
end
