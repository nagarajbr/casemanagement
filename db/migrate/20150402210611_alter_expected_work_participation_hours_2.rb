class AlterExpectedWorkParticipationHours2 < ActiveRecord::Migration
  def change
  	 add_column :expected_work_participation_hours, :workpays_min_employment_hours, :integer
  end
end
