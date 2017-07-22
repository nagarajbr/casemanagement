class AlterTableProgramBenefitDetailsN1 < ActiveRecord::Migration
  def up
  	change_column :program_benefit_details, :sanction_indicator, 'integer USING CAST(sanction_indicator AS integer)'
  end
end
