class AlterProgramWizardTable2 < ActiveRecord::Migration
  def up
  	change_column :program_wizards, :retain_ind, :string, limit: 1

  end
end
