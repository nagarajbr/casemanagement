class ProgramUnitMembersAlterTable1 < ActiveRecord::Migration
  def change
  	add_column :program_unit_members, :primary_beneficiary,:string, limit: 1
  end
end
