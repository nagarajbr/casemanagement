class AlterTableApplicationMembers1 < ActiveRecord::Migration
  def up
  	remove_column :application_members, :primary_member_flag
  end
end
