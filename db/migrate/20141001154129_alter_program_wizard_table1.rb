class AlterProgramWizardTable1 < ActiveRecord::Migration
  def change
  	add_column :program_wizards, :submit_date, :date
  end
end
