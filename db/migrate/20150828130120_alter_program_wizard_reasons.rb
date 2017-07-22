class AlterProgramWizardReasons < ActiveRecord::Migration
  def change
  	rename_column :program_wizard_reasons, :program_wizards_id, :program_wizard_id
  end
end
