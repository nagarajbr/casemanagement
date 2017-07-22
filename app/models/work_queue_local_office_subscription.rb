class WorkQueueLocalOfficeSubscription < ActiveRecord::Base
# Manoj Patil
# 09/09/2015
	 include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field

     def set_create_user_fields
	      user_id = AuditModule.get_current_user.uid
	      self.created_by = user_id
	      self.updated_by = user_id
	  end

	  def set_update_user_field
	      user_id = AuditModule.get_current_user.uid
	      self.updated_by = user_id
	  end


	HUMANIZED_ATTRIBUTES = {
        queue_type: "Queue",
        local_office_id: "Local Office"
    }


	def self.get_distinct_local_office_list_for_local_office_queues()
	  	# get distinct local offices order by name
	   	step1 = WorkQueueLocalOfficeSubscription.joins(" INNER JOIN codetable_items
	  		                                           ON  work_queue_local_office_subscriptions.local_office_id = codetable_items.id
	  		                                           ")
	   	step2 = step1.where("work_queue_local_office_subscriptions.queue_type in ( select codetable_items.id from codetable_items where codetable_items.code_table_id = 196 and codetable_items.active = 't')")
	   	step3 = step2.select("distinct work_queue_local_office_subscriptions.local_office_id,codetable_items.short_description").order("codetable_items.short_description ASC")
	  	return step3
	end

	def self.get_formatted_local_office_queues_for_local_office(arg_local_office_id)
	  	step1 = WorkQueueLocalOfficeSubscription.joins(" INNER JOIN codetable_items
	  													 ON work_queue_local_office_subscriptions.queue_type = 	codetable_items.id
	  													")
	  	step2 = step1.where("work_queue_local_office_subscriptions.local_office_id = ? and codetable_items.code_table_id = 196 and codetable_items.active = 't'",arg_local_office_id)
	  	step3 = step2.select("distinct work_queue_local_office_subscriptions.*,codetable_items.short_description").order("codetable_items.short_description ASC")
	  	# queue_collection = where("work_queue_local_office_subscriptions.local_office_id = ?",arg_local_office_id)
	  	queue_collection = step3
	  	queue_array = []
	  	ls_formatted_queue = " "
	  	if queue_collection.present?
	  		queue_collection.each do |each_queue|
	  			queue_array << each_queue.queue_type
	  		end
	  	end
	  	if queue_array.present?
	  		ls_formatted_queue = CommonUtil.get_comma_seperated_string_for_a_structure(queue_array)
	  	end
	  	return ls_formatted_queue
	end



	def self.get_local_office_queues(arg_local_office_id)
	  	queue_collection = where("work_queue_local_office_subscriptions.local_office_id = ?",arg_local_office_id)
	  	return queue_collection
	end

	def self.update_local_office_queue(arg_local_office_id,arg_queue_type)

		# Rules
		# if present in db nothing
		# if not present in db add
		# if queue present in db and having user subscription and not selected by user -error cannot deselect this as users are subscribed to this queue.
		step1 = WorkQueueLocalOfficeSubscription.joins("INNER JOIN codetable_items
	  													 ON work_queue_local_office_subscriptions.queue_type = 	codetable_items.id")
		local_office_queue_collection = step1.where("work_queue_local_office_subscriptions.local_office_id = ? and work_queue_local_office_subscriptions.queue_type = ? and codetable_items.code_table_id = 196 and codetable_items.active = 't'",arg_local_office_id,arg_queue_type)

		# local_office_queue_collection = WorkQueueLocalOfficeSubscription.where("local_office_id = ? and queue_type = ?",arg_local_office_id,arg_queue_type)
		if local_office_queue_collection.present?
		else
			#insert
			new_work_queue_local_office_subscription_object = WorkQueueLocalOfficeSubscription.new
			new_work_queue_local_office_subscription_object.queue_type = arg_queue_type
			new_work_queue_local_office_subscription_object.local_office_id = arg_local_office_id
			new_work_queue_local_office_subscription_object.save
		end
	end

	def self.user_subscriptions_found_for_this_location_queue?(arg_local_office_id,arg_queue_type)
		step1 = WorkQueueLocalOfficeSubscription.joins("INNER JOIN work_queue_user_subscriptions
			                                           ON (work_queue_local_office_subscriptions.local_office_id = work_queue_user_subscriptions.local_office_id
			                                           	   AND work_queue_local_office_subscriptions.queue_type = work_queue_user_subscriptions.queue_type)
														INNER JOIN codetable_items on work_queue_local_office_subscriptions.queue_type = codetable_items.id
			                                           	")
		step2 = step1.where("codetable_items.code_table_id = 196 and codetable_items.active = 't' and work_queue_local_office_subscriptions.local_office_id = ? and work_queue_local_office_subscriptions.queue_type = ?",arg_local_office_id,arg_queue_type)
		if 	step2.count > 0
			lb_return = true
		else
			lb_return = false
		end
		return lb_return
	end

	def self.user_subscriptions_found_for_local_office_queues?(arg_local_office_id)
		step1 = WorkQueueLocalOfficeSubscription.joins("INNER JOIN work_queue_user_subscriptions
			                                           ON (work_queue_local_office_subscriptions.local_office_id = work_queue_user_subscriptions.local_office_id
			                                           	   AND work_queue_local_office_subscriptions.queue_type = work_queue_user_subscriptions.queue_type)
														INNER JOIN codetable_items on work_queue_local_office_subscriptions.queue_type = codetable_items.id
			                                           	")
		step2 = step1.where("codetable_items.code_table_id = 196 and codetable_items.active = 't' and work_queue_local_office_subscriptions.local_office_id = ? ",arg_local_office_id)
		if 	step2.count > 0
			lb_return = true
		else
			lb_return = false
		end
		return lb_return
	end

end
