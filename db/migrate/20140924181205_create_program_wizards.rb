class CreateProgramWizards < ActiveRecord::Migration
  def change
    create_table :program_wizards do |t|
      t.references :program_unit, index: true, null:false
      t.integer :run_id
      t.integer :month_sequence
      t.date :run_month
      t.integer :no_of_months
      t.text :retain_ind, limit: 1
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
