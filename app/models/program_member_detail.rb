class ProgramMemberDetail < ActiveRecord::Base
has_paper_trail :class_name => 'ProgramMembrDetilVersion',:on => [:update, :destroy]
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


    def self.get_program_member_detail_collection(arg_run_id,arg_month_sequence,arg_member_sequence)
    	member_object_collection = ProgramMemberDetail.where("run_id = ? and month_sequence = ? and member_sequence = ?",arg_run_id,arg_month_sequence,arg_member_sequence)

    end

    	def self.get_program_member_details(arg_last_run_id, arg_last_month_id, arg_last_member_id, arg_incexp_id, arg_bdm_row_indicator)
		where("run_id = ? and month_sequence = ? and member_sequence = ? and lastcalc_incexp_id = ? and bdm_row_indicator = ?",
			arg_last_run_id, arg_last_month_id, arg_last_member_id, arg_incexp_id, arg_bdm_row_indicator).
				select("calc_method_code, run_id, month_sequence, member_sequence, last_calc_month, bdm_row_indicator, lastcalc_incexp_id, dollar_amount")
	end

		def self.get_member_last_calc_details(arg_run_id, arg_month_seq, arg_member_seq, arg_lastcalc_incexp_id, arg_bdm_row_indicator)
		where("run_id = ? and month_sequence = ? and member_sequence = ? and lastcalc_incexp_id = ? and bdm_row_indicator = ?",
				arg_run_id, arg_month_seq, arg_member_seq, arg_lastcalc_incexp_id, arg_bdm_row_indicator).
			select("calc_method_code, run_id, month_sequence, member_sequence, last_calc_month, bdm_row_indicator, lastcalc_incexp_id, dollar_amount")
	end



	def self.get_member_unconverted_last_calc_details(arg_run_id, arg_item_type, arg_month_seq, arg_member_seq)
		where("run_id = ? and item_type = ? and month_sequence = ? and member_sequence = ?",
				arg_run_id, arg_item_type, arg_month_seq, arg_member_seq).
					select("calc_method_code, item_type, item_source, run_id, month_sequence, member_sequence, last_calc_month")
	end

	def self.get_member_details_by_run_id(arg_run_id, arg_month_seq)
		where("run_id = ? and month_sequence = ? ",arg_run_id, arg_month_seq)
	end

	def self.get_member_details_domain_code(arg_run_id, arg_month_seq, arg_member_seq, arg_indicator)
        step1 = joins("INNER JOIN program_benefit_members ON program_member_details.run_id = program_benefit_members.run_id and program_member_details.month_sequence = program_benefit_members.month_sequence and program_member_details.member_sequence = program_benefit_members.member_sequence
                     INNER JOIN program_month_summaries ON  program_member_details.run_id = program_month_summaries.run_id and program_member_details.month_sequence = program_month_summaries.month_sequence
                     INNER JOIN codetable_items ON codetable_items.code_table_id = 36 and program_member_details.item_type = codetable_items.id
                     ")
		step2 = step1.where("program_benefit_members.run_id = ? and program_benefit_members.month_sequence = ? and program_benefit_members.member_sequence = ? and program_member_details.bdm_row_indicator = ?",
				arg_run_id, arg_month_seq, arg_member_seq, arg_indicator)
		step3 = step2.select("program_member_details.id,program_member_details.item_type, program_member_details.dollar_amount,
			                  program_benefit_members.run_id,
			                  program_benefit_members.month_sequence, program_benefit_members.member_sequence,
			                  program_member_details.b_details_sequence, codetable_items.short_description")



	end

	def self.get_member_details_by_run_id_and_more(arg_run_id, arg_month_seq,arg_member_seq, arg_incexp_id, arg_bdm_row_indicator)
		where("run_id = ? and month_sequence = ? and member_sequence = ? and  lastcalc_incexp_id = ? and bdm_row_indicator = ?",
			  arg_run_id, arg_month_seq,           arg_member_seq,           arg_incexp_id, arg_bdm_row_indicator)
	end



end
