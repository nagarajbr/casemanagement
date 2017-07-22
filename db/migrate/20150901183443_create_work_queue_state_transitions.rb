class CreateWorkQueueStateTransitions < ActiveRecord::Migration
  def change
    create_table :work_queue_state_transitions do |t|
      t.references :work_queue, index: true
      t.string :namespace
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
  end
end
