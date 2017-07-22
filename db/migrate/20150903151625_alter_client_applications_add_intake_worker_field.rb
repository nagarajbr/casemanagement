class AlterClientApplicationsAddIntakeWorkerField < ActiveRecord::Migration
  def change
  	add_column :client_applications, :intake_worker_id, :integer
  end
end
