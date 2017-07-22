class CaseCreatorService
	# Author : Thirumal Gonuntala
	# Description: This service class is used create cases based on the household members

	# @adult_list = Array.new
	# @child_list = Array.new
	# @processed_list = Array.new
	# @adults_with_charaterstics = Array.new
	# @household_struct = HouseholdStruct.new
	# @household_struct.family_sequence = Array.new

	def self.find_related_adult_couples_with_children
		Rails.logger.debug("Processing Adults with spouse reationship having children")
		@adult_list.each do |adults|
			adult_spouse_list = Array.new
			family_members = Array.new
			unless @processed_list.include?(adults)
				@household_struct.family_sequence << @household_struct.family_sequence.size + 1
				family_struct = FamilyStruct.new # should go in family structure
			   	family_struct.case_scenario = "Adults with spouse reationship having children"
			    family_struct.case_type = 6047 # "Two Parent"
			    family_struct.number_of_members = 1
				@household_relationships.each do |adult_relation|
					if (adults == adult_relation.to_client_id && adult_relation.relationship_type == 5991 && parent_has_child_relationship(adults)) # spouse
						if adult_spouse_list.include?(adult_relation.from_client_id) == false
						    adult_spouse_list << adult_relation.from_client_id
						   	adult_struct = AdultStruct.new # should go in adults_struct  of family struct
						    adult_struct.minor_parent = false
						    adult_struct.parent_id = adult_relation.from_client_id
						    adult_struct.status = @client_status[adult_relation.from_client_id]
						   	#populate client processed
						   	@processed_list << adult_relation.from_client_id unless @processed_list.include?(adult_relation.from_client_id)
						   	#populate to count family members
						   	family_members << adult_relation.from_client_id unless family_members.include?(adult_relation.from_client_id)

						    @child_list.each do |child|
						      	@household_relationships.each do|child_relation|

		                          	if (child == child_relation.to_client_id && adult_relation.from_client_id == child_relation.from_client_id && child_relation.relationship_type == 6009) #child
		                          		child_struct = ChildrenStruct.new
		                          		child_struct.clientid = child
							          	adult_struct.children_struct << child_struct
							           	# populate client processed
							          	@processed_list << child unless @processed_list.include?(child)
							           	# populate to count family members
									   	family_members << child unless family_members.include?(child)

									    # check if the child has any children (minor parent) if exist put minor child as adult and

									   	# insert the minor child as parent if
					            		minor_adult_struct = AdultStruct.new # should go in adults_struct of family struct
					            		minor_adult_struct.minor_parent = true
					            		minor_adult_struct.parent_id = child
					            		minor_adult_struct.status = @client_status[child]

							            @household_relationships.each do|relation|
							            	if (child == relation.to_client_id && relation.relationship_type == 5977 )  #parent
							            		# insert the minor parent's child as child
							            		minor_parent_child = ChildrenStruct.new # should go in children_struct array of minor_adult_struct
							            		minor_parent_child.clientid =  relation.from_client_id
							            		minor_adult_struct.children_struct << minor_parent_child
											   	# populate client processed
									           	@processed_list << relation.from_client_id unless @processed_list.include?(relation.from_client_id)
									           	# populate to count family members
											   	family_members << relation.from_client_id unless family_members.include?(relation.from_client_id)
											end
										end
										family_struct.adults_struct << minor_adult_struct if minor_adult_struct.children_struct.count > 0
		                    	  	end
							 	end
							end
							family_struct.adults_struct << adult_struct if adult_struct.children_struct.count > 0
						end

						if adult_spouse_list.include?(adult_relation.to_client_id) == false
							adult_spouse_list << adult_relation.to_client_id
							adult_struct = AdultStruct.new # should go in adults_struct  of family struct
						    adult_struct.minor_parent = false
						    adult_struct.parent_id = adult_relation.to_client_id
						    adult_struct.status = @client_status[adult_relation.to_client_id]
						   	#populate client processed
						   	@processed_list << adult_relation.to_client_id unless @processed_list.include?(adult_relation.to_client_id)
						   	#populate to count family members
						   	family_members << adult_relation.to_client_id unless family_members.include?(adult_relation.to_client_id)

	                        @child_list.each do |child|
						    	@household_relationships.each do|child_relation|
		                          	if (child == child_relation.to_client_id && adult_relation.to_client_id == child_relation.from_client_id && child_relation.relationship_type == 6009) #child

		                          		child_struct = ChildrenStruct.new
		                          		child_struct.clientid = child
							          	adult_struct.children_struct << child_struct
							           	# populate client processed
							          	@processed_list << child unless @processed_list.include?(child)
							           	# populate to count family members
									   	family_members << child unless family_members.include?(child)

										# check if the child has any children (minor parent) if exist put minor child as adult and
										# insert the minor child as parent
										minor_adult_struct = AdultStruct.new # should go in adults_struct of family struct
					            		minor_adult_struct.minor_parent = true
					            		minor_adult_struct.parent_id = child
					            		minor_adult_struct.status = @client_status[child]

							            @household_relationships.each do|relation|
							            	if (child == relation.to_client_id && relation.relationship_type == 5977 )  #parent
							            		# insert the minor parent's child as child
							            		minor_parent_child = ChildrenStruct.new # should go in children_struct array of minor_adult_struct
							            		minor_parent_child.clientid =  relation.from_client_id
							            		minor_adult_struct.children_struct << minor_parent_child
											   	# populate client processed
									           	@processed_list << relation.from_client_id unless @processed_list.include?(relation.from_client_id)
									           	# populate to count family members
											   	family_members << relation.from_client_id unless family_members.include?(relation.from_client_id)
											end
										end
										family_struct.adults_struct << minor_adult_struct if minor_adult_struct.children_struct.count > 0
		                    	  	end
							 	end
							end
							family_struct.adults_struct << adult_struct if adult_struct.children_struct.count > 0
						end
					end
				end

			    if family_members.present?
			    	family_struct.number_of_members = family_members.size
			    	family_struct.members = family_members
			    	family_struct = populate_member_status(family_struct)
			    	@household_struct.family_structure << family_struct
				end
			end
		end
		# Rails.logger.debug("@household_struct = #{@household_struct.inspect}")
		# fail
		remove_minor_parent_and_minor_parent_children_from_processed_list
        # remove processed client
        processed_list
	end

	def self.find_related_minor_couples_with_children
        Rails.logger.debug("Processing Minors with spouse relationship and has children")
		@child_list.each do |adults|
			adult_spouse_list = Array.new
			family_members = Array.new
			@household_struct.family_sequence << @household_struct.family_sequence.size + 1
			family_struct = FamilyStruct.new # should go in family structure
		   	family_struct.case_scenario = "Minors with spouse relationship and has children"
		    family_struct.case_type = 6049 # "Minor Parent"
		    family_struct.number_of_members = 1
			@household_relationships.each do|adult_relation|
			 	if (adults == adult_relation.to_client_id && adult_relation.relationship_type == 5991 && parent_has_child_relationship(adults)) # spouse
			 		unless adult_spouse_list.include?(adult_relation.from_client_id)
			 		  	adult_spouse_list << adult_relation.from_client_id

			 		   	adult_struct = AdultStruct.new # should go in adults_struct  of family struct
			 		   	adult_struct.minor_parent = true
			 		    adult_struct.parent_id = adult_relation.from_client_id
					    adult_struct.status = @client_status[adult_relation.from_client_id]

			 		   	# populate client processed
					   	@processed_list << adult_relation.from_client_id unless @processed_list.include?(adult_relation.from_client_id)
					   	# populate to count family members
					   	family_members << adult_relation.from_client_id unless family_members.include?(adult_relation.from_client_id)

                        @child_list.each do |child|
				 		    @household_relationships.each do|child_relation|
	                           	if (child == child_relation.to_client_id && adult_relation.from_client_id == child_relation.from_client_id && child_relation.relationship_type == 6009) #child

				 		          	child_struct = ChildrenStruct.new
	                          		child_struct.clientid = child
						          	adult_struct.children_struct << child_struct
						           	# populate client processed
						          	@processed_list << child unless @processed_list.include?(child)
						           	# populate to count family members
								   	family_members << child unless family_members.include?(child)

				 		            # check if the child has any children (minor parent) if exist put minor child as adult

			 		            	# insert the minor child as parent if they have a child
				            		minor_adult_struct = AdultStruct.new # should go in adults_struct of family struct
				            		minor_adult_struct.minor_parent = true
				            		minor_adult_struct.parent_id = child
				            		minor_adult_struct.status = @client_status[child]

						            @household_relationships.each do|relation|
						            	if (child == relation.to_client_id && relation.relationship_type == 5977 )  # parent
										   # insert the minor parent's child as child
						            		minor_parent_child = ChildrenStruct.new # should go in children_struct array of minor_adult_struct
						            		minor_parent_child.clientid =  relation.from_client_id
						            		minor_adult_struct.children_struct << minor_parent_child
										   	# populate client processed
								           	@processed_list << relation.from_client_id unless @processed_list.include?(relation.from_client_id)
								           	# populate to count family members
										   	family_members << relation.from_client_id unless family_members.include?(relation.from_client_id)
										end
									end
									family_struct.adults_struct << minor_adult_struct if minor_adult_struct.children_struct.count > 0
	                     	  	end
				 			end
			 			end
			 			family_struct.adults_struct << adult_struct if adult_struct.children_struct.count > 0
			 		end

			 		# Creating adult structure for the spouse (second adult of among the parents) and subsequent minor parents if in case there is one

			 		unless adult_spouse_list.include?(adult_relation.to_client_id)
			 			adult_spouse_list << adult_relation.to_client_id
						adult_struct = AdultStruct.new # should go in adults_struct  of family struct
					    adult_struct.minor_parent = true
					    adult_struct.parent_id = adult_relation.to_client_id
					    adult_struct.status = @client_status[adult_relation.to_client_id]
					   	#populate client processed
					   	@processed_list << adult_relation.to_client_id unless @processed_list.include?(adult_relation.to_client_id)
					   	#populate to count family members
					   	family_members << adult_relation.to_client_id unless family_members.include?(adult_relation.to_client_id)


                        @child_list.each do |child|
				 		    @household_relationships.each do|child_relation|
	                           	if (child == child_relation.to_client_id && adult_relation.to_client_id == child_relation.from_client_id && child_relation.relationship_type == 6009) #child

				 		           	child_struct = ChildrenStruct.new
	                          		child_struct.clientid = child
						          	adult_struct.children_struct << child_struct
						           	# populate client processed
						          	@processed_list << child unless @processed_list.include?(child)
						           	# populate to count family members
								   	family_members << child unless family_members.include?(child)

				 		            # check if the child has any children (minor parent) if exist put minor child as adult and
				 		            # insert the minor child as parent
									minor_adult_struct = AdultStruct.new # should go in adults_struct of family struct
				            		minor_adult_struct.minor_parent = true
				            		minor_adult_struct.parent_id = child
				            		minor_adult_struct.status = @client_status[child]

						            @household_relationships.each do|relation|
						            	if (child == relation.to_client_id && relation.relationship_type == 5977)  # parent
						            		# insert the minor parent's child as child
						            		minor_parent_child = ChildrenStruct.new # should go in children_struct array of minor_adult_struct
						            		minor_parent_child.clientid =  relation.from_client_id
						            		minor_adult_struct.children_struct << minor_parent_child
										   	# populate client processed
								           	@processed_list << relation.from_client_id unless @processed_list.include?(relation.from_client_id)
								           	# populate to count family members
										   	family_members << relation.from_client_id unless family_members.include?(relation.from_client_id)
										end
									end
									family_struct.adults_struct << minor_adult_struct if minor_adult_struct.children_struct.count > 0
	                     	  	end
				 			end
			 			end
			 			family_struct.adults_struct << adult_struct if adult_struct.children_struct.count > 0
			 		end
			 	end #spouse check
			end

			if family_members.present?
		    	family_struct.number_of_members = family_members.size
		    	family_struct.members = family_members
		    	family_struct = populate_member_status(family_struct)
		    	@household_struct.family_structure << family_struct
			end
		end
		remove_minor_parent_and_minor_parent_children_from_processed_list
        # remove processed client
        processed_list
	end

	def self.find_non_related_adult_couples_with_common_children
		Rails.logger.debug("Processing Adults with non-spouse relationship and with common children")
		@adult_list.each do |adults|
			adult_spouse_list = Array.new
			family_members = Array.new
			@household_struct.family_sequence << @household_struct.family_sequence.size + 1
			family_struct = FamilyStruct.new # should go in family structure
		   	family_struct.case_scenario = "Adults with non-spouse relationship and with common children"
		    family_struct.case_type = 6047 # "Two Parent"
		    family_struct.number_of_members = 1
		    @household_relationships.each do|adult_relation|
		 		if adults == adult_relation.to_client_id && adult_relation.relationship_type != 5991 && @adult_list.include?(adult_relation.from_client_id) # not spouse

		 		  	@child_list.each do |child_check|

                      	if find_common_child_between_two_clients(adult_relation.to_client_id,adult_relation.from_client_id,child_check)
		 		 		 	unless adult_spouse_list.include?(adult_relation.from_client_id)
			 		 		 	unless @processed_list.include?(adult_relation.from_client_id)
									adult_spouse_list << adult_relation.from_client_id
									adult_struct = AdultStruct.new # should go in adults_struct  of family struct
								    adult_struct.minor_parent = false
								    adult_struct.parent_id = adult_relation.from_client_id
								    adult_struct.status = @client_status[adult_relation.from_client_id]
								   	# populate client processed
								   	@processed_list << adult_relation.from_client_id unless @processed_list.include?(adult_relation.from_client_id)
								   	# populate to count family members
								   	family_members << adult_relation.from_client_id unless family_members.include?(adult_relation.from_client_id)

								   	@child_list.each do |child|
								      	@household_relationships.each do|child_relation|

				                          	if (child == child_relation.to_client_id && adult_relation.from_client_id == child_relation.from_client_id && child_relation.relationship_type == 6009) # child

				                               	child_struct = ChildrenStruct.new
				                          		child_struct.clientid = child
									          	adult_struct.children_struct << child_struct
									           	# populate client processed
									          	@processed_list << child unless @processed_list.include?(child)
									           	# populate to count family members
											   	family_members << child unless family_members.include?(child)

									          	# check if the child has any children (minor parent) if exist put minor child as adult
									          	# insert the minor child as parent, if the minor child has a child
							            		minor_adult_struct = AdultStruct.new # should go in adults_struct of family struct
							            		minor_adult_struct.minor_parent = true
							            		minor_adult_struct.parent_id = child
							            		minor_adult_struct.status = @client_status[child]

									            @household_relationships.each do|relation|
									            	if (child == relation.to_client_id && relation.relationship_type == 5977 )  #parent

									            		# insert the minor parent's child as child
													   	minor_parent_child = ChildrenStruct.new # should go in children_struct array of minor_adult_struct
									            		minor_parent_child.clientid =  relation.from_client_id
									            		minor_adult_struct.children_struct << minor_parent_child
													   	# populate client processed
											           	@processed_list << relation.from_client_id unless @processed_list.include?(relation.from_client_id)
											           	# populate to count family members
													   	family_members << relation.from_client_id unless family_members.include?(relation.from_client_id)
													end
												end
												family_struct.adults_struct << minor_adult_struct if minor_adult_struct.children_struct.count > 0
				                    	  	end
									 	end
									end
									family_struct.adults_struct << adult_struct if adult_struct.children_struct.count > 0
								end
		 		 			end

							unless adult_spouse_list.include?(adult_relation.to_client_id)
								unless @processed_list.include?(adult_relation.to_client_id)
									adult_spouse_list << adult_relation.to_client_id
									adult_struct = AdultStruct.new # should go in adults_struct  of family struct
								    adult_struct.minor_parent = false
								    adult_struct.parent_id = adult_relation.to_client_id
								    adult_struct.status = @client_status[adult_relation.to_client_id]

								   	# populate client processed
								   	@processed_list << adult_relation.to_client_id unless @processed_list.include?(adult_relation.to_client_id)
								   	# populate to count family members
								   	family_members << adult_relation.to_client_id unless family_members.include?(adult_relation.to_client_id)

									@child_list.each do |child|
								      	@household_relationships.each do|child_relation|
				                          	if (child == child_relation.to_client_id && adult_relation.to_client_id == child_relation.from_client_id && child_relation.relationship_type == 6009) # child

									           	child_struct = ChildrenStruct.new
				                          		child_struct.clientid = child
									          	adult_struct.children_struct << child_struct
									           	# populate client processed
									          	@processed_list << child unless @processed_list.include?(child)
									           	# populate to count family members
											   	family_members << child unless family_members.include?(child)

									            # check if the child has any children (minor parent) if exist put minor child as adult and
									            # insert the minor child as parent
												minor_adult_struct = AdultStruct.new # should go in adults_struct of family struct
							            		minor_adult_struct.minor_parent = true
							            		minor_adult_struct.parent_id = child
							            		minor_adult_struct.status = @client_status[child]

									            @household_relationships.each do|relation|
									            	if (child == relation.to_client_id && relation.relationship_type == 5977) # parent
									            		# insert the minor parent's child as child
									            		minor_parent_child = ChildrenStruct.new # should go in children_struct array of minor_adult_struct
									            		minor_parent_child.clientid =  relation.from_client_id
									            		minor_adult_struct.children_struct << minor_parent_child
													   	# populate client processed
											           	@processed_list << relation.from_client_id unless @processed_list.include?(relation.from_client_id)
											           	# populate to count family members
													   	family_members << relation.from_client_id unless family_members.include?(relation.from_client_id)
													end
												end
												family_struct.adults_struct << minor_adult_struct if minor_adult_struct.children_struct.count > 0
				                    	  	end
				                      	end
									end
									family_struct.adults_struct << adult_struct if adult_struct.children_struct.count > 0
								end
							end
					  	end # common child check
		 			end # do child check
		 		end # spouse check
		 	end
		 	if family_members.present?
		    	family_struct.number_of_members = family_members.size
		    	family_struct.members = family_members
		    	family_struct = populate_member_status(family_struct)
		    	@household_struct.family_structure << family_struct
			end
	 	end

	 	remove_minor_parent_and_minor_parent_children_from_processed_list
        # remove processed client
        processed_list
	end

	def find_non_related_minor_couples_with_common_children
	end

	def self.find_single_adult_parent_with_children
		Rails.logger.debug(" Processing Single adult parent with children")
		family_array = []
		family = {}
		parent = []
		parents_with_children = []

        @child_list.each do |child|
         	@household_relationships.each do|child_relation|
	            if (child == child_relation.to_client_id && child_relation.relationship_type == 6009 && @adult_list.include?(child_relation.from_client_id))  #child
	                Rails.logger.debug(" #{child_relation.to_client_id} relation #{child_relation.relationship_type} to #{child_relation.from_client_id}")

	             	if parent.include?(child_relation.from_client_id) == false
	             	   parent << child_relation.from_client_id
	             	   Rails.logger.debug("#{parent.inspect}")
	             	end
	                if parents_with_children.include?(child_relation.from_client_id) == false
	             	   parents_with_children << child_relation.from_client_id
	                end
	            end
            end

			# family = { "#{child}" => parent }
			family[child] = parent
			family_array << family
			parent = []
		end

		# two_parent = false
		# i = 0
		# family_array.each do ||
		# 	if family_array[i].values_at(family_array[i].keys[0]).flatten.size > 1
		# 		two_parent = true
		# 		return
		# 	end
		# 	i += 1
		# end

		parent_list = Array.new

		parents_with_children.each do |adult|
			@household_struct.family_sequence << @household_struct.family_sequence.size + 1
			family_struct = FamilyStruct.new # should go in family structure
		   	family_struct.case_scenario = "Single adult parent with children"
		    family_struct.case_type = 6046 # "Single Parent"
		    family_struct.number_of_members = 1
           	family_members = Array.new
          	unless parent_list.include?(adult)
			   	parent_list << adult

			   	adult_struct = AdultStruct.new # should go in adults_struct  of family struct
			    adult_struct.minor_parent = false
			    adult_struct.parent_id = adult
			    adult_struct.status = @client_status[adult]
			   	# populate client processed
			   	@processed_list << adult unless @processed_list.include?(adult)
			   	# populate to count family members
			   	family_members << adult unless family_members.include?(adult)

			    @child_list.each do |child|
			      	@household_relationships.each do|child_relation|
                      	if (child == child_relation.to_client_id && adult == child_relation.from_client_id && child_relation.relationship_type == 6009) # child

                      		child_struct = ChildrenStruct.new
                      		child_struct.clientid = child
				          	adult_struct.children_struct << child_struct
				           	# populate client processed
				          	@processed_list << child unless @processed_list.include?(child)
				           	# populate to count family members
						   	family_members << child unless family_members.include?(child)

                           	# check if the child has any children (minor parent) if exist put minor child as adult
                       		# insert the minor child as parent
		            		minor_adult_struct = AdultStruct.new # should go in adults_struct of family struct
		            		minor_adult_struct.minor_parent = true
		            		minor_adult_struct.parent_id = child
		            		minor_adult_struct.status = @client_status[child]

				            @household_relationships.each do|relation|
				            	if (child == relation.to_client_id && relation.relationship_type == 5977 ) # parent
								   	# insert the minor parent's child as child
				            		minor_parent_child = ChildrenStruct.new # should go in children_struct array of minor_adult_struct
				            		minor_parent_child.clientid =  relation.from_client_id
				            		minor_adult_struct.children_struct << minor_parent_child
								   	# populate client processed
						           	@processed_list << relation.from_client_id unless @processed_list.include?(relation.from_client_id)
						           	# populate to count family members
								   	family_members << relation.from_client_id unless family_members.include?(relation.from_client_id)
								end
							end
							family_struct.adults_struct << minor_adult_struct if minor_adult_struct.children_struct.count > 0
                	  	end
				 	end
				end
				family_struct.adults_struct << adult_struct if adult_struct.children_struct.count > 0
			end

			if family_members.present?
		    	family_struct.number_of_members = family_members.size
		    	family_struct.members = family_members
		    	family_struct = populate_member_status(family_struct)
		    	@household_struct.family_structure << family_struct
			end
			# Rails.logger.debug("@household_struct.family_structure.last = #{@household_struct.family_structure.inspect}")
			add_parent_or_spouse_to_family_struct_as_inactive
			# Rails.logger.debug("-->@household_struct.family_structure.last = #{@household_struct.family_structure.inspect}")
			# fail
			# @household_struct.family_structure[@household_struct.family_structure.size - 1] = family_struct
		end
		# Rails.logger.debug("@household_struct = #{@household_struct.inspect}")
		# Rails.logger.debug("@household_struct.family_structure.last = #{@household_struct.family_structure.last.inspect}")
		# Rails.logger.debug("@household_struct.family_structure.last.adults_struct = #{@household_struct.family_structure.last.adults_struct.inspect}")
		# Rails.logger.debug("-->@household_struct.family_structure.last.adults_struct = #{@household_struct.family_structure.last.adults_struct.flatten.flatten}")
        # remove processed client
        remove_minor_parent_and_minor_parent_children_from_processed_list
      	processed_list
	end

	def self.find_single_minor_parent_with_children
        Rails.logger.debug(" Processing Single Minor parent with children")

		family_array = []
		family = {}
		parent = []
		parents_with_children = []

		@child_list.each do |child|
         	@household_relationships.each do|child_relation|
             	if (child == child_relation.to_client_id && child_relation.relationship_type == 6009 && @child_list.include?(child_relation.to_client_id) == true) #child
	             	if parent.include?(child_relation.from_client_id) == false && Client.is_child(child_relation.from_client_id)
	             	   	parent << child_relation.from_client_id
	             	end
	                # Even if there is parent child relationship make sure he is included in the child list, if he has any characteristics he will not be included in the list
	                if @child_list.include?(child_relation.from_client_id)
	                	parents_with_children << child_relation.from_client_id unless parents_with_children.include?(child_relation.from_client_id)
	                end
             	end
            end
			family[child] = parent
			family_array << family
	    end

        # two_parent = false
		# i = 0
		# family_array.each do ||
		# 	if family_array[i].values_at(family_array[i].keys[0]).flatten.size > 1
		# 		two_parent = true
		# 		return
		# 	end
		# 	i += 1
		# end

		parent_list = Array.new

		parents_with_children.each do |adult|
			@household_struct.family_sequence << @household_struct.family_sequence.size + 1
			family_struct = FamilyStruct.new # should go in family structure
		   	family_struct.case_scenario = "Single Minor parent with children"
		    family_struct.case_type = 6049 # "Minor Parent"
		    family_struct.number_of_members = 1
           	family_members = Array.new

			unless parent_list.include?(adult)
				parent_list << adult
				adult_struct = AdultStruct.new # should go in adults_struct  of family struct
			    adult_struct.minor_parent = true
			    adult_struct.parent_id = adult
			    adult_struct.status = @client_status[adult]
			   	# populate client processed
			   	@processed_list << adult unless @processed_list.include?(adult)
			   	# populate to count family members
			   	family_members << adult unless family_members.include?(adult)

			    @child_list.each do |child|
			      	@household_relationships.each do|child_relation|
	                  	if (child == child_relation.to_client_id && adult == child_relation.from_client_id && child_relation.relationship_type == 6009) # child


	                  		child_struct = ChildrenStruct.new
                      		child_struct.clientid = child
				          	adult_struct.children_struct << child_struct
				           	# populate client processed
				          	@processed_list << child unless @processed_list.include?(child)
				           	# populate to count family members
						   	family_members << child unless family_members.include?(child)

	                       	# check if the child has any children (minor parent) if exist put minor child as adult and
	                       	# insert the minor child as parent
		            		minor_adult_struct = AdultStruct.new # should go in adults_struct of family struct
		            		minor_adult_struct.minor_parent = true
		            		minor_adult_struct.parent_id = child
		            		minor_adult_struct.status = @client_status[child]

				            @household_relationships.each do|relation|
				            	if (child == relation.to_client_id && relation.relationship_type == 5977 )  #parent
				            		# insert the minor parent's child as child
				            		minor_parent_child = ChildrenStruct.new # should go in children_struct array of minor_adult_struct
				            		minor_parent_child.clientid =  relation.from_client_id
				            		minor_adult_struct.children_struct << minor_parent_child
								   	# populate client processed
						           	@processed_list << relation.from_client_id unless @processed_list.include?(relation.from_client_id)
						           	# populate to count family members
								   	family_members << relation.from_client_id unless family_members.include?(relation.from_client_id)
								end
							end
							family_struct.adults_struct << minor_adult_struct if minor_adult_struct.children_struct.count > 0
	            	  	end
				 	end
				end
				family_struct.adults_struct << adult_struct if adult_struct.children_struct.count > 0
			end

			if family_members.present?
		    	family_struct.number_of_members = family_members.size
		    	family_struct.members = family_members
		    	family_struct = populate_member_status(family_struct)
		    	@household_struct.family_structure << family_struct
			end
		end

        # remove processed client
        processed_list
	end

	def self.child_only_family
        Rails.logger.debug(" Processing Child without parents ")
		family_array = []
		family = {}
		parent = []
		children_without_parent = []

        @child_list.each do |child|
         	@household_relationships.each do|child_relation|
             	if (child == child_relation.to_client_id && child_relation.relationship_type == 6009 && @child_list.include?(child_relation.to_client_id) == true) # child
	             	if parent.include?(child_relation.from_client_id) == false
	             	   parent << child_relation.from_client_id
	             	end
             	end
            end
            if parent.present?
            	family[child] = parent
				family_array << family
            end
	    end

	    # i = 0
		# family_array.each do ||
		# 	children_without_parent << family_array[i].keys[0] if family_array[i].values_at(family_array[i].keys[0]).flatten.size == 0 && children_without_parent.include?(family_array[i].keys) == false
		# 	i += 1
		# end

       	caretaker_list = Array.new

       	if @child_list.present? # @child_list.size == children_without_parent.size
       		@household_struct.family_sequence[@household_struct.family_sequence.size] = @household_struct.family_sequence.size + 1
       		family_struct = FamilyStruct.new # should go in family structure
		   	family_struct.case_scenario = "Child without parents"
		    family_struct.case_type = 6048 # "Child Only Case"
		    family_struct.number_of_members = 1
           	family_members = Array.new

       		childlist = []
		   	@adult_list.each do |adult|
				unless caretaker_list.include?(adult)
				   	caretaker_list << adult

				   	adult_struct = AdultStruct.new # should go in adults_struct  of family struct
				    adult_struct.minor_parent = false
				    adult_struct.caretaker_id = adult
				    adult_struct.status = 4471 # "Inactive Closed"
				    @client_status[adult] = 4471 # "Inactive Closed"
				   	# populate client processed
				   	@processed_list << adult unless @processed_list.include?(adult)
				   	# populate to count family members
				   	family_members << adult unless family_members.include?(adult)

				   	@child_list.each do |child|
				   		child_struct = ChildrenStruct.new
                  		child_struct.clientid = child
			          	adult_struct.children_struct << child_struct
			           	# populate client processed
			          	@processed_list << child unless @processed_list.include?(child)
			           	# populate to count family members
					   	family_members << child unless family_members.include?(child)
					end
					# @household_struct.family_structure[@household_struct.family_structure.size - 1].adults_struct << adult_struct
					family_struct.adults_struct << adult_struct if adult_struct.children_struct.count > 0
				end
			end

			# childlist.each do |child|
			# 	family_members << child unless family_members.include?(child)
			# end

			@child_list.each do |client_id|
				unless family_members.include?(client_id)
					family_members << client_id
					@processed_list << client_id
				end
			end

			if family_members.present?
		    	family_struct.number_of_members = family_members.size
		    	family_struct.members = family_members
		    	family_struct = populate_member_status(family_struct)
		    	@household_struct.family_structure << family_struct
			end
			add_parent_or_spouse_to_family_struct_as_inactive
			# remove processed client
        	processed_list
       	else
   			return # Parent present its not a child only case
       	end
	end



	def self.determine_cases(arg_application_id, arg_screening_input)
		result = nil
		@adult_list = Array.new
		@child_list = Array.new
		@processed_list = Array.new
		@adults_with_charaterstics = Array.new

		@household_struct = HouseholdStruct.new
		# @household_struct.family_sequence = Array.new

		# @household_struct = FamilyTypeStruct.new
		# @household_struct.application_id = arg_application_id
		# @household_struct.family_type = 0
		# @household_struct.case_type = "Child Not Present"

		# minor_parent_case = false
		# clients_associated_with_household = HouseholdMember.get_household_members_with_client_info(arg_household_id)
		clients_associated_with_application = ApplicationMember.get_application_members_with_client_info(arg_application_id)
		# Rails.logger.debug("clients_associated_with_application = #{clients_associated_with_application.inspect}")
		# fail
		@members_list = clients_associated_with_application
		add_parents_and_their_household_members_if_not_included(arg_application_id)
		# Rails.logger.debug("@members_list = #{@members_list.inspect}")
		# fail
		mem_count = @members_list.size

		# @household_relationships = ClientRelationship.get_household_member_relationships(arg_household_id)
		client_ids = []
		@members_list.each do |member|
			client_ids << member.client_id
		end
		# Rails.logger.debug("#{client_ids}")
		# fail
		# @household_relationships = ClientRelationship.get_apllication_member_relationships(arg_application_id)
		@household_relationships = ClientRelationship.get_relationships_for_given_clients(client_ids)

		# if  @household_relationships.size.odd? and @members_list.size > 1
		if @household_relationships.size != (mem_count * (mem_count-1))
			Rails.logger.debug("Invalid Relationsship identfied")
            return "Relationships are not completely set up. Please navigate back to Houshold Relations to set up relationships."
        end


        # Rails.logger.debug("-->determine_cases arg_household_id = #{arg_household_id}")
       	@household_struct = run_familiy_type_rules()
       	# Rails.logger.debug("@household_struct before = #{@household_struct.inspect}")
       	# fail
       	# @household_struct.family_structure.each do |family_struct|
       	# 	family_struct.ineligible_codes[0] = []
       	# 	if family_struct.members.present?
       	# 		family_struct.members.each do |client_id|
	       # 			family_struct.ineligible_codes[client_id] = []
	       # 		end
       	# 	end
       	# end

       	# family_struct = @household_struct.family_structure[0]
       	# @household_struct.family_structure = []
       	# @household_struct.family_structure << family_struct
       	# @household_struct.family_structure.delete_at(1)
       	# Rails.logger.debug("@household_struct before = #{@household_struct.inspect}")
       	# fail
       	if arg_screening_input == true
       		result = CaseEligibilityDeterminationService.calculate_benefits_for_the_determined_case_types_screening_only(arg_application_id, @household_struct)
       	else
       		result = CaseEligibilityDeterminationService.calculate_benefits_for_the_determined_case_types(arg_application_id, arg_screening_input, @household_struct)
       	end
		return result
	end

	def self.run_familiy_type_rules()
			# Separating the childs and adults from the list of clients associated with the application.
		@client_status = {}
		@members_list.each do |client|
			age = get_age(client.dob)
			if age >= 18
				if age == 18
					dob = client.dob
					if dob.month == Date.today.month
						 @child_list << client.client_id unless @child_list.include?(client.client_id)
					else
						if client.characterstics.present? && client.characterstics != 4468
							@adults_with_charaterstics << client.client_id unless @adults_with_charaterstics.include?(client.client_id)
						else
							@adult_list << client.client_id unless @adult_list.include?(client.client_id)
						end
					end
				else
					if client.characterstics.present? && client.characterstics != 4468
						@adults_with_charaterstics << client.client_id unless @adults_with_charaterstics.include?(client.client_id)
					else
						@adult_list << client.client_id unless @adult_list.include?(client.client_id)
					end
				end
			elsif age != -1 && age < 18
				if @child_list.include?(client.client_id) == false
				   @child_list << client.client_id
				end
			end
			@client_status[client.client_id] = client.characterstics
		end
		# Rails.logger.debug("@members_list = #{@members_list.inspect}")
		# Rails.logger.debug("@adults_with_charaterstics = #{@adults_with_charaterstics.inspect}")
		# Rails.logger.debug("@adult_list = #{@adult_list.inspect}")
		# Rails.logger.debug("@child_list = #{@child_list.inspect}")
		# Rails.logger.debug("@client_status = #{@client_status.inspect}")
		# fail
		# start identfying case compositions
        # check for clients before executing the functions

        Rails.logger.debug("before find_related_adult_couples_with_children #{@adult_list.inspect}")
       	Rails.logger.debug("before find_related_adult_couples_with_children #{@child_list.inspect}")
       	# fail
        if (@child_list.present? && @adult_list.present? && @adult_list.size > 1 )
    	   find_related_adult_couples_with_children()
    	end
    	Rails.logger.debug("before find_related_minor_couples_with_children #{@adult_list.inspect}")
       	Rails.logger.debug("before find_related_minor_couples_with_children #{@child_list.inspect}")
	    if (@child_list.present? && @child_list.size > 0 )
		   	find_related_minor_couples_with_children
		end
		Rails.logger.debug("before find_non_related_adult_couples_with_common_children  #{@adult_list.inspect}")
       	Rails.logger.debug("before find_non_related_adult_couples_with_common_children #{@child_list.inspect}")

	    if (@child_list.present? && @adult_list.present? && @child_list.size > 0 && @adult_list.size > 0 )
		    find_non_related_adult_couples_with_common_children
       	end

       	Rails.logger.debug("before find_single_adult_parent_with_children #{@adult_list.inspect}")
       	Rails.logger.debug("before find_single_adult_parent_with_children #{@child_list.inspect}")

       	if (@child_list.present? && @adult_list.present? && @child_list.size > 0 && @adult_list.size > 0 )
		    find_single_adult_parent_with_children
        end
        Rails.logger.debug("before find_single_minor_parent_with_children #{@adult_list.inspect}")
       	Rails.logger.debug("before find_single_minor_parent_with_children #{@child_list.inspect}")

        if (@child_list.present?)# && @adult_list.present? && @child_list.size > 0 && @adult_list.size > 0 )
		    find_single_minor_parent_with_children
        end
        # Rails.logger.debug("@household_struct = #{@household_struct.inspect}")
        # fail
        Rails.logger.debug("before child_only_family #{@adult_list.inspect}")
       	Rails.logger.debug("before child_only_family #{@child_list.inspect}")

        # if (@child_list.present? && @adult_list.present? && @child_list.size > 0 && @adult_list.size > 0 )
    	if @child_list.present?
		    child_only_family
        end

        Rails.logger.debug("final adults list #{@adult_list.inspect}")
       	Rails.logger.debug("final child list  #{@child_list.inspect}")
       	@household_struct.unporcessed_adult_list = @adult_list
       	@household_struct.unporcessed_child_list = @child_list

       	# Rails.logger.debug("$$$$$ session[:APPLICATION_ID] = session[:APPLICATION_ID]")
       	# Rails.logger.debug("$$$$$ session[:HOUSEHOLD_ID] = session[:HOUSEHOLD_ID]")
       	# Rails.logger.debug("@household_struct = #{@household_struct.inspect}")
        return @household_struct



		# Rails.logger.debug("@household_struct = #{@household_struct.inspect}")
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

	def self.find_common_child_between_two_clients(arg_parent1,arg_parent2,arg_child)
		parent_list = Array.new
		parent_list << arg_parent1
		parent_list << arg_parent2
		count = 0
	    @household_relationships.each do|members|
		   if (arg_child == members.to_client_id && parent_list.include?(members.from_client_id) == true && members.relationship_type == 6009) #child
		   	  count = count + 1
		   end
	   	end
	    if count > 1
	   	  return true
	   	else
	   	  return false
	   	end
	end

	def self.parent_has_child_relationship(arg_parent)
		@household_relationships.each do|members|
		    if (arg_parent == members.from_client_id && @child_list.include?(members.to_client_id) == true && members.relationship_type == 6009) #child
		   		return true
		    end
	    end
	   	return false
	end

	def self.get_age(birthday)
	  	return -1 unless birthday
	  	now = Time.now.utc.to_date
	  	years = now.year - birthday.year
	  	years - (birthday.years_since(years) > now ? 1 : 0)
	end

	def self.processed_list
		child_list_temp = Array.new
		adult_list_temp = Array.new

		if @processed_list.present?
	        if @child_list.present?
		        child_list_temp = @child_list.reject! {|item| @processed_list.include? item}
		        if child_list_temp != nil
		           	@child_list = child_list_temp
		        end
		    end
	      	if @adult_list.present?
		        adult_list_temp = @adult_list.reject! {|item| @processed_list.include? item}
		        if adult_list_temp != nil
		         	@adult_list = adult_list_temp
		        end
	      	end
	 	end
	end

	def self.add_parents_and_their_household_members_if_not_included(arg_application_id)
		@new_members = []
		@members_list.each do |client|
			age = get_age(client.dob)
			if age >= 18
				# Adult
				# Step1: a. Get all child with parent relationship for the adult
				# 	   b. For each child get the adult with parent relationship
				# 	   c. Get the adult with spouse relationship and all the child for these parents
				child_list = get_all_children_with_child_relationship_for_the_adult(client.client_id)
				child_list.each do |child_id|
					parent_list = get_all_the_adults_with_parent_relationship_for_the_child(child_id)
					parent_list.each do |parent_id|
						get_all_children_with_child_relationship_for_the_adult(parent_id)
						spouse_record = ClientRelationship.get_the_spouse_relation_for_the_client(parent_id)
						if spouse_record.present?
							unless @new_members.include?(spouse_record.to_client_id)
								@new_members << spouse_record.to_client_id
								get_all_children_with_child_relationship_for_the_adult(spouse_record.to_client_id)
							end
						end
					end
					get_all_children_with_child_relationship_for_the_adult(child_id) # Get all the child for the minor parent child
				end
				spouse_record = ClientRelationship.get_the_spouse_relation_for_the_client(client.client_id)
				if spouse_record.present?
					unless @new_members.include?(spouse_record.to_client_id)
						@new_members << spouse_record.to_client_id
						get_all_children_with_child_relationship_for_the_adult(spouse_record.to_client_id)
					end
				end
			else
				# Child
				# Step1: a. Get all adults with parent relationship for the child
				# 	   b. For each adult get the adult with spouse relationship and child list
				# 	   c. For each child get the adults with parent relationships
				parent_list = get_all_the_adults_with_parent_relationship_for_the_child(client.client_id)
				# Rails.logger.debug("parent_list = #{parent_list.inspect}")
				# Rails.logger.debug("@new_members = #{@new_members.inspect}")
				# fail
				parent_list.each do |client_id|
					spouse_record = ClientRelationship.get_the_spouse_relation_for_the_client(client_id)
					if spouse_record.present?
						unless @new_members.include?(spouse_record.to_client_id)
							@new_members << spouse_record.to_client_id
							get_all_children_with_child_relationship_for_the_adult(spouse_record.to_client_id)
						end
					end
					child_list = get_all_children_with_child_relationship_for_the_adult(client_id)
					# Rails.logger.debug("child_list = #{child_list.inspect}")
					# Rails.logger.debug("@new_members = #{@new_members.inspect}")
					# fail
					child_list.each do |client_id|
						missing_parents_list = get_all_the_adults_with_parent_relationship_for_the_child(client_id)
						missing_parents_list.each do |client_id|
							get_all_children_with_child_relationship_for_the_adult(client_id)
						end
					end
				end
				get_all_children_with_child_relationship_for_the_adult(client.client_id) # Get all the child for the minor parent child
			end
		end
		# Rails.logger.debug("-->@members_list = #{@members_list.inspect}")
		# Rails.logger.debug("-->@new_members = #{@new_members.inspect}")
		# fail
		@new_members.each do |client_id|
			household_id = ClientApplication.get_household_id(arg_application_id)
			# Rails.logger.debug("household_id = #{household_id}")
			if household_id.present? && HouseholdMember.is_the_client_present_within_the_household(household_id, client_id)
				if @members_list.where("application_members.client_id = ?",client_id).blank?
					# members = Client.where("id=?",client_id)
					members = ApplicationMember.get_application_member_with_client_info(client_id)
					if members.present?
						# member = members.select("clients.last_name,clients.first_name,clients.id,clients.dob as dob, 'M' as characterstics").first
						member = members.first
						@members_list << member
					end
				end
			end
		end
		# Rails.logger.debug("-->final @members_list = #{@members_list.inspect}")
		# fail
	end

	def self.get_all_children_with_child_relationship_for_the_adult(arg_parent_id)
		client_relationships = ClientRelationship.get_child_collection_for_parent(arg_parent_id)
		child_list = []
		client_relationships.each do |relationship|
			unless @new_members.include?(relationship.to_client_id)
				@new_members << relationship.to_client_id
			end
			child_list << relationship.to_client_id
		end
		return child_list
	end

	def self.get_all_the_adults_with_parent_relationship_for_the_child(arg_child_id)
		client_relationships = ClientRelationship.get_parent_collection_for_child(arg_child_id)
		parent_list = []
		client_relationships.each do |relationship|
			unless @new_members.include?(relationship.to_client_id)
				@new_members << relationship.to_client_id
			end
			parent_list << relationship.to_client_id
		end
		return parent_list
	end

	def self.remove_minor_parent_and_minor_parent_children_from_processed_list
		# if there is a minor parent combination in a 2 parent or a 1 parent case, need to remove them from processed list, so that they can be chaecked for a minor parent case possibility
		if @processed_list.present?
			child_list_to_be_removed = []
			@processed_list.each do |client_id|
				if Client.is_child(client_id)
					child_list = ClientRelationship.get_child_collection_for_parent(client_id)
					child_list.each do |relationship|
						if @processed_list.include?(relationship.to_client_id)
							child_list_to_be_removed << relationship.to_client_id unless child_list_to_be_removed.include?(relationship.to_client_id)
							child_list_to_be_removed << client_id unless child_list_to_be_removed.include?(client_id)
						end
					end
				end
			end
			# Rails.logger.debug("@processed_list = #{@processed_list.inspect}")
			# Rails.logger.debug("child_list_to_be_removed = #{child_list_to_be_removed.inspect}")
			@processed_list = @processed_list - child_list_to_be_removed
			# Rails.logger.debug("@processed_list = #{@processed_list.inspect}")
			# @test = true
			# fail
		end
	end

	def self.add_parent_or_spouse_to_family_struct_as_inactive
		if @adults_with_charaterstics.present?
			added_adults = []
			@household_struct.family_structure.last.members.each do |client_id|
				@adults_with_charaterstics.each do |char_client_Id|
					@household_relationships.each do |relationship|
						if (client_id == relationship.from_client_id && relationship.relationship_type == 5977) || (relationship.relationship_type == 5991 && char_client_Id == relationship.from_client_id)
							# adult_struct = AdultStruct.new
							# adult_struct.parent_id = char_client_Id
							# adult_struct.status = 4469 # "Inactive Partial"
							# @household_struct.family_structure.last.adults_struct << adult_struct
							# @household_struct.family_structure.last.members << char_client_Id
							added_adults << char_client_Id unless added_adults.include?(char_client_Id)
							break
						end
					end
				end
			end
			if added_adults.present?
				added_adults.each do |client_id|
					adult_struct = AdultStruct.new
					adult_struct.parent_id = client_id
					adult_struct.status = @client_status[client_id] # 4469 - "Inactive Partial"
					@household_struct.family_structure.last.adults_struct << adult_struct
					@household_struct.family_structure.last.members << client_id
					@household_struct.family_structure.last.member_status[client_id] = @client_status[client_id]
				end
				@adults_with_charaterstics = @adults_with_charaterstics - added_adults
			end
		end
	end

	def self.populate_member_status(family_struct)
		family_struct.members.each do |client_id|
	        family_struct.active_members << client_id if @client_status[client_id] == 4468
	        family_struct.member_status[client_id] = @client_status[client_id]
  		end
  		return family_struct
	end
end