class CreateBudgetUnits < ActiveRecord::Migration
  def change
    create_table :budget_units do |t|
      t.references :household, index: true,null:false
      t.integer    :service_program_id
      t.date       :application_date
      t.integer    :service_location
      t.date       :reevaluation_date
      t.integer    :application_origin
      t.integer    :created_by , null:false
      t.integer    :updated_by , null:false
      t.timestamps
    end
  end
end
