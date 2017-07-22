class AlterTableProgramUnitRepresentatives < ActiveRecord::Migration
	def up
		rename_column :program_unit_representatives, :type, :representative_type
	end
end
