class AlterProgramMemberDetailsTable1 < ActiveRecord::Migration
  def up
  	add_column :program_member_details, :program_member_summary_id, :integer
  end
end
