class AlterEventToActionsMappingsQueueType < ActiveRecord::Migration
  def change
  	add_column :event_to_actions_mappings, :queue_type, :integer
  end
end
