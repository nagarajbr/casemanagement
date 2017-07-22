class RubyElement < ActiveRecord::Base

	def self.get_primary(arg_role_id,arg_type)
			step1 = joins('INNER JOIN "ruby_element_reltns" ON "ruby_element_reltns"."parent_element_id" = "ruby_elements"."id"
				           INNER JOIN "access_rights" ON "access_rights"."ruby_element_id" = "ruby_elements"."id" ')
			step2 = step1.where("ruby_elements.element_type = ? and ruby_element_reltns.parent_element_id = ruby_element_reltns.child_element_id and  access_rights.role_id = ? and access_rights.access ='Y' ",arg_type,arg_role_id)
	    	# step3 = step2.order(id: :asc)
	    	step3 = step2.order("ruby_elements.parent_order asc")
	end

	def self.get_secondary(arg_parent_id,arg_role_id,arg_type )
			step1 = joins('INNER JOIN "ruby_element_reltns" ON "ruby_element_reltns"."child_element_id" = "ruby_elements"."id"
				           INNER JOIN "access_rights" ON "access_rights"."ruby_element_id" = "ruby_elements"."id"')

	      	step2 = step1.where("ruby_elements.element_type = ? and ruby_element_reltns.parent_element_id <> ruby_element_reltns.child_element_id and ruby_element_reltns.parent_element_id = ? and  access_rights.role_id = ? and access_rights.access ='Y' ",arg_type,arg_parent_id,arg_role_id)
	    	# step3 = step2.order(id: :asc)
	    	step3 = step2.order("ruby_element_reltns.child_order asc")
	end

	def self.get_ruby_element_id_for_field(arg_model_name, arg_field_name)
		record_id = nil
		records_collection = where("element_name = ? and element_title = ?",arg_model_name, arg_field_name)
		if records_collection.present?
			record_id = records_collection.first.id
		end
		return record_id
	end

end
