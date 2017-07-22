class WorkQueueUserSubscription < ActiveRecord::Base
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
        local_office_id: "Local Office",
        user_id: "User"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end


    # User workqueue subscription multi step form creation of data. - start

    attr_accessor :current_step,:process_object

    def steps
       %w[user_queue_subscription_first user_queue_subscription_second user_queue_subscription_last]
    end

    def current_step

      @current_step || steps.first
    end

    def next_step
      self.current_step = steps[steps.index(current_step)+1]
    end

    def previous_step
      self.current_step = steps[steps.index(current_step)-1]
    end

    def first_step?
      current_step == steps.first
    end

    def last_step?
      current_step == steps.last
    end


    def get_process_object
      self.process_object = steps[steps.index(current_step)-1]
    end


# User workqueue subscription multi step form creation of data. - - End



	def self.get_formatted_queues_for_user_and_location(arg_user_id,arg_local_office_id)
		step1 = WorkQueueUserSubscription.joins(" INNER JOIN codetable_items
	  											ON work_queue_user_subscriptions.queue_type = 	codetable_items.id
	  											")
	  	step2 = step1.where("work_queue_user_subscriptions.local_office_id = ? and work_queue_user_subscriptions.user_id = ? and codetable_items.code_table_id = 196 and codetable_items.active = 't' ",arg_local_office_id,arg_user_id)
	  	step3 = step2.select("work_queue_user_subscriptions.*,codetable_items.short_description").order("codetable_items.short_description ASC")
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


	def self.get_distinct_user_and_local_office_list_for_user_queues()
		step1 = WorkQueueUserSubscription.joins(" INNER JOIN users
	  		                                    ON work_queue_user_subscriptions.user_id = users.uid

	  		                                    INNER JOIN codetable_items
	  		                                    ON work_queue_user_subscriptions.queue_type = codetable_items.id
	  		                                   ")
	   	step2 = step1.where("codetable_items.code_table_id = 196 and codetable_items.active = 't' ")
	   	step3 = step2.select("distinct work_queue_user_subscriptions.user_id,
	   								   work_queue_user_subscriptions.local_office_id,
	   		                           users.name ||'(' ||users.uid || ')' as user_name").order("users.name ||'(' ||users.uid || ')' ASC")
	  	return step3
	end

	def self.get_distinct_local_offices_for_user_queues(arg_user_id)
		step1 = WorkQueueUserSubscription.joins("INNER JOIN codetable_items
												ON work_queue_user_subscriptions.queue_type = codetable_items.id")
		step2 = step1.where("user_id = ? and codetable_items.code_table_id = 196 and codetable_items.active = 't' ",arg_user_id)
		step3 = step2.select("distinct work_queue_user_subscriptions.local_office_id")
	end

	def self.get_subscribed_user_queues_for_local_office(arg_user_id,arg_local_office_id)
		where("work_queue_user_subscriptions.user_id = ? and work_queue_user_subscriptions.local_office_id = ?",arg_user_id,arg_local_office_id)
	end

	# def self.get_distinct_queues_subscribed_by_user(arg_user_id)
	# 	step1 = WorkQueueUserSubscription.joins("INNER JOIN codetable_items
	# 		                                    on work_queue_user_subscriptions.queue_type = codetable_items.id")
	# 	step2 = step1.where("user_id = ?",arg_user_id)
	# 	step3 = step2.select("distinct work_queue_user_subscriptions.queue_type,codetable_items.short_description").order("codetable_items.short_description ASC")
	# 	distinct_queue_collection = step3
	# 	return 	distinct_queue_collection
	# end

	# def self.get_all_users_in_the_local_office_of_the_supervisor(arg_supervisor_id, arg_queue_type)
	# 	# select distinct users.* from
	# 	# user_local_offices
	# 	# inner join work_queue_user_subscriptions
	# 	# on work_queue_user_subscriptions.local_office_id = user_local_offices.local_office_id
	# 	# inner join users on work_queue_user_subscriptions.user_id = users.id
	# 	# where user_local_offices.user_id = 1
	# 	# and work_queue_user_subscriptions.queue_type = 6557
	# 	step1 = WorkQueueUserSubscription.joins("inner join user_local_offices
	# 					on work_queue_user_subscriptions.local_office_id = user_local_offices.local_office_id
	# 					inner join users on work_queue_user_subscriptions.user_id = users.uid")
	# 	step2 = step1.where("user_local_offices.user_id = ? and work_queue_user_subscriptions.queue_type = ?",arg_supervisor_id, arg_queue_type)
	# 	step3 = step2.select("distinct users.*")
 #    end


    def self.get_distinct_queues_with_local_offices_subscribed_by_user(arg_user_id)
		step1 = WorkQueueUserSubscription.joins("INNER JOIN codetable_items queue_names on
			                                   (work_queue_user_subscriptions.queue_type = queue_names.id
			                                   	and queue_names.active = true
			                                   	and queue_names.code_table_id = 196)
			                                    INNER JOIN codetable_items local_office_names
			                                    on work_queue_user_subscriptions.local_office_id = local_office_names.id
			                                    ")
		step2 = step1.where("user_id = ?",arg_user_id)
		step3 = step2.select("distinct work_queue_user_subscriptions.queue_type,
									   work_queue_user_subscriptions.local_office_id,
			                           queue_names.short_description as queue_name,
			                           local_office_names.short_description as local_office_name,
			                           queue_names.sort_order
			                           ").order("queue_names.sort_order,local_office_names.short_description ASC")
		distinct_queue_collection = step3
		return 	distinct_queue_collection
	end

	def self.get_all_users_subscribed_to_given_queue_and_local_office(arg_queue_type,arg_local_office_id)
		step1 = WorkQueueUserSubscription.joins("INNER JOIN users
			                            on work_queue_user_subscriptions.user_id = users.uid")
		step2 = step1.where("work_queue_user_subscriptions.queue_type = ?
			                and work_queue_user_subscriptions.local_office_id = ?",arg_queue_type,arg_local_office_id)
		step3 = step2.select("distinct users.uid,
			                            users.name ||'(' || users.uid ||')' as name
			                 ").order("  users.name ||'(' || users.uid ||')' ASC")
		subscribed_users_in_location = step3
		return step3
	end

	def self.list_of_queues_for_user(arg_user_id,arg_office_id)
		step1 = WorkQueueUserSubscription.joins("INNER JOIN codetable_items
			                            on codetable_items.id = work_queue_user_subscriptions.queue_type")
		step2 = step1.where("work_queue_user_subscriptions.user_id = ?
								and work_queue_user_subscriptions.local_office_id = ?
								and codetable_items.code_table_id = 196 and codetable_items.active = 't' ",arg_user_id,arg_office_id)
		step3 = step2.select("work_queue_user_subscriptions.*")
		return step3
	end

end
