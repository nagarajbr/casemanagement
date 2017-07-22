namespace :codetable_task19 do
	desc "Setting up Characteristics Single table inheritance"
	task :field_update => :environment do
		CodetableItem.where(code_table_id: 112).update_all(type:"OtherCharacteristic")
		CodetableItem.where(code_table_id: 113).update_all(type:"WorkCharacteristic")
		CodetableItem.where(code_table_id: 114).update_all(type:"DisabilityCharacteristic")
		CodetableItem.where(code_table_id: 115).update_all(type:"HealthCharacteristic")
	end
end