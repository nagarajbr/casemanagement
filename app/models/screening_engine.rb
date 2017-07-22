class ScreeningEngine < ActiveRecord::Base

	def self.get_rule_id(arg_srvc_pgm_id, arg_rule_category_id, arg_effective_beg_date)
		step1 = joins('INNER JOIN "rule_details" ON "rule_details"."rule_id" = "screening_engines"."rule_id"
      				INNER JOIN "service_programs" ON "service_programs"."id" = "screening_engines"."service_program_id"')
    	step2 = step1.where("screening_engines.service_program_id = ? and screening_engines.rule_category = ? and screening_engines.effective_begin_date <= ?", arg_srvc_pgm_id, arg_rule_category_id, arg_effective_beg_date)
    	step3 = step2.select("screening_engines.rule_category, screening_engines.service_program_id, screening_engines.rule_id, rule_details.code_table_id, rule_details.rule_grouping_id, screening_engines.rule_set_type,
							service_programs.title, screening_engines.effective_begin_date, screening_engines.effective_end_date")
    	step4 = step3.order(rule_id: :desc)
	end
end
