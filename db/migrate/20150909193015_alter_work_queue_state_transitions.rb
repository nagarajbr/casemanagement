class AlterWorkQueueStateTransitions < ActiveRecord::Migration
  def change
  		add_column :work_queue_state_transitions, :created_by, :integer
  end
end
