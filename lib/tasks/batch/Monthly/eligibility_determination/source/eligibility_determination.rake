namespace :eligibility_determination do
	desc "Monthly ED Batch"

	# error_filename = "lib/tasks/batch/Monthly/eligibility_determination/results/errors_ed_batch_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
  	log_filename = "batch_results/monthly/eligibility_determination/results/log_ed_batch_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"

  	# error_path = File.join(Rails.root, error_filename )
	log_path = File.join(Rails.root, log_filename )

	# @error_file = File.new(error_path,"w+")
	@log_file = File.new(log_path,"w+")

	task :run_monthly_ed => :environment do
		@log_file.puts("Monthly ED Batch start")
		batch_user = User.where("uid = '555'").first
		AuditModule.set_current_user = (batch_user)

		open_program_units = get_open_program_units
		@log_file.puts("Number of open_program_units = #{open_program_units.count}")
		count = 0
		open_program_units.each do |program_unit|
			# if count > 15
			# run_eligibility_determination(program_unit.id)
			# 	if count == 25
			# 		break
			# 	end
			# end
			# count += 1
			# run_eligibility_determination(7534452)
			# break
		end
		run_eligibility_determination(7534455)
	end

	def get_open_program_units
		ProgramUnit.get_all_open_program_units
	end

	def run_eligibility_determination(arg_program_unit_id)
		result = "Program Unit id: #{arg_program_unit_id} "
		existing_program_wizard_record = ProgramWizard.get_latest_run_from_program_unit_id(arg_program_unit_id)
		if existing_program_wizard_record.present?
			result += "Last Run id: #{existing_program_wizard_record.run_id} "
			Rails.logger.debug("#{result}")
			# existing_program_wizard_record = existing_program_wizard_record.first
			# @log_file.puts("-->existing_program_wizard_record = #{existing_program_wizard_record.id}")
			new_program_wizard_record = ProgramWizard.new
			new_program_wizard_record.program_unit_id = existing_program_wizard_record.program_unit_id
			new_program_wizard_record.run_id = ProgramWizard.get_program_wizard_next_run_id
			new_program_wizard_record.run_month = existing_program_wizard_record.run_month + 1.month
			new_program_wizard_record.no_of_months = 1
			new_program_wizard_record.month_sequence = 1
			new_program_wizard_record.retain_ind = existing_program_wizard_record.retain_ind
			new_program_wizard_record.save
			result += "New Run id: #{new_program_wizard_record.run_id} "
			Rails.logger.debug("#{result}")
			# @log_file.puts("-->new_program_wizard_record = #{new_program_wizard_record.id}")
			existing_program_benefit_members = ProgramBenefitMember.get_program_benefit_members_from_run_id_and_month_sequence(existing_program_wizard_record.run_id, existing_program_wizard_record.month_sequence)
			existing_program_benefit_members.each do |pbm|
				ins_program_benefit_member = ProgramBenefitMember.new
				ins_program_benefit_member.program_wizard_id = new_program_wizard_record.id
				ins_program_benefit_member.client_id = pbm.client_id
				ins_program_benefit_member.member_sequence = pbm.member_sequence
				# Rails.logger.debug("-->arg_program_unit_id = #{arg_program_unit_id}")
				# Rails.logger.debug("-->pbm.client_id = #{pbm.client_id}")
				member_status = ProgramUnitMember.get_program_unit_member(arg_program_unit_id,pbm.client_id).member_status
				ins_program_benefit_member.member_status = member_status
				ins_program_benefit_member.run_id = new_program_wizard_record.run_id
				ins_program_benefit_member.month_sequence = 1
				ins_program_benefit_member.save
			end
			arg_service_program_id = ProgramUnit.get_service_program_id(arg_program_unit_id)
			arg_run_id = new_program_wizard_record.run_id
			arg_rule_id = ""
			if arg_service_program_id.to_i == 1
				arg_rule_id = 355
			elsif arg_service_program_id.to_i == 4
				arg_rule_id = 357
			end
			# Rails.logger.debug("BenefitCalculator begin")
			BenefitCalculator.sum_budget_cal(arg_service_program_id, arg_program_unit_id, arg_run_id, arg_rule_id)
			# Rails.logger.debug("BenefitCalculator end")

			program_wizard_hash = {}
			program_wizard_hash[:old_run_id] = existing_program_wizard_record.run_id
			program_wizard_hash[:old_month_sequence] = existing_program_wizard_record.month_sequence
			program_wizard_hash[:new_run_id] = new_program_wizard_record.run_id
			program_wizard_hash[:new_month_sequence] = new_program_wizard_record.month_sequence

			ret_hash = ProgramUnit.can_submit_program_run_id?(new_program_wizard_record.run_id,new_program_wizard_record.month_sequence)
			if ret_hash[:can_submit] == true
				msg = ProgramUnit.submit_payment(new_program_wizard_record.id)
				# if program_wizard_object.save
				if msg == "SUCCESS"
					# @log_file.puts("ProgramUnit Id: #{arg_program_unit_id} - Payment Complete")
					# @log_file.puts("ProgramUnit Id: #{arg_program_unit_id} - #{result}")
					result += "Payment Processed: Yes "
					result += "Benefit Amount: #{validate_results(program_wizard_hash)}"
				else
					# @error_file.puts("ProgramUnit Id1: #{arg_program_unit_id} - Ineligible - #{msg}")
					result += "Payment Processed: No "
					result += "Benefit Amount: Ineligible"
				end
				Rails.logger.debug("#{result}")
			else
				# @error_file.puts("ProgramUnit Id2: #{arg_program_unit_id} - Ineligible - #{ret_hash[:error_msg]}")
				result += "Payment Processed: No "
				result += "Benefit Amount: Ineligible"
				Rails.logger.debug("#{result}")
			end
		end
		Rails.logger.debug("#{result}")
		@log_file.puts("#{result}")
	end

	def self.validate_results(program_wizard_hash)
		result = ""
		old_pbd = ProgramBenefitDetail.get_program_benefit_detail_collection(program_wizard_hash[:old_run_id], program_wizard_hash[:old_month_sequence])
		new_pbd = ProgramBenefitDetail.get_program_benefit_detail_collection(program_wizard_hash[:new_run_id], program_wizard_hash[:new_month_sequence])
		if old_pbd.present? && new_pbd.present?
			old_pbd = old_pbd.first
			new_pbd = new_pbd.first
			if old_pbd.program_benefit_amount == new_pbd.program_benefit_amount
				result = "Same"
			elsif old_pbd.program_benefit_amount < new_pbd.program_benefit_amount
				result = "Increased"
			elsif old_pbd.program_benefit_amount > new_pbd.program_benefit_amount
				result = "Decreased"
			end
		end
		return result
	end
end