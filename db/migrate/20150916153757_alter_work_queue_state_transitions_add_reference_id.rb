class AlterWorkQueueStateTransitionsAddReferenceId < ActiveRecord::Migration
  def change
  	add_column :work_queue_state_transitions, :reference_type, :integer
  	add_column :work_queue_state_transitions, :reference_id, :integer
  end
end
