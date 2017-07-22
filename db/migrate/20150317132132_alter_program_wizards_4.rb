class AlterProgramWizards4 < ActiveRecord::Migration
  def change
  	add_column :program_wizards, :case_type, :integer
  end
end
