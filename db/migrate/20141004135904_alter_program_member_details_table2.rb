class AlterProgramMemberDetailsTable2 < ActiveRecord::Migration
  def up
  	add_column :program_member_details, :inc_exp_res_indicator, :string, limit: 1

  	change_column :program_member_details, :item_type, 'integer USING CAST(item_type AS integer)'
  	change_column :program_member_details, :item_source, :string, limit: 50
  	change_column :program_member_details, :bdm_row_indicator, :string, limit: 1



  end
end
