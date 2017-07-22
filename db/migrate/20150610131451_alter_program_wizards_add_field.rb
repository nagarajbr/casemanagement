class AlterProgramWizardsAddField < ActiveRecord::Migration
  def change
  	add_column :program_wizards, :selected_for_planning, "char(1)"
  end
end
