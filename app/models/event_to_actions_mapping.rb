class EventToActionsMapping < ActiveRecord::Base

   def self.get_actions_list_for_event_id(arg_event_id)
 		actions_collection = EventToActionsMapping.where("enable_flag = 'Y' and event_type = ?",arg_event_id).order("sort_order ASC")
 	end

end
