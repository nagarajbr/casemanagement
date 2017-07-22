class AlterClientAssessmentAddWithdrawReason < ActiveRecord::Migration
  def change
  	add_column :client_assessments, :withdraw_reason, :integer
  end
end
