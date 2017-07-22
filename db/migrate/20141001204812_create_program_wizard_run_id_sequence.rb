class CreateProgramWizardRunIdSequence < ActiveRecord::Migration
  def up
    execute "CREATE SEQUENCE program_wizard_run_id_seq"
  end
end
