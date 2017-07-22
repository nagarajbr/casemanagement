class CreateProgramWizardReasons < ActiveRecord::Migration
  def change
    create_table :program_wizard_reasons do |t|
    	t.references :program_wizards, null:false
    	t.references :client
    	t.integer :reason, null:false
    	t.integer :created_by , null:false
    	t.integer :updated_by , null:false
        t.timestamps
    end
  end
end
