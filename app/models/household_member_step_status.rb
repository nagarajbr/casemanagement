class HouseholdMemberStepStatus < ActiveRecord::Base
	# test svn branch & merge
	# Manoj Patil 01/14/2016
	# Description: Manages to go to last Incomplete step in the client step intake process.

	# Household Registration steps
	# 1.household_member_demographics_step
	# 2.household_member_address_step
	# 3.household_member_citizenship_step
	# 4.household_member_education_step
	# 5.household_member_employments_step
	# 6.household_member_assessment_employment_step
	# 7.household_member_incomes_step
	# 8.household_member_unearned_incomes_step
	# 9.household_member_expenses_step
	# 10.household_member_resources_step
	# 11.household_member_relations_step


	# 1.
	def self.populate_all_steps_for_client(arg_client_id)
		# After client is created from HOusehold Intake page - all steps records are added.
		# check if steps are already populated.
		client_object = Client.find(arg_client_id)
		client_steps_collection = HouseholdMemberStepStatus.where("client_id = ?",arg_client_id)
		if client_steps_collection.blank?
			total_steps = 11
			for li in 1 .. total_steps

				if li == 4
					if client_object.dob.present?
	       				if Client.is_adult(client_object.id) == false
							# education step only for kids
							household_member_steps_object = HouseholdMemberStepStatus.new
							household_member_steps_object.client_id = arg_client_id
							household_member_steps_object.step = li
							household_member_steps_object.complete_flag = 'N'
							household_member_steps_object.step_partial = 'household_member_education_step'
							household_member_steps_object.step_name = 'Education'
						end
					else
						household_member_steps_object = HouseholdMemberStepStatus.new
						household_member_steps_object.client_id = arg_client_id
						household_member_steps_object.step = li
						household_member_steps_object.complete_flag = 'N'
						household_member_steps_object.step_partial = 'household_member_education_step'
						household_member_steps_object.step_name = 'Education'
					end

				elsif li == 6
					if client_object.dob.present?
	       				if Client.is_adult(client_object.id) == true
							# employment assessment only for adults
							household_member_steps_object = HouseholdMemberStepStatus.new
							household_member_steps_object.client_id = arg_client_id
							household_member_steps_object.step = li
							household_member_steps_object.complete_flag = 'N'
							household_member_steps_object.step_partial = 'household_member_assessment_employment_step'
							household_member_steps_object.step_name = 'Employment Assessment'
						end
					else
						household_member_steps_object = HouseholdMemberStepStatus.new
						household_member_steps_object.client_id = arg_client_id
						household_member_steps_object.step = li
						household_member_steps_object.complete_flag = 'N'
						household_member_steps_object.step_partial = 'household_member_assessment_employment_step'
						household_member_steps_object.step_name = 'Employment Assessment'
					end
				elsif li == 5
					if client_object.dob.present?
	       				if Client.is_adult(client_object.id) == true
							# employment assessment only for adults
							household_member_steps_object = HouseholdMemberStepStatus.new
							household_member_steps_object.client_id = arg_client_id
							household_member_steps_object.step = li
							household_member_steps_object.complete_flag = 'N'
							household_member_steps_object.step_partial = 'household_member_employments_step'
							household_member_steps_object.step_name = 'Employment'
						end
					else
						household_member_steps_object = HouseholdMemberStepStatus.new
						household_member_steps_object.client_id = arg_client_id
						household_member_steps_object.step = li
						household_member_steps_object.complete_flag = 'N'
						household_member_steps_object.step_partial = 'household_member_employments_step'
						household_member_steps_object.step_name = 'Employment'
					end

				else
					household_member_steps_object = HouseholdMemberStepStatus.new
					household_member_steps_object.client_id = arg_client_id
					household_member_steps_object.step = li
					household_member_steps_object.complete_flag = 'N'
					case li
						when 1
							household_member_steps_object.step_partial = 'household_member_demographics_step'
							household_member_steps_object.step_name = 'Demographic'
						when 2
							household_member_steps_object.step_partial = 'household_member_address_step'
							household_member_steps_object.step_name = 'Address'
						when 3
							household_member_steps_object.step_partial = 'household_member_citizenship_step'
							household_member_steps_object.step_name = 'Citizenship'
						# when 5
						# 	household_member_steps_object.step_partial = 'household_member_employments_step'
						# 	household_member_steps_object.step_name = 'Member Employment'
						when 7
							household_member_steps_object.step_partial = 'household_member_incomes_step'
							household_member_steps_object.step_name = 'Earned Income'
						# when 6
						# 	household_member_steps_object.step_partial = 'household_member_assessment_employment_step'
						# 	household_member_steps_object.step_name = 'Member Employment Assessment'

						when 8
							household_member_steps_object.step_partial = 'household_member_unearned_incomes_step'
							household_member_steps_object.step_name = 'Unearned Income'
						when 9
							household_member_steps_object.step_partial = 'household_member_expenses_step'
							household_member_steps_object.step_name = 'Expense'
						when 10
							household_member_steps_object.step_partial = 'household_member_resources_step'
							household_member_steps_object.step_name = 'Resource'
						when 11
							household_member_steps_object.step_partial = 'household_member_relations_step'
							household_member_steps_object.step_name = 'Relationship'
					end

				end


				household_member_steps_object.save!
			end
		end
	end

	# 2.
	# def self.update_one_step_for_client(arg_client_id,arg_step,arg_status_flag)
	# 	client_steps_collection = HouseholdMemberStepStatus.where("client_id = ? and step = ? ",arg_client_id,arg_step)
	# 	if client_steps_collection.present?
	# 		client_steps_object = client_steps_collection.first
	# 		client_steps_object.complete_flag = arg_status_flag
	# 		client_steps_object.save
	# 	end
	# end

	# 3.
	# def self.delete_all_steps_for_household(arg_household_id)
	# 	client_steps_collection = HouseholdMemberStepStatus.where("household_id = ?",arg_household_id)
	# 	if client_steps_collection.present?
	# 		client_steps_collection.destroy_all
	# 	end
	# end

	# 4.
	def self.steps_completed_for_client(arg_client_id)
		client_steps_collection = HouseholdMemberStepStatus.where("client_id = ?",arg_client_id)
		li_total_steps = client_steps_collection.size
		if client_steps_collection.present?
			total_steps = client_steps_collection.size
			complete_steps_collection = HouseholdMemberStepStatus.where("client_id = ? and complete_flag = 'Y' ",arg_client_id)
			if complete_steps_collection.present?
				li_completed_steps = complete_steps_collection.size
			else
				li_completed_steps = 0
			end
		else
			li_completed_steps = 0
		end
		ls_return_string = "#{li_completed_steps} of #{li_total_steps} completed"
		return ls_return_string
	end

	# 5.
	def self.update_relationship_step_for_all_clients_in_household(arg_household_id)
		household_client_collection = HouseholdMemberStepStatus.where("household_id = ? and step_partial = 'household_member_relations_step' ",arg_household_id)
		if household_client_collection.present?
			household_client_collection.each do |each_client_step|
				each_client_step.complete_flag = 'Y'
				each_client_step.save
			end
		end
	end


	# 6.
	def self.update_household_id_to_client_steps(arg_client_id,arg_household_id)
		client_steps_collection = HouseholdMemberStepStatus.where("client_id = ?",arg_client_id)
		if client_steps_collection.present?
			client_steps_collection.each do |each_step|
				each_step.household_id = arg_household_id
				each_step.save!
			end
		end
	end

	# 7.
	def self.get_first_incomplete_step_for_client(arg_client_id,arg_household_id)
		client_steps_collection = HouseholdMemberStepStatus.where("client_id = ? and household_id = ? and complete_flag in ('N','S') ",arg_client_id,arg_household_id).order("id ASC")
		if client_steps_collection.present?
			client_steps_object = client_steps_collection.first
			return client_steps_object.step_partial
		else
			return 'household_member_demographics_step'
		end

	end

	# 8.
	def self.get_steps_completed_for_client(arg_client_id,arg_household_id)
		client_steps_collection = HouseholdMemberStepStatus.where("client_id = ? and household_id = ? and complete_flag = 'Y' ",arg_client_id,arg_household_id)
		if client_steps_collection.present?
			li_steps_completed = client_steps_collection.size
		else
			li_steps_completed = 0
		end
		return li_steps_completed
	end

	# 9.
	def self.get_all_steps_for_client(arg_client_id,arg_household_id)
		client_steps_collection = HouseholdMemberStepStatus.where("client_id = ? and household_id = ? ",arg_client_id,arg_household_id)
		if client_steps_collection.present?
			li_all_steps = client_steps_collection.size
		else
			li_all_steps = 0
		end
		return li_all_steps
	end

	# 10.
	# def self.all_steps_for_household_complete?(arg_household_id)
	# 	household_steps_collection = HouseholdMemberStepStatus.where("household_id = ? and complete_flag = 'N'",arg_household_id)
	# 	if household_steps_collection.present?
	# 		return false
	# 	else
	# 		return true
	# 	end
	# end

	# 11.
	def self.collection_of_steps_for_given_household_client(arg_household_id,arg_client_id)
		household_steps_collection = HouseholdMemberStepStatus.where("household_id = ? and client_id = ?",arg_household_id,arg_client_id).order("step asc")
	end

	# 12. step status description
	def step_complete_flag_description
		ls_description = ' '
		if complete_flag.present?
			case complete_flag
			when 'Y'
				ls_description = "Complete"
			when 'N'
				ls_description = "Not Visited"
			when 'S'
				ls_description = "Skipped"
			when 'I'
				ls_description = "Incomplete"
			end
		end
		return ls_description
	end

	# 13.
	def self.update_one_step_for_client_given_step_partial(arg_client_id,arg_step_partial,arg_status_flag)
		check_client_steps_collection = HouseholdMemberStepStatus.where("client_id = ? and step_partial = ? and complete_flag = ?",arg_client_id,arg_step_partial,arg_status_flag)
		if check_client_steps_collection.blank?
			client_steps_collection = HouseholdMemberStepStatus.where("client_id = ? and step_partial = ? ",arg_client_id,arg_step_partial)
			if client_steps_collection.present?
				client_steps_object = client_steps_collection.first
				client_steps_object.complete_flag = arg_status_flag
				client_steps_object.save!
			end
		end

	end


	# 14.
	def self.update_relationship_step_for_all_clients_in_household_with_passed_status(arg_household_id,arg_status)
		household_client_collection = HouseholdMemberStepStatus.where("household_id = ? and step_partial = 'household_member_relations_step' ",arg_household_id)
		if household_client_collection.present?
			household_client_collection.each do |each_client_step|
				if each_client_step.complete_flag != arg_status
					each_client_step.complete_flag = "#{arg_status}"
					each_client_step.save
				end
			end
		end
	end

	def self.is_household_registration_complete_for_the_client(arg_client_id, arg_household_id)
		steps_completed = get_steps_completed_for_client(arg_client_id, arg_household_id)
		total_steps = get_all_steps_for_client(arg_client_id, arg_household_id)
		steps_completed == total_steps
	end


	def self.readjust_steps_after_dob_is_populated_or_changed(arg_client_id)
		# steps will be available in steps_status table - they need to removed based on adult/kid
		# if dob is not entered when client is created all 11 steps will be there.
		if Client.is_adult(arg_client_id)
			# adult
			# remove education
			# Rails.logger.debug(" adult true")
			education_step_collection = HouseholdMemberStepStatus.where("client_id = ? and step_partial = 'household_member_education_step'",arg_client_id )
			if education_step_collection.present?
				education_step_collection.destroy_all
			end
		else
			# Rails.logger.debug(" adult false")
			# child
			# remove assessment
			assessment_step_collection = HouseholdMemberStepStatus.where("client_id = ? and step_partial = 'household_member_assessment_employment_step'",arg_client_id )
			if assessment_step_collection.present?
				assessment_step_collection.destroy_all
			end
			# remove employment only if there are no employment record found for the client
			if Employment.where("client_id = ?",arg_client_id).blank?
				employment_step_collection = HouseholdMemberStepStatus.where("client_id = ? and step_partial = 'household_member_employments_step'",arg_client_id )
				if employment_step_collection.present?
					employment_step_collection.destroy_all
				end
			end
		end
	end


	def self.readjust_steps_after_child_has_salaried_employment_income(arg_client_id)
		# employment step should be available for child if he adds employment through income ..
		if Employment.where("client_id = ?",arg_client_id).present?
			employment_step_collection = HouseholdMemberStepStatus.where("client_id = ? and step_partial = 'household_member_employments_step'",arg_client_id )
				if employment_step_collection.blank?
					household_member_steps_object = HouseholdMemberStepStatus.new
					household_member_steps_object.client_id = arg_client_id
					household_member_steps_object.step = 5
					household_member_steps_object.complete_flag = 'N'
					household_member_steps_object.step_partial = 'household_member_employments_step'
					household_member_steps_object.step_name = 'Employment'
					household_member_steps_object.save
				end
		end
	end

	def self.update_household_id_to_client_steps_with_save_bang(arg_client_id,arg_household_id)
		client_steps_collection = HouseholdMemberStepStatus.where("client_id = ?",arg_client_id)
		if client_steps_collection.present?
			client_steps_collection.each do |each_step|
				each_step.household_id = arg_household_id
				each_step.save!
			end
		end
	end


end