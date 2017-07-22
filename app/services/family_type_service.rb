class FamilyTypeService
	# Author : Kiran Chamarthi
	# Description: This service class is used to decide the family type of a parent child association within an application
	#  Modifications
	# Manoj 09/26/2014
	# Added Case Type Integer - since we will be storing casetype in Program Unit table.
	# Code table values for case type are
	# 	6049= "Minor Parent"
	# 6048 ="Child Only"
	# 6047 = "Two Parent"
	# 6046 =;"Single Parent"
	# # Manoj 09/29/2014
	#  Added method determine_family_type_for_program_unit


	def determine_family_type(arg_application_id)
		@family_type_struct = FamilyTypeStruct.new
		@family_type_struct.application_id = arg_application_id
		@family_type_struct.family_type = 0
		@family_type_struct.case_type = "Child Not Present"
		# minor_parent_case = false
		clients_associated_with_application = ApplicationMember.get_clients_list_for_the_application(arg_application_id)
		@family_type_struct.members_list = clients_associated_with_application
		#Rails.logger.debug("@family_type_struct.members_list = #{@family_type_struct.members_list.inspect}")
		run_familiy_type_rules()
		# @family_type_struct.family_type = family_type
		return @family_type_struct
	end

	def run_familiy_type_rules()
		adult_list = Array.new
		child_list = Array.new
		# Separating the childs and adults from the list of clients associated with the application.
		@family_type_struct.members_list.each do |client|
			age = Client.get_age(client.client_id)
			if age >= 18
				if age == 18
					dob = Client.get_client_dob(client.client_id)
					if dob.month == Date.today.month
						child_list << client.client_id
					else
						adult_list << client.client_id
					end
				else
					adult_list << client.client_id
				end				
			elsif age != -1 && age < 18
				child_list << client.client_id
			end
		end
		@family_type_struct.adult_list = adult_list
		@family_type_struct.child_list = child_list
		# Rails.logger.debug("adult_list = #{adult_list.inspect}")
		# Rails.logger.debug("child_list = #{child_list.inspect}")
		# Rails.logger.debug("child_list_count = #{child_list.count.inspect}")
		if child_list.count > 0
			# If there are more than one child associated with the application and no adult, check whther it's a minor parent case
			if child_list.count > 0 && adult_list.count == 0
				@family_type_struct.case_type = "Child Only Case"
				@family_type_struct.family_type = 1
				@family_type_struct.case_type_integer = 6048
				if child_list.count > 1
					minor_parent_case = is_this_a_minor_parent_case(child_list)
					if minor_parent_case
						@family_type_struct.case_type = "Minor Parent Case"
						@family_type_struct.case_type_integer = 6049
					end
				end
			else
				# If there is atleast one adult in the application then it can be a single parent case or a 2 parent case
				# Case type 2 parent case takes priority over single parent case and single parent case takes priority over minor parent case.
				if child_list.count > 0 && adult_list.count > 0
					child_list.each do |child|
						parents_list = get_parents_list(child,adult_list)
						#Rails.logger.debug("parents_list = #{parents_list.inspect}")
						# if child == 2878651
						# 	fail
						# end
						returned_family_type = 0
						if parents_list.count > 0
							# if there is at least one parent relationship with the child and the parent had a spouse relationship
							# with an adult in the family, then it's a two parent case
							parents_list.each do |parent_id|
								adult_list.each do |adult_id|
									if (parent_id != adult_id) && ClientRelationship.is_there_a_spouse_relationship_between_clients(parent_id,adult_id)
										@family_type_struct.case_type = "Two Parent Case"
										@family_type_struct.case_type_integer = 6047
										returned_family_type = 2
									end
								end
							end
							if returned_family_type != 2
								returned_family_type = get_family_type_from_parents_list(parents_list)
							end
						elsif adult_list.count > 0
							returned_family_type = get_family_type_from_adult_list(child, adult_list)
						end
						if returned_family_type > @family_type_struct.family_type || (returned_family_type == @family_type_struct.family_type && @family_type_struct.case_type != "Child Only Case")

							@family_type_struct.parents_list = parents_list
							@family_type_struct.child = child
							@family_type_struct.family_type = returned_family_type
						end
						#family_type = returned_family_type > family_type ? returned_family_type : family_type
						if @family_type_struct.family_type == 2
							break
						end
					end

					# Rails.logger.debug("@family_type_struct.case_type = #{@family_type_struct.case_type}")
					# Rails.logger.debug("@family_type_struct.family_type = #{@family_type_struct.family_type}")
					# fail
					if @family_type_struct.family_type == 0 || @family_type_struct.case_type == "Child Only Case"
						minor_parent_case = is_this_a_minor_parent_case(child_list)
						if minor_parent_case
							# child_list.each do |child|
							# 	child_list.each do |parent|
							# 		if ClientRelationship.is_there_a_child_parent_relationship_between_clients(child,parent)
							# 			@family_type_struct.case_type = "Minor Parent Case"
							# 			@family_type_struct.case_type_integer = 6049
							# 			family_type = 1
							# 			break
							# 		end
							# 	end
							# end
							@family_type_struct.family_type = 1
						end
					end
					# Code changes done to provide a quick fix for one of the bugs found, should be revisited.
					# if @family_type_struct.case_type == "Child Only Case"
					# 	@family_type_struct.family_type = 1
					# end
				else # child count > 0 and adult count is 0, this is a child only case
					@family_type_struct.case_type = "Child Only Case"
					@family_type_struct.family_type = 1
					@family_type_struct.case_type_integer = 6048
				end
			end
		end
		# Rails.logger.debug("@family_type_struct = #{@family_type_struct.inspect}")
	end

	def get_parents_list(child,adult_list)
		parents_list = Array.new
		adult_list.each do |parent|
			if ClientRelationship.is_there_a_child_parent_relationship_between_clients(child,parent)
				parents_list << parent
			end
		end
		return parents_list
	end

	def get_family_type_from_parents_list(parents_list)
		family_type = 0
		if parents_list.count == 1 || parents_list.count == 2
			if parents_list.count == 1 && @family_type_struct.family_type <= 1
				# Rails.logger.debug("parents_list.count == 1 && @family_type_struct.family_type <= 1 is true")
				@family_type_struct.case_type = "Single Parent Case"
				@family_type_struct.case_type_integer = 6046
				family_type = 1
			else
				# if ClientRelationship.is_there_a_spouse_relationship_between_clients(parents_list[0],parents_list[1])
					@family_type_struct.case_type = "Two Parent Case"
					@family_type_struct.case_type_integer = 6047
					family_type = 2
				# end
			end
		else
			family_type = 0
		end
		# Rails.logger.debug("family_type ---> #{family_type}")
		return family_type
	end

	def get_family_type_from_adult_list(arg_child, arg_adult_list)
		family_type = 0
		arg_adult_list.each do |adult|
			if ClientRelationship.is_there_a_relationship_between_clients(arg_child, adult) && @family_type_struct.family_type == 0
				@family_type_struct.case_type = "Child Only Case"
				@family_type_struct.case_type_integer = 6048
				family_type = 1
				break
			end
		end
		return family_type
	end

	def is_this_a_minor_parent_case(child_list)
		minor_parent_case_result = false
		child_list.each do |child|
			child_list.each do |parent|
				if ClientRelationship.is_there_a_child_parent_relationship_between_clients(child,parent)
					minor_parent_case_result = true
					parents_list = Array.new
					parents_list << parent
					@family_type_struct.parents_list = parents_list
					@family_type_struct.child = child
					@family_type_struct.minor_parent_case = minor_parent_case_result
					@family_type_struct.case_type = "Minor Parent Case"
					@family_type_struct.case_type_integer = 6049
					break
				end
			end
		end
		return minor_parent_case_result
	end


	# Manoj - 09/29/2014.
	def determine_family_type_for_program_unit(arg_program_unit_id)
		@family_type_struct = FamilyTypeStruct.new
		@family_type_struct.program_unit_id = arg_program_unit_id
		l_program_unit_object = ProgramUnit.find(arg_program_unit_id)
		@family_type_struct.service_program_id = l_program_unit_object.service_program_id
		@family_type_struct.application_id = l_program_unit_object.client_application_id

		@family_type_struct.family_type = 0
		@family_type_struct.case_type = "Child Not Present"
		minor_parent_case = false
		clients_associated_with_program_unit = ProgramUnitMember.get_active_program_unit_members(arg_program_unit_id)

		@family_type_struct.members_list = clients_associated_with_program_unit
		run_familiy_type_rules()
		# adult_list = Array.new
		# child_list = Array.new
		# # Separating the childs and adults from the list of clients associated with the application.
		# clients_associated_with_program_unit.each do |client|
		# 	age = Client.get_age(client.client_id)
		# 	if age >= 18
		# 		adult_list << client.client_id
		# 	elsif age != -1 && age < 18
		# 		child_list << client.client_id
		# 	end
		# end
		# Rails.logger.debug("adult_list = #{adult_list.inspect}")
		# Rails.logger.debug("child_list = #{child_list.inspect}")
		# @family_type_struct.adult_list = adult_list
		# @family_type_struct.child_list = child_list
		# if child_list.count > 0
		# 	# If there are more than one child associated with the application and no adult, check whther it's a minor parent case
		# 	if child_list.count > 1 && adult_list.count == 0
		# 		minor_parent_case = is_this_a_minor_parent_case(child_list)
		# 		if minor_parent_case
		# 			@family_type_struct.family_type = 1
		# 			@family_type_struct.case_type = "Minor Parent Case"
		# 			@family_type_struct.case_type_integer = 6049

		# 		end
		# 	else
		# 		# If there is atleast one adult in the application then it can be a single parent case or a 2 parent case
		# 		# Case type 2 parent case takes priority over single parent case and single parent case takes priority over minor parent case.
		# 		if child_list.count > 0 && adult_list.count > 0
		# 			child_list.each do |child|
		# 				parents_list = get_parents_list(child,adult_list)
		# 				Rails.logger.debug("parents_list = #{parents_list.inspect}")
		# 				returned_family_type = 0
		# 				if parents_list.count > 0
		# 					returned_family_type = get_family_type_from_parents_list(parents_list)
		# 				elsif adult_list.count > 0
		# 					returned_family_type = get_family_type_from_adult_list(child, adult_list)
		# 				end
		# 				# Rails.logger.debug("returned_family_type = #{returned_family_type}")
		# 				# Rails.logger.debug("family_type = #{family_type}")
		# 				# if child == 2885600
		# 				# 	fail
		# 				# end
		# 				if returned_family_type > @family_type_struct.family_type
		# 					@family_type_struct.parents_list = parents_list
		# 					@family_type_struct.child = child
		# 					@family_type_struct.family_type = returned_family_type
		# 				end
		# 				#family_type = returned_family_type > family_type ? returned_family_type : family_type
		# 				if @family_type_struct.family_type == 2
		# 					break
		# 				end
		# 			end
		# 			# Code changes done to provide a quick fix for one of the bugs found, should be revisited.
		# 			if @family_type_struct.case_type == "Child Only Case"
		# 				@family_type_struct.family_type = 1
		# 			end
		# 			if @family_type_struct.family_type == 0
		# 				minor_parent_case = is_this_a_minor_parent_case(child_list)
		# 				if minor_parent_case
		# 					child_list.each do |child|
		# 						child_list.each do |parent|
		# 							if ClientRelationship.is_there_a_child_parent_relationship_between_clients(child,parent)
		# 								@family_type_struct.case_type = "Minor Parent Case"
		# 								@family_type_struct.case_type_integer = 6049
		# 								@family_type_struct.family_type = 1
		# 								break
		# 							end
		# 						end
		# 					end
		# 				end
		# 			end
		# 		end
		# 	end
		# end
		# @family_type_struct.family_type = family_type
		# Rails.logger.debug("-->family_type = #{family_type}")
		# fail

		return @family_type_struct
	end

	def determine_family_type_for_program_wizard(arg_program_wizard_id)
		@family_type_struct = FamilyTypeStruct.new
		@family_type_struct.program_wizard_id = arg_program_wizard_id
		@family_type_struct.application_id = ProgramWizard.get_application_id_from_program_wizard_id(arg_program_wizard_id)
		l_program_wizard_obj = ProgramWizard.find(arg_program_wizard_id)
		l_program_unit_object = ProgramUnit.find(l_program_wizard_obj.program_unit_id)
		@family_type_struct.service_program_id = l_program_unit_object.service_program_id
		@family_type_struct.program_unit_id =  l_program_unit_object.id
		@family_type_struct.family_type = 0
		@family_type_struct.case_type = "Child Not Present"
		minor_parent_case = false
		# clients_associated_with_program_wizard = ProgramBenefitMember.get_program_benefit_memebers_from_wizard_id(arg_program_wizard_id)
		clients_associated_with_program_wizard = ProgramBenefitMember.get_active_program_benefit_memebers_from_wizard_id(arg_program_wizard_id)
		@family_type_struct.members_list = clients_associated_with_program_wizard
		# Rails.logger.debug("@family_type_struct.members_list = #{@family_type_struct.members_list.inspect}")
		run_familiy_type_rules()
		# adult_list = Array.new
		# child_list = Array.new
		# # Separating the childs and adults from the list of clients associated with the application.
		# clients_associated_with_program_wizard.each do |client|
		# 	age = Client.get_age(client.client_id)
		# 	if age >= 18
		# 		adult_list << client.client_id
		# 	elsif age != -1 && age < 18
		# 		child_list << client.client_id
		# 	end
		# end
		# @family_type_struct.adult_list = adult_list
		# @family_type_struct.child_list = child_list

		# if child_list.count > 0
		# 	# If there are more than one child associated with the application and no adult, check whther it's a minor parent case
		# 	if child_list.count > 1 && adult_list.count == 0
		# 		minor_parent_case = is_this_a_minor_parent_case(child_list)
		# 		if minor_parent_case
		# 			@family_type_struct.family_type = 1
		# 			@family_type_struct.case_type = "Minor Parent Case"
		# 			@family_type_struct.case_type_integer = 6049

		# 		end
		# 	else
		# 		# If there is atleast one adult in the application then it can be a single parent case or a 2 parent case
		# 		# Case type 2 parent case takes priority over single parent case and single parent case takes priority over minor parent case.
		# 		if child_list.count > 0 && adult_list.count > 0
		# 			child_list.each do |child|
		# 				parents_list = get_parents_list(child,adult_list)
		# 				returned_family_type = 0
		# 				if parents_list.count > 0
		# 					returned_family_type = get_family_type_from_parents_list(parents_list)
		# 				elsif adult_list.count > 0
		# 					returned_family_type = get_family_type_from_adult_list(child, adult_list)
		# 				end
		# 				if returned_family_type > @family_type_struct.family_type
		# 					@family_type_struct.parents_list = parents_list
		# 					@family_type_struct.child = child
		# 					@family_type_struct.family_type = returned_family_type
		# 				end
		# 				#family_type = returned_family_type > family_type ? returned_family_type : family_type
		# 				if @family_type_struct.family_type == 2
		# 					break
		# 				end
		# 			end
		# 			# Code changes done to provide a quick fix for one of the bugs found, should be revisited.
		# 			if @family_type_struct.case_type == "Child Only Case"
		# 				@family_type_struct.family_type = 1
		# 			end
		# 			if @family_type_struct.family_type == 0
		# 				minor_parent_case = is_this_a_minor_parent_case(child_list)
		# 				if minor_parent_case
		# 					child_list.each do |child|
		# 						child_list.each do |parent|
		# 							if ClientRelationship.is_there_a_child_parent_relationship_between_clients(child,parent)
		# 								@family_type_struct.case_type = "Minor Parent Case"
		# 								@family_type_struct.case_type_integer = 6049
		# 								@family_type_struct.family_type = 1
		# 								break
		# 							end
		# 						end
		# 					end
		# 				end
		# 			end
		# 		end
		# 	end
		# end
		#@family_type_struct.family_type = family_type
		return @family_type_struct
	end


end