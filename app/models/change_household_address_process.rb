class ChangeHouseholdAddressProcess < ActiveRecord::Base
	# MANOJ PATIL 03/31/2015
	# address change process table - to make sure all 2/3 steps are complete - process
	#


	 # 03/17/2016 - Manoj Patil - step process start
     attr_writer :current_step,:process_object

    def steps
      %w[
          household_new_address_step
          household_members_moving_to_new_address_step
        ]
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

  # 03/17/2016 - Manoj Patil - step process end



# 1.
  def self.initialize_change_household_address_processes(arg_household_id,arg_current_address_id)
  	# Goal: for a given household_id - there will be only one current_address_id and new_address_id record will be there.
	  	# delete new_address and their dependent records  --
	  	# record in this table indicates user did not complete all steps -
	  	# This process - all steps complete or Nothing is complete logic

	  	new_address_collection_for_household = ChangeHouseholdAddressProcess.where("household_id = ?",arg_household_id)
	  	if new_address_collection_for_household.present?
	  		new_address_collection_for_household.each do |each_address|
	  			if each_address.new_address_id?
		  			# delete entity_address if present
					EntityAddress.where("entity_type = 6150 and address_id = ?",each_address.new_address_id).destroy_all
					# delete address
					Address.where("id = ?",each_address.new_address_id).destroy_all
				end
	  		end
	  		new_address_collection_for_household.destroy_all
	  	end

	  	# insert record with current_address_id
	  	change_household_address_process_object = ChangeHouseholdAddressProcess.new
	  	change_household_address_process_object.household_id = arg_household_id
	  	change_household_address_process_object.current_address_id = arg_current_address_id
	  	change_household_address_process_object.process_completed = 'N'
	  	change_household_address_process_object.save
  end

  # 2.
  	def self.update_new_address_id_for_household(arg_household_id,arg_new_address_id)
  		address_collection = ChangeHouseholdAddressProcess.where("household_id = ?",arg_household_id)
  		if address_collection.present?
  			change_household_address_process_object = address_collection.first
  			change_household_address_process_object.new_address_id = arg_new_address_id
  			change_household_address_process_object.save
  		end
  	end

  	# 3.
  	def self.clear_orphan_address_records(arg_household_id)
  		new_address_collection_for_household = ChangeHouseholdAddressProcess.where("household_id = ?",arg_household_id)
	  	if new_address_collection_for_household.present?
	  		new_address_collection_for_household.each do |each_address|
	  			if each_address.new_address_id?
		  			# delete entity_address if present
					EntityAddress.where("entity_type = 6150 and address_id = ?",each_address.new_address_id).destroy_all
					# delete address
					Address.where("id = ?",each_address.new_address_id).destroy_all
				end
	  		end
	  		new_address_collection_for_household.destroy_all
	  	end
  	end

  	# 4.
  	def self.get_current_address_object_for_household(arg_household_id)
  		change_household_address_process_object = ChangeHouseholdAddressProcess.where("household_id = ?",arg_household_id).first
  		current_address_object = Address.find(change_household_address_process_object.current_address_id)
  		return current_address_object
  	end

  	# 5.
  	def self.clear_process_records_for_household(arg_household_id)
  		ChangeHouseholdAddressProcess.where("household_id = ?",arg_household_id).destroy_all
  	end





end
