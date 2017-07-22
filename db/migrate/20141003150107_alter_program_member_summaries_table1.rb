class AlterProgramMemberSummariesTable1 < ActiveRecord::Migration
  def up
  	add_column :program_member_summaries, :program_benefit_member_id, :integer
  end
end
