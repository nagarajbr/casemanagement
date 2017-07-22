class AlterProgramWizardsColumn < ActiveRecord::Migration
  def change
  		change_column :program_wizards, :submit_date, :datetime
  end
end
