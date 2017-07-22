class AssessmentStrength < ActiveRecord::Base
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

    def self.save_assessment_strength_detail(arg_assessment_id,arg_sub_section_id,arg_comments,arg_display_order)
    	l_assessment_strength = false
    	assessment_strength_collection = AssessmentStrength.where("client_assessment_id = ? and assessment_sub_section_id = ? and comments = ? ",arg_assessment_id,arg_sub_section_id,arg_comments)
    	if assessment_strength_collection.present?
    		assessment_strength_object = assessment_strength_collection.first
    		l_assessment_strength = true
    	else
    		assessment_strength_object = AssessmentStrength.new
    		l_assessment_strength = true
    	end
    	if l_assessment_strength == true
    		assessment_strength_object.client_assessment_id = arg_assessment_id
    		assessment_strength_object.assessment_sub_section_id = arg_sub_section_id
    		assessment_strength_object.comments = arg_comments
    		assessment_strength_object.display_order = arg_display_order
    		assessment_strength_object.save
    	end
    end

    def self.get_assessment_strengths(arg_assessment_id)
        where("client_assessment_id = ?",arg_assessment_id).order("id ASC")
    end

    # def self.get_assessment_sub_section_for_strengths(arg_assessment_id)
    #     step1 = AssessmentStrength.joins("INNER JOIN assessment_sub_sections ON assessment_sub_sections.id = assessment_strengths.assessment_sub_section_id")
    #     step2 = step1.where("assessment_strengths.client_assessment_id = ?",arg_assessment_id)
    #     step3 = step2.select("assessment_sub_sections.title")
    #     assessment_sub_section_title = step3.first
    #     return assessment_sub_section_title
    # end


end