class NotesService

	def self.save_notes(arg_entity_type,
						arg_entity_id,
						arg_notes_type,
						arg_reference_id,
						arg_notes)
		if arg_reference_id.present?
			#arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id unique
			# notes_collection = Notes.where("entity_type= ? and
			# 								entity_id = ? and
			# 								notes_type = ? and
			# 								reference_id = ? ", arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id )
			# if notes_collection.present?
			# 	#Update existing record
			# 	notes_object = notes_collection.first
			# 	if arg_notes.present?
			# 		notes_object.notes = arg_notes
			# 	end
			# else
				#create a new record
				if arg_notes.present?
					notes_object = Notes.new
					notes_object.entity_type = arg_entity_type
					notes_object.entity_id = arg_entity_id
					notes_object.notes_type = arg_notes_type
					notes_object.reference_id = arg_reference_id
					notes_object.notes = arg_notes
				end
			# end
		else
			#arg_entity_type,arg_entity_id,arg_notes_type unique
			# notes_collection = Notes.where("entity_type= ? and
			# 								entity_id = ? and
			# 								notes_type = ? ", arg_entity_type,arg_entity_id,arg_notes_type)
			# if notes_collection.present?
			# 	#Update existing record
			# 	notes_object = notes_collection.first
			# 	if arg_notes.present?
			# 		notes_object.notes = arg_notes
			# 	end
			# else
				#create a new record
				if arg_notes.present?
					notes_object = Notes.new
					notes_object.entity_type = arg_entity_type
					notes_object.entity_id = arg_entity_id
					notes_object.notes_type = arg_notes_type
					notes_object.notes = arg_notes
				end
			# end
		end
		notes_object.save!
	end

	def self.get_notes(arg_entity_type,
						arg_entity_id,
						arg_notes_type,
						arg_reference_id)

		ls_notes =  " "
		if arg_reference_id.present?
			notes_collection = Notes.where("entity_type= ? and
											entity_id = ? and
											notes_type = ? and
											reference_id = ? ", arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id).order("created_at DESC")

		else
			notes_collection = Notes.where("entity_type= ? and
											entity_id = ? and
											notes_type = ?", arg_entity_type,arg_entity_id,arg_notes_type).order("created_at DESC")
		end
        #Rails.logger.debug("notes collection #{notes_collection.inspect}")
		if notes_collection.present?
		   #notes_collection.each do |nt|
		   	    #user_name = User.where("uid =?",nt.created_by).first.name
		   	    #time_n = Rails.ActionView.Helpers.DateHelper.time_ago_in_words(nt.created_at)
		   	    #note =  user_name +  " " + nt.created_at.to_s + "\n"+ nt.notes
				#ls_notes = ls_notes + "\n\n"+ note
				return notes_collection
		  #end
		end

        #Rails.logger.debug("notes #{ls_notes}")

		return ls_notes.strip
	end

	def self.delete_notes(arg_entity_type,
						arg_entity_id,
						arg_notes_type,
						arg_reference_id)
		if arg_reference_id.present?
			notes_collection = Notes.where("entity_type= ? and
											entity_id = ? and
											notes_type = ? and
											reference_id = ? ", arg_entity_type,arg_entity_id,arg_notes_type,arg_reference_id).order("created_at DESC")

			if notes_collection.present?
				notes_object = notes_collection.first
				notes_object.destroy
			end
		else
			notes_collection = Notes.where("entity_type= ? and
											entity_id = ? and
											notes_type = ?", arg_entity_type,arg_entity_id,arg_notes_type).order("created_at DESC")

			if notes_collection.present?
				notes_object = notes_collection.first
				notes_object.destroy
			end
		end
	end

	def self.get_notes_related_to_client(arg_client_id)
		if arg_client_id.present?
			step1 = Notes.joins("INNER JOIN codetable_items ON notes.notes_type = codetable_items.id
								 INNER JOIN system_params ON system_params.key = to_char(notes.notes_type, 'FM9999')")
			step2 = step1.where("entity_type= ? and entity_id = ? ", 6150,arg_client_id)
			step3 = step2.select("distinct codetable_items.long_description,notes.entity_type,notes.entity_id,codetable_items.long_description,system_params.value")
			step4 = step3.order("system_params.value ASC")
			return step4
		end
	end

	def self.get_notes_for_notes_type(arg_entity_type,arg_entity_id, arg_long_description)
		step1 = Notes.joins("INNER JOIN codetable_items ON notes.notes_type = codetable_items.id")
		step2 = step1.where("notes.entity_type= ? and notes.entity_id = ? and codetable_items.long_description =?", arg_entity_type,arg_entity_id,arg_long_description)
		step3 = step2.select("notes.*, codetable_items.long_description").order("notes.created_at DESC")
		return step3
	end

	def self.get_notes_based_on_entity_type_and_entity_id(arg_entity_type,arg_entity_id)
		if arg_entity_id.present?
			step1 = Notes.joins("INNER JOIN codetable_items ON notes.notes_type = codetable_items.id
								 INNER JOIN system_params ON system_params.key = to_char(notes.notes_type, 'FM9999')")
			step2 = step1.where("entity_type= ? and entity_id = ? ", arg_entity_type, arg_entity_id)
			step3 = step2.select("distinct codetable_items.long_description,notes.entity_type,notes.entity_id,codetable_items.long_description,system_params.value")
			step4 = step3.order("system_params.value ASC")
			return step4
		end
	end

end
