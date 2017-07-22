class AssessmentSection < ActiveRecord::Base
	def self.get_assessed_sections_with_barriers(arg_assessment_id)
		step1 = AssessmentSection.joins("INNER JOIN assessment_barriers ON assessment_barriers.assessment_section_id =  assessment_sections.id")
		step2 = step1.where("assessment_barriers.client_assessment_id = ?",arg_assessment_id)
		step3 = step2.select("distinct assessment_sections.id,assessment_sections.title,assessment_sections.display_order").order("assessment_sections.display_order ASC")
		assessed_sections_collection = step3
		return assessed_sections_collection
	end


    def self.get_assessed_sub_sections_with_strengths(arg_assessment_id)
        step1 = AssessmentSection.joins("INNER JOIN assessment_sub_sections ON assessment_sub_sections.assessment_section_id =  assessment_sections.id
        								INNER JOIN assessment_strengths ON assessment_sub_sections.id =  assessment_strengths.assessment_sub_section_id")
        step2 = step1.where("assessment_strengths.client_assessment_id = ?",arg_assessment_id)
        step3 = step2.select("distinct assessment_sub_sections.id,assessment_sub_sections.title,
                              assessment_sub_sections.display_order").order("assessment_sub_sections.display_order ASC")
        assessed_sections_collection = step3
        return assessed_sections_collection
    end


    def self.get_assessed_sections_with_barriers_from_snapshot(arg_career_pathway_plan_id)
        step1 = AssessmentSection.joins("INNER JOIN assessment_barrier_cpp_snapshots ON assessment_barrier_cpp_snapshots.assessment_section_id =  assessment_sections.id")
        step2 = step1.where("assessment_barrier_cpp_snapshots.career_pathway_plan_id = ?",arg_career_pathway_plan_id)
        step3 = step2.select("distinct assessment_sections.id,assessment_sections.title,assessment_sections.display_order").order("assessment_sections.display_order ASC")
        assessed_sections_collection = step3
        return assessed_sections_collection
    end

end


