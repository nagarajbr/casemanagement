class AlterProgramBenefitMembersTable2 < ActiveRecord::Migration
  def up
  		add_column :program_benefit_members, :run_id, :integer
  		add_column :program_benefit_members, :month_sequence, :integer
  end
end
