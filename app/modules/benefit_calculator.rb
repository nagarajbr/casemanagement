
class BenefitCalculator #< RuleModule::Rule
@rule_id = 0
@ids_countable_income = nil

def self.sum_budget_cal(a_service_program_id, a_application_id, a_member_list, a_bu_id, a_run_id, a_rule_id)
        # fail
        #             // Need to get bu size from the structure of client ids.
        # long                    ll_NewRow, ll_rows
        # Decimal                            ld_ga_income
        # double                              ldb_member_id
        # integer                              li_return
        # str_pass           lstr_pass, lstr_pass1, lstr_pass2, lstr_pass3, lstr_pass4, lstr_pass5,lstr_pass6
        #Rails.logger.debug("a_service_program_id = #{a_service_program_id}, a_bu_id = #{a_bu_id}, a_run_id = #{a_run_id}, a_rule_id = #{a_rule_id}")

        @istr_budget = StrBudget.new
        if a_member_list.present?
            @screening_only = true
            @istr_budget.screening = true
        else
            @screening_only = false
            @istr_budget.screening = false
        end

        lstr_pass =  StrPass.new
        lstr_pass5 = StrPass.new

        ll_max_bdgt_mth_rows = 0.0
        ll_max_client_rows = 0.0
        ll_max_income_rows = 0.0
        ll_result = 0.0
        ls_budget_calc_rule = ''
        ls_result = ''

        # lds_bu_status, lds_bmem_summary, lds_tea_limits
        ll_num_unborn = 0
        ll_bu_size = 0
        ld_ga_income = 0
        @idb_max_b_details_id = 1
        @idb_b_details_id = 1
        @idb_bu_id = a_bu_id
        @idb_run_id = a_run_id
        if @screening_only == true
            @program_wizard_id = 0
        else
            @program_wizard_id = ProgramWizard.get_program_wizard_id_from_run_id(@idb_run_id)
        end
        @idb_bc_rule_id = a_rule_id

        @ii_service_program = a_service_program_id
        @istr_audit_trail = StrAuditTrail.new
        @istr_budget.str_months = Array.new #{ StrMonths.new }
        @istr_budget.str_months[0] = StrMonths.new
        @istr_budget.str_months[0].str_client = Array.new #{ StrClient.new }

        @istr_budget.run_id = @idb_run_id
        @istr_budget.budget_unit_id = @idb_bu_id
        @istr_budget.service_program_id = @ii_service_program
        lstr_pass.db[1] = @idb_bu_id
        @istr_budget.ineligible_codes = []

        # //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
        # ids_audit_trail_income_details = Create ds_audit_trail_income_details
        # ids_audit_trail_income_details.SetTransObject(SQLCA)
        @ids_audit_trail_income_details = []

        # ids_audit_trail_income_details_checks = Create ds_audit_trail_income_details_checks
        # ids_audit_trail_income_details_checks.SetTransObject(SQLCA)
        @ids_audit_trail_income_details_checks = []

        # ids_audit_trail_income_adj_dt = Create ds_audit_trail_income_adj_dt
        # ids_audit_trail_income_adj_dt.SetTransObject(SQLCA)
        @ids_audit_trail_income_adj_dt = []

        # ids_audit_trail_expense_details = Create ds_audit_trail_expense_details
        # ids_audit_trail_expense_details.SetTransObject(SQLCA)
        @ids_audit_trail_expense_details = []

        # ids_audit_trail_expense_details_checks = Create ds_audit_trail_expense_details_checks
        # ids_audit_trail_expense_details_checks.SetTransObject(SQLCA)
        @ids_audit_trail_expense_details_checks = []
        # ids_audit_trail_inc_shared_by = Create ds_audit_trail_inc_shared_by
        # ids_audit_trail_inc_shared_by.SetTransObject(SQLCA)
        @ids_audit_trail_inc_shared_by = []
        # ids_audit_trail_exp_shared_by = Create ds_audit_trail_exp_shared_by
        # ids_audit_trail_exp_shared_by.SetTransObject(SQLCA)
        @ids_audit_trail_exp_shared_by = []
        # //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02



        if @screening_only == true
            @ids_bud_mths = []
            @is_bu_cur_status = ""
            if a_application_id.present?
                cl_app = ClientApplication.where("id = ?",a_application_id)
                if cl_app.present?
                   cl_app = cl_app.first
                   @id_app_date = cl_app.application_date
                    @istr_budget.service_county = cl_app.application_received_office
                end
            end

            @lds_bud_mths = ProgramWizard.new # always size should be 1
            @lds_bud_mths.id = 0
            @lds_bud_mths.program_unit_id = 1
            @lds_bud_mths.run_id = 999
            @lds_bud_mths.month_sequence = 999
            @lds_bud_mths.run_month = @id_app_date
            @lds_bud_mths.no_of_months = 1

            @ids_bud_mths << @lds_bud_mths

        else
            lds_bu_status = ProgramUnitParticipation.get_participation_status(@idb_bu_id)
            @is_bu_cur_status = ""
            # if lds_bu_status.present? && lds_bu_status.size > 0
            if lds_bu_status.present?
               @is_bu_cur_status = lds_bu_status.first.participation_status
            end


            @ids_bud_mths = ProgramWizard.get_program_run_information(@idb_run_id)

            if @ids_bud_mths.size > 0
                program_unit = ProgramUnit.find(@idb_bu_id)
                application_id = 0
                if program_unit.present?
                    application_id = program_unit.client_application_id
                    @istr_budget.service_county = program_unit.processing_location
                end
                if application_id.present?
                    cl_app = ClientApplication.where("id = ?",application_id)
                    if cl_app.present?
                       cl_app = cl_app.first
                       @id_app_date = cl_app.application_date
                    end
                end
            end
        end




        @istr_budget.budget_unit_status = @is_bu_cur_status
        #ll_max_bdgt_mth_rows = @ids_bud_mths.size
        @ii_bdgt_mth_rows = 0
        @ids_bud_mths.each do |budget_month| # for each budget month

           @idc_total_fm_ded = 0
           @is_phone_expense = 'N'
           @idb_month_id = budget_month.month_sequence
           @id_month = budget_month.run_month
           @istr_budget.str_months[@ii_bdgt_mth_rows].month_id = @idb_month_id
           @istr_budget.str_months[@ii_bdgt_mth_rows].month = @id_month

           if @screening_only == true
              @ids_client_info = a_member_list # populate members from the argument
           else
              @ids_client_info = ProgramBenefitMember.program_benefit_member_dob(budget_month.run_id, budget_month.month_sequence)
           end

            if  @ids_client_info.present?
               ll_max_client_rows = @ids_client_info.size
            end
            lds_tea_limits = ProgramStandardDetail.get_program_limits(121,@id_month)
            if lds_tea_limits.size > 0
                @idc_work_related_per = lds_tea_limits.first.program_standard_limit_amount
               @idc_work_related_per = (@idc_work_related_per / 100)
            end
            lds_tea_limits = ProgramStandardDetail.get_program_limits(122,@id_month)
            if lds_tea_limits.size > 0
               @idc_work_incentive_per = lds_tea_limits.first.program_standard_limit_amount
               @idc_work_incentive_per = (@idc_work_incentive_per / 100)
            end
                @istr_income2 = StrIncome2.new
                @istr_income2.earned_cl = 0
                @istr_income2.unearned_cl = 0
                @istr_income2.ssi = 0
                @istr_income2.ssi_cl = 0
                @istr_income2.ssa = 0
                @istr_income2.ssa_cl = 0
                @istr_income2.va = 0
                @istr_income2.va_cl = 0
                @istr_income2.rr = 0
                @istr_income2.rr_cl = 0
                @istr_income2.tot_e = 0
                @istr_income2.tot_ue = 0
                @istr_income2.farmloss = 0
                @istr_income2.other = 0
                @istr_income2.other_cl = 0
                @istr_income2.child_support_cl = 0
                @istr_income2.child_support = 0
                @istr_income2.ojt = 0
                @istr_income2.sub_employment = 0
                @idc_tea_work_ded = 0
                @idc_tea_incent_ded = 0
                @idc_ltc_earned_disregard = 0
                @istr_client_exp = StrClientExp.new
                @istr_client_exp.child_support = 0
                @istr_client_exp.child_care = 0
                @istr_client_exp.rent_mortgage = 0
                @istr_client_exp.realestate_tax = 0
                @istr_client_exp.home_insur = 0
                @istr_client_exp.utilities_exp = 0
                @istr_client_exp.medical_exp = 0
                @istr_client_exp.total = 0
                @ii_org_bu_size = ll_max_client_rows
        #
                # n_cst_budget_unit lnv_bu
                # Double ldb_mc_id
                # lnv_bu = CREATE n_cst_budget_unit
                # lnv_bu.of_set_bu_id(idb_bu_id)
                # ldb_mc_id = lnv_bu.of_get_mc_id()
                # DESTROY lnv_bu
                # ii_org_bu_size =   (ldb_mc_id, idb_bu_id) //PCR#73512 - ELGutierez
                program_benefit_active_members_collection = nil
                if @screening_only == true
                    # program_benefit_active_members_collection = a_member_list.where("member_status == 4468") # populate members from the argument
                    # Rails.logger.debug("a_member_list = #{a_member_list.inspect}")
                    # program_benefit_active_members_collection = a_member_list.reject! {|item| item.member_status != "4468"}
                    # Rails.logger.debug("program_benefit_active_members_collection = #{program_benefit_active_members_collection.inspect}")
                    # Rails.logger.debug("program_benefit_active_members_collection = #{program_benefit_active_members_collection.size}")
                    program_benefit_active_members_collection = []
                    a_member_list.each do |member|
                        program_benefit_active_members_collection << member if member.member_status == "4468"
                    end
                else
                    program_benefit_active_members_collection = ProgramBenefitMember.get_active_members_from_run_id_and_month_sequence(@idb_run_id,@idb_month_id)# @ids_client_info.size
                end
                @ii_bu_size = program_benefit_active_members_collection.size
                    if @ids_client_info.size > 0
                        @idc_tea_cs_ded = 50
                        @ii_client_rows = 0

                        @ids_client_info.each do |benefit_member_clients| # for each member in the run
                            @istr_client_exp.total_cl = 0
                            @idb_client_id = benefit_member_clients.client_id
                            @id_dob = benefit_member_clients.dob
                            @istr_budget.str_months[@ii_bdgt_mth_rows].str_client[@ii_client_rows] = StrClient.new
                            @istr_budget.str_months[@ii_bdgt_mth_rows].str_client[@ii_client_rows].client_id = @idb_client_id
                            @istr_budget.str_months[@ii_bdgt_mth_rows].str_client[@ii_client_rows].member_id = benefit_member_clients.member_sequence
                            @istr_budget.str_months[@ii_bdgt_mth_rows].str_client[@ii_client_rows].client_status = benefit_member_clients.member_status

                            if @is_bu_cur_status == 6043 || @is_bu_cur_status == 6044
                               find_last_budget()
                            end

                            # lstr_pass.db[1] = @idb_client_id
                            # lstr_pass.db[2] = a_rule_id
                            @idb_rul_id = a_rule_id
                           # @is_mem_status[ii_client_rows] = @ids_client_info.GetItemString(@ii_client_rows, "b_member_status")
                           #Rails.logger.debug("@idb_client_id = #{@idb_client_id},@idb_bc_rule_id = #{@idb_bc_rule_id}")
                           # Do not check Income for TEA Diversion Cases
                           @ids_countable_income = nil
                           if @ii_service_program == 3
                                @ii_income_rows = 0
                           else
                                if benefit_member_clients.member_status == 4471 #Inactive closed - member inactive, no income or resources counted
                                else
                                    @ids_countable_income = ClientIncome.get_income_details_for_a_client(@idb_client_id,@idb_bc_rule_id)
                                end
                           end
                           #Rails.logger.debug("-->@ids_countable_income #{@ids_countable_income.inspect}")
                           @ii_income_rows = 1
                           # ll_max_income_rows = @ids_countable_income.size
                           @idc_am_deduction = 20.00
                            if @ids_countable_income.present?
                                @is_last_calc_flag = 'Y'
                                @ids_countable_income.each do |income|
                                        @is_calc_method = ""
                                        @is_income_type = income.incometype
                                        #Rails.logger.debug("@is_income_type = #{@is_income_type}")
                                        @idb_income_id = income.id
                                        @is_income_source = income.source
                                        lstr_pass5.db[1] = a_service_program_id
                                        lstr_pass5.s[1] = '15'
                                        lstr_pass5.dt[1] = @id_month.to_datetime
                                        ls_date_receieved = 0 , ls_month_run = 0
                                        ll_rows_retrieved , ll_ctr_income = 0
                                        lds_income_earned = IncomeDetail.get_income_detail_by_income_id(@idb_income_id)
                                        #Rails.logger.debug("lds_income_earned =  #{lds_income_earned.inspect}")
                                        lds_income_earned.each do |income_detail|
                                        lstr_pass5.dt[2] = income_detail.date_received
                                        ls_date_receieved =  Date.civil(lstr_pass5.dt[2].year, lstr_pass5.dt[2].month, 1)
                                        ls_month_run = Date.civil(@id_month.year, @id_month.month, 1)
                                        if ls_date_receieved == ls_month_run
                                           break
                                        end
                                end
                                ldb_rule_id = bu_rule_id(lstr_pass5.db[1], lstr_pass5.s[1], lstr_pass5.dt[1], lstr_pass5.dt[2])
                                li_valid_income = valid_income_for_bdgtcalc(ldb_rule_id, @is_income_type)
                                #Rails.logger.debug("li_valid_income = #{li_valid_income}")
                                if li_valid_income > 0
                                    if @is_income_source.present? && @is_income_source.length > 20
                                        @is_income_source = @is_income_source.strip[0, 20]
                                    end
                                    ld_income_beg = income.effective_beg_date
                                    ld_income_end = income.effective_end_date
                                    @is_recalc_ind = income.recal_ind

                                   if  (@is_bu_cur_status == 6043 || @is_bu_cur_status == 6044) && income.recal_ind == 'N'



                                        if lstr_pass5.dt.size > 1
                                            if lstr_pass5.dt[2].present?
                                                ld_ga_income = calc_last_budget('I', @idb_income_id, lstr_pass5.dt[2].to_date, ld_income_end)
                                            end
                                        else
                                            ld_ga_income = calc_last_budget('I', @idb_income_id, ld_income_beg, ld_income_end)
                                        end
                                   else

                                         @id_calc_month = @id_month
                                        if lstr_pass5.dt.length > 1
                                            if lstr_pass5.dt[2].present?
                                                @is_income_valid = valid_effective_dates(lstr_pass5.dt[2].to_date, ld_income_end)
                                            end
                                        else
                                            @is_income_valid = 'Y'
                                        end

                                        if @is_income_valid == 'N'
                                            ls_budget_calc_rule = "None"
                                        else
                                            ls_budget_calc_rule = det_bdgt_cal_rule(a_service_program_id)
                                            @ib_message_display = false
                                        end

                                        #Rails.logger.debug("calculation type = #{ls_budget_calc_rule}")

                                        case ls_budget_calc_rule
                                            when "Actual"
                                                @is_calc_method = 5848 #4
                                                ld_ga_income =  calc_actual('Y',income)
                                            when "Actual R"
                                                @is_calc_method = 5849 #5
                                                ld_ga_income =  calc_actual('N',income)
                                            when "Converted"
                                                @is_calc_method = 5846 #2
                                                ld_ga_income =  calc_converted(income)
                                            when "Averaged"
                                                @is_calc_method = 5845 #1
                                                ld_ga_income =  calc_averaged(income)
                                            when "Intended Use"
                                                @is_calc_method = 5847 #3
                                                ld_ga_income =  calc_intended_use(income)
                                            when "Actual Converted"
                                                @is_calc_method = 5850 #6
                                                ld_ga_income =  calc_actual_conv('Y',income)
                                            when "Actual Converted R"
                                                @is_calc_method = 5851 #7
                                                ld_ga_income =  calc_actual_conv('N',income)
                                            when "None"
                                                ld_ga_income = 0
                                            when "Invalid"
                                                @istr_budget.error_flag = 'Y'
                                                @istr_budget.error_message   = "Invalid budget calculation rule, income will not be counted."
                                                ld_ga_income = 0
                                        end
                                   end
                                else
                                    @is_income_valid = 'N'
                                    ld_ga_income = 0
                               end
                               #Rails.logger.debug("cl_tea_net_income ld_ga_income = #{ld_ga_income}")
                                cl_tea_net_income(ld_ga_income)

                                @ids_audit_trail_income_details.clear
                                @ids_audit_trail_income_details_checks.clear
                                @ids_audit_trail_income_adj_dt.clear
                                @ids_audit_trail_inc_shared_by.clear

                                @ii_income_rows = @ii_income_rows + 1
                           end

                            if @is_last_calc_flag == 'N'
                               @istr_budget.error_flag = 'Y'
                               @istr_budget.error_message  = "At least one income record for the current client did not have a valid record stored with the previously
                                                                            submitted budget run.  Please make sure all recalc indicators are set correctly and run this budget again."
                                return  @istr_budget
                            end
                       end

                        @ids_audit_trail_income_details.clear
                        @ids_audit_trail_income_details_checks.clear
                        @ids_audit_trail_income_adj_dt.clear
                        @ids_audit_trail_inc_shared_by.clear
                        @ids_audit_trail_expense_details.clear
                        @ids_audit_trail_expense_details_checks.clear
                        @ids_audit_trail_exp_shared_by.clear

                        @ii_client_rows = @ii_client_rows + 1
                    end
                end
                # Do not check Income for TEA Diversion service programs
                if @ii_service_program == 3
                    ls_result = "PASS"
                    ld_ga_income = bu_tea_net_income()
                    #ld_ga_income = 0
                else
                    ld_ga_income = bu_tea_net_income()
                    ls_result = net_income_test(ld_ga_income)
                    #Rails.logger.debug("ls_result = #{ls_result}")
                end
                move_errors_from_application_eligibility_results_to_eligibility_determine_results_table
                if ls_result == "PASS"
                    ll_result = determine_benefit(ld_ga_income)
                    @istr_budget.amount_eligible = ll_result
                end
            @ii_bdgt_mth_rows = @ii_bdgt_mth_rows + 1
        end
        @istr_budget.b_mem_details_id = @idb_max_b_details_id

        #populate all the ED reasons for this eligibility run.
        if @screening_only == true
        else
            ProgramWizardReason.populate_ed_run_reasons(@idb_run_id,@id_month)
        end
        return @istr_budget
    end

    def self.net_income_test(adc_net_income)
    lstr_pass_bu_stds = StrPass.new
    ls_net_income_test = 0
    ls_budget_elig_ind = 0
    ldc_income_red_rate = 0
    lstr_pass_rule = StrPass.new
    # //TEA and FOODSTAMPS NET MONTLY INCOME TEST
    #Rails.logger.debug("@ii_service_program = #{@ii_service_program}")
        if @ii_service_program  == 4
            lstr_pass_bu_stds.db[1] = @ii_bu_size
            lstr_pass_bu_stds.dates[1] = @id_month
            lstr_pass_bu_stds.s[1] = '50'
            ldc_inc_elig_std1 = ProgramUnitSizeStandardDetail.get_program_grant_amount(lstr_pass_bu_stds.db[1], lstr_pass_bu_stds.dates[1], lstr_pass_bu_stds.s[1])
            if ldc_inc_elig_std1.present?
                ldc_inc_elig_std = ldc_inc_elig_std1.first.program_limit_amount
            end
            lds_tea_income_limit = ProgramStandardDetail.get_program_limits(318, @id_month)
            if lds_tea_income_limit.present?
                lds_tea_income_limit = lds_tea_income_limit.first.program_standard_limit_amount
                if  lds_tea_income_limit != 0
                    ldc_income_red_rate = lds_tea_income_limit/100
                end
            end
            ldc_inc_elig_std = ldc_income_red_rate * ldc_inc_elig_std
            ldc_child_support = @istr_income2.child_support
            ldc_tot_unearned = (@istr_income2.tot_ue - ldc_child_support)
            ldc_gross_earned = @istr_income2.tot_e
            ldc_tot_gross_inc = (ldc_tot_unearned + ldc_gross_earned)
            @ids_10.program_income_limit = ldc_inc_elig_std
            if @screening_only == false
                unless @ids_10.save
                    #Rails.logger.debug("benefit_calculator.net_income_test cannot update @ids_10 #{ProgramBenefitDetail}")
                end
            end
            if ldc_tot_gross_inc > ldc_inc_elig_std
                ls_net_income_test = "FAIL"
                msg = "This budget unit failed the income eligibilty test and is not eligible for the grant amount."
                @ids_10.benefit_gross_earned = 0
                @ids_10.benefit_total_unearned = 0
                @ids_10.benefit_total_adjusted = 0
                @ids_10.full_benefit = 0
                @ids_10.reduction = 0
                @ids_10.sanction = 0
                @ids_10.program_benefit_amount = 0

                if @screening_only == false
                    unless @ids_10.save
                       #Rails.logger.debug("benefit_calculator.net_income_test cannot update @ids_10 #{ProgramBenefitDetail}")
                    end
                end

            else
                ls_net_income_test = "PASS"
            end

            #Rails.logger.debug("ldc_inc_elig_std = #{ldc_inc_elig_std}")
            #Rails.logger.debug("ldc_tot_gross_inc = #{ldc_tot_gross_inc}")
            if (ldc_inc_elig_std >= ldc_tot_gross_inc)
                ls_budget_elig_ind = 'Y'
            else
                ls_budget_elig_ind = 'N'
            end
            #Rails.logger.debug("ls_budget_elig_ind = #{ls_budget_elig_ind}")
            lstr_pass_rule.db[1] = @ii_service_program
            lstr_pass_rule.s[1] = '15'
            lstr_pass_rule.dt[1] = @id_month.to_datetime
            lstr_pass_rule.dt[2] = @id_month.to_datetime
            if bu_rule_id(lstr_pass_rule.db[1], lstr_pass_rule.s[1], lstr_pass_rule.dt[1], lstr_pass_rule.dt[2]) == 0
                ls_budget_elig_ind = 'N'
                ldc_inc_elig_std = 0
            end
        else

            lds_tea_income_limit = ProgramStandardDetail.get_income_eligibility_standard(115, @id_month)
            #Rails.logger.debug("lds_tea_income_limit = #{lds_tea_income_limit.inspect}")
            if lds_tea_income_limit.size > 0
                ldc_inc_elig_std = lds_tea_income_limit.first.program_standard_limit_amount
                #Rails.logger.debug("ldc_inc_elig_std = #{ldc_inc_elig_std}")
            else
                ldc_inc_elig_std = 0
            end
            @ids_10.program_income_limit = ldc_inc_elig_std
            if @screening_only == false
                unless @ids_10.save
                    #Rails.logger.debug("benefit_calculator.net_income_test cannot update @ids_10 #{ProgramBenefitDetail}")
                end
            end
            if adc_net_income > ldc_inc_elig_std
                ls_net_income_test = "FAIL"
                # DEMO CODE - OR CONDITION OF  @ii_service_program == 17 - START
                if (@ii_service_program == 1 ||  @ii_service_program == 17)
                    msg = "This budget unit failed the income eligibilty test and is not eligible for the grant amount."
                end
                @ids_10.benefit_gross_earned = 0
                @ids_10.benefit_net_income = 0
                @ids_10.benefit_total_unearned = 0
                @ids_10.benefit_total_adjusted = 0
                @ids_10.full_benefit = 0
                @ids_10.reduction = 0
                @ids_10.sanction = 0
                @ids_10.program_benefit_amount = 0
                if @screening_only == false
                    unless @ids_10.save
                        #Rails.logger.debug("benefit_calculator.net_income_test cannot update @ids_10 #{ProgramBenefitDetail}")
                    end
                end
            else
                ls_net_income_test = "PASS"
            end
        end
       # //Check to see if the Net Income test failed   --  If so write to the t_bu_mo_summary_table
        if ls_net_income_test == "FAIL"
            lds_bu_mo_summary = ProgramMonthSummary.new
            lds_bu_mo_summary.run_id = @idb_run_id
            lds_bu_mo_summary.program_wizard_id = @program_wizard_id
            lds_bu_mo_summary.month_sequence = @idb_month_id
            lds_bu_mo_summary.program_unit_size = @ii_bu_size
            lds_bu_mo_summary.tot_earned_inc = @istr_income2.tot_e
            lds_bu_mo_summary.tot_unearned_inc = @istr_income2.tot_ue
            lds_bu_mo_summary.tot_expenses = @istr_client_exp.total
            lds_bu_mo_summary.bu_sum_result = 0
            lds_bu_mo_summary.tot_resources = 0 #Will be implemented later
            if @ii_service_program == 4
               # lds_bu_mo_summary.budget_eligible_ind = ls_budget_elig_ind
               lds_bu_mo_summary.budget_eligible_ind = 'N'
               if @screening_only == true
                  @istr_budget.ineligible_codes << 6127
               else
                insert_eligibility_determine_results(@idb_run_id, @idb_month_id, @idb_bu_id, 6127, "program_unit") # Income rule fail
               end

            end
            # DEMO CODE -OR CONDITION @ii_service_program == 17
            if (@ii_service_program == 1 ||  @ii_service_program == 17)
                if adc_net_income > ldc_inc_elig_std
                    lds_bu_mo_summary.budget_eligible_ind = 'N'
                    if @screening_only == true
                        @istr_budget.ineligible_codes << 6127
                    else
                        insert_eligibility_determine_results(@idb_run_id, @idb_month_id, @idb_bu_id, 6127, "program_unit") # Income rule fail
                    end

                else
                    lds_bu_mo_summary.budget_eligible_ind = 'Y'
                end
            end
            if @screening_only == false
                unless lds_bu_mo_summary.save
                    #Rails.logger.debug("benefit_calculator.net_income_test cannot insert lds_bu_mo_summary #{ProgramMonthSummary}")
                end
            end
            @istr_income2.tot_e = 0
            @istr_income2.tot_ue = 0
            # if @ii_service_program == 4
            #             if ls_budget_elig_ind == 'N'
            #                             lnv_bu = CREATE n_cst_budget_unit
            #                             lnv_bu.of_insert_bdgt_status(idb_bu_id, double(ii_service_program), '03', 'W1', 'ADD')
            #                             gnv_online_interface_controller.of_set_bdgtstatus_refresh(idb_bu_id, TRUE)                //Refresh Budget Unit Status Tab
            #                             DESTROY lnv_bu
            #             end
            # end
        end
        return ls_net_income_test
    end

    def self.bu_tea_net_income()
        ldc_gross_earned = 0
        # //********************* TEA - BUDGET UNIT LEVEL DEDUCTIONS **********************
        ldc_tot_unearned = @istr_income2.tot_ue
        ldc_tot_earned = @istr_income2.tot_e
        ldc_ojt_sub_emp = (@istr_income2.ojt + @istr_income2.sub_employment)
        #Rails.logger.debug("@ii_service_program = #{@ii_service_program}")
        if @ii_service_program == 4
           ldc_gross_earned = ldc_tot_earned
        else
            ldc_gross_earned = (ldc_tot_earned - ldc_ojt_sub_emp)
        end
        ldc_remaining_earnings = (ldc_gross_earned - @idc_tea_work_ded)
        ldc_net_earnings = (ldc_remaining_earnings - @idc_tea_incent_ded)
        ldc_tot_ded = (@idc_tea_work_ded + @idc_tea_incent_ded)
        ldc_net_income = (ldc_gross_earned - ldc_tot_ded)
        ldc_tot_adj = (ldc_net_income + ldc_tot_unearned)
        @ids_10 = ProgramBenefitDetail.new
        @ii_curr_tearow = 1
        @ids_10.run_id = @idb_run_id
        @ids_10.program_wizard_id = @program_wizard_id
        @ids_10.month_sequence = @idb_month_id
        if @ii_service_program == 3
            @ids_10.eligibility_gross_earned = 0
            @ids_10.eligibility_work_deduct = 0
            @ids_10.eligibility_incent_deduct = 0
            @ids_10.eligibility_net_income = 0
            @ids_10.eligibility_tot_unearned = 0
            @ids_10.eligibility_tot_adjusted = 0
            @ids_10.social_security_admin_amt = 0
            @ids_10.railroad_ret_amt = 0
            @ids_10.vet_asst_amt = 0
            @ids_10.other_unearned_inc = 0
        else
            @ids_10.eligibility_gross_earned = ldc_gross_earned
            @ids_10.eligibility_work_deduct = @idc_tea_work_ded
            @ids_10.eligibility_incent_deduct = @idc_tea_incent_ded
            @ids_10.eligibility_net_income = ldc_net_income
            @ids_10.eligibility_tot_unearned = ldc_tot_unearned
            @ids_10.eligibility_tot_adjusted = ldc_tot_adj
            @ids_10.social_security_admin_amt = @istr_income2.ssa
            @ids_10.railroad_ret_amt = @istr_income2.rr
            @ids_10.vet_asst_amt = @istr_income2.va
            @ids_10.other_unearned_inc = @istr_income2.other
        end
        if @screening_only == false
            unless @ids_10.save
            #Rails.logger.debug("benefit_calculator.bu_tea_net_income cannot save @ids_10 #{ProgramBenefitDetail}")
            end
        end
        #Rails.logger.debug("ldc_tot_adj = #{ldc_tot_adj}")
        return ldc_tot_adj
    end

    def self.prorate_income(income)
    # decimal ldc_income, ldc_prorated_income
    # Long ll_prorate_busize, ll_active_busize
    ldc_income = income
    if ldc_income == 0
        ldc_prorated_income = 0
    else
        ll_prorate_busize = prorate_busize(idb_run_id, idb_month_id, ll_active_busize)
        if ll_prorate_busize > 0
           if ll_active_busize > 0
              ldc_prorated_income = (ldc_income / ll_prorate_busize) * ll_active_busize
           end
        end
    end
    return ldc_prorated_income
    end


    def self.attend_adj ()
    # string ls_student_adj, ls_attend_type
    # date   ld_edu_end_date, ld_bwiz_run_month, ld_edu_begin_date
    # n_ds  lds_student_attendance
    # str_pass lstr_pass, lstr_pass1
    # long   ll_rowsretrieved
    # integer li_cnt, li_full_time_cnt

    # lds_student_attendance = Create ds_student_check
    # lds_student_attendance.SetTransobject(SQLCA)

    # lstr_pass.db[1] = idb_client_id
    # lstr_pass1.db[1] = idb_client_id

    # li_full_time_cnt =0
    # ls_student_adj = "N"

    # //Retrieve Rows in the Local DataStore (ds_student_check)
    # If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
    #   ll_RowsRetrieved = gnv_data_access_service.retrieve(lds_student_attendance, lds_student_attendance, "Bcsc_l", lstr_pass1)
    # Else
    #   SELECT T_EDUCATION.CLIENTID,
    #    T_EDUCATION.SCHOOL_TYPE,
    #    T_EDUCATION.EFFECTIVE_END_DATE,
    #    T_EDUCATION.ATTENDANCE_TYPE,
    #    T_EDUCATION.EFFECTIVE_END_DATE
    #  FROM T_EDUCATION
    #  WHERE T_EDUCATION.CLIENTID = :rBcsc_clientid;

    # End If

    # If ll_RowsRetrieved > 0 then // Loop thru all school records to check if valid end date and attendance

    #    li_cnt = 1

    #    Do While li_cnt <= ll_RowsRetrieved

    #    ls_attend_type = lds_student_attendance.GetItemString(li_cnt, "attendance_type")
    #    ld_edu_end_date = Date(lds_student_attendance.GetItemDateTime(li_cnt, "effective_end_date"))
    #    ld_edu_begin_date = Date(lds_student_attendance.GetItemDateTime(li_cnt, "effective_beg_date"))

    #    If ls_attend_type = "01" then  // If attendance type is "Full time"
    #       ls_student_adj = of_valid_effective_dates(ld_edu_begin_date, ld_edu_end_date)

    #       If ls_student_adj = "Y" then
    #           li_full_time_cnt = li_full_time_cnt + 1
    #       End if

    #    End if
    #    li_cnt++
    #    loop
    # End if

    # Destroy lds_student_attendance

    # Return ls_student_adj

    # //***********************************************************************************
    # //*  3.015    03/8/00 ANSWER                                  J. DeVitto                                                                                                                                                                                                            *
    # //*  Created function to determine if student attendance is allowed "SD" disregard.    *
    # //*  Returns a "Y" if the adjustment should be applied and an "N" if not      #993  *
    # //***********************************************************************************
    # //*  3.015    03/13/00 ANSWER                                                J. DeVitto                                                                                                                                                                                                            *
    # //*  Added code to call of_valid_effective_dates() function                                     *
    # //***********************************************************************************

    end

    def self.check_retro_mth()
    #             date                       ld_date
    # date                   ld_check_retro
    # integer              li_month
    # integer              li_year
    # string ls_retro
        ls_retro = 'N'
        ld_date = Date.today
        li_month = ld_date.month
        li_year = ld_date.year
        ld_date = Date.civil(li_year, li_month, 1).strftime("%m/%d/%Y")
        ld_check_retro = @id_app_date
        case ld_check_retro.year
            when ld_check_retro.year == @id_month.year
                if @id_month.month < ld_check_retro.month
                                ls_retro = 'Y'
                end
            when ld_check_retro.year < @id_month.year
                            ls_retro = 'N'
            when ld_check_retro.year > @id_month.year
                            ls_retro = 'Y'
        end
        return ls_retro
    end

    def self.find_last_budget()
        lstr_pass = StrPass.new
        lstr_pass.db[1] = @idb_bu_id
        lstr_pass.db[2] = @idb_client_id
        lds_last_budget = ProgramWizard.find_last_budget(@idb_bu_id, @idb_client_id)
        if lds_last_budget.present?
            @idb_last_run_id = lds_last_budget.run_id
            @idb_last_month_id = lds_last_budget.month_sequence
            @idb_last_mem_id = lds_last_budget.member_sequence
            #Rails.logger.debug("test1#{@idb_last_run_id}")
            #Rails.logger.debug("test2#{@idb_last_month_id}")
            #Rails.logger.debug("test3#{@idb_last_mem_id}")
        end
    end

    def self.check_exp_use(as_exp_type, as_use_code)

    end



    def self.sanction_history(clientid, sanctionid, sanction_ind, sanction_type)
    # n_ds  lds_tea_sanction_his_counter,lds_tea_sanction_his,lds_sanction_list
    # n_ds  lds_reference_table,lds_sanction_detail
    # str_pass lstr_pass,lstr_pass1,lstr_pass2,lstr_pass3,lstr_pass4
    # long ll_his_counter,ll_rows,ll_found,ll_insert_row,ll_counter
    # double ldb_sanction_percent,ll_sanction_hist_id,ldb_sanctionid
    # datetime                                          ldtm_Current_time
    # ldtm_Current_time = DateTime(Today(),Now())
    # boolean lb_insert_record = false
    # string ls_find_string,ls_filter,ls_sanction_type_prg
    # integer li_return
    # uo_budget_calc_2       luo_budget_calc_2

    # lds_tea_sanction_his_counter = CREATE ds_tea_sanction_his_counter
    # lds_tea_sanction_his_counter.SetTransObject(SQLCA)

    # lds_tea_sanction_his = CREATE ds_tea_sanction_his
    # lds_tea_sanction_his.SetTransObject(SQLCA)

    # lds_sanction_detail = CREATE ds_sanction_detail
    # lds_sanction_detail.SetTransObject(SQLCA)



    # lstr_pass.db[1] = clientid
    # if sanction_ind = 'T' then
    #   ldb_sanction_percent = 25
    #   lstr_pass.db[2] = ldb_sanction_percent
    # else
    #   ldb_sanction_percent = 50
    #   lstr_pass.db[2] = ldb_sanction_percent
    # end if
    # //Retrieve the Count for Sanction History Count
    # If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
    #   ll_rows = gnv_data_access_service.retrieve(lds_tea_sanction_his_counter,lds_tea_sanction_his_counter,"Tshs_l",lstr_pass)
    # Else
    #   select  count(*) INTO :iTshs_count
    #    FROM T_tea_sanction_his
    #    WHERE ( clientid = :rTshs_clientid
    #       AND  sanction_percent = :rTshs_sanction_percent );
    # End If
    # ll_his_counter = lds_tea_sanction_his_counter.getitemnumber(1,"percent_counter")
    # if ll_his_counter = 0 then
    #    lb_insert_record = true
    # else
    #    if ll_his_counter >= 3 and sanction_ind = 'F' then
    #      return
    #    elseif ll_his_counter < 3 then
    #      lstr_pass2.db[1] = clientid
    #      //Retrieve the Count for Sanction History
    #      If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
    #         ll_rows = gnv_data_access_service.retrieve(lds_tea_sanction_his,lds_tea_sanction_his,"Tsha_l",lstr_pass2)
    #      Else
    # select  count(*) INTO :iTshs_count
    #    FROM T_tea_sanction_his
    #    WHERE ( clientid = :rTshs_clientid
    #       AND  sanction_percent = :rTshs_sanction_percent );
    #    End If
    #                             ls_find_string = "string(sanction_month,'MM/YYYY') = '" + string(id_month,'MM/YYYY') + "'"
    #                             //search for the month/year of the budget from the list service of the history table
    #                             ll_found = lds_tea_sanction_his.Find( ls_find_string,1,ll_rows)
    #                             if ll_found = 0 then
    #                                             lb_insert_record = true
    #                             end if
    #             end if
    # end if

    # if lb_insert_record then
    #                             lstr_pass1.db[1] = 2   //set domain table ID (2 is for the id portion of the domain tbl)
    #                             lstr_pass1.db[2] = 59  //set sub domain id   (32 is for requesting Sanction ID)
    #                             ll_sanction_hist_id = gnv_data_access_service.system_generate_id(lstr_pass1)
    #                             ll_insert_row = lds_tea_sanction_his.insertrow(0)
    #                             lds_tea_sanction_his.setitem(ll_insert_row,"clientid",clientid)
    #                             lds_tea_sanction_his.SetItem(ll_insert_row, 'sanction_hist_id',ll_sanction_hist_id)
    #                             lds_tea_sanction_his.setitem(ll_insert_row,"sanction_month",id_month)
    #                             lds_tea_sanction_his.setitem(ll_insert_row,"sanction_percent",ldb_sanction_percent)
    #                             lds_tea_sanction_his.SetItem (ll_insert_row, "user_id", gs_current_user)
    #                             lds_tea_sanction_his.SetItem (ll_insert_row, "last_update_date", ldtm_Current_time)
    #                             lstr_pass3.db[1] = clientid
    #                             lstr_pass3.db[2] = ll_sanction_hist_id
    #                             li_return = gnv_data_access_service.update_service(lds_tea_sanction_his,lds_tea_sanction_his, "Tsha_u", lstr_pass3)
    #                              UPDATE T_tea_sanction_his
    #         SET     sanction_month = :rTsha_sanction_month,
    #                 sanction_percent = :rTsha_sanction_percent,
    #                 user_id = :rTsha_user_id,
    #                 last_update_date = :rTsha_last_update_date
    #         WHERE ( clientid = :rTsha_clientid AND
    #                 sanction_hist_id = :rTsha_sanction_hist_id );

    #                             if ll_his_counter = 1 and sanction_ind = 'F' then
    #                                             luo_budget_calc_2 = create uo_budget_calc_2
    #                                             luo_budget_calc_2.of_create_to_do_item(clientid,sanctionid,sanction_type)
    #                                             destroy luo_budget_calc_2
    #                                             lstr_pass4.db[1] = clientid
    #                                             lstr_pass4.db[2] = sanctionid
    #                                             If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
    #                                                             li_return = gnv_data_access_service.retrieve(lds_sanction_detail,lds_sanction_detail, "Sanc_r", lstr_pass4)
    #                                             Else
    #                                                             SELECT     T_sanction.service_program_id,
    #                 T_sanction.type,
    #                 T_sanction.effective_beg_date,
    #                 T_sanction.duration,
    #                 T_sanction.infraction_date,
    #                 T_sanction.description,
    #                 T_sanction.not_serviced_ind,
    #                 T_sanction.ClientId,
    #                 T_sanction.last_update,
    #                 T_sanction.SanctionId,
    #                 T_sanction.user_id,
    #                 T_sanction.mytodolist_ind,
    #                 T_household_member.householdid
    #        FROM    T_sanction,
    #                T_household_member
    #        WHERE    (T_sanction.ClientId = T_household_member.ClientId)
    #        AND      (T_sanction.ClientId = :rSanc_ClientId)
    #        AND      (T_sanction.SanctionId = :rSanc_SanctionId);

    #                                             end if
    #                                             if li_return > 0 then
    #                                                             lds_sanction_detail.setitem(li_return,"mytodolist_ind",'Y')
    #                                             end if
    #                                             gnv_data_access_service.update_service(lds_sanction_detail,lds_sanction_detail, "Sanc_u", lstr_pass4)
    #                                              UPDATE T_sanction

    #                 SET
    #                 service_program_id   = :iSanc_service_pgm_id,
    #                 type                 = :iSanc_type,
    #                 effective_beg_date = :iSanc_effective_beg_date indicator :nSanc_effective_beg_date,
    #                 duration             = :iSanc_duration,
    #                 infraction_date      = :iSanc_infraction_date       indicator :nSanc_infraction_date,
    #                 description          = :iSanc_description,
    #                 not_serviced_ind     = :iSanc_not_serviced_ind,
    #                 ClientId             = :iSanc_ClientId,
    #                 last_update          = :iSanc_last_update,
    #                 SanctionId           = :iSanc_SanctionId,
    #                 user_id              = : iSanc_user_id,
    #                 mytodolist_ind       = : iSanc_mytodolist

    #                 WHERE   (ClientId       = :iSanc_ClientId) and
    #                         (SanctionId     = :iSanc_SanctionId);

    #                             end if
    # end if
    # destroy lds_tea_sanction_his_counter
    # destroy lds_tea_sanction_his
    # destroy lds_sanction_detail
    # //***********************************************************************
    # //*  Release  Date        Task         Author                           *
    # //*  Description                                                        *
    # //***********************************************************************
    # //*  6.003    06/29/2001  ANSWER       Anand Kotian                                                                                                        *
    # //*  PCR 65925  Used to Add Sanction history record                                                                                                    *
    # //***********************************************************************

    end

    def self.determine_benefit(adc_net_income)
        lstr_prgsv_sanction = StrPass.new
        lstr_tea_prgsv_sanction_pass = StrPass.new
        ls_sanction_indicator = 6179
        ls_sanction_indicator_final = 6179
        ls_sanction = 'N'
        li_sanction_percent = 25
        ll_clientid = 0
        ll_sanctionid = 0
        ls_sanction_type = 0
        li_client_age = 0
        lstr_pass_rule = StrPass.new
        ldc_grant_amount = 0
        lstr_pass = StrPass.new
        lstr_pass4 = StrPass.new
        ldc_sanction_amt = 0
        ldc_reduction_amt = 0
        lstr_pass_stds = StrPass.new
        lstr_pass_bu_stds = StrPass.new
        lstr_pass8 = StrPass.new
        ldc_net_income = adc_net_income
        ##Rails.logger.debug("determine_benefit.ldc_net_income = #{ldc_net_income}")
        ldc_child_support = @istr_income2.child_support
        ##Rails.logger.debug("determine_benefit.ldc_child_support = #{ldc_child_support}")
        ldc_tot_unearned = (@istr_income2.tot_ue - ldc_child_support)
        ##Rails.logger.debug("determine_benefit.ldc_tot_unearned = #{ldc_tot_unearned}")
        ldc_gross_earned = @istr_income2.tot_e
        ##Rails.logger.debug("determine_benefit.ldc_gross_earned = #{ldc_gross_earned}")
        ldc_tot_adj = (ldc_gross_earned + ldc_tot_unearned)
        ##Rails.logger.debug("determine_benefit.ldc_tot_adj = #{ldc_tot_adj}")
        ldc_tot_gross_inc = (ldc_tot_unearned + ldc_gross_earned)
        ##Rails.logger.debug("determine_benefit.ldc_tot_gross_inc = #{ldc_tot_gross_inc}")
        # Sanction only for TEA and Work Pays cases

        if @ii_service_program  == 1 || @ii_service_program  == 4
        lds_tea_sanction = Sanction.get_sanction_detail_by_client(@idb_run_id, @idb_month_id, @ii_service_program)
            if lds_tea_sanction.present?
                lds_tea_sanction.each do |sanction|
                # Get Sanction Details
                    lds_tea_sanction_his = SanctionDetail.get_sanction_details_by_sanction_id_and_sanction_month(sanction.id,@id_month)
                    if lds_tea_sanction_his.present?
                    ls_sanction_indicator = lds_tea_sanction_his.first.sanction_indicator
                        if  (ls_sanction_indicator_final == 6179) || (ls_sanction_indicator_final == 6111 && ls_sanction_indicator != 6111)
                        ls_sanction_indicator_final = ls_sanction_indicator

                        end
                    end
                end

                if ls_sanction_indicator_final != 6179
                    ls_sanction_indicator = ls_sanction_indicator_final
                    ls_sanction ='Y'
                    li_sanction_percent = ls_sanction_indicator_final
                end
            end
        end

        # # old implementation of sanctions

        # lds_tea_sanction = Sanction.get_sanction_detail_by_client(@idb_run_id, @idb_month_id, @ii_service_program)

        # Rails.logger.debug("determine_benefit.lds_tea_sanction = #{lds_tea_sanction}")
        # # Pending implementation
        # # lstr_pass8.s[1] = "130"    // domain code value (key) for Sanction Type Progressive
        # # ll_san_type_prg = gnv_data_access_service.retrieve(lds_reference_table,lds_reference_table, "Rddw_l", lstr_pass8)
        # # ls_filter = " "
        # # ll_san_type_prg = 1
        # # For ll_san_type_prg = 1 to lds_reference_table.rowcount()
        # #   ls_sanction_type_prg =  trim(lds_reference_table.getitemstring(ll_san_type_prg,"value"))
        # #   if ll_san_type_prg = lds_reference_table.rowcount() then
        # #      ls_filter = ls_filter + "type = '" + ls_sanction_type_prg + "'"
        # #   else
        # #       ls_filter = ls_filter + "type = '" + ls_sanction_type_prg + "' or "
        # #   end if
        # # Next
        # # //ls_filter = "type = '28' or type = 'MP' or type = '32' or type = '34' or type = '31'"
        # # lds_tea_sanction.Setfilter(ls_filter)
        # # lds_tea_sanction.filter()
        #   if lds_tea_sanction.present?
        #     li_filter_count = lds_tea_sanction.size
        #   end
        #   li_cnt = 1

        #  if @ii_service_program  == 1
        #     lstr_prgsv_sanction = determine_tea_prgsv_sanction(@idb_run_id, @idb_month_id, @ii_service_program, @id_month, lstr_tea_prgsv_sanction_pass)
        #     ls_sanction_indicator = lstr_prgsv_sanction.s[1]
        #     ls_sanction = lstr_prgsv_sanction.s[4]
        #     li_sanction_percent = lstr_prgsv_sanction.i[1]
        #     if ls_sanction_indicator == 6114
        #           ls_sanction_indicator = 6179
        #           ls_sanction = 'N'
        #           li_sanction_percent = 0
        #     end
        #  else
        #     if li_filter_count > 0
        #     while ls_sanction == 'N' && li_cnt <= li_filter_count
        #         lds_tea_sanction.each do |sanction|
        #              if ls_sanction == 'N'
        #                  ll_clientid = sanction.client_id
        #                  ll_sanctionid = sanction.id
        #                  ls_sanction_type = sanction.sanction_type
        #                  li_client_age = Client.get_age(ll_clientid)
        #                  ls_member_status = sanction.member_status
        #                       #ld_sanction_begin = sanction.effective_beg_date
        #                       # Pending implementation
        #                       # sanction.Date(lds_tea_sanction.GetItemDateTime(li_cnt,"expiration_date"))
        #                       #ld_sanction_end = sanction.expiration_date
        #                       #ld_sanction_end = ld_sanction_begin + 1.month
        #                       #Pending implementation
        #                       #unless @ii_service_program == 4
        #                  lds_tea_sanction_his = SanctionDetail.get_sanction_details_by_sanction_id(ll_sanctionid)
        #                  ll_rows = lds_tea_sanction_his.size
        #                       # // Rules as per requirement document says that for Sanction progressive in nature.
        #                       # // If the Sanction Begin Date <> Oldest Sanction History record then Use the
        #                       # // Oldest Sanction History record should be used to determine whether or not to
        #                       # // disregard the sanction
        #                       # if ll_rows > 0
        #                       #   ld_sanction_month = lds_tea_sanction_his.first.sanction_month
        #                       #   ld_sanction_begin = lds_tea_sanction_his.first.effective_begin_date
        #                       #    #Rails.logger.debug("ld_sanction_month = #{ld_sanction_month}")
        #                       #    #Rails.logger.debug("ld_sanction_begin = #{ld_sanction_begin}")
        #                       #   if ld_sanction_month != ld_sanction_begin
        #                       #     ld_sanction_begin = ld_sanction_month
        #                       #   end
        #                       #   case ld_sanction_begin.year
        #                       #     when @id_month.year
        #                       #       if ld_sanction_begin.month <= @id_month.month
        #                       #           ls_sanction = "Y"
        #                       #       else
        #                       #           ls_sanction = "N"
        #                       #       end
        #                       #     when ld_sanction_begin.year < @id_month.year
        #                       #       ls_sanction = "Y"
        #                       #     when ld_sanction_begin.year > @id_month.year
        #                       #       ls_sanction = "N"
        #                       #   end
        #                       # end
        #  # if ls_sanction == 'Y'
        #  #    case ld_sanction_end.year
        #  #       when @id_month.year
        #  #          if ld_sanction_end.month >= @id_month.month
        #  #              ls_sanction = "Y"
        #  #          else
        #  #              ls_sanction = "N"
        #  #          end
        #  #       when ld_sanction_end.year < @id_month.year
        #  #          ls_sanction = "N"
        #  #       when ld_sanction_end.year > @id_month.year
        #  #          ls_sanction = "Y"
        #  #    end
        #  # end
        #  #end

        #  ls_sanction = 'Y' #??? # Pending implementation Rao

        #  if ls_sanction == 'Y'


        #     if @ii_service_program == 4
        #        if ls_sanction_type == 3064
        #            li_sanction_percent = 50
        #            ls_sanction_indicator = 6113 #'F'
        #        end
        #     else
        #        lstr_pass6.db[1] = ll_clientid
        #        lstr_pass6.db[2] = 25

        #        ll_his_counter = lds_tea_sanction_his.size

        #        #ls_find_string = "string(sanction_month,'MM/YYYY') = '" + string(id_month,'MM/YYYY') + "'"
        #        #//search for the month/year of the budget from the list service of the history table
        #        ll_his_rowcount = lds_tea_sanction_his.rowcount()
        #        ll_found = lds_tea_sanction_his.Find( ls_find_string,1,ll_his_rowcount)

        #        lds_tea_sanction_his.each do |sanction|
        #          if Date.civil(ad_sanction_month.year, ad_sanction_month.month, 1) == Date.civil(sanction.sanction_month.year, l_sanction_detail.sanction_month.month, 1)
        #             ll_found = true
        #             ll_found_data = sanction
        #             break
        #          end
        #        end

        #             if ll_found
        #                 li_sanction_percent = ll_found_data.sanction_indicator
        #                 if li_sanction_percent == 6111
        #                                 ls_sanction_indicator = 6111 #'T'
        #                 else
        #                                 ls_sanction_indicator = 6113 #'F'
        #                 end
        #             elsif ll_his_counter >= 3
        #                 li_sanction_percent = 6113 #50
        #                 ls_sanction_indicator = 6113 #'F'
        #             else
        #                 li_sanction_percent = 6111 #25
        #                 ls_sanction_indicator = 6111 #'T'
        #             end
        #          end
        #             break
        #         else
        #             li_cnt = li_cnt + 1
        # end
        #                                                                             end #if
        #                                                             end # each
        #                                             end # while
        #                             end #if
        #             end


        # #  Pending implementation
        #      if (@ii_service_program  == 1) && (ls_sanction_indicator == 6110 || ls_sanction_indicator == 6112) && (ls_sanction == 'Y')
        # #        //No Need to read for Non-Progrressive
        #      else
        # #        //Non-Progressive Sanction Type
        #           if ls_sanction == 'N'

        #                                      # Set up "Sanction Type which are progressive in nature"
        #                                      # lstr_pass8.s[1] = "130"    # // domain code value (key) for Sanction Type Progressive
        #                                     # ll_san_type_prg = gnv_data_access_service.retrieve(lds_reference_table,lds_reference_table, "Rddw_l", lstr_pass8)
        #                                      # ls_filter = " "
        #                                      # ll_san_type_prg = 1
        # #                                  For ll_san_type_prg = 1 to lds_reference_table.rowcount()
        # #                                                  ls_sanction_type_prg =                 trim(lds_reference_table.getitemstring(ll_san_type_prg,"value"))
        # #                                                  if ll_san_type_prg = lds_reference_table.rowcount() then
        # #                                                                  ls_filter = ls_filter + "type <> '" + ls_sanction_type_prg + "'"
        # #                                                  else
        # #                                                                  ls_filter = ls_filter + "type <> '" + ls_sanction_type_prg + "' and "
        # #                                                  end if
        # #                                  Next
        # #                                  //ls_filter = "type <> '28' and type <> 'MP' and type <> '32' and type <> '34' and type <> '31'"
        # #                                  lds_tea_sanction.setfilter(ls_filter)
        # #                                  lds_tea_sanction.filter()


        # #                                  li_filter_count = lds_tea_sanction.size
        # # #                               //Added following code to check sanction begin and end date - J Kelch 10/20/99
        # #                                  if li_filter_count > 0
        # #                                                  li_cnt = 1
        # #                                                  lds_tea_sanction.each do |sanction_detail|
        # #                                                                  if ls_sanction == 'N'
        # #                                                                                  ll_clientid = sanction_detail.client_id
        # #                                                                                  ls_sanction_type =  sanction_detail.sanction_type
        # #                                                                                  li_client_age = Client.get_age(ll_clientid)

        # #                                                                                  lds_bu_comp_rel = ProgramUnitMember.get_primary_beneficiary_from_client_id_and_program_unit_id(ll_clientid, @idb_bu_id)


        # #                                                                                  if lds_bu_comp_rel.present?
        # #                                                                                                  lds_bu_comp_rel = lds_bu_comp_rel.first
        # #                                                                                                  ls_bu_relationship = lds_bu_comp_rel.primary_beneficiary
        # #                                                                                                  if ls_bu_relationship == 'Y'
        # #                                                                                                                  ld_sanction_begin = sanction_detail.effective_beg_date
        # #                                                                                                                  ld_sanction_end = sanction_detail.expiration_date
        # #                                                                                                                  case ld_sanction_begin.year
        # #                                                                                                                                  when ld_sanction_begin.year ==  @id_month.year
        # #                                                                                                                                                  if ld_sanction_begin.month <= @id_month.month
        # #                                                                                                                                                                  ls_sanction = "Y"
        # #                                                                                                                                                  else
        # #                                                                                                                                                                  ls_sanction = "N"
        # #                                                                                                                                                  end
        # #                                                                                                                                  when ld_sanction_begin.year < @id_month.year
        # #                                                                                                                                                  ls_sanction = "Y"
        # #                                                                                                                                  when ld_sanction_begin.year > @id_month.year
        # #                                                                                                                                                  ls_sanction = "N"
        # #                                                                                                                  end

        # #                                                                                                                  if ls_sanction == 'Y'
        # #                                                                                                                                  case ld_sanction_end.year
        # #                                                                                                                                                  when ld_sanction_end.year == @id_month.year
        # #                                                                                                                                                                  if ld_sanction_end.month >= @id_month.month
        # #                                                                                                                                                                                  ls_sanction = "Y"
        # #                                                                                                                                                                  else
        # #                                                                                                                                                                                  ls_sanction = "N"
        # #                                                                                                                                                                  end
        # #                                                                                                                                                  when ld_sanction_end.year < @id_month.year
        # #                                                                                                                                                                  ls_sanction = "N"
        # #                                                                                                                                                  when ld_sanction_end.year > @id_month.year
        # #                                                                                                                                                                  ls_sanction = "Y"
        # #                                                                                                                                  end
        # #                                                                                                                  end
        # #                                                                                                  end
        # #                                                                                  end
        # #                                                                                Destroy lds_bu_comp_rel
        # #                                                                                //* End of PCR#68006 - expansion
        # #                                                                                  case ls_sanction_type
        # #                                                                                                  when '26'
        # #                                                                                                                  ls_sanction_indicator = 'C'
        # #                                                                                                  when 'IM'
        # #                                                                                                                  ls_sanction_indicator = 'I'
        # #                                                                                                  when '33'
        # #                                                                                                                  ls_sanction_indicator = 'P'
        # #                                                                                                  else
        # #                                                                                                                  ls_sanction_indicator = 'N'
        # #                                                                                  end
        # #                                                                  else
        # #                                                                                  break
        # #                                                                  end
        # #                                                  end
        # #                                  end
        #                                 end
        #      end
        # #end #Sanctions old implementation
        # # old implementation of sanctions

        lds_tea_income_limit = ProgramStandardDetail.get_program_limits(120, @id_month)
        if lds_tea_income_limit.present?
                        lds_tea_income_limit = lds_tea_income_limit.first
        end
        #Rails.logger.debug("lds_tea_income_limit = #{lds_tea_income_limit.inspect}")


                    # ****************************************** Panding implementation *********************************************

        if lds_tea_income_limit.present?
            ldc_grant_amount_std = lds_tea_income_limit.program_standard_limit_amount
            if @ii_bu_size > 9
                            lstr_pass.db[1] = 9
                            lstr_pass4.db[1] = 9
            else
                            lstr_pass.db[1] = @ii_bu_size
                            lstr_pass4.db[1] = @ii_bu_size
            end

            if @ii_service_program == 4
                            lstr_pass.s[1] = "51"
                            lstr_pass4.s[2] = "51"
            else
                            lstr_pass.s[1] = "30"
                            lstr_pass4.s[2] = "30"
            end

            lstr_pass.dates[1] = @id_month
            lstr_pass4.s[1] = @id_month.to_s
            lds_tea_grant_amount = ProgramUnitSizeStandardDetail.get_program_grant_amount(lstr_pass.db[1], lstr_pass.dates[1], lstr_pass.s[1])
            #Rails.logger.debug("lds_tea_grant_amount = #{lds_tea_grant_amount.inspect}")

            if lds_tea_grant_amount.present?
                            ldc_full_grant = lds_tea_grant_amount.first.program_limit_amount
                            #Rails.logger.debug("ldc_full_grant = #{ldc_full_grant}")
            else
                            msg = "There is no FULL GRANT standard set up for this budget unit size."
                            ldc_full_grant = 0
                            #Rails.logger.debug("ldc_full_grant = NA")
            end

            # DEMO - CODE - @ii_service_program  == 17 - START
            if @ii_service_program  == 17
                ldc_full_grant = 0
                case  @ii_bu_size
                when 2
                    ldc_full_grant = 357
                when 3
                    ldc_full_grant = 511
                when 4
                    ldc_full_grant = 649
                end
            end
            # DEMO - CODE - @ii_service_program  == 17 - END

            if @ids_10.present? #&& @ids_10.count > 1
            #             count = 1
            #             @ids_10.each do |id|
            #                             if @ii_curr_tearow == count
            #                                             id.full_benefit = ldc_full_grant
            #                                             break
            #                             else
            #                                             count = count + 1
            #                             end
            #             end
            # else
                @ids_10.full_benefit = ldc_full_grant
            end

            if ldc_tot_gross_inc > ldc_grant_amount_std
                            ls_reduced = 'Y'
            else
                            ls_reduced = 'N'
            end

            if @ii_service_program == 4
                            ls_reduced = 'N'
            end



           if (@ii_service_program  == 1) && (ls_sanction_indicator == 6110 || ls_sanction_indicator == 6112 || ls_sanction_indicator == 6114) && (ls_sanction == 'Y')
    #          //No Need to calc for Non-Progressive, calculate only for reduction
               ldc_grant_amount = ldc_full_grant
               ldc_reduction_amt = 0
               ldc_sanction_amt = 0

               if ls_reduced == 'Y' && ls_sanction == 'N'
                   if @ii_bu_size > 9
                       lstr_pass.db[1] = 9
                       #lstr_pass4.db[1] = 9
                   else
                       lstr_pass.db[1] = @ii_bu_size   #//budget unit size

                   end

                   lstr_pass.s[1] = "35"          #//partial grant
                   lstr_pass.dates[1] = @id_month  #//run month
    #                                                                                             //WP Partial Grant is not used for WorkPays
                   if @ii_service_program == 4
                       ldc_partial_grant  = ldc_full_grant
                   end
                    ldc_inc_elig_std1 = ProgramUnitSizeStandardDetail.get_program_grant_amount(lstr_pass.db[1], lstr_pass.dates[1], lstr_pass.s[1])
                    if ldc_inc_elig_std1.present?
                        ldc_partial_grant = ldc_inc_elig_std1.first.program_limit_amount
                    else
                        ldc_partial_grant = 0
                    end
                   ldc_grant_amount = ldc_partial_grant
                   ldc_reduction_amt = ldc_full_grant - ldc_partial_grant
                   ldc_sanction_amt = 0
               else
                   ldc_grant_amount = 0 # for suspend grant amount should be zero
                   ldc_sanction_amt = ldc_full_grant
                   ldc_reduction_amt = 0
               end
           else
               if ls_reduced == 'Y' && ls_sanction == 'Y'
                    if @ii_bu_size > 9
                        lstr_pass.db[1] = 9
                        lstr_pass4.db[1] = 9
                    else
                        lstr_pass.db[1] = @ii_bu_size   #//budget unit size
                    end

                    lstr_pass.s[1] = "35"          #//partial grant
                    lstr_pass.dates[1] = @id_month  #//run month

                    ldc_partial_grant = ProgramUnitSizeStandardDetail.get_program_grant_amount(lstr_pass.db[1], lstr_pass.dates[1], lstr_pass.s[1])
                    if ldc_partial_grant.present?
                        ldc_partial_grant = ldc_partial_grant.first.program_limit_amount
                    else
                        ldc_partial_grant = 0
                    end


                    # Service Program ID 84 for WorkPays, take the Sanctioned Full Grant (25%)
                    if @ii_service_program == 4
                        lstr_pass.s[1] = '52'
                    else
                        lstr_pass.s[1] = '45'
                    end

                    ldc_sanction =  ProgramUnitSizeStandardDetail.get_program_grant_amount(lstr_pass.db[1], lstr_pass.dates[1], lstr_pass.s[1])
                    if ldc_sanction.present?
                        ldc_sanction = ldc_sanction.first.program_limit_amount
                    else
                        ldc_sanction = 0
                    end


                    # //Sanctioned Partial Grant is not used for WorkPays, by defualt it should refer to full grant
                    if @ii_service_program == 4
                        ldc_partial_grant = ldc_full_grant
                    end

                    #Rails.logger.debug("determine_benefit.li_sanction_percent = #{li_sanction_percent}")
                    if li_sanction_percent == 6113 #50 then // 50% sanction will be equal to 25% Tea Partial Grant PCR 65925
                        #Rails.logger.debug("determine_benefit.ldc_partial_grant = #{ldc_partial_grant}")
                        ldc_sanction = (ldc_partial_grant * 0.50).to_i
                    end

                    ldc_grant_amount = ldc_sanction
                    ldc_reduction_amt = ldc_full_grant - ldc_partial_grant
                    ldc_sanction_amt = ldc_full_grant - ldc_reduction_amt - ldc_sanction

               elsif ls_reduced == 'Y'
                    if @ii_bu_size > 9
                        lstr_pass.db[1] = 9
                    else
                        lstr_pass.db[1] = @ii_bu_size
                    end

                    lstr_pass.s[1] = "35"          #//partial grant
                    lstr_pass.dates[1] = @id_month  #//run month

                    # //WP Partial Grant is not used for WorkPays
                    if @ii_service_program == 4
                        ldc_partial_grant = ldc_full_grant
                    end

                    lds_red_tea_grant_amount =  ProgramUnitSizeStandardDetail.get_program_grant_amount(lstr_pass.db[1], lstr_pass.dates[1], lstr_pass.s[1])

                    if lds_red_tea_grant_amount.present?
                        ldc_partial_grant = lds_red_tea_grant_amount.first.program_limit_amount
                    else
                        ldc_partial_grant = 0
                    end
                    ldc_grant_amount = ldc_partial_grant
                    ldc_reduction_amt = ldc_full_grant - ldc_partial_grant
                    ldc_sanction_amt = 0

               elsif ls_sanction == 'Y'
                    if @ii_bu_size > 9
                        lstr_pass.db[1] = 9
                    else
                        lstr_pass.db[1] = @ii_bu_size
                    end

                    lstr_pass.s[1] = '40'
                    lstr_pass.dates[1] = @id_month


                    if @ii_service_program == 4
                        lstr_pass.s[1] = '52'
                    end

                    lds_red_tea_grant_amount =  ProgramUnitSizeStandardDetail.get_program_grant_amount(lstr_pass.db[1], lstr_pass.dates[1], lstr_pass.s[1])

                    if lds_red_tea_grant_amount.present?
                        ldc_sanction = lds_red_tea_grant_amount.first.program_limit_amount
                    else
                        ldc_sanction = 0
                    end

                    if li_sanction_percent == 6113 #// 50% Sanction is equal to 50% of Full Grant                                                                                                                                                                #// Which is equal to Partial Grant PCR 65925
                        #Rails.logger.debug("ldc_full_grant = #{ldc_full_grant}")
                        ldc_sanction = (ldc_full_grant * 0.50).round(0)
                    end

                    if li_sanction_percent == 6114 #// IF close then 100% Sanction is equal to 100% of Full Grant
                        ldc_sanction = ldc_full_grant
                    end
                    ldc_grant_amount = ldc_sanction
                    ldc_reduction_amt = 0
                    ldc_sanction_amt = ldc_full_grant - ldc_sanction
               else
                   ldc_partial_grant = 0
                   ldc_sanction = 0
                   ldc_reduction_amt = 0
                   ldc_sanction_amt = 0
                   ldc_grant_amount = ldc_full_grant
                   ls_sanction_indicator = 6179 #'N' #// PCR 65925
               end
           end

                        #Rails.logger.debug("ldc_full_grant = #{ldc_full_grant}")

            #  DEMO CODE -  @ii_service_program == 17 - SNAP - START
            if (@ii_service_program == 1 ||  @ii_service_program == 17)
                if ls_sanction == 'N'
                    ls_sanction_indicator = 6179 #'N'
                end
            end
            ldc_grant_amount = ldc_grant_amount.round(2)

            if @ids_10.present?
                @ids_10.reduction = ldc_reduction_amt
                @ids_10.sanction = ldc_sanction_amt
                @ids_10.sanction_indicator = ls_sanction_indicator
                @ids_10.benefit_gross_earned = ldc_gross_earned
                @ids_10.benefit_total_unearned = ldc_tot_unearned
                @ids_10.benefit_total_adjusted = ldc_tot_adj
                # TEA Diversion benefit amount should be three times the grant amount.
                if @ii_service_program == 3
                    lds_red_tea_grant_amount =  ProgramUnitSizeStandardDetail.get_program_grant_amount(lstr_pass.db[1], lstr_pass.dates[1], lstr_pass.s[1])
                    if lds_red_tea_grant_amount.present?
                        ldc_grant_amount = lds_red_tea_grant_amount.first.program_limit_amount
                    else
                        ldc_grant_amount = 0
                    end
                    @ids_10.program_benefit_amount = ldc_grant_amount * 3

                else
                    @ids_10.program_benefit_amount = ldc_grant_amount
                end
            end

        end
        if @screening_only == false
            unless @ids_10.save
                            #Rails.logger.debug("benefit_calculator.determine_benefit cannot update @ids_10 #{ProgramBenefitDetail}")
            end
        end
        # //Call the update service

        # //PCR#72489 ELGutierez
        # IF ii_service_program = 84 THEN
        #             //No need to create sanction history online, batch extract file will do the processing.
        # ELSE
        #             //PCR#740454 - ELGutierez ; No need to create sanction history for TEA
        #             IF ii_service_program <> 20 THEN
        #                             // PCR 65925 Anand Kotian
        #                             if ls_sanction_indicator = 'T' or ls_sanction_indicator = 'F' then
        #                                             of_create_sanction_history(ll_clientid,ll_sanctionid,ls_sanction_indicator,ls_sanction_type)
        #                             end if
        #                             // PCR 65925 Anand Kotian
        #             END IF
        # END IF

    # *********************************************

        if (@ii_service_program == 4 || @ii_service_program == 3)
            lstr_pass_stds.db[1] = @ii_bu_size
            lstr_pass_stds.dates[1] = @id_month
            lstr_pass_stds.s[1] = '50'
            ldc_inc_elig_std1 = ProgramUnitSizeStandardDetail.get_program_grant_amount(lstr_pass_stds.db[1], lstr_pass_stds.dates[1], lstr_pass_stds.s[1])
            if ldc_inc_elig_std1.present?
                ldc_inc_elig_std = ldc_inc_elig_std1.first.program_limit_amount
            end
            lds_tea_income_limit = ProgramStandardDetail.get_program_limits(318, @id_month)
            if lds_tea_income_limit.present?
                lds_tea_income_limit = lds_tea_income_limit.first.program_standard_limit_amount
                if  lds_tea_income_limit != 0
                    ldc_income_red_rate = lds_tea_income_limit/100
                end
            end
            #Rails.logger.debug("ldc_income_red_rate = #{ldc_income_red_rate}, ldc_inc_elig_std = #{ldc_inc_elig_std}")
            ldc_inc_elig_std = ldc_income_red_rate * ldc_inc_elig_std
            if ldc_inc_elig_std >= ldc_tot_adj
                ls_budget_elig_ind = 'Y'
            else
                ls_budget_elig_ind = 'N'
            end
            lstr_pass_rule.db[1] = @ii_service_program
            lstr_pass_rule.s[1] = '15'
            lstr_pass_rule.dt[1] = @id_month.to_datetime
            lstr_pass_rule.dt[2] = @id_month.to_datetime
            if bu_rule_id(lstr_pass_rule.db[1], lstr_pass_rule.s[1], lstr_pass_rule.dt[1], lstr_pass_rule.dt[2]) == 0
                ls_budget_elig_ind = 'N'
                ldc_inc_elig_std = 0
            end
            #Pending implementation
            # if ls_budget_elig_ind == 'N'
            #             insert_eligibility_determine_results(@idb_run_id, @idb_month_id, @idb_bu_id, 6127, "program_unit") #Income rule fail
            # end
        end

        lds_bu_mo_summary = ProgramMonthSummary.new
        lds_bu_mo_summary.run_id = @idb_run_id
        lds_bu_mo_summary.program_wizard_id = @program_wizard_id
        lds_bu_mo_summary.month_sequence = @idb_month_id
        lds_bu_mo_summary.program_unit_size = @ii_bu_size
        lds_bu_mo_summary.tot_earned_inc = @istr_income2.tot_e
        lds_bu_mo_summary.tot_unearned_inc = @istr_income2.tot_ue
        lds_bu_mo_summary.tot_expenses = @istr_client_exp.total
        if  @ii_service_program == 3
            lds_bu_mo_summary.bu_sum_result = ldc_grant_amount * 3
        else
            lds_bu_mo_summary.bu_sum_result = ldc_grant_amount
        end

        lds_bu_mo_summary.tot_resources = 0 #Will be implemented later
        if (@ii_service_program == 4 || @ii_service_program == 3)
            lds_bu_mo_summary.budget_eligible_ind = ls_budget_elig_ind
        end

        if (@ii_service_program == 1 && ldc_grant_amount == 0 && ls_sanction == 'N')
            lds_bu_mo_summary.budget_eligible_ind = 'N'
            if @screening_only == true
                @istr_budget.ineligible_codes << 6127
            else
                insert_eligibility_determine_results(@idb_run_id, @idb_month_id, @idb_bu_id, 6127, "program_unit") #Income rule fail
            end


        else
            lds_bu_mo_summary.budget_eligible_ind = 'Y'
        end

        # Manoj 11/17/2014 -start
        # Rule - If any critical errors are found in eligibility determine_results for the Run ID - budget_eligible_ind is set to No.
        ed_critical_errors = EligibilityDetermineResult.get_critical_errors_results_list(@idb_run_id, @idb_month_id)
        if ed_critical_errors.present?
            lds_bu_mo_summary.budget_eligible_ind = 'N'
        end

        # Manoj 11/17/2014 -end

        if @screening_only == false
            unless lds_bu_mo_summary.save
                            #Rails.logger.debug("benefit_calculator.determine_benefit cannot save lds_bu_mo_summary (ProgramMonthSummary)")
            end
        end


        # *****************Pending implementation, will be implemented after eligibilty run is approved***************
        # li_return = gnv_data_access_service.update_service(lds_bu_mo_summary, lds_bu_mo_summary, "Bcms_u", lstr_pass)

        # if @ii_service_program == 4
        #             if ls_budget_elig_ind == 'N'
        #                             lnv_bu = CREATE n_cst_budget_unit
        #                             lnv_bu.of_insert_bdgt_status(idb_bu_id, double(ii_service_program), '03', 'W1', 'ADD')
        #                             gnv_online_interface_controller.of_set_bdgtstatus_refresh(idb_bu_id, TRUE)                //Refresh Budget Unit Status Tab
        #                             DESTROY lnv_bu
        #             end
        # end

        # //PCR#74054 - ELGutierez
        # //Need to update Bwiz Eliigibility Indicator to identify the applied sanction on budget used when displaying the zero Grant Amount on Detail Tab.


        # if ii_service_program == 1
        #                             if ls_sanction == 'N' #THEN //10.01B - Build2
        #                                             ls_sanction_indicator = 6179
        #                             end
        #                             ls_elig_ind = 'S' + ls_sanction_indicator
        #                             if idb_run_id > 0
        #                                             This.of_update_cat_elig_in (idb_run_id, idb_month_id, ls_elig_ind, 'NOTREQ' )
        #                             END IF
        #              END IF=end


        # *************************************************************************************************************

        @istr_income2.tot_e = 0
        @istr_income2.tot_ue = 0

        return ldc_grant_amount

    end

    def self.move_errors_from_application_eligibility_results_to_eligibility_determine_results_table
        clients_ids = ProgramBenefitMember.get_client_ids_associated_with_run_id(@idb_run_id)
        #Rails.logger.debug("clients_ids = #{clients_ids.inspect}")
        if clients_ids.present?
            clients_ids.each do |client|
            # application_eligibility_results = ApplicationEligibilityResults.get_the_results_list_for_the_client(client.client_id)
            # Manoj 10/11/2014
            # Same client can be associated with many rejected/denied program units
            # result should be filtered for program unit in focus.
            application_eligibility_results = ApplicationEligibilityResults.get_the_results_list_for_the_client_and_program_unit_id(client.client_id,@idb_bu_id)
            #Rails.logger.debug("application_eligibility_results = #{application_eligibility_results.inspect}")
                if application_eligibility_results.present?
                    application_eligibility_results.each do |record|
                        unless record.result
                            message = record.data_item_type
                            if @screening_only == true
                                @istr_budget.ineligible_codes << message
                            else
                                insert_eligibility_determine_results(@idb_run_id, @idb_month_id, record.client_id, message, "client")
                            end

                        end
                    end
                end
            end
        end
    end

    def self.insert_eligibility_determine_results(arg_run_id, arg_month_sequence, arg_id, arg_message, arg_type)
        if arg_id.present?
            ins_eligibility_determine_result = EligibilityDetermineResult.new
            ins_eligibility_determine_result.run_id = arg_run_id
            ins_eligibility_determine_result.month_sequence = arg_month_sequence
            if arg_type.present? && arg_type == "client"
                ins_eligibility_determine_result.client_id = arg_id
            else
                ins_eligibility_determine_result.program_unit_id = arg_id
            end
            ins_eligibility_determine_result.message_type = arg_message

            if [6035,6036,6754,6085].include?(arg_message) #6035 = "Immunization", 6036 = "Education", 6754 = "Race Information", 6085 = "Violations check"
                ins_eligibility_determine_result.message_type_text = "Warning"
            else
                ins_eligibility_determine_result.message_type_text = "Critical"
            end
            if ins_eligibility_determine_result.valid?
                if @screening_only == false
                    ins_eligibility_determine_result.save
                end
            else
                if arg_type == "client"
                    #Rails.logger.debug("Can't insert eligibility determination result for client_id: #{ins_eligibility_determine_result.client_id}")
                else
                    #Rails.logger.debug("Can't insert eligibility determination result for program_unit_id: #{ins_eligibility_determine_result.program_unit_id}")
                end
            end
        end
    end



    def self.calc_last_budget(as_calc_type, adb_item_id, ad_beg_date, ad_end_date)
        ldc_ga_amount = 0
        ll_rows = 0
        ll_cnt = 0
        lstr_pass = StrPass.new
        lstr_pass1 = StrPass.new
        ld_save_date = @id_month
        ll_source_row = 0

        if as_calc_type == 'I'
           @is_income_valid = valid_effective_dates(ad_beg_date, ad_end_date)
           if @is_income_valid == 'N'
               return ldc_ga_amount
           else
                lstr_pass.db[1] = @idb_last_run_id
                lstr_pass.db[2] = @idb_last_month_id
                lstr_pass.db[3] = @idb_last_mem_id
                lstr_pass.db[4] = adb_item_id

                lstr_pass1.db[1] = @idb_last_run_id
                lstr_pass1.db[2] = @idb_last_month_id
                lstr_pass1.db[3] = @idb_last_mem_id
                lstr_pass1.db[4] = adb_item_id

                # Kiran 04/09/2015
                # @ii_income_rows is not used a array index so the count should start from 1
                # whereas for @ii_bdgt_mth_rows and @ii_client_rows are used as array index, so the count should be initialized to 0
                count = 1
                l_criteria_a_ind = ""
                @ids_countable_income.each do |income|
                    if count == @ii_income_rows
                        l_criteria_a_ind = income.criteria_a_ind
                        break
                    else
                        count = count + 1
                    end
                end

                if l_criteria_a_ind.present? && l_criteria_a_ind  == 1
                    lstr_pass.s[1] = 'I'
                    lstr_pass1.s[1] = 'I'
                else
                    lstr_pass.s[1] = 'U'
                    lstr_pass1.s[1] = 'U'
                end
                lds_last_calc_method = ProgramMemberDetail.get_program_member_details(@idb_last_run_id, @idb_last_month_id,@idb_last_mem_id, adb_item_id, lstr_pass1.s[1])

               if lds_last_calc_method.present?
                    @is_calc_method = lds_last_calc_method.first.calc_method_code
                    @id_calc_month = lds_last_calc_method.first.last_calc_month
               else
                    # lstr_pass.db[1] = @idb_last_run_id
                    # lstr_pass.db[2] = @idb_last_mont@h_id
                    # lstr_pass.db[3] = @idb_last_mem_id
                    # lstr_pass.s[1] = @is_income_type

                    # lstr_pass2.db[1] = @idb_last_run_id
                    # lstr_pass2.db[2] = @idb_last_month_id
                    # lstr_pass2.db[3] = @idb_last_mem_id
                    # lstr_pass2.s[1] = @is_income_type
                    lds_unconverted_last_calc = ProgramMemberDetail.get_member_unconverted_last_calc_details(@idb_last_run_id, @is_income_type, @idb_last_month_id, @idb_last_mem_id)
                    if lds_unconverted_last_calc.present?
                        ll_cnt = 1
                        if lds_unconverted_last_calc.size == 1
                            ll_source_row = 1
                        else
                            # Implement Later
                            # Do
                            # //R. Durairaj 6/2/00. Defect 1611. As item_source in lds_2 is <= 20 ch,
                            # //    limited matching to 20 CH and set no match default to row 1.
                            # If RightTrim(lds_unconverted_last_calc.GetItemString(ll_cnt, "item_source")) =  RightTrim(Left(is_income_source,20)) then
                            #     ll_source_row = ll_cnt
                            # Elseif ll_cnt = ll_rows then
                            #    ll_source_row = 1
                            # Else
                            #     ll_cnt ++
                            # End if
                            # Loop Until ll_source_row <> 0
                        end
                    end

                    if ll_source_row > 0
                        @id_calc_month = lds_unconverted_last_calc.last_calc_month
                        @is_calc_method = lds_unconverted_last_calc.calc_method_code
                    else
                        @is_last_calc_flag = 'N'
                    end
               end

                if @is_recalc_ind == "N"
                    ldc_ga_amount = last_submit_bdgt(@idb_last_run_id, @idb_last_month_id, @idb_last_mem_id)
                else
                    @id_month = @id_calc_month
                    case @is_calc_method
                        when 5845
                            ldc_ga_amount = calc_averaged(income)
                        when 5846
                            ldc_ga_amount = calc_converted(income)
                        when 5847
                            ldc_ga_amount = calc_intended_use(income)
                        when 5848
                            ldc_ga_amount = calc_actual('Y',income)
                        when 5849
                            ldc_ga_amount = calc_actual('N',income)
                        when 5850
                            ldc_ga_amount = calc_actual_conv('Y',income)
                        when 5851
                            ldc_ga_amount = calc_actual_conv('N',income)
                        else
                            ldc_ga_amount = 0
                            @is_last_calc_flag = 'N'
                    end
                end
           end
        elsif as_calc_type == 'E' || as_calc_type == 'A'
        # Implement if needed
                     @is_expense_valid = valid_effective_dates(ad_beg_date, ad_end_date)

                    if is_expense_valid == 'N'
                                    return ldc_ga_amount
                    else

                    lds_last_calc_method = ProgramMemberDetail.get_member_last_calc_details(@idb_last_run_id, @idb_last_month_id, @idb_last_mem_id, adb_item_id, 'E')

                    if lds_last_calc_method.size > 0
                        @is_exp_calc_method = lds_last_calc_method.calc_method_code
                        ldc_ga_amount = lds_last_calc_method.dollar_amount
                        case @is_exp_calc_method
                            when '01', '02', '03', '04', '05', '06', '07'
                            else
                            @is_last_exp_calc_flag = 'N'
                        end
                    else
                             @is_last_exp_calc_flag = 'N'
                    end
                    end
        end
        @id_month = ld_save_date
        return ldc_ga_amount
    end

    def self.calc_converted(arg_income)
        #             long                                       ll_rows
        # str_pass           lstr_pass
        # int
        li_cnt = 1
        # string                                 ls_frequency, ls_check_type
        # decimal {2}      ldc_ckga_income
        # double                              ldb_income_earned_id
        # n_ds                                  lds_income_countable

        # lstr_pass.db[1] = idb_income_id
        li_num_records = 0
        ldc_ir_total = 0
        ldc_ckga_income = 0
        ls_frequency = 0
        lds_income_countable = IncomeDetail.get_countable_income(@idb_income_id)

        if lds_income_countable.size <= 0
            return ldc_ir_total
        else
            lds_income_countable.each do |income_detail|
               ls_check_type = income_detail.check_type
               #Rails.logger.debug("calc_converted.ls_check_type = #{ls_check_type}")
               if ls_check_type != 4386 && ls_check_type != 4388 #check_type 10 --> 4385, 20 --> 4386, 30 -->4387, 40--> 4388
                    ldb_income_earned_id = income_detail.id

                     @istr_audit_trail.date_of_inc_exp  = income_detail.date_received
                     @istr_audit_trail.check_type      = income_detail.check_type
                     @istr_audit_trail.gross_amount    = income_detail.gross_amt
                     @istr_audit_trail.adjusted_total  = income_detail.adjusted_total
                     @istr_audit_trail.net_amount      = income_detail.net_amt

                    # //Since we are calling this function from a function which calculates
                    # //income the third paramter to the function is passed as 'I'
                    # //We will later determine if it is an earned income or unearned income

                    create_audit_trail_data(@idb_income_id,ldb_income_earned_id,'I',1,arg_income)
                          ldc_ckga_income = det_ckga_amt(ldb_income_earned_id)
                   li_num_records = li_num_records + 1
                   ldc_ir_total = ldc_ir_total + ldc_ckga_income
               end
            end
        end

        if li_num_records == 0
            return ldc_ir_total
        end

        count =1
        @ids_countable_income.each do |income|
            if count == @ii_income_rows
                ls_frequency = income.frequency
                break
            else
                count = count + 1
            end
        end
        #Rails.logger.debug("calc_converted.ls_frequency = #{ls_frequency}")
        case ls_frequency
                        when 2316                                                                                                                                                                                                                                                                          # Bi-weekly
                            ldc_ir_total = (ldc_ir_total/li_num_records) * 2.167
                        when 2320                                                                                                                                                                                                                                                                          # Weekly
                            ldc_ir_total = (ldc_ir_total/li_num_records) * 4.334
                        when 2321                                                                                                                                                                                                                                                          # Annually # ls_frequency = '5' check for CICS
                            ldc_ir_total = (ldc_ir_total/li_num_records)/12
                        when 2330                                                                                                                                                                                                                                                                          # Twice a Month
                            ldc_ir_total = (ldc_ir_total/li_num_records) * 2
                        when 2319                                                                                                                                                                                                                                                                          # Quarterly
                            ldc_ir_total = (ldc_ir_total/li_num_records)/3
                        when 2317                                                                                                                                                                                                                                                                          # Monthly
                            ldc_ir_total = (ldc_ir_total/li_num_records)
        end
        #Rails.logger.debug("calc_converted.ldc_ir_total = #{ldc_ir_total}")
        return ldc_ir_total
    end

    def self.calc_future(ld_budget_month)
    #             string                     ls_frequency, ls_date_increment
    # long                                    ll_days, ll_rows
    # Date                                   ld_check_date, ld_end_date
    # datetime          ldt_end_date
    # Integer                             li_check_month, li_budget_month, li_cnt, li_twice_monthly
    # decimal {2} ldc_last_check_amt, ldc_sd_income = 0
    # str_pass           lstr_pass
    # n_ds                                  lds_income_frequency
    # //Anand Kotian Audit Trail PCR 65267 - Start -01/31/02
    # double ldb_inc_earned_id
    # //Anand Kotian Audit Trail PCR 65267 - End   - 01/31/02

    # ldt_end_date = ids_countable_income.GetItemDatetime(ii_income_rows,"t_income_effective_end_date")
    # ld_end_date = Date(ldt_end_date)

    # //Check income frequency and date and amount of last check in income detail grid
    # lstr_pass.db[1] = idb_income_id
    # lds_income_frequency = Create ds_income_frequency
    # lds_income_frequency.SetTransObject(SQLCA)
    # ll_rows = gnv_data_access_service.retrieve(lds_income_frequency, lds_income_frequency, "Bcif_l", lstr_pass)
    #  SELECT T_INCOME.TYPE,
    #                T_INCOME.FREQUENCY,
    #                T_INCOME.EFFECTIVE_BEG_DATE,
    #                T_INCOME.EFFECTIVE_END_DATE,
    #                T_INCOME_EARNED.DATE_RECEIVED,
    #                T_INCOME_EARNED.GROSS_AMOUNT,
    #                T_INCOME_EARNED.CHECK_TYPE,
    #                T_INCOME_EARNED.ADJUSTED_TOTAL,
    #                T_INCOME_EARNED.NET_AMOUNT,
    #                T_INCOME_EARNED.CNT_FOR_CONVRT_IND,
    #                T_INCOME_EARNED.INCOME_EARNED_ID
    #         FROM T_INCOME LEFT OUTER JOIN T_INCOME_EARNED
    #         ON   T_INCOME.INCOMEID = T_INCOME_EARNED.INCOMEID
    #         WHERE T_INCOME.INCOMEID = :rBcif_incomeid
    #         ORDER BY T_INCOME_EARNED.DATE_RECEIVED DESC;


    # If ll_rows > 0 then

    #             ls_frequency = lds_income_frequency.GetItemString(1, "frequency")
    #             li_cnt = 1

    #             //J Kelch 3/1/00 - Get the last check in the grid that was either received before or during the
    #             //                                                                                            current budget month.  This is the one that should be used to project income.
    #             Do
    #                             ld_check_date = Date(lds_income_frequency.GetItemDateTime(li_cnt, "t_income_earned_date_received"))
    #                             li_cnt ++
    #             Loop Until ld_check_date <= ld_budget_month Or li_cnt > ll_rows

    #             li_cnt --

    #             li_check_month = Month(ld_check_date)
    #             ldc_last_check_amt = lds_income_frequency.GetItemNumber(li_cnt, "t_income_earned_gross_amount")

    #             Choose Case ls_frequency
    #                             Case '40'
    #                                             ls_date_increment = 'D'                                //J Kelch 3/1/00
    #                                             ll_days = 7
    #                             Case '10'
    #                                             ls_date_increment = 'D'                                //J Kelch 3/1/00
    #                                             ll_days = 14
    #                             Case '20'
    #                                             ls_date_increment = 'M'                              //J Kelch 3/1/00 - Changed to increment by the month instead of days
    #                                             ll_days = 1

    #                             //J Kelch 3/1/00 - Added Twice a Month frequency.
    #                             Case 'TM'
    #                                             ls_date_increment = 'M'
    #                                             ll_days = 1
    #                                             //If the budget month is the current month, the actual income received for the month will have
    #                                             //already been counted.  If there was only one check for the month, add in another one.  If two
    #                                             //checks have already been counted, destroy datastore and return.  If there were no checks for
    #                                             //the month, add in two checks, destroy datastore and return.
    #                                             If Month(ld_budget_month) = Month(Today()) then
    #                                                             If IsNull(ld_end_date) Or ld_end_date > ld_check_date then
    #                                                                             If li_check_month < Month(Today()) then
    #                                                                                             ldc_sd_income = ldc_last_check_amt * 2
    #                                                                                             Destroy lds_income_frequency
    #                                                                                             Return ldc_sd_income
    #                                                                             Else
    #                                                                                             If li_cnt < ll_rows then
    #                                                                                                             li_cnt ++
    #                                                                                                             ld_check_date = Date(lds_income_frequency.GetItemDateTime(li_cnt, "t_income_earned_date_received"))
    #                                                                                                             If Month(ld_check_date) = li_check_month then
    #                                                                                                                             ldc_sd_income = 0
    #                                                                                                                             Destroy lds_income_frequency
    #                                                                                                                             Return ldc_sd_income
    #                                                                                                             Else
    #                                                                                                                             ldc_sd_income = ldc_last_check_amt
    #                                                                                                                             Destroy lds_income_frequency
    #                                                                                                                             Return ldc_sd_income
    #                                                                                                             End if

    #                                                                                             Else
    #                                                                                                             ldc_sd_income = ldc_last_check_amt
    #                                                                                                             Destroy lds_income_frequency
    #                                                                                                             Return ldc_sd_income
    #                                                                                             End if
    #                                                                             End if
    #                                                             End if
    #                                             //If the budget month is not the current month, set the increment variables and
    #                                             //initialize a variable to keep track of the number of checks that have been
    #                                             //counted for the month.  A max of two should be counted.
    #                                             Else
    #                                                             ls_date_increment = 'D'
    #                                                             li_twice_monthly = 0
    #                                                             If Month(ld_budget_month) = 2 then
    #                                                                             ll_days = 14
    #                                                             Else
    #                                                                             ll_days = 15
    #                                                             End If
    #                                             End if
    #                             //J Kelch 3/1/00 - Don't increment for other income frequencies
    #                             Case Else
    #                                             Destroy lds_income_frequency
    #                                             Return 0
    #             End Choose

    #             //J Kelch 3/1/00 - If the budget month is the current month, all income received during the month will have been
    #             //                                                                                            counted already.  Increment the check date to ensure that no check is counted twice.
    #             If Month(ld_budget_month) = Month(Today()) then
    #                             ld_check_date = f_future_date(Date(lds_income_frequency.GetItemDateTime(1, "t_income_earned_date_received")), ls_date_increment, ll_days)
    #             End if

    #             //J Kelch 11/12/99 - Put this check here because going to a new year, the Do Until Loop may never get executed
    #             //                                                                                                            "Do until 12 > 01"
    #             If Year(ld_budget_month) > Year(ld_check_date) then
    #                             li_check_month = Month(ld_check_date) - 12
    #             Else
    #                             li_check_month = Month(ld_check_date)
    #             End if

    #             li_budget_month = Month(ld_budget_month)

    #             Do until li_check_month > li_budget_month
    #                             If IsNull(ld_end_date) or ld_end_date >= ld_check_date then
    #                                             If li_check_month = li_budget_month then
    #                                                             //J Kelch 3/1/00 - Don't count more than two checks for the twice a month frequency.
    #                                                             If ls_frequency = 'TM' then
    #                                                                             If li_twice_monthly < 2 then
    #                                                                                             ldc_sd_income = ldc_sd_income + ldc_last_check_amt
    #                                                                                             li_twice_monthly ++
    #                                                                             End if
    #                                                             Else
    #                                                                             ldc_sd_income = ldc_sd_income + ldc_last_check_amt
    #                                                             End if
    #                                             End if

    #                                             ld_check_date = f_future_date(ld_check_date,ls_date_increment, ll_days) //J Kelch 3/1/00 - Send variable ls_date_increment

    #                                             Choose Case Year(ld_budget_month)
    #                                                             Case Is > Year(ld_check_date)
    #                                                                             li_check_month = Month(ld_check_date) - 12
    #                                                             Case Is < Year(ld_check_date)
    #                                                                             li_check_month = Month(ld_check_date) + 12
    #                                                             Case Year(ld_check_date)
    #                                                                             li_check_month = Month(ld_check_date)
    #                                             End Choose
    #                             //J Kelch 3/1/00 - Added an else so that function would stop incrementing when the income record is not effective.
    #                             Else
    #                                             li_check_month = 13
    #                             End if
    #             Loop
    #             //Anand Kotian Audit Trail PCR 65267 - Start 01/31/02
    #             if ldc_sd_income > 0 then
    #                             ldb_inc_earned_id = lds_income_frequency.GetItemNumber(li_cnt,"t_income_earned_income_earned_id")
    #                             istr_audit_trail.date_of_inc_exp = lds_income_frequency.GetItemDatetime(li_cnt,"t_income_earned_date_received")
    #                             istr_audit_trail.check_type      = lds_income_frequency.GetitemString(li_cnt,"t_income_earned_check_type")
    #                             istr_audit_trail.gross_amount    = lds_income_frequency.GetitemNumber(li_cnt,"t_income_earned_gross_amount")
    #                             istr_audit_trail.adjusted_total  = lds_income_frequency.GetitemNumber(li_cnt,"t_income_earned_adjusted_total")
    #                             istr_audit_trail.net_amount      = lds_income_frequency.GetitemNumber(li_cnt,"t_income_earned_net_amount")

    #                             //Since we are calling this function from a function which calculates
    #                             //income the third paramter to the function is passed as 'I'
    #                             //We will later determine if it is an earned income or unearned income
    #                             of_create_audit_trail_data(idb_income_id,ldb_inc_earned_id,'I',li_cnt,@istr_audit_trail)
    #             end if
    #             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
    # End if
    # Destroy lds_income_frequency

    # Return ldc_sd_income

    # //***********************************************************************
    # //*  Release  Date     Task         Author                              *
    # //*  Description                                                        *
    # //***********************************************************************
    # //*  2.000    07/14/99 ANSWER                                                Jennifer Kelch                      *
    # //*  Function determines monthly income amount for future months based  *
    # //*  on the last check in the income detail grid.                       *
    # //***********************************************************************
    # //*  3.000    09/16/99 ANSWER                                Jennifer Kelch                      *
    # //*  Corrected infinite loop.                                                                                                                                                                                                                     *
    # //***********************************************************************
    # //*  3.015           03/01/00 ANSWER                                         Jennifer Kelch                                                                                                                   *
    # //*  Added code to process correctly for twice a month and monthly                   *
    # //*  income frequencies.  Defect 1052.                                                                                                                                                                                               *
    # //***********************************************************************
    # //*  7.003A    03/19/02 ANSWER                                             Anand Kotian                                                                                                     *
    # //*  Collecting the check details which will be used in the                                      *
    # //*  of_create_audit_trail_data function Audit Trail PCR 65267                                                *
    # //***********************************************************************

    end

    def self.exp_calc_actual(as_use_estimated, as_exp_type, adb_exp_id)
    #             Integer                                 li_cnt
    # long                                    ll_rows
    # decimal {2} ldc_expense_amt
    # string                 ls_use_code, ls_cnt_payment
    # n_ds                                  lds_actual_exp
    # str_pass           lstr_pass
    # //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    # Double ldb_debt_exp_detail_id
    # //Anand Kotian Audit Trail PCR 65267 - End   - 01/31/02

    # lds_actual_exp = Create ds_actual_expenses
    # lds_actual_exp.SetTransObject(SQLCA)

    # lstr_pass.db[1] = adb_exp_id
    # lstr_pass.db[2] = Month(id_month)
    # lstr_pass.db[3] = Year(id_month)

    # ll_rows = gnv_data_access_service.retrieve(lds_actual_exp, lds_actual_exp, "Acex_l", lstr_pass)
    #   SELECT debt_exp_detail_id,
    #                exp_due_date,
    #                expense_amount,
    #                exp_use_code,
    #                payment_method,
    #                payment_status,
    #                debt_expid
    #           FROM t_debt_exp_detail
    #          WHERE ( debt_expid          = :rAcex_debt_expid ) AND
    #                ( Month(exp_due_date) = :rAcex_month ) AND
    #                ( Year(exp_due_date)  = :rAcex_year );


    # //If calculating for a retro month, don't include any estimated payments.
    # If ll_rows > 0 then
    #             If as_use_estimated = 'N' then

    #                             lds_actual_exp.SetFilter("payment_status <> '30'")
    #                             lds_actual_exp.Filter()
    #             End if
    #             ll_rows = lds_actual_exp.RowCount()
    # End if

    # If ll_rows > 0 then

    # ldc_expense_amt = 0

    # li_cnt = 1
    # Do While li_cnt <= ll_rows

    #             //Each expense payment must be checked to see if it has a valid use.
    #             ls_use_code = lds_actual_exp.GetItemString(li_cnt, "exp_use_code")
    #             //Anand Kotian Audit Trail PCR 65267     - Start - 01/31/02
    #             ldb_debt_exp_detail_id = lds_actual_exp.GetItemnumber(li_cnt, "debt_exp_detail_id")
    #             //Anand Kotian Audit Trail PCR 65267  - End   - 01/31/02

    #             If of_check_exp_use(as_exp_type, ls_use_code) = 'Y' Then
    #                             //Anand Kotian Audit Trail PCR 65267  - Start - 01/31/02
    #                             istr_audit_trail.date_of_inc_exp = lds_actual_exp.Getitemdatetime(li_cnt,"exp_due_date")
    #                             istr_audit_trail.gross_amount    = lds_actual_exp.Getitemnumber(li_cnt,"expense_amount")
    #                             istr_audit_trail.payment_status  = lds_actual_exp.Getitemstring(li_cnt,"payment_status")
    #                             istr_audit_trail.use_code        = lds_actual_exp.GetitemString(li_cnt,"exp_use_code")
    #                             of_create_audit_trail_data(adb_exp_id,ldb_debt_exp_detail_id,'E',li_cnt,@istr_audit_trail)
    #                             //Anand Kotian Audit Trail PCR 65267  - End   - 01/31/02
    #                             ldc_expense_amt = ldc_expense_amt + lds_actual_exp.GetItemNumber(li_cnt, 'expense_amount')
    #             End if

    #             li_cnt = li_cnt + 1
    # Loop
    # End if

    # Destroy lds_actual_exp

    # Return ldc_expense_amt

    # //**************************************************************************
    # //*  Release  Date        Task                       Author                                  *
    # //*  Description                                                             *
    # //**************************************************************************
    # //*  4.003         ANSWER                              05/25/00                                              Jennifer Kelch                                                                                   *
    # //*  This function calculates the actual value for expenses within the                   *
    # //*  current budget month.                                                                                                                                                                                                                                                     *
    # //**************************************************************************
    # //*  7.003         ANSWER                              03/19/02                                              Anand Kotian                                                                                                     *
    # //*  Collect Payment Details and call create function to create records for*
    # //*  Audit Trail updation PCR 65267                                                                                                                                                                                                                      *
    # //**************************************************************************

    end
    def self.exp_calc_actual_conv(as_use_estimated, as_exp_type, as_exp_frequency, adb_exp_id)
    # Integer                             li_cnt, li_num_records = 0
    # long                                    ll_rows
    # decimal {2} ldc_expense_amt
    # string                 ls_use_code, ls_cnt_payment
    # n_ds                                  lds_actual_expenses
    # str_pass           lstr_pass
    # //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    # Double ldb_debt_exp_detail_id
    # //Anand Kotian Audit Trail PCR 65267 - End   - 01/31/02

    # lds_actual_expenses = Create ds_actual_expenses
    # lds_actual_expenses.SetTransObject(SQLCA)

    # lstr_pass.db[1] = adb_exp_id
    # lstr_pass.db[2] = Month(id_month)
    # lstr_pass.db[3] = Year(id_month)

    # ll_rows = gnv_data_access_service.retrieve(lds_actual_expenses, lds_actual_expenses, "Acex_l", lstr_pass)
    #  SELECT debt_exp_detail_id,
    #                exp_due_date,
    #                expense_amount,
    #                exp_use_code,
    #                payment_method,
    #                payment_status,
    #                debt_expid
    #           FROM t_debt_exp_detail
    #          WHERE ( debt_expid          = :rAcex_debt_expid ) AND
    #                ( Month(exp_due_date) = :rAcex_month ) AND
    #                ( Year(exp_due_date)  = :rAcex_year );



    # If ll_rows > 0 then
    #             If as_use_estimated = 'N' then
    #                             lds_actual_expenses.SetFilter("payment_status <> '30'")
    #                             lds_actual_expenses.Filter()
    #             End if
    #             ll_rows = lds_actual_expenses.RowCount()
    # End if

    # If ll_rows > 0 then

    #             ldc_expense_amt = 0

    #             li_cnt = 1
    #             Do While li_cnt <= ll_rows
    #                             ls_use_code = lds_actual_expenses.GetItemString(li_cnt, "exp_use_code")
    #                             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                             ldb_debt_exp_detail_id = lds_actual_expenses.Getitemnumber(li_cnt,"debt_exp_detail_id")
    #                             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
    #                             If of_check_exp_use(as_exp_type, ls_use_code) = 'Y' Then
    #                                             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                                             istr_audit_trail.date_of_inc_exp = lds_actual_expenses.Getitemdatetime(li_cnt,"exp_due_date")
    #                                             istr_audit_trail.gross_amount    = lds_actual_expenses.Getitemnumber(li_cnt,"expense_amount")
    #                                             istr_audit_trail.payment_status  = lds_actual_expenses.Getitemstring(li_cnt,"payment_status")
    #                                             istr_audit_trail.use_code        = lds_actual_expenses.GetitemString(li_cnt,"exp_use_code")
    #                                             of_create_audit_trail_data(adb_exp_id,ldb_debt_exp_detail_id,'E',li_cnt,@istr_audit_trail)
    #                                             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
    #                                             li_num_records ++
    #                                             ldc_expense_amt = ldc_expense_amt + lds_actual_expenses.GetItemNumber(li_cnt, 'expense_amount')
    #                             End if

    #                             li_cnt = li_cnt + 1
    #             Loop
    # End if

    # Destroy lds_actual_expenses

    # If li_num_records <= 0 Then
    #             Return 0
    # End if

    # Choose Case as_exp_frequency
    #             Case '10'                                                                                                                                                                                                                                                                               //Bi-weekly
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records) * 2.167
    #             Case '40'                                                                                                                                                                                                                                                                               //Weekly
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records) * 4.334
    #             Case '5 ', '5'                                                                                                                                                                                                                                                         //Annually //ls_frequency = '5' check for CICS
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records)/12
    #             Case 'TM'                                                                                                                                                                                                                                                                             //Twice a Month
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records) * 2
    #             Case '30'                                                                                                                                                                                                                                                                               //Quarterly
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records)/3
    #             Case '20'                                                                                                                                                                                                                                                                               //Monthly
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records)
    # End Choose

    # Return ldc_expense_amt

    # //********************************************************************
    # //*  4.003         ANSWER                              05/25/00                                              Jennifer Kelch                                                   *
    # //*  This function calculates the actual value for expenses within           *
    # //*  the current budget month.                                                                                                                                                                                                             *
    # //********************************************************************
    # //*  7.003         ANSWER                              03/19/02                                              Anand Kotian                                                                     *
    # //*  Collect Payment Details and call create function to create      *
    # //*  records for Audit Trail updation PCR 65267                                                                                                                               *
    # //********************************************************************

    end
    def self.exp_calc_converted(as_exp_frequency, as_exp_type, adb_exp_id)
    #             long                                       ll_rows
    # str_pass           lstr_pass
    # int                                       li_cnt = 1, li_num_records = 0
    # string                                 ls_frequency, ls_check_type
    # decimal {2}      ldc_expense_amt = 0
    # double                              ldb_income_earned_id
    # string                 ls_use_code
    # n_ds                                  lds_countable_exp
    # //Anand Kotian Audit Trail PCR 65267 - 01/31/02
    # Double ldb_debt_exp_detail_id
    # //Anand Kotian Audit Trail PCR 65267 - 01/31/02

    # lstr_pass.db[1] = adb_exp_id

    # lds_countable_exp = Create ds_countable_exp
    # lds_countable_exp.SetTransObject(SQLCA)
    # ll_rows = gnv_data_access_service.retrieve(lds_countable_exp, lds_countable_exp, "Coex_l", lstr_pass)
    # SELECT debt_exp_detail_id,
    #                exp_due_date,
    #                expense_amount,
    #                exp_use_code,
    #                payment_method,
    #                payment_status,
    #                exp_calc_ind
    #         FROM t_debt_exp_detail
    #         WHERE (debt_expid = :rCoex_debt_expid)
    #         AND   (exp_calc_ind = 'Y');


    # If ll_rows <= 0 then
    #             Destroy lds_countable_exp
    #             Return ldc_expense_amt
    # Else
    #             Do While li_cnt <= ll_rows

    #                             If lds_countable_exp.GetItemString(li_cnt, "payment_status") <> '35' Then
    #                                             ls_use_code = lds_countable_exp.GetItemString(li_cnt, "exp_use_code")
    #                                             //Anand Kotian Audit Trail PCR 65267 - Start 01/31/02
    #                                             ldb_debt_exp_detail_id = lds_countable_exp.Getitemnumber(li_cnt,"debt_exp_detail_id")
    #                                             //Anand Kotian Audit Trail PCR 65267 - End 01/31/02
    #                                             If of_check_exp_use(as_exp_type, ls_use_code) = 'Y' Then
    #                                                             //Anand Kotian Audit Trail PCR 65267 - Start 01/31/02
    #                                                             istr_audit_trail.date_of_inc_exp = lds_countable_exp.Getitemdatetime(li_cnt,"exp_due_date")
    #                                                             istr_audit_trail.gross_amount    = lds_countable_exp.Getitemnumber(li_cnt,"expense_amount")
    #                                                             istr_audit_trail.payment_status  = lds_countable_exp.Getitemstring(li_cnt,"payment_status")
    #                                                             istr_audit_trail.use_code        = lds_countable_exp.GetitemString(li_cnt,"exp_use_code")
    #                                                             of_create_audit_trail_data(adb_exp_id,ldb_debt_exp_detail_id,'E',li_cnt,@istr_audit_trail)
    #                                                             //Anand Kotian Audit Trail PCR 65267 - End 01/31/02
    #                                                             li_num_records ++
    #                                                             ldc_expense_amt = ldc_expense_amt + lds_countable_exp.GetItemNumber(li_cnt, "expense_amount")
    #                                             End if
    #                             End if

    #                             li_cnt ++
    #             Loop
    # End If

    # If li_num_records = 0 then
    #             Destroy lds_countable_exp
    #             Return ldc_expense_amt
    # End if

    # ////////////////////////////////////////////////////////////////////////////

    # Choose Case as_exp_frequency
    #             Case '10'                                                                                                                                                                                                                                                                               //Bi-weekly
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records) * 2.167
    #             Case '40'                                                                                                                                                                                                                                                                               //Weekly
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records) * 4.334
    #             Case '5 ', '5'                                                                                                                                                                                                                                                         //Annually //ls_frequency = '5' check for CICS
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records)/12
    #             Case 'TM'                                                                                                                                                                                                                                                                             //Twice a Month
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records) * 2
    #             Case '30'                                                                                                                                                                                                                                                                               //Quarterly
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records)/3
    #             Case '20'                                                                                                                                                                                                                                                                               //Monthly
    #                             ldc_expense_amt = (ldc_expense_amt/li_num_records)
    # End Choose

    # Destroy lds_countable_exp

    # Return ldc_expense_amt

    # //***********************************************************************
    # //*  Release  Date     Task         Author                              *
    # //*  Description                                                        *
    # //***********************************************************************
    # //*  4.003    06/06/00 ANSWER                                                Jennifer Kelch                      *
    # //*  Function determines a monthly expense amount using the conversion  *
    # //*  method. Added for Enhancement 1113.                                                                                                                                                                   *
    # //***********************************************************************
    # //*  7.003         ANSWER                              03/19/02                                              Anand Kotian                                                                                     *
    # //*  Collect Payment Details and call create function to create records *
    # //*  for Audit Trail updation PCR 65267                                                                                                                                                                               *
    # //***********************************************************************


    end
    def self.exp_calc_intended_use(adb_expense_id, as_exp_type, ai_exp_months)
    #             long                                       ll_rows
    # str_pass           lstr_pass
    # int                                       li_cnt = 1
    # decimal {2}      ldc_expense_amt = 0
    # string                 ls_use_code
    # n_ds                                  lds_countable_exp
    # //Anand Kotian Audit Trail PCR 65267 - Start 01/31/02
    # Double ldb_debt_exp_detail_id
    # //Anand Kotian Audit Trail PCR 65267 - End   01/31/02

    # lstr_pass.db[1] = adb_expense_id

    # lds_countable_exp = Create ds_countable_exp
    # lds_countable_exp.SetTransObject(SQLCA)
    # ll_rows = gnv_data_access_service.retrieve(lds_countable_exp, lds_countable_exp, "Coex_l", lstr_pass)
    # # SELECT debt_exp_detail_id,
    # #                exp_due_date,
    # #                expense_amount,
    # #                exp_use_code,
    # #                payment_method,
    # #                payment_status,
    # #                exp_calc_ind
    # #         FROM t_debt_exp_detail
    # #         WHERE (debt_expid = :rCoex_debt_expid)
    # #         AND   (exp_calc_ind = 'Y');


    # If ll_rows <= 0 then
    #             Destroy lds_countable_exp
    #             Return ldc_expense_amt
    # Else
    #             Do While li_cnt <= ll_rows
    #                             ls_use_code = lds_countable_exp.GetItemString(li_cnt, "exp_use_code")
    #                             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                             ldb_debt_exp_detail_id = lds_countable_exp.GetitemNumber(li_cnt,"debt_exp_detail_id")
    #                             //Anand Kotian Audit Trail PCR 65267 - End   - 01/31/02
    #                             If of_check_exp_use(as_exp_type, ls_use_code) = 'Y' Then
    #                                             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                                             istr_audit_trail.date_of_inc_exp = lds_countable_exp.Getitemdatetime(li_cnt,"exp_due_date")
    #                                             istr_audit_trail.gross_amount    = lds_countable_exp.Getitemnumber(li_cnt,"expense_amount")
    #                                             istr_audit_trail.payment_status  = lds_countable_exp.Getitemstring(li_cnt,"payment_status")
    #                                             istr_audit_trail.use_code        = lds_countable_exp.GetitemString(li_cnt,"exp_use_code")
    #                                             of_create_audit_trail_data(adb_expense_id,ldb_debt_exp_detail_id,'E',li_cnt,@istr_audit_trail)
    #                                             //Anand Kotian Audit Trail PCR 65267 - End  - 01/31/02
    #                                             ldc_expense_amt = ldc_expense_amt + lds_countable_exp.GetItemNumber(li_cnt, "expense_amount")
    #                             End if

    #                             li_cnt ++
    #             Loop
    # End If

    # If ldc_expense_amt = 0 then  //J Kelch 1/19/00 - Added to ensure division by 0 doesn't occur
    #             Destroy lds_countable_exp
    #             Return ldc_expense_amt
    # End if

    # ldc_expense_amt = ldc_expense_amt/ai_exp_months

    # Return ldc_expense_amt

    # //***********************************************************************
    # //*  Release  Date     Task         Author                              *
    # //*  Description                                                        *
    # //***********************************************************************
    # //*  4.003    06/06/00 ANSWER                                                Jennifer Kelch                      *
    # //*  Function determines a monthly expense amount using the intended            *
    # //*  use method.  Added for enhancement 1113.                                                                                                                                          *
    # //***********************************************************************
    # //*  7.003         ANSWER                              03/19/02                                              Anand Kotian                                                                                     *
    # //*  Collect Payment Details and call create function to create records *
    # //*  for Audit Trail updation PCR 65267                                                                                                                                                                               *
    # //***********************************************************************

    end
    def self.cl_tea_net_income(adc_ga_income)
        #             //Declaration of variables
        # n_cst_datetime                            inv_datetime
        # n_ds                                                                  lds_client_head_of_hh, lds_member_room_board, lds_t_b_mem_details
        # n_ds                                                                  lds_bmem_summary, lds_bu_comp_rel
        # str_pass                                                           lstr_pass, lstr_pass1, lstr_pass2
        # long                                                                    ll_rows
        # string                                                 ls_frequency
        # decimal {2}       ldc_room_board = 120
        # double            ldb_hhid
        # string            ls_income_flag
        # str_income2       lstr_income2
        # decimal {2}       ldc_ga_income, ldc_tot_earned, ldc_ojt_sub_emp, ldc_gross_earned
        # integer           li_cnt, li_return
        # decimal {2}       ldc_work_related_ded, ldc_remaining_earnings, ldc_work_incentive_ded
        # integer           li_max_rows
        # date                                                                   ld_dob
        # long                                                                    ll_age
        # date                                                                   ld_bms_start
        # date                                                                   ld_bms_stop
        # String                                                 ls_resource_ind
        ls_bu_relationship = 0
        ls_bdm_row_indicator = 0
        ldb_member_id = 0
        ls_income_flag = 0
        ls_frequency  = 0
        ls_resource_ind = 0
        # //********************* TEA - CLIENT LEVEL EXCLUSIONS FOR NET INCOME **********************
        # //Get the current income amount
        ldc_ga_income = adc_ga_income
        #Rails.logger.debug("cl_tea_net_income.ldc_ga_income = #{ldc_ga_income}")
        count = 1
        @ids_countable_income.each do |income|
            if count == @ii_income_rows
                ls_income_flag = income.criteria_a_ind.to_i
                ls_resource_ind = income.criteria_b_ind.to_i
                break
            else
                count = count + 1
            end
        end
        # //Move The condition before the child support deduction Anand Kotian 01/04/2001 defect 1976
        if ldc_ga_income < 5                       # If income is less than $5.00, it is excluded for TEA.
          ldc_ga_income = 0
        end

        # Disregard the earnings of a bu member who is under age 18 and NOT the head of the budget unit.
        if ls_income_flag == 1
            # Needs a revisit

            # lds_bu_comp_rel = ProgramUnitMember.get_primary_beneficiary(@idb_bu_id)
            # if lds_bu_comp_rel.size > 0
            #     ls_bu_relationship = lds_bu_comp_rel.first.primary_beneficiary
            #     ll_age = Client.get_age(@idb_client_id)
            #     if ll_age != -1
            #         if ll_age < 18 && ls_bu_relationship != 'Y'
            #             ldc_ga_income = 0
            #         end
            #     else
            #         #Rails.logger.debug("benefit_calculator.cl_tea_net_income age not available for client #{@idb_client_id}")
            #     end
            # end
        end
        count = 1
        @ids_countable_income.each do |income|
            if count == @ii_income_rows
                ls_frequency = income.frequency
                #Rails.logger.debug("income = #{income.inspect}")
                break
            else
                count = count + 1
            end
        end

        if ls_frequency == 2327
            ldc_ga_income = 0
        end

        if ls_frequency == 2318
            ls_resource_ind = 1
        end

        # "Roommate" (21-Roomer) or "Boarder" (28) income type cases will be handled if needed
        # if @is_income_type = 2791 # "RB" --> 2797
        # #   lstr_pass.db[1] = idb_client_id
        # #          lstr_pass.db[2] = idb_bu_id  //budget_unit_id

        # lds_client_head_of_hh = ProgramUnitMember.get_primary_beneficiary(@idb_client_id, @idb_bu_id, '00')
        # lds_client_head_of_hh = PrimaryContact.get_primary_contact(@idb_bu_id, 6345)

        # #    //Retrieve the Member Role for the Client you are on to see if they are the Head of Household
        # #    ll_rows = gnv_data_access_service.retrieve(lds_client_head_of_hh,lds_client_head_of_hh,"Bcch_l",lstr_pass)
        # #     SELECT T_budget_unit.householdid,
        # #                T_budget_unit.budget_unit_id,
        # #                T_household_member.clientid,
        # #                T_household_member.hh_memb_role
        # #         FROM T_household_member,
        # #              T_budget_unit,
        # #              T_budget_unit_comp
        # #         WHERE ( T_household_member.householdid = T_budget_unit.householdid )
        # #         AND ( T_budget_unit_comp.budget_unit_id = T_budget_unit.budget_unit_id )
        # #         AND ( T_budget_unit_comp.clientid = T_household_member.clientid )
        # #         AND ( ( T_budget_unit_comp.clientid = :rBcch_clientid )
        # #         AND ( T_budget_unit_comp.budget_unit_id = :rBcch_budget_unit_id )
        # #         AND ( T_household_member.hh_memb_role = '00' ) );


        # #    //You know the current client is the "Head of Household"(00) if ll_rows is greater than zero
        # #          IF ll_rows > 0 THEN

        # #                          //Get the Household_ID from ds_client_head_of_hh
        # #                          ldb_hhid = DOUBLE(lds_client_head_of_hh.GetItemNumber(1, "t_budget_unit_householdid"))

        # #             //Get the datastore ready
        # #       lds_member_room_board = CREATE ds_member_room_board
        # #       lds_member_room_board.SetTransObject(SQLCA)

        # #                          //Set the local structure equal to whatever is in the instance structure
        # #       lstr_pass.db[1] = ldb_hhid

        # #       lstr_pass1.db[1] = ldb_hhid

        # #                          //Retrieve the Member Roles for all members within the MasterCase to see if any of
        # #                          //them are either "Roommate" (21-Roomer) or "Boarder" (28)
        # #                          If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
        # #                ll_rows = gnv_data_access_service.retrieve(lds_member_room_board,lds_member_room_board,"Bcmr_l",lstr_pass1)
        # #                          Else
        # #                 SELECT householdid,
        # #                clientid,
        # #                hh_memb_role
        # #         FROM t_household_member
        # #         WHERE ( t_household_member.householdid = :rBcmr_householdid ) AND
        # #               ( t_household_member.hh_memb_role in ('21','28') ) ;

        # #                          End If

        # #                          //ll_rows tells how many members are "Roommate" or "Boarder"
        # #             IF ll_rows > 0 THEN
        # #                                          //Take the idc_net_income amount from the Unearned Income Exclusions or the
        # #                                          //structure if none and subtract $120 per Roomer/Boarder from it
        # #                                          ldc_ga_income = (ldc_ga_income - (ldc_room_board * ll_rows))
        # #                          END IF

        # #                          Destroy lds_member_room_board
        # #          END IF
        # end

        if ls_income_flag == 1
           ls_bdm_row_indicator = "I"
        else
           ls_bdm_row_indicator = "U"
        end
        #Rails.logger.debug("-->cl_tea_net_income.ls_resource_ind = #{ls_resource_ind}")
        #Rails.logger.debug("-->cl_tea_net_income.ls_income_flag = #{ls_income_flag}")
        if ls_resource_ind.to_i == 0
        #             //Check to see if the current income record is "Earned"
        #Rails.logger.debug("-->cl_tea_net_income.ls_income_flag = #{ls_income_flag}")
            if ls_income_flag.to_i == 1
                #Rails.logger.debug("before cl_tea_net_income.@istr_income2.tot_e = #{@istr_income2.tot_e}")
                if ldc_ga_income < 0
                                ldc_ga_income = 0
                end
                @istr_income2.earned_cl = @istr_income2.earned_cl + ldc_ga_income
                # fail
                @istr_income2.tot_e = @istr_income2.tot_e + ldc_ga_income
                #Rails.logger.debug("cl_tea_net_income.@istr_income2.tot_e = #{@istr_income2.tot_e}")
            else
                @istr_income2.unearned_cl = @istr_income2.unearned_cl + ldc_ga_income
                @istr_income2.tot_ue = @istr_income2.tot_ue + ldc_ga_income
            end

            case @is_income_type
                when 2706 #|| 2814 || 2828
                    @istr_income2.ssa_cl = @istr_income2.ssa_cl + ldc_ga_income
                    @istr_income2.ssa = @istr_income2.ssa + ldc_ga_income
                when 2814
                    @istr_income2.ssa_cl = @istr_income2.ssa_cl + ldc_ga_income
                    @istr_income2.ssa = @istr_income2.ssa + ldc_ga_income
                when 2828
                    @istr_income2.ssa_cl = @istr_income2.ssa_cl + ldc_ga_income
                    @istr_income2.ssa = @istr_income2.ssa + ldc_ga_income
                when 2665 #|| 2849
                    @istr_income2.va_cl = @istr_income2.va_cl + ldc_ga_income
                    @istr_income2.va = @istr_income2.va + ldc_ga_income
                when 2849
                    @istr_income2.va_cl = @istr_income2.va_cl + ldc_ga_income
                    @istr_income2.va = @istr_income2.va + ldc_ga_income
                when 2803
                    @istr_income2.rr_cl = @istr_income2.rr_cl + ldc_ga_income
                    @istr_income2.rr = @istr_income2.rr + ldc_ga_income
                when 2674
                    @istr_income2.child_support = @istr_income2.child_support + ldc_ga_income
                    @istr_income2.child_support_cl = @istr_income2.child_support_cl + ldc_ga_income
                when 2825
                    @istr_income2.ojt = @istr_income2.ojt + ldc_ga_income
                    @istr_income2.ojt_cl = @istr_income2.ojt_cl + ldc_ga_income
                when 5909 #|| 2796
                    @istr_income2.sub_employment = @istr_income2.sub_employment + ldc_ga_income
                    @istr_income2.sub_employment_cl = @istr_income2.sub_employment_cl + ldc_ga_income
                when 2796
                    @istr_income2.sub_employment = @istr_income2.sub_employment + ldc_ga_income
                    @istr_income2.sub_employment_cl = @istr_income2.sub_employment_cl + ldc_ga_income
                else
                    if ls_income_flag == 0
                        @istr_income2.other_cl = @istr_income2.other_cl + ldc_ga_income
                        @istr_income2.other = @istr_income2.other + ldc_ga_income
                    end
            end
        else
            ls_bdm_row_indicator = "S"
            #Rails.logger.debug("@istr_budget.str_months[@ii_bdgt_mth_rows].income_as_res = #{@istr_budget.str_months[@ii_bdgt_mth_rows].inspect}, @ii_bdgt_mth_rows = #{@ii_bdgt_mth_rows}")
            @istr_budget.str_months[@ii_bdgt_mth_rows].income_as_res = (@istr_budget.str_months[@ii_bdgt_mth_rows].income_as_res.present?) ? @istr_budget.str_months[@ii_bdgt_mth_rows].income_as_res + ldc_ga_income : ldc_ga_income
        end

        count = 0
        @ids_client_info.each do |client_info|
            if count == @ii_client_rows
                ldb_member_id = client_info.member_sequence
                break
            else
                count = count + 1
            end
        end
         @istr_budget.str_months[@ii_bdgt_mth_rows].str_client[@ii_client_rows].member_id = ldb_member_id
        #Rails.logger.debug("cl_tea_net_income.@is_income_valid = #{@is_income_valid}")
        if @is_income_valid == 'Y'
            #             lds_t_b_mem_details = CREATE ds_t_b_mem_details
            #             lds_t_b_mem_details.SetTransObject(SQLCA)
            lds_t_b_mem_details = ProgramMemberDetail.new
            #             //Insert a row at the end of the table
            #             li_cnt = lds_t_b_mem_details.InsertRow(0)                        //J Kelch 7/26/00
            lds_t_b_mem_details.run_id = @idb_run_id
            lds_t_b_mem_details.month_sequence = @idb_month_id
            lds_t_b_mem_details.member_sequence = ldb_member_id
            lds_t_b_mem_details.b_details_sequence = @idb_b_details_id
            lds_t_b_mem_details.bdm_row_indicator = ls_bdm_row_indicator
            lds_t_b_mem_details.item_type = @is_income_type
            lds_t_b_mem_details.item_source = @is_income_source
            lds_t_b_mem_details.dollar_amount = ldc_ga_income
            lds_t_b_mem_details.calc_method_code = @is_calc_method
            lds_t_b_mem_details.last_calc_month = @id_calc_month
            lds_t_b_mem_details.lastcalc_incexp_id = @idb_income_id
            if @screening_only == false
                unless lds_t_b_mem_details.save
                    Rails.logger.debug("benefit_calculator.cl_tea_net_income cannot save lds_t_b_mem_details (ProgramMemberDetail)")
                end
            end
            #             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
            #             // The Row indicator and the b_details_id is identified in this function
            #             // Therefore the updation tot the audit trail datastore is done in the
            #             // function below  The updation to the database will also be done in this function
            #             // because the t_b_mem_details table get updated to the database here.
            #             // Anand Kotian. Audit trail table updation is not straight forward so please
            #             // take care when changing the code for audit trail or t_b_mem_details table
                         update_audit_trail_data(ls_bdm_row_indicator, @idb_b_details_id,ldb_member_id)
            #             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
            #             // Moved here by anand Kotian for Audit Trail - will make no difference to the existing code
            #             // this move is just to help on coding Audit Trail
            #             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
            @idb_b_details_id = @idb_b_details_id.present? ? @idb_b_details_id : 0
            @idb_b_details_id = @idb_b_details_id + 1
            if @idb_b_details_id > @idb_max_b_details_id
                @idb_max_b_details_id = @idb_b_details_id
            end

            @ids_audit_trail_income_details.each do |audit_trail_income_detail|
                if @screening_only == false
                    audit_trail_income_detail.save
                end
            end

             @ids_audit_trail_income_details_checks.each do |audit_trail_income_details_check|
                if @screening_only == false
                    audit_trail_income_details_check.save
                end
             end

            @ids_audit_trail_income_adj_dt.each do |audit_trail_income_adj_dt|
                if @screening_only == false
                    audit_trail_income_adj_dt.save
                end
            end
            @ids_audit_trail_inc_shared_by.each do |audit_trail_inc_shared_by|
                if @screening_only == false
                     audit_trail_inc_shared_by.save
                end
            end
        end

        li_max_rows = @ids_countable_income.size
        if @ii_income_rows == li_max_rows
           if @istr_income2.earned_cl != 0
                ldc_tot_earned = @istr_income2.earned_cl
                ldc_ojt_sub_emp = ((@istr_income2.ojt_cl.present? ? @istr_income2.ojt_cl : 0) + (@istr_income2.sub_employment_cl.present? ? @istr_income2.sub_employment_cl : 0))
                if @ii_service_program == 4
                    ldc_gross_earned = ldc_tot_earned
                else
                    ldc_gross_earned = (ldc_tot_earned - ldc_ojt_sub_emp)
                end
                # //Check to see if the current status is OPEN
                if @is_bu_cur_status == 6043
                    if @ii_service_program == 4
                        ldc_work_related_ded = 0
                    else
                        ldc_work_related_ded = (ldc_gross_earned * @idc_work_related_per)
                    end
                    @idc_tea_work_ded = @idc_tea_work_ded + ldc_work_related_ded
                    ldc_remaining_earnings = ldc_gross_earned - ldc_work_related_ded
                    if @ii_service_program == 4
                                    ldc_work_incentive_ded = 0
                    else
                                    ldc_work_incentive_ded = (ldc_remaining_earnings * @idc_work_incentive_per)
                    end
                    @idc_tea_incent_ded = @idc_tea_incent_ded + ldc_work_incentive_ded

                else
                    # //Perform the Applicant Income Eligibilty Budget
                    # //Calculate the Work Related Deduction (20%)
                    # //PCR#72489 ELGutierez - Service Program ID for WorkPays (Work Related Deduction should not be applied)
                    if @ii_service_program == 4
                        ldc_work_related_ded = 0
                    else
                        ldc_work_related_ded = (ldc_gross_earned * @idc_work_related_per)
                    end
                    @idc_tea_work_ded = @idc_tea_work_ded + ldc_work_related_ded


                    # //Copied the codes from the is_bu_cur_status = "02" to this "else" part
                    # //so that it does the same thing whether the status is 02 or not.
                    # //                                        ldc_remaining_earnings = ldc_gross_earned - idc_tea_work_ded
                    ldc_remaining_earnings = ldc_gross_earned - ldc_work_related_ded
                    #  Service Program ID for WorkPays (Work Incentive Deduction should not be applied)
                     if @ii_service_program == 4
                        ldc_work_incentive_ded = 0
                     else
                        # As per policy if the case is not open then apply only work deduction and nto work incentive
                        ldc_work_incentive_ded = 0 #(ldc_remaining_earnings * @idc_work_incentive_per)
                     end
                     @idc_tea_incent_ded = @idc_tea_incent_ded + ldc_work_incentive_ded
                end
           end

            lds_bmem_summary =  ProgramMemberSummary.new
            lds_bmem_summary.run_id = @idb_run_id
            lds_bmem_summary.month_sequence = @idb_month_id
            lds_bmem_summary.member_sequence = ldb_member_id
            lds_bmem_summary.tot_earned_inc = @istr_income2.earned_cl
            lds_bmem_summary.tot_unearned_inc = @istr_income2.unearned_cl
            lds_bmem_summary.tot_expenses = @istr_client_exp.total_cl
            # lds_bmem_summary.soc_sec_admin_amt = @istr_income2.ssa_cl
            # lds_bmem_summary.railroad_ret_amt = @istr_income2.rr_cl
            # lds_bmem_summary.vet_asst_amt = @istr_income2.va_cl)
            # lds_bmem_summary.other_unearned_inc = @istr_income2.other_cl
            # lds_bmem_summary.elig_work_deduct = ldc_work_related_ded
            # lds_bmem_summary.elig_incent_deduct = ldc_work_incentive_ded
            if @screening_only == false
                unless lds_bmem_summary.save
                    #Rails.logger.debug("benefit_calculator.cl_tea_net_income cannot save lds_bmem_summary (ProgramMemberSummary)")
                end
            end
            @istr_income2.earned_cl = 0
            @istr_income2.unearned_cl = 0
            @istr_income2.ssa_cl = 0
            @istr_income2.rr_cl = 0
            @istr_income2.va_cl = 0
            @istr_income2.child_support_cl = 0
            @istr_income2.other_cl = 0
            @istr_income2.ojt_cl = 0
            @istr_income2.sub_employment_cl = 0
        end
    end

    def self.client_sd_exp(ad_first_month)
    #             integer                 li_cnt
    # integer                              li_cnt_mths
    # integer                              li_budget_month
    # date                                   ld_budget_month
    # date                                   ld_beg_date
    # date                                   ld_end_date
    # decimal {2}      ldc_child_care
    # decimal {2}      ldc_calc_amount
    # decimal {2}      ldc_child_care_max
    # decimal {2}      ldc_child_care_exp
    # long                                    ll_rowsretrieved
    # long                                    ll_age
    # long                                    ll_domain
    # long                                    ll_newrow
    # double                              ldb_expense_id
    # double                              ldb_member_id
    # string                 ls_debt_exp_type
    # string                 ls_frequency
    # string                 ls_det_calc
    # n_ds                                  lds_reg_expenses
    # n_ds                                  lds_b_mem_details
    # str_pass                           lstr_pass, lstr_pass1
    # //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    # integer li_return
    # //Anand Kotian Audit Trail PCR 65267 - End   - 01/31/02

    # //Create a new datastore to get store the checks for this expense records for a client
    # lds_reg_expenses = CREATE ds_client_exp_calc
    # lds_reg_expenses.SetTransObject(SQLCA)

    # lstr_pass.db[1] = idb_client_id                                               //Client_id is an instance variable

    # // Retrieve Records from the data store
    # ll_RowsRetrieved = gnv_data_access_service.retrieve(lds_reg_expenses, lds_reg_expenses, "Bcce_l", lstr_pass)
    # SELECT t_debt_exp.type,
    #                t_debt_exp.debt_expid,
    #                t_debt_exp.frequency,
    #                t_debt_exp.effective_beg_date,
    #                t_debt_exp.effective_end_date,
    #                t_debt_exp.budget_recalc_ind,
    #                t_debt_exp.exp_calc_months,
    #                t_debt_exp.creditor_contact
    #         FROM t_client,
    #              t_client_debt_exp,
    #              t_debt_exp
    #         WHERE t_client_debt_exp.clientid = t_client.clientid
    #         AND  t_debt_exp.debt_expid = t_client_debt_exp.debt_expid
    #         AND  t_client.clientid = :rBcce_clientid;


    # If ll_RowsRetrieved > 0 then
    #             li_cnt = 1

    #             //Loop through the records to find any expenses that match the Case Statement
    #             Do While li_cnt <= ll_RowsRetrieved
    #                             li_cnt_mths = 1
    #                             ldc_child_care_exp = 0
    #                             ld_budget_month = ad_first_month
    #                             ld_budget_month = f_future_date(ld_budget_month, 'M', 0) //Set to last day of month
    #                             ls_debt_exp_type = lds_reg_expenses.GetItemString(li_cnt, "debt_exp_type")
    #                             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                             istr_audit_trail.exp_source =lds_reg_expenses.GetItemString(li_cnt, "t_debt_exp_creditor_contact")
    #                             istr_audit_trail.exp_frequency =lds_reg_expenses.GetItemString(li_cnt, "t_debt_exp_frequency")
    #                             istr_audit_trail.exp_beg_date = lds_reg_expenses.GetItemdatetime(li_cnt, "debt_beg_date")
    #                             istr_audit_trail.exp_end_date = lds_reg_expenses.GetItemdatetime(li_cnt, "debt_end_date")
    #                             istr_audit_trail.exp_type     = ls_debt_exp_type
    #                             istr_audit_trail.exp_calc_months =lds_reg_expenses.GetItemnumber(li_cnt, "t_debt_exp_exp_calc_months")
    #                             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
    #                             ldb_expense_id = lds_reg_expenses.GetItemNumber(li_cnt, "t_debt_exp_debt_expid")
    #                             idb_expense_id = ldb_expense_id // Defect #1852

    #                             ld_beg_date = Date(lds_reg_expenses.GetItemDateTime(li_cnt, "debt_beg_date"))
    #                             ld_end_date = Date(lds_reg_expenses.GetItemDateTime(li_cnt, "debt_end_date"))

    #                             If ls_debt_exp_type = 'D2' Then
    #                                             Do While li_cnt_mths <= il_num_months
    #                                                             id_month = ld_budget_month

    #                                                             // See if the expense is valid (budget run month must be greater than the expense begin date and less than the expense end date.)
    #                                                             is_expense_valid = of_valid_effective_dates(ld_beg_date, ld_end_date)

    #                                                             If is_expense_valid = "Y" then                                                                   // IF the expense IS VALID for the budget month
    #                                                                             ldc_child_care = 0

    #                                                                             li_budget_month = Month(ld_budget_month)

    #                                                                             If check_retro_mth() = 'Y' then
    #                                                                                             ls_det_calc = 'R'
    #                                                                             Else
    #                                                                                             ls_det_calc = 'C'
    #                                                                             End if

    #                                                                             Choose Case ls_det_calc
    #                                                                                             Case 'R'
    #                                                                                                             ldc_calc_amount = this.of_exp_calc_actual('N', ls_debt_exp_type, ldb_expense_id)
    #                                                                                             Case 'C'
    #                                                                                                             ldc_calc_amount = this.of_exp_calc_actual('Y', ls_debt_exp_type, ldb_expense_id)
    #                                                                                                             ldc_calc_amount = ldc_calc_amount + of_calc_future_exp(ld_budget_month, ld_end_date) // Defect #1852
    #                                                                             End Choose

    #                                                                             ll_age = of_age()
    #                                                                             If ll_age < 2 then
    #                                                                                             ll_domain = 503                                                                                                                //Stds id for Max Dep Care < 2 (T_Program_STDS)
    #                                                                             Else
    #                                                                                             ll_domain = 504                                                                                                                //Stds id for Max Dep Care > 2 (T_Program_STDS)
    #                                                                             End if

    #                                                                             ldc_child_care_max = of_standards(ll_domain, id_month)
    #                                                                             If ldc_child_care_max > ldc_calc_amount then
    #                                                                                             ldc_child_care = ldc_calc_amount
    #                                                                             Else
    #                                                                                             ldc_child_care = ldc_child_care_max
    #                                                                             End if

    #                                                                             ldc_child_care_exp = ldc_child_care_exp + ldc_child_care

    #                                                             End if
    #                                                             ld_budget_month = f_future_date(ld_budget_month,'M', 1)
    #                                                             li_cnt_mths ++
    #                                             Loop

    #                                             istr_client_exp.child_care = istr_client_exp.child_care + ldc_child_care_exp
    #                                             istr_client_exp.total_cl = istr_client_exp.total_cl + ldc_child_care_exp
    #                                             istr_client_exp.total = istr_client_exp.total + ldc_child_care_exp

    #                                             //Used for ds_t_b_mem_details table
    #                                             lds_b_mem_details = Create ds_t_b_mem_details
    #                                             lds_b_mem_details.SetTransObject(SQLCA)

    #                                             //Get the Budget Member ID for ids_client_info (clientstatus)
    #                                             ldb_member_id = ids_client_info.GetItemNumber(ii_client_rows, "bmember_id")

    #                                             //            Insert a row at the end of the DataStore
    #                                             ll_NewRow = lds_b_mem_details.InsertRow(0)

    #                                             //            Set the fields to be written to the datastore
    #                                             lds_b_mem_details.SetItem(ll_NewRow, "bwiz_run_id", idb_run_id)
    #                                             lds_b_mem_details.SetItem(ll_NewRow, "bwiz_mo_id", idb_month_id)
    #                                             lds_b_mem_details.SetItem(ll_NewRow, "bmember_id", ldb_member_id)
    #                                             lds_b_mem_details.SetItem(ll_NewRow, "bdm_row_indicator", 'E')
    #                                             lds_b_mem_details.SetItem(ll_NewRow, "item_type", ls_debt_exp_type)
    # //                                        lds_b_mem_details.SetItem(ll_NewRow, "item_source", )
    #                                             lds_b_mem_details.SetItem(ll_newRow, "dollar_amount", ldc_child_care_exp)
    #                                             lds_b_mem_details.SetItem(ll_newRow, "calc_method_code", '04')
    #                                             lds_b_mem_details.SetItem(ll_newRow, "b_details_id", idb_b_details_id)
    #                                             lds_b_mem_details.SetItem(ll_newRow, "last_calc_month", id_month)
    #                                             lds_b_mem_details.SetItem(ll_newRow, "lastcalc_incexp_id", ldb_expense_id)
    #                                             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                                             // The Row indicator and the b_details_id is identified in this function
    #                                             // Therefore the updation tot the audit trail datastore is done in the
    #                                             // function below  The updation to the database will also be done in this function
    #                                             // because the t_b_mem_details table get updated to the database here.
    #                                             // Anand Kotian. Audit trail table updation is not straight forward so please
    #                                             // take care when changing the code for audit trail or t_b_mem_details table
    #                                             of_update_audit_trail_data('E',idb_b_details_id,ldb_member_id)
    #                                             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
    #                                             idb_b_details_id ++

    #                                             If idb_b_details_id > idb_max_b_details_id then
    #                                                             idb_max_b_details_id = idb_b_details_id
    #                                             End if

    #                                             gnv_data_access_service.Update_Service(lds_b_mem_details, lds_b_mem_details, "Bcmd_u", lstr_pass)
    #                                             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                                             li_return = gnv_data_access_service.update_service(ids_audit_trail_expense_details,ids_audit_trail_expense_details, "Ated_u",lstr_pass)
    #                                             li_return = gnv_data_access_service.update_service(ids_audit_trail_expense_details_checks,ids_audit_trail_expense_details_checks, "Atec_u",lstr_pass)
    #                                             li_return = gnv_data_access_service.update_service(ids_audit_trail_exp_shared_by,ids_audit_trail_exp_shared_by, "Atsb_u",lstr_pass)
    #                                             ids_audit_trail_expense_details.reset()
    #                                             ids_audit_trail_expense_details_checks.reset()
    #                                             ids_audit_trail_exp_shared_by.reset()
    #                                             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
    #                                             Destroy lds_b_mem_details

    #                             End if
    #                             li_cnt ++
    #             Loop
    # End if

    # //***********************************************************************
    # //*  Release  Date     Task         Author                              *
    # //*  Description                                                        *
    # //***********************************************************************
    # //*  4.003    06/05/00 ANSWER                                                Jennifer Kelch                      *
    # //*  Function determines countable expenses for spend down service                               *
    # //*  programs.  Enhancement 1113.                                                                                                                                                                                                     *
    # //***********************************************************************
    # //*  5.002           01/22/01 ANSWER                                         Evangeline Gutierez                                                                                       *
    # //*  Defect#1852 - Call function for calculation of future expense                          *
    # //***********************************************************************
    # //*  7.003           03/19/02 ANSWER                                         Anand Kotian                                                                                                                     *
    # //*  Collect Payment Details,Update the Audit Trail Data and generate   *
    # //*  system generated Id's PCR 65267                                                                                                                                                                                 *
    # //***********************************************************************

    end

    def self.calc_averaged()
        #             //Declare the variables
        # date                                                                   ld_begin_date, ld_end_date, ld_check_date
        # integer                                                              li_intended_use_months, li_int_use_mo_minus_one
        li_cnt = 1
        # n_ds              lds_check_dates
        # str_pass          lstr_pass
        # long              ll_rows
        # decimal {2}       ldc_ir_total
        # decimal {2}       ldc_ckga_income
        # double                                    ldb_inc_earned_id
        li_intended_use_months = 0
        ldc_ir_total = 0
        count = 1
        ld_begin_date
        @ids_countable_income.each do |income|
            if count == @ii_income_rows
                li_intended_use_months = income.intended_use_mos
                ld_begin_date = income.inc_avg_beg_date
                break
            else
                count = count + 1
            end
        end
        li_int_use_mo_minus_one = li_intended_use_months - 1
        ld_end_date = DateService.f_future_date(ld_begin_date,'M', li_int_use_mo_minus_one)
        lds_check_dates = IncomeDetail.get_income_detail_by_income_id(@idb_income_id)
        if lds_check_dates.size > 0
            lds_check_dates.count.each do |income_detail|
               ld_check_date = income_detail.date_received
               if ((ld_begin_date <= ld_check_date) && (ld_check_date <= ld_end_date))
                   ldb_inc_earned_id = income_detail.id

                     @istr_audit_trail.date_of_inc_exp  = income_detail.date_received
                     @istr_audit_trail.check_type       = income_detail.check_type
                     @istr_audit_trail.gross_amount    = income_detail.gross_amt
                     @istr_audit_trail.adjusted_total  = income_detail.adjusted_total
                     @istr_audit_trail.net_amount      = income_detail.net_amt

                    # //Since we are calling this function from a function which calculates
                    # //income the third paramter to the function is passed as 'I'
                    # //We will later determine if it is an earned income or unearned income
                    create_audit_trail_data(idb_income_id,ldb_inc_earned_id,'I',li_cnt,income_detail)

                   ldc_ckga_income = det_ckga_amt(ldb_inc_earned_id)
                   ldc_ir_total = (ldc_ir_total + ldc_ckga_income)
               end
            end
           # //Follow the Averaged formula
            ldc_ir_total = (ldc_ir_total / li_intended_use_months)
        end
        return ldc_ir_total
    end

    def self.calc_actual_conv(arg_use_estimated,arg_income)
        li_cnt = 1
        li_num_records = 0
        ls_frequency = 0
        ldc_ga_income = 0, ldc_ckga_income = 0
        lds_actual_income = 0
        ldb_inc_earned_id = 0
        # lstr_pass.db[1] = idb_income_id
        # lstr_pass.db[2] = Month(id_month)
        # lstr_pass.db[3] = Year(id_month)
        # lstr_pass1.db[1] = idb_income_id
        # lstr_pass1.db[2] = Month(id_month)
        # lstr_pass1.db[3] = Year(id_month)
        lds_actual_income = IncomeDetail.get_actual_income_details(@idb_income_id, @id_month.month, @id_month.year)
        if lds_actual_income.size > 0
            if use_estimated == 'N'
                lds_actual_income = lds_actual_income.where("check_type != 4387")
            end
            li_num_records = lds_actual_income.size
        end
        ldc_ga_income = 0
        if li_num_records.size > 0
            ldc_ga_income = 0
            li_num_records.each do |income_detail|
                # Audit Trail will be implemented later
                @istr_audit_trail.date_of_inc_exp  = income_detail.date_received
                @istr_audit_trail.check_type       = income_detail.check_type
                @istr_audit_trail.gross_amount    = income_detail.gross_amt
                @istr_audit_trail.adjusted_total  = income_detail.adjusted_total
                @istr_audit_trail.net_amount      = income_detail.net_amt

                # //Since we are calling this function from a function which calculates
                # //income the third paramter to the function is passed as 'I'
                # //We will later determine if it is an earned income or unearned income
                create_audit_trail_data(idb_income_id,ldb_inc_earned_id,'I',li_cnt,arg_income)
                # ///Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
                ldc_ckga_income = det_ckga_amt(income_detail.id)
                ldc_ga_income = ldc_ga_income + ldc_ckga_income
            end
        end

        if li_num_records.size <= 0
            return ldc_ga_income
        end

        count = 1
        @ids_countable_income.each do |income|
            if count == @ii_income_rows
                ls_frequency = income.frequency
                break
            else
                count = count + 1
            end
        end
        case ls_frequency
            when 2316                                                                                                                                                                                                                                                                          # Bi-weekly
                ldc_ga_income = (ldc_ga_income/li_num_records) * 2.167
            when 2320                                                                                                                                                                                                                                                                          # Weekly
                ldc_ga_income = (ldc_ga_income/li_num_records) * 4.334
            when 2321
                ldc_ga_income = (ldc_ga_income/li_num_records)/12
            when 2330                                                                                                                                                                                                                                                                          # Twice a Month
                ldc_ga_income = (ldc_ga_income/li_num_records) * 2
            when 2319                                                                                                                                                                                                                                                                          # Quarterly
                ldc_ga_income = (ldc_ga_income/li_num_records)/3
            when 2317                                                                                                                                                                                                                                                                          # Monthly
                ldc_ga_income = (ldc_ga_income/li_num_records)
        end
        return ldc_ga_income
    end

    def self.child_care_edits ()
    #             decimal {2}          ldc_dollar_amount
    # long                                   ll_cc_rows,ll_rowcount
    # str_pass           lstr_pass,lstr_pass1
    # n_ds                                  lds_b_mem_details
    # // Anand Kotian Audit Trail PCR 65267 - Start 01/31/02
    # str_pass    lstr_pass2,lstr_pass3
    # n_ds        lds_audit_trail_expense_details,lds_audit_trail_expense_details_checks
    # n_ds        lds_audit_trail_exp_shared_by
    # double      ldb_audit_id
    # long        ll_audit,ll_auditcount,ll_rows
    # string      ls_filter
    # // Anand Kotian Audit Trail PCR 65267 - end - 01/31/02
    # double                              ldb_member_id


    # lstr_pass.db[1] = idb_run_id
    # lstr_pass.db[2] = idb_month_id

    # //Used for ds_t_b_mem_details table. Delete child care since total earned income = 0
    # // Anand Kotian PCR 65823

    # lds_b_mem_details = Create ds_t_b_mem_details
    # lds_b_mem_details.SetTransObject(SQLCA)

    # ll_cc_rows = gnv_data_access_service.retrieve(lds_b_mem_details, lds_b_mem_details, "Bcmd_l", lstr_pass)

    #  SELECT bwiz_run_id,
    #                bwiz_mo_id,
    #                bmember_id,
    #                b_details_id,
    #                item_type,
    #                bdm_row_indicator,
    #                item_source,
    #                dollar_amount,
    #                item_countable,
    #                calc_method_code,
    #                last_calc_month,
    #                lastcalc_incexp_id
    #         FROM t_b_mem_details
    #         WHERE (bwiz_run_id = :rBcmd_bwiz_run_id) AND
    #               (bwiz_mo_id = :rBcmd_bwiz_mo_id)
    #         ORDER BY bwiz_run_id ASC,
    #                  bwiz_mo_id ASC;



    # ls_filter = " bwiz_run_id = " + string(idb_run_id) + &
    #                                                             " and bwiz_mo_id = " + string(idb_month_id) + &
    #                                                             " and item_type = '" + 'D2' + &
    #                                                             "' and bdm_row_indicator = '" + 'E' +"'"

    # lds_b_mem_details.Setfilter("")
    # lds_b_mem_details.filter()
    # lds_b_mem_details.Setfilter(ls_filter)
    # lds_b_mem_details.filter()
    # ll_rowcount = lds_b_mem_details.rowcount()
    # // We need to delete all the records present in the filter therefore using 1 purpously.
    # // Iam trying to update the structure and delete the row at the same time.
    # // Anand Kotian 05/01/2001
    # if ll_rowcount > 0 then
    #             ll_cc_rows = 1
    #             do while ll_cc_rows = 1 // Do while loop instead of For Next //*special code under PCR 65267
    #             //For ll_cc_rows = 1 to ll_rowcount // Changed the For Loop to Do while Under Audit Trail
    #             // PCR 65267 - 01/31/02
    #                 //PCR 75327 Anand kotian - 10.09B - Start
    #                              //Since we are deducting the child care out of a earlier rounded
    #                              //off tot exp value we need to round off the dollar amount so that we are in sync
    #                             ldc_dollar_amount = round(lds_b_mem_details.getitemnumber(ll_cc_rows,"dollar_amount"),0)
    #                             //PCR 75327 Anand kotian - 10.09B - End

    #                             istr_client_exp.child_care = istr_client_exp.child_care - ldc_dollar_amount
    #                             istr_client_exp.total      = istr_client_exp.total - ldc_dollar_amount
    #                             // Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                             lstr_pass2.db[1] = lds_b_mem_details.getitemnumber(ll_cc_rows,"bwiz_run_id")
    #                             lstr_pass2.db[2] = lds_b_mem_details.getitemnumber(ll_cc_rows,"bwiz_mo_id")
    #                             lstr_pass2.db[3] = lds_b_mem_details.getitemnumber(ll_cc_rows,"bmember_id")
    #                             lstr_pass2.db[4] = lds_b_mem_details.getitemnumber(ll_cc_rows,"b_details_id")
    #                             // Anand Kotian Audit Trail PCR 65267 - End  - 01/31/02
    #                             lds_b_mem_details.Deleterow(ll_cc_rows)
    #                             // Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                             lds_audit_trail_expense_details = Create ds_audit_trail_expense_details
    #                             lds_audit_trail_expense_details.SetTransObject(SQLCA)
    #                             ll_auditcount = gnv_data_access_service.retrieve(lds_audit_trail_expense_details, lds_audit_trail_expense_details, "Ated_l", lstr_pass2)
    #                             if ll_auditcount > 0 then
    #                                             ll_audit = 1
    #                                             do while ll_audit = 1
    #                                                             ldb_audit_id = lds_audit_trail_expense_details.getitemnumber(ll_audit,"audit_id")
    #                                                             lstr_pass3 = lstr_pass2
    #                                                             lstr_pass3.db[5] = ldb_audit_id
    #                                                             lds_audit_trail_expense_details_checks = Create ds_audit_trail_expense_details_checks
    #                                                             lds_audit_trail_expense_details_checks.SetTransObject(SQLCA)
    #                                                             ll_rows = gnv_data_access_service.retrieve(lds_audit_trail_expense_details_checks, lds_audit_trail_expense_details_checks, "Atec_l", lstr_pass3)
    #                                                             if ll_rows > 0 then
    #                                                                             ll_audit = 1
    #                                                                             do while ll_audit = 1
    #                                                                                             lds_audit_trail_expense_details_checks.deleterow(ll_audit)
    #                                                                                             if lds_audit_trail_expense_details_checks.rowcount() <= 0 then
    #                                                                                                             exit
    #                                                                                             end if
    #                                                                             Loop
    #                                                             End if
    #                                                             lds_audit_trail_exp_shared_by = Create ds_audit_trail_exp_shared_by
    #                                                             lds_audit_trail_exp_shared_by.SetTransObject(SQLCA)
    #                                                             ll_rows = gnv_data_access_service.retrieve(lds_audit_trail_exp_shared_by, lds_audit_trail_exp_shared_by, "Atsb_l", lstr_pass3)
    #                                                             If ll_rows > 0 then
    #                                                                             ll_audit = 1
    #                                                                             Do while ll_audit = 1
    #                                                                                             lds_audit_trail_exp_shared_by.deleterow(ll_audit)
    #                                                                                             if lds_audit_trail_exp_shared_by.rowcount() <= 0 then
    #                                                                                                             exit
    #                                                                                             end if
    #                                                                             loop
    #                                                             End if
    #                                                             lds_audit_trail_expense_details.deleterow(ll_audit)
    #                                                             If lds_audit_trail_expense_details.rowcount() <= 0 then
    #                                                                             exit
    #                                                             end if
    #                                             loop
    #                                             if lds_audit_trail_expense_details.deletedcount() > 0 then
    #                                                             if lds_audit_trail_expense_details_checks.deletedcount() > 0 then
    #                                                                             If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
    #                                                                                             gnv_data_access_service.Update_Service(lds_audit_trail_expense_details_checks, lds_audit_trail_expense_details_checks, "Atec_u", lstr_pass3)
    #                                                                             Else
    #                                                                                             gnv_data_access_service.Update_Service(lds_audit_trail_expense_details_checks, lds_audit_trail_expense_details_checks, "Atec_u", lstr_pass3)
    #                                                                             End If
    #                                                             End if
    #                                                             if lds_audit_trail_exp_shared_by.deletedcount() > 0 then
    #                                                                             If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
    #                                                                                                             gnv_data_access_service.Update_Service(lds_audit_trail_exp_shared_by, lds_audit_trail_exp_shared_by, "Atsb_u", lstr_pass3)
    #                                                                             Else
    #                                                                                                             gnv_data_access_service.Update_Service(lds_audit_trail_exp_shared_by, lds_audit_trail_exp_shared_by, "Atsb_u", lstr_pass3)
    #                                                                             End If
    #                                                             End if
    #                                                             If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
    #                                                                             gnv_data_access_service.Update_Service(lds_audit_trail_expense_details, lds_audit_trail_expense_details, "Ated_u", lstr_pass2)
    #                                                             Else
    #                                                                             gnv_data_access_service.Update_Service(lds_audit_trail_expense_details, lds_audit_trail_expense_details, "Ated_u", lstr_pass2)
    #                                                             End If
    #                                             End if
    #                             End if
    #                             // Anand Kotian Audit Trail PCR 65267 - End         01/31/02
    #                             // The Below change is required so that the code can come out of the loop
    #                             // This change is done under Audit Trail PCR 65267
    #                             If lds_b_mem_details.rowcount() <= 0 then //*special code under PCR 65267
    #                                             exit                                                                                                                                                                                        //*special code under PCR 65267
    #                             end if                                                                                                                                                                                    //*special code under PCR 65267
    #             // Changed the for next loop to Do while Loop Under Audit Trail PCR 65267
    #             // This Changed is also incorporated under PCR 65267
    #             //Next
    #             Loop
    # End if
    # lstr_pass1.db[1] = idb_run_id
    # lstr_pass1.db[2] = idb_month_id
    # lstr_pass1.s[1]  = 'D2'
    # lstr_pass1.s[2]  = 'E'
    # //if ll_cc_rows > 0 then // Anand Kotian Audit Trail This Changed is also incorporated under PCR 65267
    # if ll_rowcount > 0 then
    #             If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
    #                             ??????????gnv_data_access_service.Update_Service(lds_b_mem_details, lds_b_mem_details, "Bcmd_u", lstr_pass1)
    #             Else
    #                             gnv_data_access_service.Update_Service(lds_b_mem_details, lds_b_mem_details, "Bcmd_u", lstr_pass)
    #             End If
    # end if
    # Destroy lds_b_mem_details
    # // Anand Kotian Audit Trail PCR 65267 - Start 01/31/02
    # Destroy  lds_audit_trail_expense_details
    # Destroy  lds_audit_trail_expense_details_checks
    # Destroy  lds_audit_trail_exp_shared_by
    # // Anand Kotian Audit Trail PCR 65267 - End 01/31/02

    # //***********************************************************************
    # //*  Release  Date     Task         Author                              *
    # //*  Description                                                        *
    # //***********************************************************************
    # //*  6.003    06/12/01 ANSWER                                                Anand Kotian                          *
    # //*  Deleting the rows from the member details and updating the structure*
    # //*  PCR 65823 - child care expenses should not be considered if earned            *
    # //*  income = 0                                                                                                                                                                                                                                                                                                              *
    # //***********************************************************************
    # //*  7.003A    01/31/02 ANSWER                                             Anand Kotian                       *
    # //*  Since the B_Mmem_Detail is getting deleted. It is necessary that the*
    # //*  Audit Trail Detail also gets deleted because there is a foreign Key*
    # //*  relationship between the two tables.                                                                                                                                                                        *
    # //***********************************************************************
    # //*  10.09B    09/17/08 ANSWER                                             Anand Kotian                       *
    # //*  child Care expenses is deducted from total expenses since there is no earned income.
    # //*  It should be first rounded off and then deducted because earlier child care expense was rounded off
    # //*  when it was added to tot expense.
    # //***********************************************************************

    end
    def self.calc_future_exp(ld_budget_month, ld_end_date)
    #             string                     ls_frequency, ls_date_increment
    # long                                    ll_days, ll_rows
    # Date                                   ld_check_date
    # Integer                             li_check_month, li_budget_month, li_cnt, li_twice_monthly
    # decimal {2} ldc_last_check_amt, ldc_sd_expense = 0
    # str_pass           lstr_pass
    # n_ds                                  lds_expense_frequency
    # //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    # Double ldb_debt_exp_detail_id
    # //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02

    # lstr_pass.db[1] = idb_expense_id
    # lds_expense_frequency = Create ds_expense_frequency
    # lds_expense_frequency.SetTransObject(SQLCA)
    # ll_rows = gnv_data_access_service.retrieve(lds_expense_frequency, lds_expense_frequency, "Expf_l", lstr_pass)
    #  SELECT  T_Debt_Exp.type,
    #                 T_Debt_Exp.frequency,
    #                 T_Debt_Exp.effective_beg_date,
    #                 T_Debt_Exp.effective_end_date,
    #                 T_Debt_Exp_Detail.exp_due_date,
    #                 T_Debt_Exp_Detail.expense_amount,
    #                 T_Debt_Exp_Detail.debt_exp_detail_id,
    #                 T_Debt_Exp_Detail.exp_use_code,
    #                 T_Debt_Exp_Detail.payment_method,
    #                 T_Debt_Exp_Detail.payment_status,
    #                 T_Debt_Exp_Detail.Exp_Calc_ind
    #         FROM    T_Debt_Exp
    #         LEFT OUTER JOIN T_Debt_Exp_Detail
    #         ON      T_Debt_Exp.debt_expid = T_Debt_Exp_Detail.debt_expid
    #         WHERE   T_Debt_Exp.debt_expid = :rExpf_debt_expid
    #         ORDER BY T_DEBT_EXP_DETAIL.EXP_DUE_DATE DESC;


    # If ll_rows > 0 then

    #             ls_frequency = lds_expense_frequency.GetItemString(1, "frequency")
    #             li_cnt = 1

    #             Do
    #                             ld_check_date = Date(lds_expense_frequency.GetItemDateTime(li_cnt, "t_debt_exp_detail_exp_due_date"))
    #                             li_cnt ++
    #             Loop Until ld_check_date <= ld_budget_month Or li_cnt > ll_rows

    #             li_cnt --

    #             li_check_month = Month(ld_check_date)
    #             ldc_last_check_amt = lds_expense_frequency.GetItemNumber(li_cnt, "t_debt_exp_detail_expense_amount")

    #             Choose Case ls_frequency
    #                             Case '30'                                     // Nissim defect 1823  65464
    #                                             ls_date_increment = 'M'                                              // add case 30 quaterly
    #                                             ll_days = 1
    #                                             ldc_last_check_amt=ldc_last_check_amt/3
    #                Case '5','5 '                                 // Nissim defect 1823  65464
    #                                             ls_date_increment = 'M'                                              // add case 5 annualy
    #                                             ll_days = 1
    #                                             ldc_last_check_amt=ldc_last_check_amt/12
    #                             Case '40'
    #                                             ls_date_increment = 'D'
    #                                             ll_days = 7
    #                             Case '10'
    #                                             ls_date_increment = 'D'
    #                                             ll_days = 14
    #                             Case '20'
    #                                             ls_date_increment = 'M'
    #                                             ll_days = 1
    #                             Case 'TM'
    #                                             ls_date_increment = 'M'
    #                                             ll_days = 1

    #                                             //If the budget month is the current month, the actual income received for the month will have
    #                                             //already been counted.  If there was only one check for the month, add in another one.  If two
    #                                             //checks have already been counted, destroy datastore and return.  If there were no checks for
    #                                             //the month, add in two checks, destroy datastore and return.
    #                                             If Month(ld_budget_month) = Month(Today()) then
    #                                                             If IsNull(ld_end_date) Or ld_end_date > ld_check_date then
    #                                                                             If li_check_month < Month(Today()) then
    #                                                                                             ldc_sd_expense = ldc_last_check_amt * 2
    #                                                                                             Destroy lds_expense_frequency
    #                                                                                             Return ldc_sd_expense
    #                                                                             Else
    #                                                                                             If li_cnt < ll_rows then
    #                                                                                                             li_cnt ++
    #                                                                                                             ld_check_date = Date(lds_expense_frequency.GetItemDateTime(li_cnt, "t_debt_exp_detail_exp_due_date"))
    #                                                                                                             If Month(ld_check_date) = li_check_month then
    #                                                                                                                             ldc_sd_expense = 0
    #                                                                                                                             Destroy lds_expense_frequency
    #                                                                                                                             Return ldc_sd_expense
    #                                                                                                             Else
    #                                                                                                                             ldc_sd_expense = ldc_last_check_amt
    #                                                                                                                             Destroy lds_expense_frequency
    #                                                                                                                             Return ldc_sd_expense
    #                                                                                                             End if

    #                                                                                             Else
    #                                                                                                             ldc_sd_expense = ldc_last_check_amt
    #                                                                                                             Destroy lds_expense_frequency
    #                                                                                                             Return ldc_sd_expense
    #                                                                                             End if
    #                                                                             End if
    #                                                             End if
    #                                             //If the budget month is not the current month, set the increment variables and
    #                                             //initialize a variable to keep track of the number of checks that have been
    #                                             //counted for the month.  A max of two should be counted.
    #                                             Else
    #                                                             ls_date_increment = 'D'
    #                                                             li_twice_monthly = 0
    #                                                             If Month(ld_budget_month) = 2 then
    #                                                                             ll_days = 14
    #                                                             Else
    #                                                                             ll_days = 15
    #                                                             End If
    #                                             End if
    #                             Case Else
    #                                             Destroy lds_expense_frequency
    #                                             Return 0
    #             End Choose

    #             //If the budget month is the current month, all income received during the month will have been
    #             //counted already.  Increment the check date to ensure that no check is counted twice.
    #             If Month(ld_budget_month) = Month(Today()) then
    #                             ld_check_date = f_future_date(Date(lds_expense_frequency.GetItemDateTime(1, "t_debt_exp_detail_exp_due_date")), ls_date_increment, ll_days)
    #             End if

    #             //Put this check here because going to a new year, the Do Until Loop may never get executed
    #             //"Do until 12 > 01"
    #             If Year(ld_budget_month) > Year(ld_check_date) then
    #                             li_check_month = Month(ld_check_date) - 12
    #             Else
    #                             li_check_month = Month(ld_check_date)
    #             End if

    #             li_budget_month = Month(ld_budget_month)

    #             Do until li_check_month > li_budget_month
    #                             If IsNull(ld_end_date) or ld_end_date >= ld_check_date then
    #                                             If li_check_month = li_budget_month then
    #                                                             //Don't count more than two checks for the twice a month frequency.
    #                                                             If ls_frequency = 'TM' then
    #                                                                             If li_twice_monthly < 2 then
    #                                                                                             ldc_sd_expense = ldc_sd_expense + ldc_last_check_amt
    #                                                                                             li_twice_monthly ++
    #                                                                             End if
    #                                                             Else
    #                                                                             ldc_sd_expense = ldc_sd_expense + ldc_last_check_amt
    #                                                             End if
    #                                             End if

    #                                             ld_check_date = f_future_date(ld_check_date,ls_date_increment, ll_days) //Send variable ls_date_increment

    #                                             Choose Case Year(ld_budget_month)
    #                                                             Case Is > Year(ld_check_date)
    #                                                                             li_check_month = Month(ld_check_date) - 12
    #                                                             Case Is < Year(ld_check_date)
    #                                                                             li_check_month = Month(ld_check_date) + 12
    #                                                             Case Year(ld_check_date)
    #                                                                             li_check_month = Month(ld_check_date)
    #                                             End Choose
    #                             //Added an else so that function would stop incrementing when the income record is not effective.
    #                             Else
    #                                             li_check_month = 13
    #                             End if
    #             Loop
    #             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #             if ldc_sd_expense > 0 then
    #                             ldb_debt_exp_detail_id = lds_expense_frequency.GetItemnumber(li_cnt, "t_debt_exp_detail_debt_exp_detail_id")
    #                             istr_audit_trail.date_of_inc_exp = lds_expense_frequency.Getitemdatetime(li_cnt,"t_debt_exp_detail_exp_due_date")
    #                             istr_audit_trail.gross_amount    = lds_expense_frequency.Getitemnumber(li_cnt,"t_debt_exp_detail_expense_amount")
    #                             istr_audit_trail.payment_status  = lds_expense_frequency.Getitemstring(li_cnt,"t_debt_exp_detail_payment_status")
    #                             istr_audit_trail.use_code        = lds_expense_frequency.GetitemString(li_cnt,"t_debt_exp_detail_exp_use_code")
    #                             of_create_audit_trail_data(idb_expense_id,ldb_debt_exp_detail_id,'E',li_cnt,@istr_audit_trail)
    #             end if
    #             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02

    # End if
    # Destroy lds_expense_frequency

    # Return ldc_sd_expense

    # //***********************************************************************
    # //*  Release  Date     Task         Author                              *
    # //*  Description                                                        *
    # //***********************************************************************
    # //*  5.002    01/22/01 ANSWER                                                Evangeline Gutierez                 *
    # //*  Defect #1852 - Function determines monthly expense amount for                              *
    # //*  future months based on the last check in the expense detail grid.  *
    # //***********************************************************************
    # //*  5.002    02/22/01 ANSWER                                                Nissim Behar                        *
    # //*  Defect 1823  65464 - add case 30 and 5 for annual and quaterly exp.*
    # //*  for retro month.                                                   *
    # //***********************************************************************
    # //*  7.003A    03/19/02 ANSWER                                             Anand Kotian                                                                                        *
    # //*  Collecting the Payment details which will be used in the                       *
    # //*  of_create_audit_trail_data function Audit Trail PCR 65267                                                   *
    # //***********************************************************************

    end

    def self.calc_intended_use()
        ldc_num_of_months = 0
        ldc_ir_total = 0
        ldc_contract_amt = 0
        count = 1
        @ids_countable_income.each do |income|
            if count == @ii_income_rows
                ldc_num_of_months = income.intended_use_mos
                ldc_contract_amt = income.contract_amt
                break
            else
                count = count + 1
            end
        end
        # //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
        # // A Special treatment for Intended Use - Since this function does not consider the check
        # // details even i have not collected the check details
         create_audit_trail_data(@idb_income_id,0,'D',1,@istr_audit_trail)
        # // indentify that we do not need to create records for Checks or adjustments
        # //Anand Kotian Audit Trail PCR 65267 - 01/31/02
        # //Take the Contract Amount and divide by the Number of Months and store it in ldc_ir_total
        if ldc_contract_amt.present? && ldc_num_of_months.present?
           ldc_ir_total = (ldc_contract_amt / ldc_num_of_months)
        end

        return ldc_ir_total
    end

    def self.calc_actual(use_estimated,arg_income)
        li_cnt = 1
        ldc_ckga_income = 0
        ldb_inc_earned_id = 0
        ldc_ga_income = 0
            lds_actual_income = IncomeDetail.get_actual_income_details(@idb_income_id, @id_month.month, @id_month.year)
        if lds_actual_income.size > 0
            if use_estimated == 'N'
                lds_actual_income = lds_actual_income.where("check_type != 4387") # check_type 30 --> 4387
            end
        end
        if lds_actual_income.size > 0
            ldc_ga_income = 0
            lds_actual_income.each do |income_detail|
                ldb_inc_earned_id = income_detail.id

                @istr_audit_trail.date_of_inc_exp  = income_detail.date_received
                @istr_audit_trail.check_type       = income_detail.check_type
                @istr_audit_trail.gross_amount    = income_detail.gross_amt
                @istr_audit_trail.adjusted_total  = income_detail.adjusted_total
                @istr_audit_trail.net_amount      = income_detail.net_amt

                # //Since we are calling this function from a function which calculates
                # //income the third paramter to the function is passed as 'I'
                # //We will later determine if it is an earned income or unearned income
                create_audit_trail_data(@idb_income_id,ldb_inc_earned_id,'I',li_cnt,arg_income)
                #//Call the of_det_ckga_income() funciton and pass the income_id
                ldc_ckga_income = det_ckga_amt(ldb_inc_earned_id)
                ldc_ga_income = ldc_ga_income + ldc_ckga_income
            end
        end
        return ldc_ga_income

    end

    def self.create_audit_trail_data(arg_db_inc_expid,arg_db_income_earned_id,arg_indicator,arg_counter,arg_object)
        #  // This function is used for Audit Trail to create rows which can be updated
        # // into the audit trail tables

        # double ldb_member_id
        # long ll_newrow,ll_shared_by,
        ll_rowsretrieved = 0
        #,ll_count
        # datetime ldtm_current_time
        # str_pass lstr_pass
        # double clientid
        # string ls_if_condition
        # boolean lb_condition


        # String ls_inc_source, ls_service_county, ls_income_type, ls_frequency
        # Double ldb_contract_amt, ldb_intended_use_mos
        # Long ll_row, ll_counter
        # String ls_bu_cur_status
        # //Get the Budget Member ID for ids_client_info (clientstatus)
         ldb_member_id = @istr_budget.str_months[@ii_bdgt_mth_rows].str_client[@ii_client_rows].member_id
        # // In this function we are purposely not updating the bdetails_id field
        # // because at present the T_B_MEM_details tables is not yet updated.
        # // Since there is a FK relationship between T_Audit_Trail_Mstr table.



        if (arg_indicator == 'I' || arg_indicator == 'D' ) #  // D is used for intended Use
            ll_RowsRetrieved = @ids_audit_trail_income_details.count
            lb_condition = check_condition(arg_counter,ll_rowsretrieved)
            if lb_condition
                @AuditTrailMasters = AuditTrailMaster.new
                @AuditTrailMasters.run_id = @idb_run_id
                @AuditTrailMasters.month_sequence = @idb_month_id
                @AuditTrailMasters.member_sequence = ldb_member_id
                @AuditTrailMasters.audit_det_ind =arg_indicator
                @AuditTrailMasters.client_id = @idb_client_id
                @AuditTrailMasters.service_program_id = @istr_budget.service_program_id
                @AuditTrailMasters.b_details_sequence = @idb_b_details_id
                ls_bu_cur_status = @is_bu_cur_status
                 if ls_bu_cur_status.blank?
                    ls_bu_cur_status = 0
                 end
                 if (@is_recalc_ind == "N" && ls_bu_cur_status == 6043  || ls_bu_cur_status == 6044)

                    if @istr_audit_mstr.size  > 0
                        ls_inc_source = @istr_audit_mstr[10]
                        ls_service_county = @istr_audit_mstr[12]
                        ls_frequency = @istr_audit_mstr[13]
                        ls_income_type = @istr_audit_mstr[14]
                    end
                    if @istr_audit_mstr.size > 0
                       ldt_inc_avg_begin_date = @istr_audit_mstr[17]
                       ldt_effective_beg_date = @istr_audit_mstr[18]
                       ldt_effective_end_date = @istr_audit_mstr[19]
                    end
                     if @istr_audit_mstr.size > 0
                        ldb_intended_use_mos = @istr_audit_mstr[8]
                        ldb_contract_amt = @istr_audit_mstr[9]
                     end
                 else
                    ls_inc_source  = @is_income_source
                    ls_service_county = @istr_budget.service_county
                    ls_income_type = @is_income_type
                    ldt_inc_avg_begin_date = arg_object.inc_avg_beg_date
                    ldb_contract_amt = arg_object.contract_amt
                    ldb_intended_use_mos  = arg_object.intended_use_mos
                    ldt_effective_beg_date = arg_object.effective_beg_date
                    ls_frequency  = arg_object.frequency
                    ldt_effective_end_date  = arg_object.effective_end_date
                 end
                 @AuditTrailMasters.source =  ls_inc_source
                 @AuditTrailMasters.processing_location = ls_service_county
                 @AuditTrailMasters.inc_exp_type =  ls_income_type
                 @AuditTrailMasters.inc_avg_begin_date =  ldt_inc_avg_begin_date
                 @AuditTrailMasters.contract_amt = ldb_contract_amt
                 @AuditTrailMasters.intended_use_mos =  ldb_intended_use_mos
                 @AuditTrailMasters. effective_beg_date =  ldt_effective_beg_date
                 @AuditTrailMasters.frequency =  ls_frequency
                 @AuditTrailMasters.effective_end_date = ldt_effective_end_date
                 if (@is_recalc_ind == "N" && (ls_bu_cur_status == 6043 || ls_bu_cur_status == 6044))
                    lds_audit_trail_shared_by = AuditTrailShared.get_income_shared_information(@idb_last_run_id,@idb_last_month_id,@idb_last_mem_id,@idb_b_details_id,@istr_audit_mstr[5])
                    lds_audit_trail_shared_by.each do|income_shared|
                    lds_audit_trail_inc_shared_temp = AuditTrailShared.new
                    lds_audit_trail_inc_shared_temp.run_id = @idb_run_id
                    lds_audit_trail_inc_shared_temp.month_sequence = @idb_month_id
                    lds_audit_trail_inc_shared_temp.member_sequence = ldb_member_id
                    lds_audit_trail_inc_shared_temp.client_id = income_shared.client_id
                    @ids_audit_trail_inc_shared_by << lds_audit_trail_inc_shared_temp
                    end
                 else
                    lds_client_income_shareby = ClientIncome.clients_income_details(arg_db_inc_expid,@idb_client_id)
                    ll_RowsRetrieved = @ids_audit_trail_inc_shared_by.count
                    lb_condition = check_condition(arg_counter,ll_rowsretrieved)
                    if lb_condition
                        lds_client_income_shareby.each do|income_shared|
                        lds_audit_trail_inc_shared_temp = AuditTrailShared.new
                        lds_audit_trail_inc_shared_temp.run_id = @idb_run_id
                        lds_audit_trail_inc_shared_temp.month_sequence = @idb_month_id
                        lds_audit_trail_inc_shared_temp.member_sequence = ldb_member_id
                        lds_audit_trail_inc_shared_temp.member_sequence = ldb_member_id
                        lds_audit_trail_inc_shared_temp.client_id = income_shared.id
                        @ids_audit_trail_inc_shared_by << lds_audit_trail_inc_shared_temp
                        end
                     end
                 end
                 @ids_audit_trail_income_details << @AuditTrailMasters
        #      end
             if arg_indicator != 'D'

                lds_audit_trail_income_details_checks_temp = AuditTrailIncomeDetail.new
                lds_audit_trail_income_details_checks_temp.run_id = @idb_run_id
                lds_audit_trail_income_details_checks_temp.month_sequence =  @idb_month_id
                lds_audit_trail_income_details_checks_temp.member_sequence = ldb_member_id
                lds_audit_trail_income_details_checks_temp.date_received = @istr_audit_trail.date_of_inc_exp
                lds_audit_trail_income_details_checks_temp.check_type = @istr_audit_trail.check_type
                lds_audit_trail_income_details_checks_temp.gross_amt = @istr_audit_trail.gross_amount
                lds_audit_trail_income_details_checks_temp.adjusted_total = @istr_audit_trail.adjusted_total
                lds_audit_trail_income_details_checks_temp.net_amt = @istr_audit_trail.net_amount
                lds_audit_trail_income_details_checks_temp.audit_trail_masters_id = arg_db_income_earned_id
                lds_audit_trail_income_details_checks_temp.b_details_sequence = @idb_b_details_id
                @ids_audit_trail_income_details_checks << lds_audit_trail_income_details_checks_temp
             end
            end
        else
              ll_RowsRetrieved = @ids_audit_trail_expense_details.size
              lb_condition = check_condition(arg_counter,ll_rowsretrieved)
             if lb_condition
                lds_audit_trail_expense_details_tmp = AuditTrailMaster.new
                lds_audit_trail_expense_details_tmp.run_id = @idb_run_id
                lds_audit_trail_expense_details_tmp.month_sequence =  @idb_month_id
                lds_audit_trail_expense_details_tmp.member_sequence = ldb_member_id
                lds_audit_trail_expense_details_tmp.audit_det_ind = arg_indicator
                lds_audit_trail_expense_details_tmp.clientid =  @idb_client_id
                lds_audit_trail_expense_details_tmp.service_program_id = @istr_budget.service_program_id
                lds_audit_trail_expense_details_tmp.source = @istr_audit_trail.exp_source
                lds_audit_trail_expense_details_tmp.processing_location = @istr_budget.service_county
                lds_audit_trail_expense_details_tmp.type = @istr_audit_trail.exp_type
                lds_audit_trail_expense_details_tmp.frequency = @istr_audit_trail.exp_frequency
                lds_audit_trail_expense_details_tmp.effective_beg_date = @istr_audit_trail.exp_beg_date
                lds_audit_trail_expense_details_tmp.effective_end_date = @istr_audit_trail.exp_end_date
                lds_audit_trail_expense_details_tmp.exp_calc_months = @istr_audit_trail.exp_calc_months
                @ids_audit_trail_expense_details << lds_audit_trail_expense_details_tmp

                ll_RowsRetrieved = ids_audit_trail_exp_shared_by.size
                lb_condition = check_condition(arg_counter,ll_rowsretrieved)
                if lb_condition
                   lds_client_debt_shareby = ClientExpense.clients_expense_details(arg_db_inc_expid,@idb_client_id)
                   lds_client_debt_shareby.each do |expense_shared|
                   lds_audit_trail_exp_shared_by_tmp = AuditTrailShared.new
                   lds_audit_trail_exp_shared_by_tmprun_id.run_id = @idb_run_id
                   lds_audit_trail_exp_shared_by_tmprun_id.month_sequence = @idb_mo_id
                   lds_audit_trail_exp_shared_by_tmprun_id.member_sequence = ldb_member_id
                   lds_audit_trail_exp_shared_by_tmprun_id.client_id =  @idb_client_id
                   end
                end
                 @ids_audit_trail_expense_details << lds_audit_trail_inc_shared_temp
             end
             lds_audit_trail_expense_details_checks_tmp = AuditTrailExpenseDetail.new
             lds_audit_trail_expense_details_checks_tmp.run_id = @idb_run_id
             lds_audit_trail_expense_details_checks_tmp.month_sequence = @idb_month_id
             lds_audit_trail_expense_details_checks_tmp.member_sequence = @idb_member_id
             lds_audit_trail_expense_details_checks_tmp.expense_due_date = @istr_audit_trail.date_of_inc_exp
             lds_audit_trail_expense_details_checks_tmp.expense_due_date = @istr_audit_trail.gross_amount
             lds_audit_trail_expense_details_checks_tmp.expense_due_date = @istr_audit_trail.payment_status
             lds_audit_trail_expense_details_checks_tmp.expense_due_date = @istr_audit_trail.use_code
             @ids_audit_trail_expense_details_checks << lds_audit_trail_expense_details_checks_tmp
        #     end
        return 1
        end
    end

    def self.sys_generate_audit_id(arg_rows, arg_table)
        system_id = 0
        case
            when arg_table == "AM"
                 system_id_tmp =  ActiveRecord::Base.connection.execute("SELECT nextval('audit_master_seq')").first
                 system_id_tmp.each do |key, val|
                 system_id = val
                 end
                 @ids_audit_trail_income_details[arg_rows].id = system_id
            when arg_table == "AD"
                 system_id_tmp =  ActiveRecord::Base.connection.execute("SELECT nextval('audit_master_detail_seq')").first
                 system_id_tmp.each do |key, val|
                 system_id = val
                 end
                 @ids_audit_trail_income_details_checks[arg_rows].id = system_id
            when arg_table == "AA"
                 system_id_tmp =  ActiveRecord::Base.connection.execute("SELECT nextval('audit_master_inc_adj_seq')").first
                 system_id_tmp.each do |key, val|
                 system_id = val
                 end
                 @ids_audit_trail_income_adj_dt[arg_rows].id = system_id
            when arg_table == "AME"
                 system_id_tmp =  ActiveRecord::Base.connection.execute("SELECT nextval('audit_master_seq')").first
                 system_id_tmp.each do |key, val|
                 system_id = val
                 end
                 @ids_audit_trail_expense_details[arg_rows].id = system_id
            when arg_table == "ADE"
                 system_id_tmp =  ActiveRecord::Base.connection.execute("SELECT nextval('audit_master_detail_seq')").first
                 system_id_tmp.each do |key, val|
                 system_id = val
                 end
                 @ids_audit_trail_expense_details_checks[arg_rows].id = system_id
        end

        return system_id
    end

    def self.update_audit_trail_data(arg_bdm_row_ind, arg_b_details_id, arg_member_id)

        ll_cntMstr = 0
        ll_cntaudit = 0
        ll_cnt_adjaudit = 0
        ldb_audit_id = 0
        ldb_audit_det_id = 0
        ldb_inc_adj_id = 0

     if (arg_bdm_row_ind == 'I' || arg_bdm_row_ind == 'U' || arg_bdm_row_ind == 'S')

            @ids_audit_trail_income_details.each do |audit_trail_income_details|

            audit_trail_income_details.audit_det_ind = arg_bdm_row_ind
            audit_trail_income_details.b_details_sequence = arg_b_details_id
            audit_trail_income_details.member_sequence =  arg_member_id
            #ldb_member_id = ids_audit_trail_income_details.getitemnumber(ll_cntMstr, "bmember_id")
            ldb_check_audit_id = audit_trail_income_details.id
            if ldb_check_audit_id.present?
                continue
            end
            ldb_audit_id = sys_generate_audit_id(ll_cntMstr,"AM")
            ldb_dummy1_id = @ids_audit_trail_income_details[ll_cntMstr].month_sequence
            ll_rowsaudit = @ids_audit_trail_income_details_checks.count
            ll_cntaudit = 0
            @ids_audit_trail_income_details_checks.each do |income_details_checks|
                income_details_checks.audit_trail_masters_id = ldb_audit_id
                income_details_checks.b_details_sequence = arg_b_details_id
                income_details_checks.member_sequence =  arg_member_id
                #ldb_dummy_id = ids_audit_trail_income_details_checks.getitemnumber(ll_cntaudit, "audit_det_id")

                ldb_audit_det_id = sys_generate_audit_id(ll_cntaudit,"AD")
                ll_cnt_adjaudit = 0
                @ids_audit_trail_income_adj_dt.each do |audit_trail_income_adj_dt|
                    audit_trail_income_adj_dt.audit_trail_masters_id =  ldb_audit_id
                    audit_trail_income_adj_dt.audit_trail_income_details_id =  ldb_audit_det_id
                    audit_trail_income_adj_dt.b_details_sequence = arg_b_details_id
                    audit_trail_income_adj_dt.member_sequence = arg_member_id
                    ldb_inc_adj_id = sys_generate_audit_id(ll_cnt_adjaudit,"AA")

                    ll_cnt_adjaudit = ll_cnt_adjaudit + 1
                end
                ll_cntaudit = ll_cntaudit + 1
            end

             ll_cntaudit = 0
             @ids_audit_trail_inc_shared_by.each do|audit_trail_inc_shared_by|
             audit_trail_inc_shared_by.audit_trail_masters_id = ldb_audit_id
             audit_trail_inc_shared_by.b_details_sequence = arg_b_details_id
             audit_trail_inc_shared_by.member_sequence = arg_member_id
             end
             ll_cntMstr = ll_cntMstr + 1
             end
      elsif arg_bdm_row_ind == 'E'

            ll_CntMstr = 0
            @ids_audit_trail_expense_details.each do |audit_trail_expense_details|
            audit_trail_expense_details.audit_det_ind = 'E'
            audit_trail_expense_details.b_details_sequence = arg_b_details_id
            ldb_audit_id = sys_generate_audit_id(ll_cntMstr,"AME")


            ll_cntaudit = 0
            @ids_audit_trail_expense_details_checks.each do|audit_trail_expense_details_checks|
             audit_trail_expense_details_checks.audit_trail_masters_id = ldb_audit_id
             audit_trail_expense_details_checks.b_details_sequence =  arg_b_details_id
             ldb_audit_det_id = sys_generate_audit_id(ll_cntaudit,"ADE")
             ll_cntaudit = ll_cntaudit + 1
            end

            ll_cntaudit = 0
            @ids_audit_trail_exp_shared_by.each do|audit_trail_exp_shared_by|
            audit_trail_exp_shared_by.audit_trail_masters_id = ldb_audit_id
            audit_trail_exp_shared_by.b_details_sequence = arg_b_details_id
            end

            end

     ll_cntMstr = ll_cntMstr + 1
     end
    # //initialize the istr_audit_trail structure

    @istr_audit_trail.date_of_inc_exp = nil
    @istr_audit_trail.check_type = ""
    @istr_audit_trail.gross_amount = 0
    @istr_audit_trail.adjusted_total = 0
    @istr_audit_trail.net_amount = 0
    @istr_audit_trail.payment_status = ""
    @istr_audit_trail.use_code = ""
    @istr_audit_trail.exp_source = ""
    @istr_audit_trail.exp_frequency = ""
    @istr_audit_trail.exp_beg_date = nil
    @istr_audit_trail.exp_end_date = nil
    @istr_audit_trail.exp_type = ""
    @istr_audit_trail.exp_calc_months = 0



    end


    def self.sum_multiple_month()
    #             string                     ls_mem_status[], ls_det_calc, ls_result
    # integer                              li_cnt, li_budget_month, li_return
    # long                                    ll_max_client_rows, ll_max_income_rows
    # long                                    ll_num_months
    # str_pass           lstr_pass
    # long                                    ll_bu_size, ll_rows, ll_newrow, ll_num_unborn = 0
    # decimal {2} ldc_net_income, ldc_child_care
    # date                                   ld_budget_month, ld_first_month
    # n_ds                                  lds_mult_months
    # date                                   ld_bms_start
    # date                                   ld_bms_stop
    # double                              ldb_member_id
    # string                 ls_resource_ind

    # string ls_earned_ind, ls_bdm_row_indicator
    # string ls_valid_month = 'N'
    # date   ld_income_beg_date, ld_income_end_date
    # decimal{2} ldc_earned_inc_deduct[]
    # decimal{2} ldc_net_income_monthly
    # decimal{2} ldc_total_fm_ded
    # integer              li_ded_cnt
    # decimal{2} ldc_total_inc_ded_per_client
    # integer li_inc_ded_cnt
    # long    ll_num_months_inc

    # //PCR#66133
    # Integer li_month_ctr
    # Decimal{2} ldc_am_deduction = 0.00

    # //PCR#67289
    # Integer li_fm_month_ctr
    # Decimal{2} ldc_fm_cs_ded
    # Decimal{2} ldc_fm_cs_deduction_excess[]

    # //PCR#73830
    # String ls_frequency

    # lstr_pass.db[1] = idb_run_id
    # lstr_pass.db[2] = idb_bu_id
    # idc_total_fm_ded = 0
    # ii_bdgt_mth_rows = 0                                //J Kelch 7/26/00 - Enh 1077 - value needed in det_ckga_amt

    # lds_mult_months = Create ds_mult_months
    # lds_mult_months.SetTransObject(SQLCA)
    # ll_rows = gnv_data_access_service.retrieve(lds_mult_months, lds_mult_months, "Bbmo_l", lstr_pass)
    #  SELECT bwiz_run_id,
    #                bwiz_mo_id,
    #                budget_unit_id,
    #                service_program_id,
    #                bwiz_run_month,
    #                user_id,
    #                bwiz_run_date,
    #                num_budget_months,
    #                bwiz_cat_elig_ind
    #         FROM t_budget_wizard
    #         WHERE ( bwiz_run_id = :rBbmo_Bwiz_run_id ) AND
    #               ( budget_unit_id = :rBbmo_budget_unit_id )
    #         ORDER BY bwiz_run_month ASC;

    # ll_num_months = lds_mult_months.GetItemNumber(1, 'num_budget_months')
    # il_num_months = ll_num_months

    # idb_month_id = lds_mult_months.GetItemNumber(1, 'bwiz_mo_id')
    # ld_first_month = lds_mult_months.GetItemDate(1, 'bwiz_run_month')

    # istr_budget.str_months[1].month_id = idb_month_id                               //J Kelch 7/13/00 - Enh 1077
    # istr_budget.str_months[1].month = ld_first_month                    //J Kelch 7/13/00 - Enh 1077
    # istr_budget.str_months[1].sd_num_months = ll_num_months             //J Kelch 7/13/00 - Enh 1077

    # /*of_sobra_medicaid needs the il_month_id to retrieve a datastore.
    # The call for of_sobra_medicaid was before il_month_id was set, so
    # I moved the call to here - J Kelch 10/29/99 */
    # If ii_service_program = 67 then
    #             ll_num_unborn = this.of_sobra_medicaid()
    # End if

    # lstr_pass.db[1] = idb_run_id
    # lstr_pass.db[2] = idb_month_id
    # li_return = gnv_data_access_service.retrieve(ids_client_info, ids_client_info, "Bccs_l", lstr_pass)
    #                t_budget_member.b_member_status,
    #  SELECT t_budget_member.client_id,
    #                t_budget_member.bmember_id,
    #                t_person_biograph.dob
    #         FROM t_budget_member,
    #              t_person_biograph
    #         WHERE t_person_biograph.clientid = t_budget_member.client_id
    #         AND   t_budget_member.bwiz_run_id = :rBccs_bwiz_run_id
    #         AND   t_budget_member.bwiz_mo_id = :rBccs_bwiz_mo_id;

    # ll_max_client_rows = li_return

    # ll_bu_size = ll_max_client_rows
    # ii_client_rows = 0
    # //commented for PCR#67289, this is not the right calcultaion for CS Deduction SpendDown
    # //idc_fm_cs_ded = 50 * ll_num_months                                                                           //Added for customer defect #200

    # If isvalid(in_ds_5) then
    #             Destroy in_ds_5
    # End if

    # in_ds_5 = Create ds_t_b_mem_details
    # in_ds_5.SetTransObject(SQLCA)

    # If isvalid(in_ds_6) then
    #             Destroy in_ds_6
    # End if

    # //DataStore used for T_bmem_summary - Set the summary records for this client
    # in_ds_6 = Create ds_bmem_summary_update
    # in_ds_6.SetTransObject(SQLCA)

    # //Intialize 50 Deduction for all members in each month of spend down - PCR#67289
    # FOR li_fm_month_ctr = 1 to ll_num_months
    #             idc_fm_cs_deduction_excess[li_fm_month_ctr] = 50
    #             idc_client_monthly_net_income[li_fm_month_ctr] = 0 //PCR#68345
    # NEXT


    # //** PCR#68345 - expansion, Get the bu size counted for budget eligibility
    # Long ll_client_ctr
    # String ls_member_status
    # FOR ll_client_ctr = 1 TO ll_max_client_rows
    #             ls_member_status = ids_client_info.getitemString(ll_client_ctr, "b_member_status")
    #             IF ls_member_status <> "04" THEN
    #                             ii_bu_client_cnt++
    #             END IF
    # NEXT
    # ii_bu_client_cnt = ii_bu_client_cnt + ll_num_unborn
    # //**

    # Do while ii_client_rows <= ll_max_client_rows  //Loop through clients for this budget month *JH
    #             //PCR#67289 - Reset Total CS deduction for each client
    #             idc_fm_cs_ded = 0
    #             ldc_fm_cs_ded = 0

    #             ldc_net_income = 0
    #             idb_b_details_id = 1  //J Kelch 11/16/99
    #             id_dob = Date(ids_client_info.GetItemDateTime(ii_client_rows, "t_person_biograph_dob")) //PC#65468-ELGutierez
    #             idb_client_id = ids_client_info.getitemNumber(ii_client_rows, "client_id")
    #             lstr_pass.db[1] = idb_client_id
    #             lstr_pass.db[2] = idb_bc_rule_id
    #             ldb_member_id = ids_client_info.GetItemNumber(ii_client_rows, "bmember_id")
    #             ls_mem_status[ii_client_rows] = ids_client_info.getitemString(ii_client_rows, "b_member_status")

    #             istr_budget.str_months[1].str_client[ii_client_rows].client_id = idb_client_id                    //J Kelch 7/13/00 - Enh 1077
    #             istr_budget.str_months[1].str_client[ii_client_rows].client_status = ls_mem_status[ii_client_rows]                       //J Kelch 7/13/00 - Enh 1077
    #             istr_budget.str_months[1].str_client[ii_client_rows].member_id = ldb_member_id                       //J Kelch 7/13/00 - Enh 1077

    #             // nebinger find the bms start and stop dates for the client/budget unit pair
    #             of_find_bms_dates(idb_client_id,idb_bu_id,ld_bms_start,ld_bms_stop,idb_run_id,idb_month_id)//Trao 69962

    #             If ls_mem_status[ii_client_rows] =  "04" or ls_mem_status[ii_client_rows] = "05" &
    #                             or ls_mem_status[ii_client_rows] = "06" then                                    //J Kelch 1/25/00 Added Active-None clients to If

    #                             /* Inactive-Closed members need to be saved to t_bmem_summary so that a Medicaid
    #                             end date can be set when closing a member out of an open Medicaid case.
    #                             Added code to add these members - J Kelch 10/26/99 */

    #                             //Insert a row at the end of the DataStore
    #                             ll_NewRow = in_ds_6.InsertRow(0)
    #                             //Set the fields to be written to the datastore
    #                             in_ds_6.SetItem(ll_NewRow, "bwiz_run_id", idb_run_id)
    #                             in_ds_6.SetItem(ll_NewRow, "bwiz_mo_id", idb_month_id)
    #                             in_ds_6.SetItem(ll_NewRow, "bmember_id", ldb_member_id)
    #                             in_ds_6.SetItem(ll_NewRow, "tot_earned_inc", 0)
    #                             in_ds_6.SetItem(ll_NewRow, "tot_unearned_inc",0)
    #                             in_ds_6.SetItem(ll_NewRow, "tot_expenses",0)
    #                             in_ds_6.SetItem(ll_NewRow, "supl_sec_inc_amt", 0)
    #                             in_ds_6.SetItem(ll_NewRow, "soc_sec_admin_amt", 0)
    #                             in_ds_6.SetItem(ll_NewRow, "railroad_ret_amt", 0)
    #                             in_ds_6.SetItem(ll_NewRow, "vet_asst_amt", 0)
    #                             in_ds_6.SetItem(ll_NewRow, "other_unearned_inc", 0)

    #                             in_ds_6.SetItem(ll_NewRow, "bms_start_date", ld_bms_start)
    #                             in_ds_6.SetItem(ll_NewRow, "bms_stop_date", ld_bms_stop)

    #                             //Call the update service to write the records to the datastore (update database t_b_mem_details)
    #                             li_return = gnv_data_access_service.update_service(in_ds_6, in_ds_6, "Bcsu_u",lstr_pass)
    #                              UPDATE t_bmem_summary
    #       SET    bms_reason         = :rBcsu_bms_reason
    #                                                 indicator :nBcsu_bms_reason,
    #              bms_start_date     = :rBcsu_bms_start_date
    #                                                 indicator :nBcsu_bms_start_date,
    #              bms_stop_date      = :rBcsu_bms_stop_date
    #                                                 indicator :nBcsu_bms_stop_date,
    #              tot_earned_inc     = :rBcsu_tot_earned_inc,
    #              tot_unearned_inc   = :rBcsu_tot_unearned_inc,
    #              tot_expenses       = :rBcsu_tot_expenses,
    #              tot_resources      = :rBcsu_tot_resources,
    #              unmet_liability    = :rBcsu_unmet_liability,
    #              supl_sec_inc_amt   = :rBcsu_supl_sec_inc_amt,
    #              soc_sec_admin_amt  = :rBcsu_soc_sec_admin_amt,
    #              railroad_ret_amt   = :rBcsu_railroad_ret_amt,
    #              vet_asst_amt       = :rBcsu_vet_asst_amt,
    #              other_unearned_inc = :rBcsu_other_unearned_inc,
    #              elig_work_deduct   = :rBcsu_elig_work_deduct,
    #              elig_incent_deduct = :rBcsu_elig_incent_deduct,
    #              earned_inc_deduct  = :rBcsu_earned_inc_deduct,
    #              child_care_deduct  = :rBcsu_child_care_deduct
    #       WHERE  bwiz_run_id = :rBcsu_bwiz_run_id
    #       AND    bwiz_mo_id  = :rBcsu_bwiz_mo_id
    #       AND    bmember_id  = :rBcsu_bmember_id;

    #                             If ls_mem_status[ii_client_rows] <> "06" then  //J Kelch 1/25/00 Active-None clients do count in bu size
    #                                             ll_bu_size = ll_bu_size - 1
    #                             End if
    #                             ii_client_rows++
    #                             continue// If the member has an inactive closed status then we don't want to count any income

    #             Else

    # //                        idc_am_deduction = 20 * ll_num_months //PCR#66133 - comment out, this is wrong setting of deduction for spend down..
    #                             FOR li_month_ctr = 1 to ll_num_months //PCR#66133 - intialized the 20 deduction for all month....
    #                                             idc_am_sd_deduction[li_month_ctr] = 20.00
    #                                             idc_net_earned_income[li_month_ctr] = 0.00
    #                                             idc_net_unearned_income[li_month_ctr] = 0.00
    #                                             idc_gen_exclusion[li_month_ctr] = 0.00
    #                             NEXT


    #                             li_return = gnv_data_access_service.retrieve(ids_countable_income, ids_countable_income, "Bcci_l", lstr_pass)  //Datastore contains all income records for the client
    #                             ii_income_rows = 1
    #                             ll_max_income_rows = li_return
    #                             If li_return > 0 then
    #                                             Do while ii_income_rows <= ll_max_income_rows
    #                                                             ls_earned_ind = ids_countable_income.GetItemString(ii_income_rows, "t_rule_object_cdv_crit_a_ind") //put here to get the status earned and resource -Defect #1852
    #                                                             ls_resource_ind = ids_countable_income.GetItemString(ii_income_rows, "t_rule_object_cdv_crit_b_ind")             //Defect #1852
    #                                                             is_income_type = ids_countable_income.getitemstring(ii_income_rows, "t_income_type")
    #                                                             idb_income_id = ids_countable_income.getitemNumber(ii_income_rows, "t_income_incomeid")
    #                                                             ld_income_beg_date = Date(ids_countable_income.GetItemDateTime(ii_income_rows, "t_income_effective_beg_date")) //Defect #1923
    #                                                             ld_income_end_date = Date(ids_countable_income.GetItemDateTime(ii_income_rows, "t_income_effective_end_date")) //Defect #1923
    #                                                             //Anand Kotian 04/26/2002         Start
    #                                                             is_income_source = ids_countable_income.GetItemString(ii_income_rows, "t_income_source")
    #                                                             If Len(is_income_source) > 20 Then
    #                                                                             is_income_source = RightTrim(Left(is_income_source,20))
    #                                                             End if
    #                                                             //Anand Kotian Audit Trail PCR 65267 - End - 04/26/02


    #                                                             li_cnt = 1

    #                                                             ld_budget_month = ld_first_month
    #                                                             ld_budget_month = f_future_date(ld_budget_month,'M', 0)

    #                                                             ls_valid_month = 'N' //Defect #1923

    #                                                             Do While li_cnt <= ll_num_months

    #                                                                             li_budget_month = Month(ld_budget_month)

    #                                                                             Choose Case Year(ld_budget_month)
    #                                                                                             Case Is < Year(Today())
    #                                                                                                             ls_det_calc = 'A'
    #                                                                                             Case Is > Year(Today())
    #                                                                                                             ls_det_calc = 'F'
    #                                                                                             Case Year(Today())
    #                                                                                                             Choose Case li_budget_month
    #                                                                                                                             Case Is < Month(Today())
    #                                                                                                                                             ls_det_calc = 'A'
    #                                                                                                                             Case Month(Today())
    #                                                                                                                                             ls_det_calc = 'B'
    #                                                                                                                             Case Else
    #                                                                                                                                             ls_det_calc = 'F'
    #                                                                                                             End Choose
    #                                                                             End Choose

    #                                                                             Choose Case ls_det_calc
    #                                                                                             Case 'A'
    #                                                                                                             id_month = ld_budget_month
    #                                                                                                             ldc_net_income_monthly = this.of_calc_actual('N') // Defect #1992
    #                                                                                             Case 'B'
    #                                                                                                             id_month = ld_budget_month
    #                                                                                                             ldc_net_income_monthly = this.of_calc_actual('Y') // // Defect #1992
    #                                                                                                             ldc_net_income_monthly = ldc_net_income_monthly + this.of_calc_future(ld_budget_month) // Defect #1992
    # //                                                                                                        ldc_net_income = ldc_net_income + ldc_net_income_monthly                // Defect #1992
    #                                                                                             Case 'F'
    #                                                                                                             id_month = ld_budget_month
    #                                                                                                             ldc_net_income_monthly = this.of_calc_future(ld_budget_month) // Defect #1992
    # //                                                                                                        ldc_net_income = ldc_net_income + ldc_net_income_monthly                // Defect #1992
    #                                                                             End Choose

    #                                                                             //PCR#73830  - ELGutierez
    #                                                                             ls_frequency = ids_countable_income.GetItemString(ii_income_rows, 't_income_frequency')  //J Kelch 2/8/00

    #                                                                             CHOOSE CASE ii_service_program
    #                                                                                             CASE 17, 37, 47
    #                                                                                             // Added code to disregard earned irregular income if it's less than $10
    #                                                                                             If ls_frequency = 'IR' then                                                            //Irregular frequency
    #                                                                                                             If ls_earned_ind = "1" AND ldc_net_income_monthly < DEC(10.00) then
    #                                                                                                                             ldc_net_income_monthly = 0
    #                                                                                                             End if
    #                                                                                                             // Added code to disregard Unearned irregular income if it's less than $20
    #                                                                                                             If ls_earned_ind = "0" AND ldc_net_income_monthly < DEC(20.00) then
    #                                                                                                                             ldc_net_income_monthly = 0
    #                                                                                                             End if
    #                                                                                             END IF
    #                                                                             END CHOOSE

    #                                                                             ldc_net_income = ldc_net_income + ldc_net_income_monthly                // Defect #1992

    #                                                                             ld_budget_month = f_future_date(ld_budget_month,'M', 1)

    #                                                                             //Added array variable to get the total earned income ded - Defect #1992
    #                                                                             If ls_resource_ind = '0' Then
    #                                                                                             IF ls_earned_ind = "1" THEN
    #                                                                                                             ldc_earned_inc_deduct[li_cnt] = ldc_earned_inc_deduct[li_cnt] + ldc_net_income_monthly
    #                                                                                             END IF
    #                                                                             END IF

    #                                                                             IF of_valid_effective_dates(ld_income_beg_date, ld_income_end_date) = 'Y' THEN // Defect #1923
    #                                                                                             ls_valid_month = 'Y'
    #                                                                             END IF

    #                                                                             //PC#66133 ELGutierez - count no. of months with income
    #                                                                             IF ldc_net_income_monthly > 0 THEN
    #                                                                                             ll_num_months_inc++
    #                                                                             END IF

    #                                                                             //PCR#66583
    #                                                                             ii_bu_size = ll_bu_size + ll_num_unborn
    #                                                                             //

    #                                                                             //PCR#67289 - Calculation of CS Deduction
    #                                                                             IF is_income_type = "30" THEN
    #                                                                                             Choose Case ii_service_program
    #                                                                                                             Case 27, 57, 67, 77, 87
    #                                                                                                                                             IF Upperbound(idc_fm_cs_deduction_excess[]) > 0 THEN
    #                                                                                                                                                             If ldc_net_income_monthly >= idc_fm_cs_deduction_excess[li_cnt] then
    #                                                                                                                                                                             ldc_fm_cs_ded = idc_fm_cs_deduction_excess[li_cnt]
    #                                                                                                                                                             Else
    #                                                                                                                                                                             ldc_fm_cs_ded = ldc_net_income_monthly
    #                                                                                                                                                             End if
    #                                                                                                                                                             idc_fm_cs_deduction_excess[li_cnt] = idc_fm_cs_deduction_excess[li_cnt] - ldc_fm_cs_ded
    #                                                                                                                                             END IF
    #                                                                                                             END CHOOSE
    #                                                                             END IF

    #                                                                             idc_fm_cs_ded = idc_fm_cs_ded + ldc_fm_cs_ded

    #                                                                             //moved this code to include the cs deduction PCR#68345
    #                                                                             If ls_resource_ind = '0' Then       //PCR#66133 - set the total earned/unearned income for each month..
    #                                                                                             IF ls_earned_ind = "1" THEN
    #                                                                                                             idc_net_earned_income[li_cnt] = idc_net_earned_income[li_cnt] + ldc_net_income_monthly
    #                                                                                             ELSE
    #                                                                                                             idc_net_unearned_income[li_cnt] = idc_net_unearned_income[li_cnt] + ldc_net_income_monthly
    #                                                                                             END IF
    #                                                                                             idc_net_unearned_income[li_cnt] = idc_net_unearned_income[li_cnt] - ldc_fm_cs_ded
    #                                                                             END IF

    #                                                                             li_cnt ++

    #                                                             Loop /* while li_cnt <= ll_num_months */

    # //                                                        idc_am_deduction = 20 * ll_num_months_inc //PC#66133 - comment out, this is not the right calculation for spend down...
    # //                                                        idc_fm_cs_ded = 50 * ll_num_months_inc // PCR#67204 // commented for PCR#67289

    #                                                             If ii_income_rows = ll_max_income_rows then
    #                                                                             of_client_sd_exp(ld_first_month)
    #                                                                             ldc_child_care = ldc_child_care + istr_client_exp.child_care
    #                                                             End if

    #                                                             Choose Case ii_service_program
    #                                                                             Case 17, 37, 47
    #                                                                                             ldc_net_income = this.of_am_sd_net_income(ldc_net_income, ls_earned_ind)
    #                                                                             Case 27, 57, 67, 77, 87, 97  //J Kelch 2/2/00 Moved 97 to here - 3/15/00 Took out 25
    #                                                                                             //Do nothing - Income should already be correct.
    #                                                             End Choose

    #                                                             If ls_resource_ind = '0' Then                       //J Kelch 7/25/00 - Enh 1077
    #                                                                             IF ls_earned_ind = "1" THEN
    #                                                                             //Earned Income
    #                                                                                             ls_bdm_row_indicator = "I"
    #                                                                                             If ldc_net_income < 0 then                         //J Kelch 1/10/00
    #                                                                                                             ldc_net_income = 0
    #                                                                                             End if
    #                                                                                             istr_income2.earned_cl = istr_income2.earned_cl + ldc_net_income
    #                                                                                istr_income2.tot_e = istr_income2.tot_e + ldc_net_income
    #                                                             ELSE
    #                                                                                //Unearned Income
    #                                                                                ls_bdm_row_indicator = "U"

    #                                                                                             CHOOSE CASE is_income_type
    #                                                                                             //Keep track of SSA income types
    #                                                                                CASE "70", "SD", "SV"                  // JD added SV (Soc. Sec. Survivor type) per defect #1512
    #                                                                                                                             istr_income2.ssa_cl = istr_income2.ssa_cl + ldc_net_income
    #                                                                                                                istr_income2.ssa = istr_income2.ssa + ldc_net_income
    #                                                                                                //Keep track of VA income types
    #                                                                                                CASE "20", "VC"
    #                                                                                                                             istr_income2.va_cl = istr_income2.va_cl + ldc_net_income
    #                                                                                                             istr_income2.va = istr_income2.va + ldc_net_income
    #                                                                                             //Keep track of Railroad Retirement income types
    #                                                                                CASE "RR"
    #                                                                                                                             istr_income2.rr_cl = istr_income2.rr_cl + ldc_net_income
    #                                                                                                                istr_income2.rr = istr_income2.rr + ldc_net_income

    #                                                                                                             //A Godoy PCR 66663 - Assisted Living/SSI Assisted Living - added case for 75
    #                                                                                CASE "75"
    #                                                                                                                             if ii_service_program = 82 or ii_service_program = 83 then
    #                                                                                                                                             istr_income2.ssi = istr_income2.ssi + ldc_net_income
    #                                                                                                                                istr_income2.ssi_cl = istr_income2.ssi_cl + ldc_net_income
    #                                                                                                                             end if

    #                                                                                                             CASE "30"                                            //Added for customer defect #200
    #                                                                                                                             Choose Case ii_service_program
    #                                                                                                                                             Case 27, 57, 67, 77, 87
    #                                                                                                                                             If ldc_net_income >= idc_fm_cs_ded then
    #                                                                                                                                                             ldc_net_income = ldc_net_income - idc_fm_cs_ded
    #                                                                                                                                                             idc_fm_cs_ded = 0
    #                                                                                                                                             Else
    #                                                                                                                                                             idc_fm_cs_ded = idc_fm_cs_ded - ldc_net_income
    #                                                                                                                                                             ldc_net_income = 0
    #                                                                                                                                             End if
    #                                                                                                                             End Choose
    #                                                                                                                                             istr_income2.other_cl = istr_income2.other_cl + ldc_net_income
    #                                                                                                                                istr_income2.other = istr_income2.other + ldc_net_income
    #                                                                                                             CASE ELSE
    #                                                                                                                             istr_income2.other_cl = istr_income2.other_cl + ldc_net_income
    #                                                                                                                istr_income2.other = istr_income2.other + ldc_net_income
    #                                                                             END CHOOSE
    #                                                                                             istr_income2.unearned_cl = istr_income2.unearned_cl + ldc_net_income
    #                                                                             istr_income2.tot_ue = istr_income2.tot_ue + ldc_net_income
    #                                                                END IF
    #                                                             Else                        //J Kelch 7/25/00 - Enh 1077
    #                                                                             ls_bdm_row_indicator = 'S'
    #                                                                             istr_budget.str_months[1].income_as_res = istr_budget.str_months[1].income_as_res + ldc_net_income
    #                                                             End if

    #                                                             //Insert a row at the end of the DataStore
    #                                                             ll_NewRow = in_ds_5.InsertRow(0)

    #                                                             //Set the fields to be written to the datastore
    #                                                             in_ds_5.SetItem(ll_NewRow, "bwiz_run_id", idb_run_id)
    #                                                             in_ds_5.SetItem(ll_NewRow, "bwiz_mo_id", idb_month_id)
    #                                                             in_ds_5.SetItem(ll_NewRow, "bmember_id", ldb_member_id)

    #                                                             in_ds_5.SetItem(ll_NewRow, "bdm_row_indicator", ls_bdm_row_indicator)
    #                                                             in_ds_5.SetItem(ll_NewRow, "item_type", is_income_type)
    #                                                             in_ds_5.SetItem(ll_NewRow, "item_source", is_income_source)            //J Kelch 1/19/00 Uncommented
    #                                                in_ds_5.SetItem(ll_newRow, "dollar_amount", ldc_net_income)
    #                                                             in_ds_5.SetItem(ll_newRow, "calc_method_code", '04')              //J Kelch 01/18/00 Enhancement 1042
    #                                                             in_ds_5.SetItem(ll_newRow, "b_details_id", idb_b_details_id)                 //J Kelch 11/16/99
    #                                                             //Anand Kotian Audit Trail PCR 65267 - Start 01/31/02
    #                                                             // The Row indicator and the b_details_id is identified in this function
    #                                                             // Therefore the updation tot the audit trail datastore is done in the
    #                                                             // function below  The updation to the database will also be done in this function
    #                                                             // because the t_b_mem_details table get updated to the database here.
    #                                                             // Anand Kotian. Audit trail table updation is not straight forward so please
    #                                                             // take care when changing the code for audit trail or t_b_mem_details table
    #                                                             of_update_audit_trail_data(ls_bdm_row_indicator,idb_b_details_id,ldb_member_id)
    #                                                             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
    #                                                             idb_b_details_id ++

    #                                                             If idb_b_details_id > idb_max_b_details_id then
    #                                                                             idb_max_b_details_id = idb_b_details_id
    #                                                             End if
    #                                                             //Call the update service to write the records to the datastore (update database t_b_mem_details)
    #                                                             li_return = gnv_data_access_service.update_service(in_ds_5, in_ds_5, "Bcmd_u",lstr_pass)
    #                                                             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                                                             li_return = gnv_data_access_service.update_service(ids_audit_trail_income_details,ids_audit_trail_income_details, "Atid_u",lstr_pass)
    #                                                             li_return = gnv_data_access_service.update_service(ids_audit_trail_income_details_checks,ids_audit_trail_income_details_checks, "Atic_u",lstr_pass)
    #                                                             li_return = gnv_data_access_service.update_service(ids_audit_trail_income_adj_dt,ids_audit_trail_income_adj_dt, "Atia_u",lstr_pass)
    #                                                             li_return = gnv_data_access_service.update_service(ids_audit_trail_inc_shared_by,ids_audit_trail_inc_shared_by, "Atsb_u",lstr_pass)
    #                                                             ids_audit_trail_income_details.reset()
    #                                                             ids_audit_trail_income_details_checks.reset()
    #                                                             ids_audit_trail_income_adj_dt.reset()
    #                                                             ids_audit_trail_inc_shared_by.reset()
    #                                                             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
    #                                                             ii_income_rows ++
    #                                                             ldc_net_income = 0

    #                                                             idc_fm_cs_ded = idc_fm_cs_ded + ldc_fm_cs_ded //PCR#67289 - Total CS Deduction for each client.

    #                                             Loop /* while ii_income_rows <= li_max_income_rows */

    #                                                             //Added DO WHILE codes for calculation of total earned income deduction - Defect #1992
    #                                                             li_ded_cnt = 0

    #                                                             DO WHILE UpperBound(ldc_earned_inc_deduct[]) > li_ded_cnt //Loop through counts of earned inc deduct - Defect#1992
    #                                                                             li_ded_cnt++
    #                                                                                             IF ldc_earned_inc_deduct[li_ded_cnt] < 90 THEN
    #                                                                                                             idc_fm_deduction[li_ded_cnt] = ldc_earned_inc_deduct[li_ded_cnt]
    #                                                                                                             idc_total_fm_ded = idc_total_fm_ded  + ldc_earned_inc_deduct[li_ded_cnt]
    #                                                                                                             ldc_total_fm_ded = ldc_total_fm_ded  + ldc_earned_inc_deduct[li_ded_cnt]
    #                                                                                             ELSE
    #                                                                                                             idc_fm_deduction[li_ded_cnt] = 90
    #                                                                                                             idc_total_fm_ded = idc_total_fm_ded  + 90
    #                                                                                                             ldc_total_fm_ded = ldc_total_fm_ded  + 90
    #                                                                                             END IF
    #                                                             LOOP

    #                                                             ldc_am_deduction = of_calc_am_sd_deduction(ll_num_months) //PCR#66133 - returns the total deduction...
    #                                                             idc_am_deduction = idc_am_deduction + ldc_am_deduction // total unearned deduction (general exclusion) PCR#66133

    #                                                             in_ds_6.SetItem(ll_NewRow, "earned_inc_deduct", ldc_total_fm_ded) // j kelch 11/9/99
    #                                                             ldc_total_inc_ded_per_client = ldc_total_fm_ded //PC#65990 ELGutierez - set this value                to total inc ded for each client.
    #                                                             ldc_total_fm_ded = 0.00 // Refresh value for calculation of next income - Defect#1992
    #                             Else
    #                                             ld_budget_month = lds_mult_months.GetItemDate(1, 'bwiz_run_month')
    #                                             of_client_sd_exp(ld_first_month)
    #                                             ldc_child_care = ldc_child_care + istr_client_exp.child_care

    #                             End if

    #             End if

    #             //Write the client records to the datastore

    #             //Insert a row at the end of the DataStore when all the income records for the client have been read
    #             ll_NewRow = in_ds_6.InsertRow(0)
    #             //Set the fields to be written to the datastore
    #             in_ds_6.SetItem(ll_NewRow, "bwiz_run_id", idb_run_id)
    #             in_ds_6.SetItem(ll_NewRow, "bwiz_mo_id", idb_month_id)
    #             in_ds_6.SetItem(ll_NewRow, "bmember_id", ldb_member_id)
    #             in_ds_6.SetItem(ll_NewRow, "tot_earned_inc", istr_income2.earned_cl)
    #             in_ds_6.SetItem(ll_NewRow, "tot_unearned_inc",istr_income2.unearned_cl)
    #             in_ds_6.SetItem(ll_NewRow, "tot_expenses", istr_client_exp.total_cl)
    #             in_ds_6.SetItem(ll_NewRow, "supl_sec_inc_amt", istr_income2.ssi_cl)
    #             in_ds_6.SetItem(ll_NewRow, "soc_sec_admin_amt", istr_income2.ssa_cl)
    #             in_ds_6.SetItem(ll_NewRow, "railroad_ret_amt", istr_income2.rr_cl)
    #             in_ds_6.SetItem(ll_NewRow, "vet_asst_amt", istr_income2.va_cl)
    #             in_ds_6.SetItem(ll_NewRow, "other_unearned_inc", istr_income2.other_cl)

    #             in_ds_6.SetItem(ll_NewRow, "bms_start_date", ld_bms_start)
    #             in_ds_6.SetItem(ll_NewRow, "bms_stop_date", ld_bms_stop)

    #             //J Kelch 3/15/00
    #             If istr_income2.earned_cl <> 0 then
    # //                        in_ds_6.SetItem(ll_NewRow, "earned_inc_deduct", 90 * ll_num_months)         // j kelch 11/9/99 //PC#65990 ELGutierez - comment out for changed calculations
    #                             in_ds_6.SetItem(ll_NewRow, "earned_inc_deduct", ldc_total_inc_ded_per_client)       //PC#65990 ELGutierez - changed value set to inc deduction.
    #             End if

    #             ldc_total_inc_ded_per_client = 0 //PC#65990 ELGutierez - Reset the value for the next client.

    #             // Set child_care_deduct to 0 because it is now being set in the of_bu_fm_net_income due to defect #891
    #             // that says the total child care deduct should be placed with the adult with the most earned income not with the child.
    #             in_ds_6.SetItem(ll_NewRow, "child_care_deduct",  0) // j kelch 11/9/99  // j devitto 12/9/99

    #             li_return = gnv_data_access_service.update_service(in_ds_6, in_ds_6, "Bcsu_u",lstr_pass)

    #             istr_income2.earned_cl = 0
    #             istr_income2.unearned_cl = 0
    #             istr_income2.ssi_cl =   0
    #             istr_income2.ssa_cl =   0
    #             istr_income2.rr_cl =    0
    #             istr_income2.va_cl    = 0
    #             istr_income2.other_cl = 0
    #             istr_client_exp.total_cl = 0
    #             ldc_child_care = 0

    #             ii_client_rows ++

    #             //Reset Earned Income Deduction Array for calculation of next client - PC#65990 ELGutierez
    #             li_inc_ded_cnt = UpperBound(ldc_earned_inc_deduct[])
    #             li_ded_cnt = 0
    #             DO WHILE  li_inc_ded_cnt > li_ded_cnt
    #                             li_ded_cnt++
    #                             ldc_earned_inc_deduct[li_ded_cnt] = 0
    #             LOOP

    # Loop

    # Choose Case ii_service_program
    #             Case 27, 57, 67, 77, 87, 97 //J Kelch 2/2/00 Moved 97 to here - 3/15/00 Took out 25
    #                             ldc_net_income = this.of_bu_fm_net_income()
    #             Case 17, 37, 47
    # //                        ldc_net_income = this.of_bu_am_net_income() //PCR#66133 - comment out, call the function for spend down..
    #                             ldc_net_income = this.of_bu_am_sd_net_income() //PCR#66133
    # End Choose

    # id_month = ld_budget_month
    # ii_bu_size = ll_bu_size + ll_num_unborn

    # ls_result = of_medicaid_stds(ldc_net_income)

    # IF Isnull(is_cat_elig_ind) OR is_cat_elig_ind = "" THEN
    #             is_cat_elig_ind = "N" //default to N if there's no income  - 7.03C Build2
    # END IF

    # //PCR#66583 - Update Category Eligibility Indicator
    # //PCR 71132 Anand Kotian 9.00A
    # // retain_ind does not need to be updated hence adding parameter 'NOTREQ'
    # // if it requires to be updated then pass the valid value for retain_ind
    # // i.e. 'R' to retain and "" not to retain
    # of_update_cat_elig_in(idb_run_id, idb_month_id, is_cat_elig_ind,'NOTREQ')
    # IF is_cat_elig_ind = "N" THEN
    #             Messagebox("Transaction Warning", "Not Eligible for Spend Down - Should be processed as Exceptionally Needy.", EXCLAMATION!)
    # END IF

    # //PCR#67289 - Clear the array values.
    # idc_fm_cs_deduction_excess[] = ldc_fm_cs_deduction_excess[]

    # Destroy lds_mult_months
    # Destroy in_ds_5
    # Destroy in_ds_6

    # //***********************************************************************
    # //*  Release  Date     Task         Author                              *
    # //*  Description                                                        *
    # //***********************************************************************
    # //*  2.000    07/27/99 ANSWER                                                Jennifer Kelch                      *
    # //*  Function allows multiple months to be totaled together for spend   *
    # //*  down and transitional Medicaid service programs.                   *
    # //***********************************************************************
    # //*  3.000           08/18/99 ANSWER       Jennifer Kelch                                                                              *
    # //*  Made changes to correct customer defect #200.  Family Medicaid     *
    # //*  doesn't count the first $50 of child support income for a budget   *
    # //*  unit.                                                                                                                                                *
    # //***********************************************************************
    # //*  3.005           10/26/99 ANSWER                                         Jennifer Kelch                                                                                                                   *
    # //*  Added code to add a row to the t_bmem_summary table for inactive-  *
    # //*  closed members.                                                                                                                                                                                                                                                                                 *
    # //***********************************************************************
    # //*  3.006    10/29/99 ANSWER                                                Jennifer Kelch                                                                                                                   *
    # //*  Number of unborn was not calculating for Pregnant Woman Spend Down.*
    # //*  Moved call of of_sobra_medicaid so that it will have the arguements*
    # //*  it needs to retrieve a datastore.                                                                                                                                                                                   *
    # //***********************************************************************
    # //*  3.007    11/09/99 ANSWER                                                Jennifer Kelch                                                                                                                   *
    # //*  Added code to set earned income and child care deductions for the  *

    # //*  t_bmem_summary table.  Deductions have to be calculated at the                              *
    # //*  client and budget unit levels to satisfy mainframe overnight edits *
    # //***********************************************************************
    # //*  3.008    11/16/99 ANSWER                                                Jennifer Kelch                                                                                                      *
    # //*  Took out code to generate an id for b_details_id column of the                     *
    # //*  t_b_mem_details table.  This value should start with 1 for each                     *
    # //*  member.                                                                                                                                                                                                                                                                                                                 *
    # //***********************************************************************
    # //*  3.009    12/9/99 ANSWER                                  Jennifer DeVitto                                                                                                               *
    # //*  Set child care deduct to 0 at the client level, Child care deduct        *
    # //*  will be set in of_bu_fm_net_income as the entire amount needs                                *
    # //*  to be set to the member with the most earned income.Defect #891                           *
    # //***********************************************************************
    # //*  3.011           01/10/00 ANSWER                                         Jennifer Kelch                                                                                                                   *
    # //*  For Farm Loss to count correctly for Food Stamps, an income record *
    # //*  of Self-Employed Farm/Ranch will be created with a negative amount.*
    # //*  The negative amount shouldn't be counted for any other service                                 *
    # //*  program.  Added code to set a negative amount to zero.                                                                  *
    # //***********************************************************************
    # //*  3.011    01/20/00 ANSWER                                                Jennifer Kelch                                                                                                                   *
    # //*  Added code to set the calculation method and income source fields           *
    # //*  when updating t_b_mem_details.              Enhancement 1042.                                                                                       *
    # //***********************************************************************
    # //*  3.011    01/24/00 ANSWER                                                Jennifer Kelch                                                                                                                   *
    # //*  Added code to check amount of earned income.  If amount is less               *
    # //*  than the full earned income deduction amount, then the deduction           *
    # //*  should be equal to the total earned income.                                                                                                                           *
    # //***********************************************************************
    # //*  3.014    02/16/00 ANSWER                                                Nebinger                                                                                                                                                             *
    # //*  Added code to bring forward medicaid begin/end dates.                                                                  *
    # //***********************************************************************
    # //*  3.015           03/15/00 ANSWER                                         Jennifer Kelch                                                                                                                   *
    # //*  Took category 25 out of most of processing.  This service program                *
    # //*  will be handled with a separate function.                                                                                                                                 *
    # //***********************************************************************
    # //*  4.000           4/26/00 ANSWER                                           Jennifer DeVitto                                                                                                               *
    # //*  "SV" income type should be bucketed with SSA income not other                                *
    # //*  unearned, so added "SV" to the case statement that totals SSA      *
    # //*  income (for the bu and for the client).  Defect #1512.             *
    # //***********************************************************************
    # //*  4.002           05/04/00 ANSWER                                         Jennifer Kelch                                                                                                                   *
    # //*  Took out reference to of_fm_sd_net_income.  All functionality had           *
    # //*  been removed from this function, so it is being deleted.                                                   *
    # //***********************************************************************
    # //*  4.003    06/06/00 ANSWER                                                Jennifer Kelch                                                                                                                   *
    # //*  Added code to call the new of_client_sd_exp function instead of                *
    # //*  calling of_client_exp.  Also added code to set the expense values                *
    # //*  for the datastores.              Enhancement 1113                                                                                                                                                         *
    # //***********************************************************************
    # //*  4.005    07/13/00 ANSWER                                                Jennifer Kelch                                                                                                                   *
    # //*  Added code to set structure values to be used by the resource                     *
    # //*  calculations and total the income types that are supposed to be                   *
    # //*  counted as resources.  Also took out unnecessary RowCount                                         *
    # //*  functions.  Enhancement 1077                                                                                                                                                                                                       *
    # //***********************************************************************
    # //*  5.002           01/22/01 ANSWER                                         Evangeline Gutierez                                                                                       *
    # //*  Defect #1923 - Added codes to get the valid month of income                                       *
    # //*  for spenddown to be shown in the final budget.                                                                                                   *
    # //***********************************************************************
    # //*  5.002    01/22/01 ANSWER                                                Evangeline Gutierez                                                                                       *
    # //*  Defect #1992 - Added and change codes to get the right calculation *
    # //*  for the total fm deduction.                                                                                                                                                                                                              *
    # //***********************************************************************
    # //*  6.02A          03/27/01 ANSWER                                         Evangeline Gutierez                                                                                       *
    # //*  PC#65468 - Initialized instance value of dob to determine age      *
    # //***********************************************************************
    # //*  6.03A    06/13/01 ANSWER                                               Evangeline Gutierez                                                                                       *
    # //*  PC#65990 - Modify setting of values to Income Deduction. It should *
    # //*                                                       deducted to months with earned income.                                                                                          *
    # //***********************************************************************
    # //*  7.000    09/21/01 ANSWER                                                Evangeline Gutierez                                                                                       *
    # //*  PCR#66133 - General exclusion of $20 should be counted to number of*
    # //*                                                        months with income, the defect is multiplying $20 to    *
    # //*                                                        total number of months ran in the budget.                                                                        *
    # //***********************************************************************
    # //*  7.000    10/09/01 ANSWER                                                Evangeline Gutierez                                                                                       *
    # //*  PCR#66133 - Created new function in calculating the deduction for  *
    # //*                                                        spend down..calculation should get the sum of income               *
    # //*                                                        for each month first and then based it to 20 exclusion *
    # //***********************************************************************
    # //*  7.002    02/13/2002 ANSWER                           Aurora Godoy                                                                                                                   *
    # //*  PCR 66663                                                                                                                                                                                                                                                                                                                               *
    # //*  Added a case for 75 (SSI Income Type)..                                                                                                                                                    *
    # //*  The instance variable istr_income2.ssi holds the total for SSI                           *
    # //*  income type.  This will then be sent to WASM & WAIV interfaces                  *
    # //*  (SSI field).  Before this value is being sent to OTher Unearned        *
    # //*  Income field.  This is applicable for AL/SSI AL only.                                                                                *
    # //***********************************************************************
    # //*  7.003         ANSWER                              01/31/02                                              Anand Kotian                                                                                     *
    # //*  Update Audit Trail Data this function also calls a function which  *
    # //*  generates system generated Ids for Audit Trail PCR 65267           *
    # //***********************************************************************
    # //*  7.03C         ANSWER                              04/15/02                                              Evangeline Gutierez                                                                       *
    # //*  PCR#67204 - Multiply 50 deduction to total number of months with             *
    # //*                                                        valid income.                                                                                                                                                                                                                   *
    # //***********************************************************************
    # //*  7.03C-Pack2           ANSWER                              04/15/02                                              Evangeline Gutierez                                       *
    # //*  PCR#66583 - Should not be eligible for Spend Down if there's no                   *
    # //*                                                        income build for the case.                                                                                                                                                          *
    # //***********************************************************************
    # //*  7.004                                         ANSWER                              06/13/02                                              Evangeline Gutierez                                       *
    # //*  PCR#67289 - $50 CS Deduction should calculate be spread out to each*
    # //*                                                        member for each month. If Income is less than $50 ded,             *
    # //*                                                        CS Deduction will be equal to the income, the excess CS*
    # //*                                                        deduction will be applied to the next member. IF Incme *
    # //*                                                        is equal or greater than $50, then CS Deduction will be*
    # //*                                                        $50, there will be no deduction to be applied on the     *
    # //*                                                        next member since $50 Deduction is accumulated by the            *
    # //*                              first meember.                                                                                                                                                                                                                         *
    # //***********************************************************************
    # //* 7.05D                                         ANSWER                              10/18/02                                              Evangeline Gutierez                                       *
    # //* PCR#68345              - Initialized the the value of idc_client_monthly_net_income
    # //*                                                        to zero.                                                                                                                                                                                                                                                              *
    # //*                                                        Include Deduction of the $50 Child Support.            *
    # //***********************************************************************
    # //* 7.05DPk2                  ANSWER                              10/22/02                                              Evangeline Gutierez                                       *
    # //* PCR#68345              - Expansion, Get the bu size counted for budget eligibility.*
    # //***********************************************************************
    # //* 9.07B                          ANSWER                              03/08/2007                                         Evangeline Gutierez                                       *
    # //* PCR#73830 - SpendDown Single Medicaid is receiving a Deficit/Excess *
    # //*                             Amount Invalid because of sending incorrect net countable*
    # //*             income due to wrong calculation using Irregular Frequency*
    # //***********************************************************************



    end


    def self.valid_income_for_bdgtcalc(ai_rule_id, as_income_type)
        #             Integer li_row
        # DataStore lds_rule_object_cdv
        lstr_pass = StrPass.new
        # lds_rule_object_cdv = Create ds_rule_object_cdv
        # lds_rule_object_cdv.SetTransObject(SQLCA)
        # lstr_pass.db[1] = ai_rule_id
        # lstr_pass.s[1] = as_income_type
        lds_rule_object_cdv = RuleDetail.get_rule_details_by_rule_id_and_codetable_id(ai_rule_id, as_income_type)
        #Rails.logger.debug("ai_rule_id = #{ai_rule_id}, as_income_type = #{as_income_type}")
        #Rails.logger.debug("-->lds_rule_object_cdv = #{lds_rule_object_cdv.inspect}")
        lds_rule_object_cdv = lds_rule_object_cdv.where("code_table_id =36")
        #Rails.logger.debug("lds_rule_object_cdv = #{lds_rule_object_cdv.inspect}")
        #Rails.logger.debug("lds_rule_object_cdv.size = #{lds_rule_object_cdv.size}")
        return lds_rule_object_cdv.size
    end



    def self.bu_rule_id(arg_srvc_pgm_id, arg_rule_category_id, arg_effective_beg_date, arg_effective_end_date)
        ldb_rule_id = 0
        #Rails.logger.debug("arg_srvc_pgm_id= #{arg_srvc_pgm_id}, arg_rule_category_id = #{arg_rule_category_id}, arg_effective_beg_date = #{arg_effective_beg_date}")
        ll_rows = ScreeningEngine.get_rule_id(arg_srvc_pgm_id, arg_rule_category_id, arg_effective_beg_date)
        #Rails.logger.debug("ll_rows = #{ll_rows.inspect}")
        ll_rows.each do |row|
            if (row.effective_begin_date <= arg_effective_beg_date && (arg_effective_end_date.present? && row.effective_end_date.present? && row.effective_end_date >= arg_effective_end_date) ||
                                                            !row.effective_end_date.present?)
                ldb_rule_id = row.rule_id
            end
        end
        #Rails.logger.debug("ldb_rule_id = #{ldb_rule_id}")
        return ldb_rule_id
    end

    def self.client_exp ()
    # String  ls_debt_exp_type, ls_frequency, ls_char_type
    # Decimal {2} ldc_rent_mort_amt, ldc_rent_mort_exp, ldc_realestate_amt, ldc_realestate_exp, Ldc_home_insr_amt, Ldc_home_insr_exp
    # Decimal {2} ldc_utilities_amt, ldc_utilities_exp, ldc_calc_amount
    # Decimal {0} ldc_child_care_max
    # //Decimal {0} ldc_fs_child_care_amt, ldc_fs_child_care_exp, Ldc_child_support_amt, Ldc_child_support_exp //PCR#73362 - No need to round off
    # Decimal {2} ldc_fs_child_care_amt, ldc_fs_child_care_exp, Ldc_child_support_amt, Ldc_child_support_exp
    # Decimal {2} ldc_med_child_care_amt, ldc_med_child_care_exp, Ldc_medical_exp, Ldc_ex_medical_amt
    # long      ll_RowsRetrieved, ll_age, ll_RowsRetrieved1, ll_char_rows
    # integer li_char_cnt, li_cnt
    # date     ld_beg_date, ld_end_date
    # string  ls_aged_disabled = "N"
    # double  ldb_expense_id, ldb_member_id
    # long      ll_newrow
    # n_ds   lds_fs_char, lds_b_mem_details, lds_reg_expenses, lds_med_expenses
    # str_pass lstr_pass, lstr_pass1, lstr_pass2, lstr_pass3
    # string  ls_calc_rule
    # string  ls_recalc_ind
    # long      ll_int_use_mths
    # long      ll_domain
    # //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    # integer li_return
    # //Anand Kotian Audit Trail PCR 65267 - End   - 01/31/02

    # //PCR 68182 Aurora Godoy 04/10/2003
    # String                 ls_member_status
    # Boolean                            lb_prorate_amount = True, lb_standard_utility = False
    # Decimal{2}  ldc_before_prorate_amt
    # //End PCR 68182

    # //11.10A - PCR#78405 (Standard Medical Deduction)
    # long ll_std_med_ded_found
    # Date ld_std_med_ded_beg, ld_std_med_ded_end
    # String ls_std_med_ded_valid = 'N'

    # is_check_child_support = 'Y'
    # is_last_exp_calc_flag = 'Y'
    # ldc_fs_child_care_exp = 0
    # ldc_med_child_care_exp = 0
    # Ldc_child_support_exp = 0
    # Ldc_medical_exp = 0
    # Ldc_rent_mort_exp = 0
    # ldc_realestate_exp = 0
    # ldc_home_insr_exp = 0
    # ldc_utilities_exp = 0
    # idc_child_care_exp = 0                              //J Kelch 11/12/99

    # //Create a new datastore to get store the checks for this expense records for a client
    # lds_reg_expenses = CREATE ds_client_exp_calc
    # lds_reg_expenses.SetTransObject(SQLCA)

    # lstr_pass.db[1] = idb_client_id                                               //Client_id is an instance variable

    # //PCR 68182    Aurora Godoy - Get the status of the client
    # ls_member_status = ids_client_info.GetItemString(ii_client_rows, "b_member_status")
    # //End PCR 68182

    # // Retrieve Records from the data store
    # ll_RowsRetrieved = gnv_data_access_service.retrieve(lds_reg_expenses, lds_reg_expenses, "Bcce_l", lstr_pass)
    #              SELECT t_debt_exp.type,
    #                t_debt_exp.debt_expid,
    #                t_debt_exp.frequency,
    #                t_debt_exp.effective_beg_date,
    #                t_debt_exp.effective_end_date,
    #                t_debt_exp.budget_recalc_ind,
    #                t_debt_exp.exp_calc_months,
    #                t_debt_exp.creditor_contact
    #         FROM t_client,
    #              t_client_debt_exp,
    #              t_debt_exp
    #         WHERE t_client_debt_exp.clientid = t_client.clientid
    #         AND  t_debt_exp.debt_expid = t_client_debt_exp.debt_expid
    #         AND  t_client.clientid = :rBcce_clientid;


    # If ll_RowsRetrieved > 0 then
    #             li_cnt = 1

    #             //Loop through the records to find any expenses that match the Case Statement
    #             Do While li_cnt <= ll_RowsRetrieved

    #                             //Aurora Godoy PCR 69259 05/30/2003
    #                             lb_prorate_amount = True

    #                             SetNull(ll_int_use_mths)
    #                             SetNull(is_exp_calc_method)
    #                             ldb_expense_id = lds_reg_expenses.GetItemNumber(li_cnt, "t_debt_exp_debt_expid")
    #                             ls_debt_exp_type = lds_reg_expenses.GetItemString(li_cnt, "debt_exp_type")
    #                             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                             istr_audit_trail.exp_source = lds_reg_expenses.GetItemString(li_cnt, "t_debt_exp_creditor_contact")
    #                             istr_audit_trail.exp_frequency = lds_reg_expenses.GetItemString(li_cnt, "t_debt_exp_frequency")
    #                             istr_audit_trail.exp_beg_date = lds_reg_expenses.GetItemdatetime(li_cnt, "debt_beg_date")
    #                             istr_audit_trail.exp_end_date = lds_reg_expenses.GetItemdatetime(li_cnt, "debt_end_date")
    #                             istr_audit_trail.exp_type     = ls_debt_exp_type
    #                             istr_audit_trail.exp_calc_months = lds_reg_expenses.GetItemnumber(li_cnt, "t_debt_exp_exp_calc_months")
    #                             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02

    #                             ll_age = of_age()  // JD - Created new function of_age()

    #                             Choose Case ls_debt_exp_type
    #                                             Case 'D2', 'C4', 'IC', 'MI', 'MH', 'RT', 'MT' , 'PH', 'GH', 'HQ', 'HC', 'IP', 'TP', 'TI', 'R2', 'HS','TL', 'LH', 'LP','RH', 'RS','UT', 'CO', 'EL', 'FU', 'GT', 'KS', 'NG', 'PP', 'PW', 'UI', 'WS','AD', 'TB', 'LS', 'US'
    #                                                             If ii_service_program <> 04 And ii_service_program <> 05 and ls_debt_exp_type <> 'D2' then
    #                                                                             li_cnt ++
    #                                                                             continue
    #                                                             Else
    #                                                                             ld_beg_date = Date(lds_reg_expenses.GetItemDateTime(li_cnt, "debt_beg_date")) // JD 3/15/00 combined 2 lines
    #                                                                             ld_end_date = Date(lds_reg_expenses.GetItemDateTime(li_cnt, "debt_end_date")) // JD 3/15/00 combined 2 lines

    #                                                                             ls_recalc_ind = lds_reg_expenses.GetItemString(li_cnt, "t_debt_exp_budget_recalc_ind")
    #                                                                             If (is_bu_cur_status = '02' OR is_bu_cur_status = '03') and ls_recalc_ind = 'N' and ii_service_program <> 25 Then //9.06E
    #                                                                                             ldc_calc_amount = of_calc_last_budget('E', ldb_expense_id, ld_beg_date, ld_end_date)
    #                                                                                             lb_prorate_amount = false  //PCR 68182 Aurora Godoy
    #                                                                             Else

    #                                                                                             ll_int_use_mths = lds_reg_expenses.GetItemNumber(li_cnt, "t_debt_exp_exp_calc_months")

    #                                                                                             // See if the expense is valid (budget run month must be greater than the expense begin date and less than the expense end date.)
    #                                                                                             // Changed code to call the new of_valid_effective_dates() function instead of below code
    #                                                                                             is_expense_valid = of_valid_effective_dates(ld_beg_date, ld_end_date)

    #                                                                                             If is_expense_valid = "Y" then                                                                   // IF the expense IS VALID for the budget month

    #                                                                                                             ls_frequency = lds_reg_expenses.GetItemString(li_cnt, "t_debt_exp_frequency")
    #                                                                                                             ls_calc_rule = of_det_exp_calc_rule(ldb_expense_id, ls_frequency, ll_int_use_mths, ld_beg_date, ld_end_date)

    #                                                                                                             Choose Case ls_calc_rule
    #                                                                                                                             Case "Actual"
    #                                                                                                                                             is_exp_calc_method = '04'
    #                                                                                                                                             ldc_calc_amount = of_exp_calc_actual('Y', ls_debt_exp_type, ldb_expense_id)
    #                                                                                                                             Case "Actual R"
    #                                                                                                                                             is_exp_calc_method = '05'
    #                                                                                                                                             ldc_calc_amount = of_exp_calc_actual('N', ls_debt_exp_type, ldb_expense_id)
    #                                                                                                                             Case "Actual Converted"
    #                                                                                                                                             is_exp_calc_method = '06'
    #                                                                                                                                             ldc_calc_amount = of_exp_calc_actual_conv('Y', ls_debt_exp_type, ls_frequency, ldb_expense_id)
    #                                                                                                                             Case "Actual Converted R"
    #                                                                                                                                             is_exp_calc_method = '07'
    #                                                                                                                                             ldc_calc_amount = of_exp_calc_actual_conv('N', ls_debt_exp_type, ls_frequency, ldb_expense_id)
    #                                                                                                                             Case "Intended Use"
    #                                                                                                                                             is_exp_calc_method = '03'
    #                                                                                                                                             ldc_calc_amount = of_exp_calc_intended_use(ldb_expense_id, ls_debt_exp_type, ll_int_use_mths)
    #                                                                                                                             Case "Converted"
    #                                                                                                                                             is_exp_calc_method = '02'
    #                                                                                                                                             ldc_calc_amount = of_exp_calc_converted(ls_frequency, ls_debt_exp_type, ldb_expense_id)
    #                                                                                                             End Choose
    #                                                                                             End if
    #                                                                             End if

    #                                                                             If is_expense_valid = 'Y' Then

    #                                                                                             CHOOSE CASE ls_debt_exp_type
    #                                                                                                             CASE  'D2' //(Dependent Care costs)
    #                                                                                                                             If ldc_calc_amount > 0 then

    #                                                                                                                                             If ii_service_program = 25 then
    #                                                                                                                                                             idc_child_care_exp = idc_child_care_exp + ldc_calc_amount //J kelch 11/12/99
    #                                                                                                                                             Else
    #                                                                                                                                                             //CHeck to see the age of the child
    #                                                                                                                                                             If ll_age < 2 then
    #                                                                                                                                                                             IF ii_service_program = 4 OR ii_service_program = 5 THEN //10.08C
    #                                                                                                                                                                                             ll_domain = 503                                                                                //Stds id for Max Dep Care < 2 (T_Program_STDS)
    #                                                                                                                                                                             ELSE
    #                                                                                                                                                                                             ll_domain = 118                                                                                //Stds id for Max Dep Care < 2 (T_Program_STDS)
    #                                                                                                                                                                             END IF
    #                                                                                                                                                             Else
    #                                                                                                                                                                             IF ii_service_program = 4 OR ii_service_program = 5 THEN      //10.08C
    #                                                                                                                                                                                             ll_domain = 504                                                                                //Stds id for Max Dep Care > 2 (T_Program_STDS)
    #                                                                                                                                                                             ELSE
    #                                                                                                                                                                                             ll_domain = 119                                                                                //Stds id for Max Dep Care > 2 (T_Program_STDS)
    #                                                                                                                                                                             END IF
    #                                                                                                                                                             End if

    #                                                                                                                                                             ldc_child_care_max = of_standards(ll_domain, id_month)

    #                                                                                                                                                             If ldc_child_care_max > 0 Then
    #                                                                                                                                                                             Choose Case ii_service_program
    #                                                                                                                                                                                             Case 04, 05
    #                                                                                                                                                                                                             //10.08A

    # //                                                                                                                                                                                                        IF id_month >= date("10/01/2008") THEN
    # //                                                                                                                                                                                                                                        ldc_fs_child_care_amt = Round(ldc_calc_amount, 0) //1018 PCR#73309
    # //                                                                                                                                                                                                                                        ldc_calc_amount = Round(ldc_calc_amount, 0) //1018 PCR#73309
    # //                                                                                                                                                                                                        ELSE
    #                                                                                                                                                                                                                             If ldc_child_care_max > ldc_calc_amount then
    #                                                                                                                                                                                                                                             ldc_fs_child_care_amt = Round(ldc_calc_amount, 0) //1018 PCR#73309
    #                                                                                                                                                                                                                                             ldc_calc_amount = Round(ldc_calc_amount, 0) //PCR#73362 - No need to round off //1018 PCR#73309
    #                                                                                                                                                                                                                             Else
    #                                                                                                                                                                                                                                             ldc_fs_child_care_amt = Round(ldc_child_care_max, 0) //1018 PCR#73309
    #                                                                                                                                                                                                                                             ldc_calc_amount = Round(ldc_child_care_max, 0) //1018 PCR#73309
    #                                                                                                                                                                                                                             End if
    # //                                                                                                                                                                                                        END IF

    #                                                                                                                                                                                                             //PCR 68182 Aurora Godoy
    #                                                                                                                                                                                                             If ii_service_program = 04 and ls_member_status = "02" and lb_prorate_amount Then
    # //                                                                                                                                                                                                                        ldc_calc_amount = Round(ldc_calc_amount, 0) //PCR#73362 - No need to round off
    #                                                                                                                                                                                                                             ldc_before_prorate_amt = ldc_calc_amount
    #                                                                                                                                                                                                                             ldc_calc_amount = of_prorate_expense(ldc_before_prorate_amt)
    #                                                                                                                                                                                                                             ldc_fs_child_care_amt = Round(ldc_calc_amount, 0) //1018 PCR#73309
    #                                                                                                                                                                                                             End If
    #                                                                                                                                                                                                             //End pcr 68182

    #                                                                                                                                                                                                             ldc_fs_child_care_exp = Round((ldc_fs_child_care_exp  +  ldc_fs_child_care_amt), 0) //1018 PCR#73309
    #                                                                                                                                                                                             Case Else
    #                                                                                                                                                                                                             If ldc_child_care_max > ldc_calc_amount then
    #                                                                                                                                                                                                                             ldc_med_child_care_amt = Round(ldc_calc_amount, 0) //1018 PCR#73309
    #                                                                                                                                                                                                             Else
    #                                                                                                                                                                                                                             ldc_med_child_care_amt = Round(ldc_child_care_max, 0) //1018 PCR#73309
    #                                                                                                                                                                                                                             ldc_calc_amount = Round(ldc_child_care_max, 0) //1018 PCR#73309
    #                                                                                                                                                                                                             End if
    #                                                                                                                                                                                                             ldc_med_child_care_exp = Round((ldc_med_child_care_exp  +  ldc_med_child_care_amt), 0) //1018 PCR#73309
    #                                                                                                                                                                             End Choose
    #                                                                                                                                                             Else
    #                                                                                                                                                                             MessageBox(gnv_app.iapp_object.DisplayName,"The standards table does not contain an amount for the child care < age 2 maximum.")
    #                                                                                                                                                                             ldc_child_care_max = 0
    #                                                                                                                                                             End if

    #                                                                                                                                             End if
    #                                                                                                                             End if

    #                                                                                                             CASE Else

    #                                                                                                                             If ii_service_program = 04 Or ii_service_program = 05 Then

    #                                                                                                                             Else
    #                                                                                                                                             is_last_exp_calc_flag = 'Y'
    #                                                                                                                             End if
    #                                                                                             End Choose
    #                                                                             End if
    #                                                                             If is_expense_valid = 'Y' Then

    #                                                                                             If ii_service_program <> 25 Then
    #                                                                                                             If is_sobra_flag <> 'B' Then
    #                                                                                                                             //Used for ds_t_b_mem_details table
    #                                                                                                                             lds_b_mem_details = Create ds_t_b_mem_details
    #                                                                                                                             lds_b_mem_details.SetTransObject(SQLCA)

    #                                                                                                                             //Get the Budget Member ID for ids_client_info (clientstatus)
    #                                                                                                                             ldb_member_id = ids_client_info.GetItemNumber(ii_client_rows, "bmember_id")

    #                                                                                                                             //            Insert a row at the end of the DataStore
    #                                                                                                                             ll_NewRow = lds_b_mem_details.InsertRow(0)

    #                                                                                                                             //            Set the fields to be written to the datastore
    #                                                                                                                             lds_b_mem_details.SetItem(ll_NewRow, "bwiz_run_id", idb_run_id)
    #                                                                                                                             lds_b_mem_details.SetItem(ll_NewRow, "bwiz_mo_id", idb_month_id)
    #                                                                                                                             lds_b_mem_details.SetItem(ll_NewRow, "bmember_id", ldb_member_id)
    #                                                                                                                             lds_b_mem_details.SetItem(ll_NewRow, "bdm_row_indicator", 'E')
    #                                                                                                                             lds_b_mem_details.SetItem(ll_NewRow, "item_type", ls_debt_exp_type)
    #                             //                                                                                            lds_b_mem_details.SetItem(ll_NewRow, "item_source", )
    #                                                                                                                             lds_b_mem_details.SetItem(ll_newRow, "dollar_amount", ldc_calc_amount)
    #                                                                                                                             lds_b_mem_details.SetItem(ll_newRow, "calc_method_code", is_exp_calc_method)
    #                                                                                                                             lds_b_mem_details.SetItem(ll_newRow, "b_details_id", idb_b_details_id)
    #                                                                                                                             lds_b_mem_details.SetItem(ll_newRow, "last_calc_month", id_month)
    #                                                                                                                             lds_b_mem_details.SetItem(ll_newRow, "lastcalc_incexp_id", ldb_expense_id)
    #                                                                                                                             //Anand Kotian Audit Trail PCR 65267 - Start 01/31/02
    #                                                                                                                             of_update_audit_trail_data('E',idb_b_details_id,ldb_member_id)
    #                                                                                                                             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
    #                                                                                                                             idb_b_details_id ++

    #                                                                                                                             If idb_b_details_id > idb_max_b_details_id then
    #                                                                                                                                             idb_max_b_details_id = idb_b_details_id
    #                                                                                                                             End if

    #                                                                                                                             gnv_data_access_service.Update_Service(lds_b_mem_details, lds_b_mem_details, "Bcmd_u", lstr_pass)
    #                                                                                                                             //Anand Kotian Audit Trail PCR 65267 - Start - 01/31/02
    #                                                                                                                             li_return = gnv_data_access_service.update_service(ids_audit_trail_expense_details,ids_audit_trail_expense_details, "Ated_u",lstr_pass)
    #                                                                                                                             li_return = gnv_data_access_service.update_service(ids_audit_trail_expense_details_checks,ids_audit_trail_expense_details_checks, "Atec_u",lstr_pass)
    #                                                                                                                             li_return = gnv_data_access_service.update_service(ids_audit_trail_exp_shared_by,ids_audit_trail_exp_shared_by, "Atsb_u",lstr_pass)
    #                                                                                                                             ids_audit_trail_expense_details.reset()
    #                                                                                                                             ids_audit_trail_expense_details_checks.reset()
    #                                                                                                                             ids_audit_trail_exp_shared_by.reset()
    #                                                                                                                             //Anand Kotian Audit Trail PCR 65267 - End - 01/31/02
    #                                                                                                                             Destroy lds_b_mem_details
    #                                                                                                             End if
    #                                                                                             End if
    #                                                                             End if
    #                                                             End if
    #                             End Choose
    #                             li_cnt ++

    #             Loop
    # End if

    # Destroy lds_reg_expenses

    # //PCR#71734 - Vangie for 9.01B Pack2
    # ll_age = of_age()

    # //Following code calculates if a Food Stamp budget unit member is aged/disabled and, if
    # //they are, if they are eligible for a medical deduction.
    # Choose Case ii_service_program
    #             Case 04, 05

    #                             istr_client_exp.child_care =  istr_client_exp.child_care + ldc_fs_child_care_exp
    #             Case Else
    #                             istr_client_exp.child_care =  istr_client_exp.child_care + ldc_med_child_care_exp
    # End Choose

    # istr_client_exp.child_support = Round((istr_client_exp.child_support + Ldc_child_support_exp), 0) //1018 PCR#73309
    # istr_client_exp.rent_mortgage =  istr_client_exp.rent_mortgage + ldc_rent_mort_exp
    # istr_client_exp.realestate_tax =  istr_client_exp.realestate_tax + ldc_realestate_exp
    # istr_client_exp.home_insur =  istr_client_exp.home_insur + Ldc_home_insr_exp

    # //J Kelch 4/28/00 Added to ensure that utility standard amount is all that is counted if applicable.
    # If is_utility_code = "A" then
    #             istr_client_exp.utilities_exp =  istr_client_exp.utilities_exp + ldc_utilities_exp
    # End if

    # //PCR 68182
    # If ii_service_program = 04 and ls_member_status = "02" and lb_standard_utility Then
    #             is_utility_code = "A"
    # end if
    # //End PCR 68182

    # //11.10A - PCR#78405
    # IF is_med_code = 'A' THEN
    #             istr_client_exp.medical_exp =  Round((istr_client_exp.medical_exp + ldc_medical_exp), 0) //1018 PCR#73309
    # END IF

    # istr_client_exp.total_cl = istr_client_exp.total_cl + Round(ldc_child_support_exp,0) + ldc_rent_mort_exp + ldc_realestate_exp + ldc_home_insr_exp + Round(ldc_fs_child_care_exp,0) + Round(ldc_med_child_care_exp,0) + ldc_utilities_exp + Round(ldc_medical_exp,0) //1018
    # istr_client_exp.total = istr_client_exp.total + Round(ldc_child_support_exp, 0) + ldc_rent_mort_exp + ldc_realestate_exp + ldc_home_insr_exp + Round(ldc_fs_child_care_exp,0) + Round(ldc_med_child_care_exp,0) + ldc_utilities_exp + Round(ldc_medical_exp,0) //1018

    # If is_last_exp_calc_flag = 'N' Then
    #             MessageBox(gnv_app.iapp_object.DisplayName, "At least one expense record for the current client did not have a valid record stored with the previously " + &
    #                             "submitted budget run.  Please make sure all recalc indicators are set correctly and run this budget again.")
    # End if

    end

    def self.det_bdgt_cal_rule(service_prgm_id)
        #             long                       ll_return, ll_cur_row, ll_rows, ll_age
        # str_pass lstr_pass, lstr_pass1, lstr_pass2
        # string                 ls_bdgt_calrule, ls_retro = 'N'
        # string                 ls_not_paid
        # date                   ld_check_retro
        # string                 ls_frequency
        # n_ds                  lds_actual_income
        # date                   ld_income_end, ld_date
        # Integer             li_month, li_year
        ls_frequency = 0
        ld_income_end = 0
        ld_date = Date.today
        li_month = ld_date.month
        li_year = ld_date.year
        ld_date = Date.civil(li_year, li_month, 1).strftime("%m/%d/%Y")
        #Date(String(string(li_month)  + "/01/" + string(li_year) ))
        lds_actual_income = IncomeDetail.get_actual_income_details(@idb_income_id, @id_month.month, @id_month.year)
        # lstr_pass.db[1] = idb_income_id
        # lstr_pass.db[2] = Month(id_month)
        # lstr_pass.db[3] = Year(id_month)



        if lds_actual_income.size > 0
            lds_actual_income = lds_actual_income.where("check_type = 4388")
            if lds_actual_income.size > 0
                ls_not_paid = 'Y'
            else
                ls_not_paid = 'N'
            end
        else
            ls_not_paid = 'N'
        end
        count = 1
        @ids_countable_income.each do |income|
            if count == @ii_income_rows
                ls_frequency = income.frequency
                ld_income_end = income.effective_end_date
                break
            else
                count = count + 1
            end
        end

        ls_retro = check_retro_mth()
        if ls_retro == 'Y'
            if ls_frequency = 2321 || ls_frequency = 2319
                return "Converted"
            else
                return "Actual R"
            end
        else
            if ls_frequency == 2329
                return "Intended Use"
            else
                if (ld_income_end.present? && @id_month.present? && (ld_income_end.month == @id_month.month) && (ld_income_end.year == @id_month.year))
                    return "Actual"
                else
                    return "Converted"
                end
            end
        end
    end

    def self.det_ckga_amt(arg_income_detail_id)

ldb_member_id = 0

      count = 0
    @ids_client_info.each do |client_info|
        if count == @ii_client_rows
            ldb_member_id = client_info.member_sequence
            break
        else
            count = count + 1
        end
    end


        income_detail = IncomeDetail.find(arg_income_detail_id)
        if income_detail.present?
            ldc_ckga_income = income_detail.gross_amt
        end



    #===========================================================
                    # Audit Trail will be implemented later
    #===========================================================


    # lstr_pass1.db[1] = adc_inc_earned_id

    # //Retrieve the check amount for the current check
    lds_income_adj_reason =IncomeDetailAdjustReason.get_adjusted_income_detail_id(arg_income_detail_id)

    if lds_income_adj_reason.size  > 0
        lds_income_adj_reason.each do |income_adjustements|

        ids_audit_trail_income_adj_dt_tmp = AuditTrailIncAdj.new

        ids_audit_trail_income_adj_dt_tmp.run_id = @idb_run_id
        ids_audit_trail_income_adj_dt_tmp.month_sequence = @idb_month_id
        ids_audit_trail_income_adj_dt_tmp.member_sequence = ldb_member_id
        ids_audit_trail_income_adj_dt_tmp.adjusted_reason = income_adjustements.adjusted_reason
        ids_audit_trail_income_adj_dt_tmp.adjusted_amount = income_adjustements.adjusted_amount
        ids_audit_trail_income_adj_dt_tmp.adj_use_ind = 'N'
        ids_audit_trail_income_adj_dt_tmp.audit_trail_income_details_id = arg_income_detail_id
        @ids_audit_trail_income_adj_dt << ids_audit_trail_income_adj_dt_tmp
        end
     end

    # //Anand Kotian Audit Trail PCR 65267

    #===========================================================
                    # Audit Trail will be implemented later end
    #===========================================================


    # //Retrieve the adjustment records
    # //Retrieve Adjustment Utility portion of the rule to determine what reasons are VALID

        adjusment_utility_portion_results = IncomeDetailAdjustReason.get_adjustment_utility_portion(arg_income_detail_id, @rule_id)
        if adjusment_utility_portion_results.present?
            adjusment_utility_portion_results.each do |aup|

                            ldc_adj_amount = aup.adjusted_amount
                            ls_adj_reason =  aup.adjusted_reason
                            ls_resource_ind = aup.as_resource_ind
                            ls_income_frequency = @ids_countable_income.frequency
                            if @ids_countable_income.frequency == 2318 # 25 legacy
                                case ls_adj_reason
                                    when 4445 || 4443 || 4444
                                        #Apply adjustment - follow normal processing
                                    else
                                    ldc_adj_amount = 0
                                end
                            else
                                #Apply adjustment - follow normal processing
                            end
                            unless ldc_adj_amount.present?
                                ldc_adj_amount = 0
                            end
                           ldc_ckga_income = (ldc_ckga_income - ldc_adj_amount)
                           #Rails.logger.debug("ls_resource_ind = #{ls_resource_ind}")
                           if ls_resource_ind == 1
                                @istr_budget.str_months[@ii_bdgt_mth_rows].income_as_res = @istr_budget.str_months[@ii_bdgt_mth_rows].income_as_res + ldc_adj_amount
                                program_member_detail = ProgramMemberDetail.new
                                program_member_detail.run_id = @idb_run_id
                                program_member_detail.month_sequence = @idb_month_id
                                program_member_detail.member_sequence = ldb_member_id
                                program_member_detail.bdm_row_indicator = 'A'
                                program_member_detail.item_type = ls_adj_reason
                                program_member_detail.dollar_amount = ldc_adj_amount
                                program_member_detail.b_details_sequence = @idb_b_details_id
                                if @screening_only == false
                                    unless program_member_detail.save

                                    end
                                end
                                @idb_b_details_id = @idb_b_details_id.present? ? @idb_b_details_id : 0
                                @idb_b_details_id = @idb_b_details_id + 1
                                if @idb_b_details_id > @idb_max_b_details_id
                                    @idb_max_b_details_id = @idb_b_details_id
                                end

                            end
                            #  //Increment the line count by one
                            #    //Anand Kotian Audit Trail PCR 65267
                            @ids_audit_trail_income_adj_dt.each do |income_adj|
                            #  li_rowaudit = ids_audit_trail_income_adj_dt.rowcount()
                            #  for li_cntaudit = 1 to li_rowaudit
                              if ls_adj_reason == income_adj.adjsted_reason
                                 if ldc_adj_amount == income_adj.adjsted_amount
                                     if ldc_adj_amount != 0
                                        income_adj.adj_use_ind = 'Y'
                                     end
                                  end
                               end
                            end
                            # //Anand Kotian Audit Trail PCR 65267
              li_cnt = li_cnt + 1
            end
        end
        #Rails.logger.debug("det_ckga_amt.ldc_ckga_income = #{ldc_ckga_income}")
        return ldc_ckga_income
    end

    def self.check_condition(arg_counter_value, arg_rowsretrieved_value)
        if arg_rowsretrieved_value <= 0
            return true
        else
            return false
        end
    end

    def self.det_exp_calc_rule(adb_exp_id, as_frequency, as_no_months, ad_beg_date, ad_end_date)
    #             long                       ll_rows
    # str_pass lstr_pass
    # string                 ls_retro = 'N'
    # string                 ls_not_paid
    # n_ds                  lds_actual_exp

    # lds_actual_exp = Create ds_actual_expenses
    # lds_actual_exp.SetTransObject(SQLCA)

    # lstr_pass.db[1] = adb_exp_id
    # lstr_pass.db[2] = Month(id_month)
    # lstr_pass.db[3] = Year(id_month)

    # ll_rows = gnv_data_access_service.retrieve(lds_actual_exp, lds_actual_exp, "Acex_l", lstr_pass)
    #  SELECT debt_exp_detail_id,
    #                exp_due_date,
    #                expense_amount,
    #                exp_use_code,
    #                payment_method,
    #                payment_status,
    #                debt_expid
    #           FROM t_debt_exp_detail
    #          WHERE ( debt_expid          = :rAcex_debt_expid ) AND
    #                ( Month(exp_due_date) = :rAcex_month ) AND
    #                ( Year(exp_due_date)  = :rAcex_year );


    # If ll_rows > 0 then
    #             lds_actual_exp.SetFilter("payment_status = '35'")
    #             lds_actual_exp.Filter()
    #             If lds_actual_exp.RowCount() > 0 then
    #                             ls_not_paid = 'Y'
    #             Else
    #                             ls_not_paid = 'N'
    #             End if
    # Else
    #             ls_not_paid = 'N'
    # End if

    # Destroy lds_actual_exp

    # Choose Case ii_service_program
    #             Case 52, 63   //69  //PCR 69054 - Aurora Godoy

    #             Case Else

    #                             ls_retro = of_check_retro_mth()

    #                             Choose Case ii_service_program
    #                                             //PACE - ELGutierez - PCR#69962
    #                                             //Case 03,11,12,13,14,16,17,18,19,27,28,29,31,32,33,34,35,59,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,53,54,57,58,59,60,65,66,67,70,77,78,87,88,97//,91,92,96,97  //Adult Medicaid
    #                                             Case 7,8,9,10,03,11,12,13,14,15,16,17,18,19,27,28,29,31,32,33,34,35,59,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,53,54,57,58,59,60,65,66,67,70,77,78,87,88,97, 82, 83, 89, 90,79    //A Godoy PCR 66663 - Added Assisted Living/SSi Assisted Living //PCR#79352-AutismWaiver(89, 90)


    #                                             Case 20, 21, 84
    #                                                             //PCR#72489 - Added Service Program ID 84 for WorkPays
    #                                                             If as_frequency = 'IR' then
    #                                                                             Return "None"
    #                                                             ElseIf ls_retro = 'Y' then
    #                                                                                             // Defect 1910 Added by Anand Kotian 01/17/2001
    #                                                                                             //if not isnull(as_no_months) and as_no_months <> 0 then
    #                                                                                             //            return "Intended Use"
    #                                                                                             //            // Defect 1823 Added by Anand Kotian 01/17/2001
    #                                                                                             // Defect was closed but I Feel that it will popup
    #                                                                                             // If it popups up change the condition to if elseif
    #                                                                                             /* Marked for 6.00A Version by Anand Kotian 02/20/2001
    #                                                                                             if as_frequency = '5 ' or as_frequency = '5' or as_frequency = '30' then
    #                                                                                                             return "Converted"
    #                                                                                             else
    #                                                                                                             Return "Actual R"
    #                                                                                             end if
    #                                                                                                             Removed and added the above code Defect 1823 Anand Kotian on 01/22/01
    #                                                                                             */
    #                                                                                             Return "Actual R"
    #                                                             Else

    #                                                                             If Month(ad_end_date) = Month(id_month) and Year(ad_end_date) = Year(id_month) then
    #                                                                                             Return "Actual"
    #                                                                             Else
    #                                                                                             If Not IsNull(as_no_months) And as_no_months <> 0 Then
    #                                                                                                             Return "Intended Use"
    #                                                                                             Else
    #                                                                                                             Return "Converted"
    #                                                                                             End if
    #                                                                             End if
    #                                                             End if
    #                                             Case 25

    #                                             Case 01,26,51,56,62,69,76,80,81,86,91,92,96  //Family Medicaid categories  //PCR 68099 Aurora Godoy
    #                                             Case 04,05 // Foodstamps Categories
    #                                             Case 61


    #                                             Case Else
    #                                                             MessageBox(gnv_app.iapp_object.DisplayName, "Unable to determine Budget Calc. Rule due to incorrect service program.  Actual will be used.", INFORMATION!, OK!)
    #                                                             Return "Actual"
    #                             End Choose

    # End Choose
    end

    def self.last_submit_bdgt(arg_run_id, arg_month_id, arg_member_id)
        #             n_ds lds_bud_ueincome_detail
        # uo_audit_trail luo_audit_trail
        # str_pass lstr_pass, lstr_pass_submit, lstr_pass_reset
        lstr_pass = StrPass.new
        ll_ctr = 1
        # Long ll_row, , ll_inc_rows
        # string                                 ls_frequency, ls_check_type
        ldc_ckga_income = 0
        # double                              ldb_income_earned_id, ldb_details_id
        # n_ds                                  lds_aud_trl_inc_dt_interface
        # Integer
        li_num_records = 0
        ldc_ir_total = 0
        # Long ll_income_ctr
        # str_pass lstr_pass_bmem
        # String ls_row_indicator, ls_bmem_filter
        # n_ds lds_bmem_details
        # Long ll_bmem_row
        ls_crit_ind =""


        lstr_pass.db[1] = @idb_income_id
        lds_income_countable = IncomeDetail.get_countable_income(@idb_income_id)
        lds_aud_trl_inc_dt_interface =AuditTrailIncomeDetail.get_income_details_based_on_run_id(arg_run_id)
        if lds_aud_trl_inc_dt_interface.present?

               lds_aud_trl_inc_dt_interface.each do|audit_income_detail|
               lds_bmem_details = ProgramMemberDetail.get_member_details_by_run_id(arg_run_id, arg_month_id)
                count = 1
                @ids_countable_income.each do |income|
                    if count == @ii_income_rows
                        ls_crit_ind = income.criteria_a_ind


                        break
                    else
                        count = count + 1
                    end
                end

                if ls_crit_ind == '1'
                   lds_bud_ueincome_detail = ProgramMemberDetail.get_member_details_domain_code(arg_run_id,arg_month_id,arg_member_id,'I')
                   ls_row_indicator = "I"
                else
                    lds_bud_ueincome_detail = ProgramMemberDetail.get_member_details_domain_code(arg_run_id,arg_month_id,arg_member_id,'U')
                   ls_row_indicator = "U"
                end

                if lds_bud_ueincome_detail.present?

                   lds_bud_ueincome_detail.each do |ueincome_detail|
                   ldb_details_id   = ueincome_detail.b_details_sequence
                   if lds_bmem_details.size > 0
                       lds_bmem_details_temp = ProgramMemberDetail.get_member_details_by_run_id_and_more(arg_run_id, arg_month_id,arg_member_id,@idb_income_id,ls_row_indicator)
                   end
                   ll_bmem_row = lds_bmem_details_temp.count


                    if ldb_details_id == @ii_income_rows

                       if ll_bmem_row > 0


                                    #Audit Trail Master
                                    #@istr_audit_mstr = lstr_pass_reset
                                    @istr_audit_mstr = AuditTrailModule.get_audit_mstr(arg_run_id, arg_month_id, arg_member_id,ldb_details_id)
                                    if (@istr_audit_mstr[1].present? && @istr_audit_mstr[2].present? && @istr_audit_mstr[3].present? && @istr_audit_mstr[4].present?)
                                       #Audit Trail Income Detail
                                       #@istr_audit_inc_dtl = lstr_pass_reset

                                       @istr_audit_inc_dtl = AuditTrailModule.get_audit_inc_dtl(arg_run_id,arg_month_id,arg_member_id,ldb_details_id,@istr_audit_mstr[5],ll_ctr)
                                    end

                                    if @istr_audit_inc_dtl[12].present?
                                        if (@istr_audit_inc_dtl[12] != 4386 && @istr_audit_inc_dtl[12] != 4388)  # check_type 10 --> 4385, 20 --> 4386, 30 -->4387, 40--> 4388
                                           @istr_audit_trail.date_of_inc_exp  = @istr_audit_inc_dtl[10] # Date Received
                                           @istr_audit_trail.check_type       = @istr_audit_inc_dtl[12]  # Check Type
                                            @istr_audit_trail.gross_amount     = @istr_audit_inc_dtl[6] # Gross Amount
                                            @istr_audit_trail.adjusted_total   = @istr_audit_inc_dtl[7] # Adjusted_total
                                            @istr_audit_trail.net_amount       = @istr_audit_inc_dtl[8] # Net_amount
                                            ldb_income_earned_id = @istr_audit_inc_dtl[9] # Audit_det_id - income_earned_id
                                            create_audit_trail_data(@idb_income_id, ldb_income_earned_id, 'I', ll_ctr,ueincome_detail)
                                            if (@istr_audit_mstr[1].present?  && @istr_audit_inc_dtl[1].present? )
                                                ldc_ckga_income = det_ckga_amt_audit(arg_run_id, arg_month_id, arg_member_id, ldb_details_id, @istr_audit_mstr[5], @istr_audit_inc_dtl[9], @istr_audit_inc_dtl[6])
                                            end
                                            li_num_records = li_num_records + 1
                                            if ldc_ckga_income.present?
                                              ldc_ir_total = ldc_ir_total + ldc_ckga_income
                                            end
                                        end
                                    end
                        end
                    end
                end
                       ll_ctr = ll_ctr + 1
                end
            end
        end

        if li_num_records == 0
            return ldc_ir_total
        end

        if @istr_audit_mstr[13].present?
            ls_frequency = @istr_audit_mstr[13] #Frequency
        end

       # case ls_frequency
       #      when 2316                                                                                                                                                                                                                                                                          # Bi-weekly
       #          ldc_ga_income = (ldc_ga_income/li_num_records) * 2.167
       #      when 2320                                                                                                                                                                                                                                                                          # Weekly
       #          ldc_ga_income = (ldc_ga_income/li_num_records) * 4.334
       #      when 2321
       #          ldc_ga_income = (ldc_ga_income/li_num_records)/12
       #      when 2330                                                                                                                                                                                                                                                                          # Twice a Month
       #          ldc_ga_income = (ldc_ga_income/li_num_records) * 2
       #      when 2319                                                                                                                                                                                                                                                                          # Quarterly
       #          ldc_ga_income = (ldc_ga_income/li_num_records)/3
       #      when 2317                                                                                                                                                                                                                                                                          # Monthly
       #          ldc_ga_income = (ldc_ga_income/li_num_records)
       #  end

        return ldc_ir_total

    end

    def self.get_org_bu_size(adb_hh_id, adb_bu_id)
    #             Integer                 li_org_bu_size
    # n_ds                  lds_bud_totals
    # str_pass           lstr_pass
    # long                    ll_ret




    # lstr_pass.db[1] = adb_hh_id
    # lstr_pass.db[2] = adb_bu_id

    # lds_bud_totals = CREATE n_ds
    # lds_bud_totals.SetTransObject(SQLCA)
    # lds_bud_totals.DataObject = 'dw_budget_comp_sel_ex'

    # ll_ret = gnv_data_access_service.retrieve(lds_bud_totals, lds_bud_totals, "Oibx_l", lstr_pass)
    # SELECT t_household_member.householdid,
    #                t_person_demograph.first_name,
    #                t_person_demograph.last_name,
    #                t_household_member.clientid,
    #                t_budget_unit_comp.relationship,
    #                t_budget_unit_comp.budget_unit_id,
    #                t_budget_unit_comp.user_id,
    #                t_budget_unit_comp.last_update,
    #                t_budget_unit_comp.clientid,
    #                t_budget_unit_comp.budget_unit_compid,
    #                t_budget_unit_comp.mrt,
    #                t_budget_unit_comp.member_suffix,
    #                t_person_demograph.suffix,
    #                t_person_demograph.middle_name,
    #                t_person_demograph.sex,
    #                t_person_biograph.ssn,
    #                t_person_demograph.ethnicity,
    #                t_person_biograph.dob,
    #                t_budget_unit_comp.curr_bmem_status,
    #                t_budget_unit_comp.otc_bmem_status ,
    #                t_budget_unit_comp.application_flag
    #         FROM t_budget_unit_comp,
    #                t_household_member,
    #                t_person_demograph,
    #                t_person_biograph
    #         WHERE ( t_household_member.clientid = t_person_demograph.clientid )
    #         AND  ( t_person_demograph.clientid = t_budget_unit_comp.clientid )
    #         AND  ( t_household_member.clientid = t_budget_unit_comp.clientid )
    #         AND  ( t_person_biograph.clientid = t_person_demograph.clientid )
    #         AND  ( t_household_member.householdid = :rOibx_householdid )
    #         AND  ( t_budget_unit_comp.budget_unit_id = :rOibx_budget_unit_id )
    #         ORDER BY t_budget_unit_comp.relationship ASC;


    # IF ll_ret > 0 THEN
    #             lds_bud_totals.SetFilter("")
    #             lds_bud_totals.Filter()
    #             lds_bud_totals.SetFilter("bmem_status = '01'")
    #             lds_bud_totals.Filter()
    #             li_org_bu_size = lds_bud_totals.RowCount()
    # END IF

    # DESTROY lds_bud_totals

    # RETURN li_org_bu_size

    end

    def self.prorate_busize(adb_run_id, adb_month_id, al_active_busize)
    #             n_ds lds_bu_total
    # Long ll_ret, ll_prorate_busize
    # String ls_filter

    # lds_bu_total = CREATE n_ds
    # lds_bu_total.SetTransObject(SQLCA)
    # lds_bu_total.DataObject = 'dw_client_info'

    # str_pass lstr_pass
    # lstr_pass.db[1] = adb_run_id
    # lstr_pass.db[2] = adb_month_id

    # ll_ret = gnv_data_access_service.retrieve(lds_bu_total, lds_bu_total, "Bccs_l", lstr_pass)
    #  SELECT t_budget_member.client_id,
    #                t_budget_member.b_member_status,
    #                t_budget_member.bmember_id,
    #                t_person_biograph.dob
    #         FROM t_budget_member,
    #              t_person_biograph
    #         WHERE t_person_biograph.clientid = t_budget_member.client_id
    #         AND   t_budget_member.bwiz_run_id = :rBccs_bwiz_run_id
    #         AND   t_budget_member.bwiz_mo_id = :rBccs_bwiz_mo_id;


    # IF ll_ret > 0 THEN
    #             lds_bu_total.SetFilter("")
    #             lds_bu_total.Filter()
    #             ls_filter =  "b_member_status in ('01', '02', '03')"
    #             lds_bu_total.SetFilter(ls_filter)
    #             lds_bu_total.Filter()
    #             ll_prorate_busize =         lds_bu_total.RowCount()

    #             lds_bu_total.SetFilter("")
    #             lds_bu_total.Filter()
    #             ls_filter =  "b_member_status = '01'"
    #             lds_bu_total.SetFilter(ls_filter)
    #             lds_bu_total.Filter()
    #             al_active_busize = lds_bu_total.RowCount()
    # END IF

    # DESTROY lds_bu_total

    # RETURN ll_prorate_busize

    end
    def self.det_ckga_amt_audit(arg_run_id, arg_month_id, arg_member_id, arg_details_id, arg_audit_id, arg_audit_det_id, arg_gross_amount)
    # //Audit Trail Income Adjustment

    ldc_inc_adj_amt = arg_gross_amount

    lds_audit_inc_adj = AuditTrailIncAdj.get_audit_income_adjust_details(arg_run_id,arg_month_id,arg_member_id,arg_details_id,arg_audit_id,arg_audit_det_id)

     if lds_audit_inc_adj.size  > 0
        lds_audit_inc_adj.each do |income_adjustements|
        ids_audit_trail_income_adj_dt_tmp = AuditTrailIncAdj.new
        ids_audit_trail_income_adj_dt_tmp.run_id = @idb_run_id
        ids_audit_trail_income_adj_dt_tmp.month_sequence = @idb_month_id
        ids_audit_trail_income_adj_dt_tmp.member_sequence = ldb_member_id
        ids_audit_trail_income_adj_dt_tmp.adjusted_reason = income_adjustements.adjusted_reason
        ids_audit_trail_income_adj_dt_tmp.adjusted_amount = income_adjustements.adjusted_amount
        ids_audit_trail_income_adj_dt_tmp.adj_use_ind = income_adjustements.adj_use_ind
        ids_audit_trail_income_adj_dt_tmp.audit_trail_income_details_id = arg_audit_det_id
        @ids_audit_trail_income_adj_dt << ids_audit_trail_income_adj_dt_tmp

        if income_adjustements.adj_use_ind == "Y"
           ldc_inc_adj_amt = ldc_inc_adj_amt - income_adjustements.adjusted_amount
        end

        end
     end
     return ldc_inc_adj_amt
    end

    def self.recalc_benefit_for_tea_prgsv_sanction(astr_pass)
    #             //************************************************************************
    # //*  10.01A        08/06/2007 ANSWER                    Evangeline L. Gutierez
    # //*
    # //*  PCR#74057             - Tea Progressive Sanction
    # //*  Recalculate Tea Benefit based on the new saction applied.
    # //*  This function is being called when invoking non-visual interface upon adding TEA Progressive Sanction.
    # //*  This is created based on function of_determine_benefit which is being called when running budget.
    # //*
    # //*  Parameters:
    # //*  astr_pass.db[1]                    = Budget Unit ID
    # //*  astr_pass.db[2]                    = Service Program Id
    # //*  astr_pass.db[3]                    = Client ID
    # //*  astr_pass.dates[1]              = Sanction Month
    # //*  astr_pass.s[1]                       = Sanction Indicator
    # //*  astr_pass.s[2]                       = Release Payment
    # //*  astr_pass.s[3]                       = Sanction Serve Indicator //Added on 10.01D Package
    # //*  astr_pass.d[1]                       = Sanction ID      //Added on 10.01D Package
    # //*  astr_pass.d[2]                       = Sanction Hist ID             //Added on 10.01D Package
    # //*
    # //*  Return Values:
    # //*  lstr_pass.db[1] = temp_grant_amt (New Benefit Amount)
    # //*  lstr_pass.db[2] = temp_reduction_amt (New Reduction Amount)
    # //*  lstr_pass.db[3] = temp_retro_amt (Retro Amount)
    # //*  lstr_pass.db[4] = New Run ID
    # //*  lstr_pass.db[5] = New Month ID
    # //*  lstr_pass.dt[1]  = temp_start_pmt_date
    # //*  lstr_pass.dt[2]  = temp_retro_begin_date
    # //*  lstr_pass.dt[3]  = temp_retro_end_date
    # //*  lstr_pass.s[1]          = Sanction Indicator
    # //*
    # //* Note: Process Retro when Release Payment Indicator = Y for Suspend1, Suspend2 and Non-Porgressive Sanction
    # //************************************************************************

    # str_pass lstr_pass, lstr_return, lstr_lastbdgt
    # Double ldb_sanction_percent
    # n_cst_budget_unit lnv_budget
    # n_cst_datetime lnv_datetime
    # DateTime ldt_start_payment, ldt_retro_begin, ldt_retro_end

    # String                                 ls_sanction
    # Date                                   ldt_cutoff_date
    # str_pass                           lstr_sanction_nonprogtype_pass, lstr_sanction_nonprogtype_return, lstr_pass_retro, lstr_tea_sanction_retro_update, lstr_lastbdgt_ret

    # Date                                   ldt_start
    # Double                              ldb_bu_id, ldb_sp_id, ldb_clientid,  ldb_sanction_id, ldb_sanction_hist_id
    # String                                 ls_sanction_ind, ls_release_ind, ls_serve_ind
    # Date                                   ld_sanction_month
    # Double                              ldb_run_id, ldb_month_id
    # str_pass                           lstr_tea_prgsv_sanction_pass, lstr_tea_prgsv_sanction
    # Boolean                            lb_retro = FALSE
    # Date                                   ld_run_month
    # str_pass                           lstr_parameter


    # //PCR#74461
    # Long ll_ctr_retro, ll_retro_months
    # DateTime ldt_retro_month

    # //*************** Initialized all local variables to what has been passed ******************//
    # //10.01D //09-05-07
    # ldb_bu_id                                                        = astr_pass.db[1]
    # ldb_sp_id                                                        = astr_pass.db[2]
    # ldb_clientid                                                     = astr_pass.db[3]
    # ls_sanction_ind                             = astr_pass.s[1]
    # ls_release_ind                                               = astr_pass.s[2]
    # ls_serve_ind                                  = astr_pass.s[3]
    # ld_sanction_month     = astr_pass.dates[1]
    # ldb_sanction_id                            = astr_pass.d[1]
    # ldb_sanction_hist_id = astr_pass.d[2]

    # //**************** Run ID and Month ID of Last Successfully Submitted Budget **************** //

    # lnv_budget = CREATE n_cst_budget_unit
    # lstr_lastbdgt = lnv_budget.of_get_last_bdgt_successfully_submitted(astr_pass.db[1])
    # DESTROY lnv_budget

    # IF Upperbound(lstr_lastbdgt.db[]) < 2 THEN
    #             MessageBox(gnv_app.iapp_object.DisplayName, "No record found on budget detail.", INFORMATION!, OK!)
    # END IF

    # ldb_run_id                      = lstr_lastbdgt.db[2]
    # ldb_month_id               = lstr_lastbdgt.db[3]

    # //10.01D //09-05-07
    # //************************Determine Retro***********************************//
    # CHOOSE CASE ls_sanction_ind
    #             CASE 'E', 'T', 'F'
    #             CASE ELSE
    #                             IF ls_release_ind = 'Y' THEN //Release Ind = 'Y'
    #                                             lb_retro = TRUE
    #                             END IF
    # END CHOOSE

    # //*********** Verify Run Month of the last submitted budget when processing retro to identify if there is applied sanction *******//
    # n_ds  lds_bwiz
    # str_pass lstr_bwiz_pass
    # Integer li_bwiz_ret
    # String ls_filter

    # IF lb_retro = TRUE THEN
    #             lds_bwiz = CREATE n_ds
    #             lds_bwiz.SetTransObject(SQLCA)
    #             lds_bwiz.DataObject = 'dw_bud_month'
    #             lstr_bwiz_pass.db[1] = ldb_bu_id
    #             li_bwiz_ret = gnv_data_access_service.retrieve(lds_bwiz, lds_bwiz, "Bump_l", lstr_bwiz_pass)
    #             IF li_bwiz_ret > 0 THEN
    #                             lds_bwiz.SetFilter("")
    #                             lds_bwiz.Filter()
    #                             ls_filter =  "bwiz_run_id = " + string(ldb_run_id) + " and bwiz_mo_id = "               + string(ldb_month_id)
    #                             lds_bwiz.SetFilter(ls_filter)
    #                             lds_bwiz.Filter()
    #                             IF lds_bwiz.RowCount() > 0 THEN
    #                                             ld_run_month = lds_bwiz.GetItemDate(1, 'bwiz_run_month')
    #                             END IF
    #             END IF
    #             DESTROY lds_bwiz
    #             ld_sanction_month = ld_run_month
    # ELSE
    #             //10.01D - Passed values from TEA Sanction Tab
    #             lstr_tea_prgsv_sanction_pass.d[1] = ldb_sanction_id                                     // Sanction ID
    #             lstr_tea_prgsv_sanction_pass.d[2] = ldb_sanction_hist_id                           // Sanction Hist ID
    #             lstr_tea_prgsv_sanction_pass.s[1] = ls_sanction_ind                                      // sanction_indicator
    #             lstr_tea_prgsv_sanction_pass.s[2] = ls_release_ind                                                        // release_ind
    #             lstr_tea_prgsv_sanction_pass.s[3] = ls_serve_ind                                                            // sacntion serve
    #             lstr_tea_prgsv_sanction_pass.dates[1] = ld_sanction_month     // sanction_month
    # END IF

    # //10.01D //09-06-07
    # lstr_tea_prgsv_sanction = of_determine_tea_prgsv_sanction(ldb_run_id, ldb_month_id, ldb_sp_id, ld_sanction_month, lstr_tea_prgsv_sanction_pass)
    # //*  lstr_tea_prgsv_sanction.s[1] = Sanction Indicator;  lstr_tea_prgsv_sanction.s[2] = Sanction Flag ; lstr_tea_prgsv_sanction.s[3] = Release Indicator
    # //* lstr_tea_prgsv_sanction.i[1] = Sanction Percent ; lstr_tea_prgsv_sanction.dates[1] = Sanction Start Date ; lstr_tea_prgsv_sanction.dt[1] = TEA Sanction Effective Begin Date

    # ls_sanction_ind = lstr_tea_prgsv_sanction.s[1]
    # ls_serve_ind = lstr_tea_prgsv_sanction.s[2] //10.01E
    # ls_release_ind = lstr_tea_prgsv_sanction.s[3]
    # ls_sanction = lstr_tea_prgsv_sanction.s[4] //10.01E

    # //10.01D //09-06-07
    # IF lb_retro = TRUE THEN
    #             IF ls_sanction_ind = 'B' OR ls_sanction_ind ='D' THEN
    #                             IF Upperbound(lstr_tea_prgsv_sanction.db[]) > 0 THEN
    #                                             IF lstr_tea_prgsv_sanction.db[1] = ldb_clientid THEN
    #                                                             ls_sanction_ind = 'N'
    #                                                             ls_release_ind = 'Y'
    #                                                             ls_sanction = 'N'
    #                                             END IF
    #                             END IF
    #             END IF
    # END IF

    # //10.01E
    # IF Upperbound(lstr_tea_prgsv_sanction.db[]) > 0 THEN
    #             IF lstr_tea_prgsv_sanction.db[1] = ldb_clientid THEN
    #                             ls_serve_ind = astr_pass.s[3]
    #             END IF
    # END IF

    # //10.01D //09-05-07
    # ////************************Determine Retro***********************************//
    # //CHOOSE CASE ls_sanction_ind
    # //        CASE 'E', 'T', 'F'
    # //        CASE ELSE
    # //                        IF ls_release_ind = 'Y' THEN //Release Ind = 'Y'
    # //                                        lb_retro = TRUE
    # //                        END IF
    # //END CHOOSE

    # IF IsNull(ls_sanction) THEN
    #             ls_sanction = 'N'
    # END IF

    # //** Verify Sanction for Non-Progressive Type if Progressive Sanction has been released (Release Ind = Y) **//
    # IF ls_sanction = 'N' THEN //Release Ind = Y
    #             lstr_sanction_nonprogtype_pass.db[1] = ldb_bu_id
    #             lstr_sanction_nonprogtype_pass.db[2] = ldb_run_id
    #             lstr_sanction_nonprogtype_pass.db[3] = ldb_month_id
    #             lstr_sanction_nonprogtype_pass.db[4] = ldb_sp_id
    #             lstr_sanction_nonprogtype_pass.s[1] = ls_sanction
    #             lstr_sanction_nonprogtype_pass.dates[1] = ld_sanction_month
    #             lstr_sanction_nonprogtype_return = of_verify_sanction_nonprogtype(lstr_sanction_nonprogtype_pass)
    #             ls_sanction_ind                = lstr_sanction_nonprogtype_return.s[1] //Sanction Indicator
    #             ls_sanction = lstr_sanction_nonprogtype_return.s[2] //Sanction Flag
    # END IF

    # //******** Call Function to Recalculate Benefit for TEA based on Sanction Applied *****************//

    # IF ls_sanction = 'Y' THEN
    #             IF ls_sanction_ind = 'F' THEN
    #                             ldb_sanction_percent = 50
    #             ELSE
    #                             ldb_sanction_percent = 25
    #             END IF
    # END IF

    # astr_pass.db[4] = ldb_run_id //Run ID
    # astr_pass.db[5] = ldb_month_id //Month ID
    # astr_pass.db[6] = ldb_sanction_percent //Sanction Percent
    # //ls_serve_ind = ls_sanction//Sanction Flag //10.01E
    # //10.01D //09-05-07
    # lstr_parameter.db[1] = astr_pass.db[1]
    # lstr_parameter.db[2] = astr_pass.db[2]
    # lstr_parameter.db[3] = astr_pass.db[3]
    # lstr_parameter.dates[1] = ld_sanction_month
    # lstr_parameter.s[1] = ls_sanction_ind
    # lstr_parameter.s[2] = ls_release_ind
    # lstr_parameter.s[3] = ls_serve_ind
    # lstr_parameter.s[4] = ls_sanction //10.01E
    # lstr_parameter.d[1] = astr_pass.d[1]
    # lstr_parameter.d[2] = astr_pass.d[2]
    # lstr_parameter.db[4] = ldb_run_id //Run ID
    # lstr_parameter.db[5] = ldb_month_id //Month ID
    # lstr_parameter.db[6] = ldb_sanction_percent //Sanction Percent

    # lstr_return = of_recalc_benefit_for_tea(lstr_parameter) //10.01D //09-05-07

    # //**********************************************************************************//
    # // For the Sanction Indicator of Suspend 1 or Suspend 2 the start date on WACE will be equal to the first day of the sanction month.
    # // The grant amount will be zero and the sanction indicator will be â€œB or Dâ€.
    # // When TEA extract occurs if the Sanc field on WACE contains a â€œB or Dâ€ payment will bypassed for the start date.
    # // The budget summary tab in ANSWER will be updated to display a zero grant amount.
    # // If an OCSE sanction was open the budget result detail will contain the sanction amount. The tables will display the grant amount that was suspended.
    # // When a Suspended TEA payment is released the amount of the retro will be determined by the grant amount displayed on the tables.
    # //**********************************************************************************//

    # //*********                Return the New calculated Grant Amount            ****************//

    # IF Upperbound(lstr_return.db[]) > 7 THEN
    #             lstr_pass.db[1] = lstr_return.db[8] // New Grant Amount
    #             lstr_pass.db[2] = lstr_return.db[9] // New Reduction Amount
    # ELSE
    #             //Default to 0
    #             lstr_pass.db[1] = 0 // New Grant Amount
    #             lstr_pass.db[2] = 0 // New Reduction Amount
    # END IF

    # IF  ls_sanction_ind = 'B' OR ls_sanction_ind = 'D' THEN
    #             lstr_pass.db[1] = 0 // New Grant Amount
    #             lstr_pass.db[2] = 0 // New Reduction Amount
    # END IF

    # //10.01D 09-05-07
    # //*********                Generate Start Payment and Retro for Sanction Progressive Type            ****************//
    # IF lb_retro = TRUE THEN
    #             ldt_start_payment  = DateTime(RelativeDate(lnv_datetime.of_LastDayOfMonth(gdt_current_date), 1), time('00:00:00'))  //10.01C Start Payment should be following month of current month
    #             ldt_retro_begin = DateTime(astr_pass.dates[1], time('00:00:00')) //Sanction Month should be the date from TEA Sanction Tab
    #             ldt_retro_end = DateTime(lnv_datetime.of_LastDayOfMonth(Date(ldt_retro_begin)), time('00:00:00'))
    #             IF Date(ldt_retro_begin) = Date(ldt_start_payment) THEN
    #                             ldt_retro_begin = DateTime(lnv_datetime.of_RelativeMonth(astr_pass.dates[1], -1), time('00:00:00'))
    #                             ldt_retro_end = DateTime(lnv_datetime.of_LastDayOfMonth(Date(ldt_retro_begin)), time('00:00:00'))
    #             END IF

    #             //PCR#74461- Code for Marrying Suspend2
    #             IF Upperbound(astr_pass.dt[]) > 0 THEN
    #                             ll_retro_months = Upperbound(astr_pass.dt[])
    #                             ldt_retro_begin = astr_pass.dt[1]
    #                             ldt_retro_end = DateTime(lnv_datetime.of_LastDayOfMonth(Date(astr_pass.dt[1])), time('00:00:00'))
    #                             IF Upperbound(astr_pass.dt[]) > 1 THEN
    #                                             IF Not IsNull(astr_pass.dt[2]) THEN
    #                                                             ldt_retro_end = DateTime(lnv_datetime.of_LastDayOfMonth(Date(astr_pass.dt[2])), time('00:00:00'))
    #                                             END IF
    #                             END IF
    #             END IF
    # ELSE
    #             ldt_start_payment  = DateTime(RelativeDate(lnv_datetime.of_LastDayOfMonth(gdt_current_date), 1), time('00:00:00'))  //10.01C Start Payment should be following month of current month
    #             ldt_retro_begin = DateTime(Date('00/00/0000'), time('00:00:00'))
    #             ldt_retro_end = DateTime(Date('00/00/0000'), time('00:00:00'))
    # END IF

    # //lstr_pass.s[1] = ls_sanction_ind //Sanction Indicator
    # lstr_pass.s[1] = lstr_return.s[1] //10.01B
    # lstr_pass.dt[1]  = ldt_start_payment
    # lstr_pass.dt[2]  = ldt_retro_begin
    # lstr_pass.dt[3]  = ldt_retro_end

    # //10.01D Pack2 09-11-2007
    # IF Upperbound(lstr_return.db[]) > 9 THEN //10.01B
    #             lstr_pass.db[4] = lstr_return.db[10]        // New Run ID
    #             lstr_pass.db[5] = lstr_return.db[11]        // New Month ID
    # END IF

    # //10.01D
    # IF lb_retro = TRUE THEN
    #
    #                             //for regular retro
    #                             lstr_pass_retro = of_tea_sanction_retro(astr_pass)
    #                             IF Upperbound(lstr_pass_retro.db[]) > 7 THEN //10.01D Pack2 09-11-2007
    #                                             lstr_pass.db[3] = lstr_pass_retro.db[8]
    #                             ELSE
    #                                             //10.01D Pack2 09-11-2007
    #                                             //Should not pass run id to fail interface submission when there is no existing budget for retro
    #                                             lstr_pass.db[4] = 0 // Run ID
    #                                             lstr_pass.db[5] = 0 // Month ID
    #                             END IF
    # //        END IF

    # ELSE
    #             lstr_pass.db[3] = 0 // Retro Amount would be the Grant Amount of the previous month
    # END IF

    # RETURN lstr_pass
    end

    def self.recalc_benefit_for_tea(astr_pass)
    #             /************************************************************************
    # //*  10.01A        08/02/2007 ANSWER                    Evangeline L. Gutierez                                                                                                                                   *
    # //*  PCR#74057             - Tea Progressive Sanction                                                                                                                                                                                                                                           *
    # //*  Recalculate Tea Benefit based on the new saction applied.                                                                                                                                              *
    # //* Parameters: astr_pass.db[1] = Budget Unit ID                                                                                                                                                                                                         *
    # //*                                                                      astr_pass.db[2] = Service Program ID                                                                                                                                                                                    *
    # //*                                                                      astr_pass.db[3] = Client ID                                                                                                                                                                                                                                          *
    # //*                                                                      astr_pass.db[4] = Run ID                                                                                                                                                                                                                                                             *
    # //*                                                                      astr_pass.db[5] = Month ID                                                                                                                                                                                                                                       *
    # //*                                                                      astr_pass.db[6] = Sanction Percent                                                                                                                                                                                                        *
    # //*                                                                      astr_pass.s[1] = Sanction Indicator                                                                                                                                                                                                          *
    # //*                                                                      astr_pass.s[2] = Release Payment                                                                                                                                                                                                           *
    # //*                                                       astr_pass.s[3]   = Serve Indicator //Added on 10.01E Package
    # //*                                                       astr_pass.s[4]   = Sanction Flag //Added on 10.01E Package
    # //*  Return Values: lstr_pass_bdgt.db[3] = Full Benefit Amount                                                                                                                                             *
    # //*                                                                       lstr_pass_bdgt.db[4] = Reduction Amount                                                                                                                                                          *
    # //*                                                                       lstr_pass_bdgt.db[5] = Old Sanction Amount                                                                                                                                     *
    # //*                                                                       lstr_pass_bdgt.db[6] = Old Benefit Amount                                                                                                                                       *
    # //*                                                                       lstr_pass_bdgt.db[7] = New Sanction Amount                                                                                                                                  *
    # //*                                                                       lstr_pass_bdgt.db[8] = New Benefit Amount                                                                                                                                     *
    # //*                                                                       lstr_pass_bdgt.db[9] = New Reduction Amount                                                                                                                               *
    # //*                                                                       lstr_pass_bdgt.db[10] = New Run ID                                                                                                                                                                      *
    # //*                                                                       lstr_pass_bdgt.db[11] = New Month ID                                                                                                                                                                                *
    # //*                                                                                      lstr_pass_bdgt.s[1] = Sanction Indicator                                                                                                                                                               *
    # //************************************************************************



    # str_pass lstr_pass_bdgt, lstr_pass
    # n_ds lds_bdgt_sum_tea
    # Long ll_bdgt_return
    # Double ldb_run_id

    # n_ds lds_bdgt_member, lds_bdgt_member_copy
    # Long ll_bdgt_member, ll_bdgt_member_ctr
    # str_pass lstr_bdgt_member
    # Integer li_bdgt_member_copy

    # n_ds lds_bmem_details, lds_bmem_details_copy
    # Long ll_bmem_details, ll_bmem_details_ctr
    # str_pass lstr_bmem_details
    # Integer li_bmem_details_copy

    # n_ds lds_bmem_summary, lds_bmem_summary_copy
    # Long ll_bmem_summary, ll_bmem_summary_ctr
    # str_pass lstr_bmem_summary
    # Integer li_bmem_summary_copy

    # n_ds lds_tea_detail, lds_tea_detail_copy
    # Long ll_tea_detail, ll_tea_detail_ctr
    # str_pass lstr_tea_detail
    # Integer li_tea_detail_copy

    # n_ds lds_bu_mo_summary, lds_bu_mo_summary_copy
    # Long ll_bu_mo_summary, ll_bu_mo_summary_ctr
    # str_pass lstr_bu_mo_summary
    # Integer li_bu_mo_summary_copy

    # n_ds lds_bdgt_wizard, lds_bdgt_wizard_copy
    # Long ll_bdgt_wizard, ll_bdgt_wizard_ctr
    # str_pass lstr_bdgt_wizard
    # Integer li_bdgt_wizard_copy

    # Long ll_bmember_id, ll_currow
    # Long ll_bdetails_id

    # Decimal{2} ldc_grant_amount, ldc_sanction
    # Double ldb_audit_id_old, ldb_audit_det_id_old

    # Integer li_audit_inc_orig_count, li_audit_inc_ctr, li_audit_inc_currow
    # Integer li_audit_adj_orig_count, li_audit_adj_ctr, li_audit_adj_currow
    # Integer li_audit_shared_orig_count, li_audit_shared_ctr, li_audit_shared_currow

    # str_pass lstr_submit, lstr_submit_date
    # ds_bb_submit_date lds_submit_date
    # Integer li_submit

    # str_pass lstr_red_tea_grant, lstr_sanctionfull_grant
    # Long ll_sanction_rows, ll_red_tea_grant_rows, ll_sanctionfull_rows
    # ds_tea_grant_amount lds_red_tea_grant_amount
    # Decimal{2} ldc_teapartial_grant, ldc_sanctionpartial_grant, ldc_sanctionfull_grant
    # Decimal{2} ldc_tot_gross_inc
    # String ls_reduced, ls_sanction

    # str_pass lstr_bu_size
    # n_ds lds_bu_size
    # Integer li_bu_size_rows, li_bu_size

    # Decimal{2} ldc_ben_gross_earned, ldc_elig_gross_earned, ldc_tot_unearned

    # Date ld_sanction_month
    # n_cst_datetime lnv_datetime

    # //10.01F - 0918-2007
    # str_pass lstr_pass_grant_std
    # Long ll_grant_std
    # n_ds lds_tea_income_limit
    # Decimal ldc_grant_amount_std

    # lds_bdgt_sum_tea = CREATE n_ds
    # lds_bdgt_sum_tea.DataObject = 'dw_bdgt_unit_sum_tea'
    # lds_bdgt_sum_tea.SetTransObject(SQLCA)

    # lstr_pass_bdgt.db[1] = astr_pass.db[4]
    # lstr_pass_bdgt.db[2] = astr_pass.db[5]

    # ll_bdgt_return = gnv_data_access_service.retrieve(lds_bdgt_sum_tea, lds_bdgt_sum_tea, "Buta_l", lstr_pass_bdgt)

    # IF ll_bdgt_return >  0 THEN
    #             lstr_pass_bdgt.db[3] = lds_bdgt_sum_tea.GetItemNumber(1, 'full_benefit')
    #             lstr_pass_bdgt.db[4] = lds_bdgt_sum_tea.GetItemNumber(1, 'reduction')
    #             lstr_pass_bdgt.db[5] = lds_bdgt_sum_tea.GetItemNumber(1, 'sanction')
    #             lstr_pass_bdgt.db[6] = lds_bdgt_sum_tea.GetItemNumber(1, 'program_benefit_amount')
    #             ldc_ben_gross_earned = lds_bdgt_sum_tea.GetItemNumber(1, 'ben_gross_earned')
    #             ldc_elig_gross_earned = lds_bdgt_sum_tea.GetItemNumber(1, 'elig_gross_earned')
    #             ldc_tot_unearned =       lds_bdgt_sum_tea.GetItemNumber(1, 'ben_total_unearned')

    #             //10.01F - 09-18-2007
    # //        ldc_tot_gross_inc = lds_bdgt_sum_tea.GetItemNumber(1, 'elig_tot_adjusted')
    # //        IF ldc_ben_gross_earned > ldc_elig_gross_earned THEN
    # //                        //OJT exists
    # //                        ldc_tot_gross_inc = lds_bdgt_sum_tea.GetItemNumber(1, 'ben_total_adjusted')
    # //        END IF

    #             ldc_tot_gross_inc = ldc_ben_gross_earned + ldc_tot_unearned

    #             //10.01F 09-18-2007
    #             lds_tea_income_limit = CREATE ds_tea_income_limit
    #             lds_tea_income_limit.SetTransObject(SQLCA)
    #             //Set the local structure equal to whatever is in the instance structure
    #             lstr_pass_grant_std.db[1] = 120
    #             lstr_pass_grant_std.s[1] = string(astr_pass.dates[1])
    #             //Retrieve the grant amount standard
    #             ll_grant_std = gnv_data_access_service.retrieve(lds_tea_income_limit,lds_tea_income_limit,"Bctl_l",lstr_pass_grant_std)
    #             IF ll_grant_std > 0 THEN
    #                             //Get the grant amount standard
    #                             ldc_grant_amount_std = lds_tea_income_limit.GetItemNumber(1,"program_standard_limit_amount")
    #             END IF
    #             DESTROY lds_tea_income_limit


    #             //Recalculate benefit amount based on new sanction applied
    #             IF astr_pass.db[6] > 0 THEN //Sanction Percent
    #                             //** Take the Budget Unit Size of the last submitted budget
    #                             lstr_bu_size.db[1] = astr_pass.db[4]
    #                             lstr_bu_size.db[2] = astr_pass.db[5]

    #                             lds_bu_size = CREATE n_ds
    #                             lds_bu_size.DataObject = 'dw_bud_totals'
    #                             lds_bu_size.SetTransObject(SQLCA)
    #                             li_bu_size_rows = gnv_data_access_service.retrieve(lds_bu_size, lds_bu_size, "Busp_l", lstr_bu_size)

    #                             IF li_bu_size_rows > 0 THEN
    #                                             li_bu_size = lds_bu_size.GetItemNumber(1, "budget_unit_size")
    #                             END IF

    #                             DESTROY lds_bu_size

    #                             IF li_bu_size > 9 THEN
    #                                             lstr_red_tea_grant.db[1] = 9
    #                             ELSE
    #                                             lstr_red_tea_grant.db[1] = li_bu_size   //budget unit size
    #                             END IF

    #                             lds_red_tea_grant_amount = CREATE ds_tea_grant_amount
    #                             lds_red_tea_grant_amount.SetTransObject(SQLCA)

    #                             lstr_red_tea_grant.s[1] = string(astr_pass.dates[1])  //Run month
    #                             lstr_red_tea_grant.s[2] = "35"          //TEA Partial Grant (50% of TEA Full Grant)

    #                             //Retrieve the grant amount by unit size
    #                             ll_red_tea_grant_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l", lstr_red_tea_grant)

    #                             IF ll_red_tea_grant_rows > 0 THEN
    #                                             ldc_teapartial_grant = lds_red_tea_grant_amount.GetItemNumber(1,"bus_limit_amount")
    #                             ELSE
    #                                             MessageBox(gnv_app.iapp_object.DisplayName,"There is no PARTIAL GRANT standard set up for this budget unit size.")
    #                                             ldc_teapartial_grant = 0
    #                             END IF

    #                             lstr_red_tea_grant.s[2] = '45' //Sanction Partial Grant (50% of Sanction Full 25% Grant)

    #                             If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
    #                                             ll_red_tea_grant_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l",lstr_red_tea_grant)
    #                             Else
    #                                             ll_red_tea_grant_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l",lstr_pass)
    #                             End If

    #                             IF ll_red_tea_grant_rows > 0 THEN
    #                                             ldc_sanctionpartial_grant = lds_red_tea_grant_amount.GetItemNumber(1,"bus_limit_amount")
    #                             ELSE
    #                                             MessageBox(gnv_app.iapp_object.DisplayName,"There is no SANCTION standard set up for this budget unit size.")
    #                                             ldc_sanction = 0
    #                             END IF

    # //                        IF ldc_tot_gross_inc > lstr_pass_bdgt.db[3] THEN            //10.01F
    #                             IF ldc_tot_gross_inc > ldc_grant_amount_std THEN        //10.01F 09-18-2007
    #                                             ls_reduced = 'Y'
    #                             Else
    #                                             ls_reduced = 'N'
    #                             End if

    #                             IF astr_pass.s[1] = 'N' THEN
    #                                             ls_sanction = 'N'
    #                             ELSE
    #                                             ls_sanction = 'Y'
    #                             END IF

    #                             IF astr_pass.s[1] = 'E' THEN
    #                                             //No need to recalculate
    #                                             lstr_pass_bdgt.db[7] = lstr_pass_bdgt.db[5] //Sanction
    #                                             lstr_pass_bdgt.db[8] = lstr_pass_bdgt.db[6] //Grant Amount
    #                                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[4] //Reduction
    #                             ELSE

    #                                             IF (astr_pass.s[1] = 'B' OR astr_pass.s[1] = 'D')  AND astr_pass.s[4] = 'Y' THEN //10.01B - Recalculating for Suspend 1 or Suspend 2
    #                                                             lstr_pass_bdgt.db[7] = lstr_pass_bdgt.db[5] //Sanction
    #                                                             lstr_pass_bdgt.db[8] = lstr_pass_bdgt.db[6] //Grant Amount
    #                                                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[4] //Reduction
    #                                                             IF ls_reduced = 'Y' THEN
    #                                                                             lstr_pass_bdgt.db[8] = ldc_teapartial_grant
    #                                                                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[3] - ldc_teapartial_grant
    #                                                                             lstr_pass_bdgt.db[7] = 0
    #                                                             END IF
    #                                             ELSE

    #                                                             //10.01B
    #                                                             //** Verify if there is an existing OCSE Sanction
    #                                                             str_pass lstr_sanction_nonprogtype_pass, lstr_sanction_nonprogtype_return
    #                                                             IF ls_sanction = 'N' THEN //If Porgressive Sanction is not Active, verify Non-Progressive Sanction
    #                                                                             lstr_sanction_nonprogtype_pass.db[1] = astr_pass.db[1]
    #                                                                             lstr_sanction_nonprogtype_pass.db[2] = astr_pass.db[4]
    #                                                                             lstr_sanction_nonprogtype_pass.db[3] = astr_pass.db[5]
    #                                                                             lstr_sanction_nonprogtype_pass.db[4] = astr_pass.db[2]
    #                                                                             lstr_sanction_nonprogtype_pass.s[1] = ls_sanction
    #                                                                             lstr_sanction_nonprogtype_pass.dates[1] = astr_pass.dates[1]
    #                                                                             lstr_sanction_nonprogtype_return = of_verify_sanction_nonprogtype(lstr_sanction_nonprogtype_pass)
    #                                                                             astr_pass.s[1]    = lstr_sanction_nonprogtype_return.s[1] //Sanction Indicator
    #                                                                             ls_sanction = lstr_sanction_nonprogtype_return.s[2] //Sanction Flag
    #                                                             END IF
    #                                                             //*************************************************************

    #                                                             If ls_reduced = 'Y' and ls_sanction = 'Y' then
    #                                                                             IF astr_pass.db[6] = 50 THEN
    #                                                                                             ldc_sanctionpartial_grant = round((ldc_teapartial_grant * .50),0)
    #                                                                             END IF

    #                                                                             lstr_pass_bdgt.db[8] = ldc_sanctionpartial_grant //Grant Amount
    #                                                                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[3] - ldc_teapartial_grant //Full Grant - Partial Grant
    #                                                                             lstr_pass_bdgt.db[7] = lstr_pass_bdgt.db[3] - lstr_pass_bdgt.db[9] - lstr_pass_bdgt.db[8] //FullGrant - Reduction - Sanction

    #                                                             Elseif ls_reduced = 'Y' then

    #                                                                             lstr_pass_bdgt.db[8] = ldc_teapartial_grant
    #                                                                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[3] - ldc_teapartial_grant
    #                                                                             lstr_pass_bdgt.db[7] = 0

    #                                                             Elseif ls_sanction = 'Y' then

    #                                                                             IF li_bu_size > 9 THEN
    #                                                                                             lstr_sanctionfull_grant.db[1] = 9
    #                                                                             ELSE
    #                                                                                             lstr_sanctionfull_grant.db[1] = li_bu_size
    #                                                                             END IF
    #                                                                             lstr_sanctionfull_grant.s[1] = string(astr_pass.dates[1])
    #                                                                             lstr_sanctionfull_grant.s[2] = '40'

    #                                                                             ll_sanctionfull_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l", lstr_sanctionfull_grant)

    #                                                                             IF ll_sanctionfull_rows > 0 THEN
    #                                                                                             ldc_sanctionfull_grant = lds_red_tea_grant_amount.GetItemNumber(1,"bus_limit_amount")
    #                                                                             Else
    #                                                                                             MessageBox(gnv_app.iapp_object.DisplayName,"There is no SANCTION standard set up for this budget unit size.")
    #                                                                                             ldc_sanction = 0
    #                                                                             End if

    #                                                                             IF astr_pass.db[6] = 50 THEN
    #                                                                                             ldc_sanctionfull_grant = round((lstr_pass_bdgt.db[3] * .50),0)
    #                                                                             END IF

    #                                                                             lstr_pass_bdgt.db[8]  = ldc_sanctionfull_grant //Grant Amount
    #                                                                             lstr_pass_bdgt.db[9] = 0 //Reduction
    #                                                                             lstr_pass_bdgt.db[7] = lstr_pass_bdgt.db[3] - ldc_sanctionfull_grant //Full Grant - Sanction

    #                                                             Else
    #                                                                             lstr_pass_bdgt.db[7] = 0
    #                                                                             lstr_pass_bdgt.db[8] = lstr_pass_bdgt.db[3]
    #                                                                             lstr_pass_bdgt.db[9] = 0
    #                                                             End if
    #                                             END IF
    #                             END IF
    #             ELSE
    #                             //When Sanction Flag = N; Full Grant Amount Should be send without applied sanction
    #                             lstr_pass_bdgt.db[8] = lstr_pass_bdgt.db[3] - lstr_pass_bdgt.db[4] //10.01E
    #                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[4]
    #                             lstr_pass_bdgt.db[7] = 0
    #             END IF

    #             DESTROY lds_red_tea_grant_amount

    #             //Generate New Run ID
    #             lstr_pass.db[1] = 2   //set domain table ID (2 is for the id portion of the domain tbl)
    #             lstr_pass.db[2] = 46  //set sub domain id   (46 is for requesting Budget Wizard Run ID)
    #             ldb_run_id = gnv_data_access_service.system_generate_id(lstr_pass)
    #             lstr_pass_bdgt.db[10] = ldb_run_id //New Run ID
    #             lstr_pass_bdgt.db[11] = astr_pass.db[5] //New Month ID

    #             //******************** Create Budget Record*********************************************//

    #             //** T_Budget_Wizard
    #             lds_bdgt_wizard = CREATE n_ds
    #             lds_bdgt_wizard.DataObject = 'dw_budget_months'
    #             lds_bdgt_wizard.SetTransObject(SQLCA)
    #             lds_bdgt_wizard_copy = CREATE n_ds
    #             lds_bdgt_wizard_copy.DataObject = 'dw_budget_months'
    #             lds_bdgt_wizard_copy.SetTransObject(SQLCA)

    #             lstr_bdgt_wizard .db[1] = astr_pass.db[4] //Run ID
    #             lstr_bdgt_wizard .db[2] = astr_pass.db[1] //Budget Unit ID

    #             ll_bdgt_wizard  = gnv_data_access_service.retrieve(lds_bdgt_wizard , lds_bdgt_wizard , "Bbmo_l", lstr_bdgt_wizard )
    #             IF ll_bdgt_wizard > 0 THEN
    #                             lds_bdgt_wizard.SetFilter("")
    #                             lds_bdgt_wizard.Filter()
    #                             lds_bdgt_wizard.SetFilter("bwiz_mo_id = " + string(astr_pass.db[5]))
    #                             lds_bdgt_wizard.Filter()
    #                             lds_bdgt_wizard .RowsCopy(lds_bdgt_wizard .GetRow(), lds_bdgt_wizard .RowCount(), Primary!, lds_bdgt_wizard_copy, 1, Primary!)
    #                             FOR ll_bdgt_wizard_ctr = 1 TO lds_bdgt_wizard_copy.Rowcount()
    #                                             lds_bdgt_wizard_copy.SetItem(ll_bdgt_wizard_ctr, 'bwiz_run_id', ldb_run_id)
    #                                             lds_bdgt_wizard_copy.SetItem(ll_bdgt_wizard_ctr, 'bwiz_mo_id', astr_pass.db[5])
    #                                             ld_sanction_month = astr_pass.dates[1] //10.01E

    #                                             //10.01E 09-13-2007 ; Bwiz Run Month should be following month of current month when cut off date is prior to current date, Served Indicator = Y.

    #                                             //Check for the last 6 working day
    #                                             Date ldt_cutoff_date

    # //                                        IF gdt_current_date > ld_sanction_month THEN
    # //                                                        gnv_app.of_get_cutoffdate(astr_pass.db[2], gdt_current_date, ldt_cutoff_date)
    # //                                        ELSE
    # //                                                        gnv_app.of_get_cutoffdate(astr_pass.db[2], RelativeDate(ld_sanction_month, -1), ldt_cutoff_date)
    # //                                        END IF

    #                                              gnv_app.of_get_cutoffdate(astr_pass.db[2], gdt_current_date, ldt_cutoff_date)

    #                                             IF            astr_pass.s[3] = 'Y' THEN
    # //                                                        IF ((gdt_current_date <= ldt_cutoff_date) or ((Month (gdt_current_date) >  Month (ldt_cutoff_date)) and Year (gdt_current_date) >= Year(ldt_cutoff_date))) THEN //10.01F
    # //                                                                        ld_sanction_month = lnv_datetime.of_RelativeMonth(gdt_current_date, 1)
    # //                                                        ELSE
    # //                                                                        ld_sanction_month = lnv_datetime.of_RelativeMonth(gdt_current_date, 2)
    # //                                                        END IF

    #                                                             IF            ldt_cutoff_date >= gdt_current_date THEN
    #                                                                             IF ((Month(ld_sanction_month) > Month(gdt_current_date)) and (Year(ld_sanction_month) >= Year(gdt_current_date))) &
    #                                                                                             OR ((Month(ld_sanction_month) < Month(gdt_current_date)) and (Year(ld_sanction_month) <= Year(gdt_current_date))) &
    #                                                                                             OR ((Month(ld_sanction_month) = Month(gdt_current_date)) and (Year(ld_sanction_month) = Year(gdt_current_date))) THEN
    #                                                                                             ld_sanction_month = lnv_datetime.of_RelativeMonth(gdt_current_date, 1)
    #                                                                             END IF
    #                                                             ELSE
    #                                                                             ld_sanction_month = lnv_datetime.of_RelativeMonth(gdt_current_date, 2)
    #                                                             END IF

    #                                             END IF

    #                                             IF Upperbound(astr_pass.s[]) > 1 THEN //10.01B - Setting Budget Run Month
    #                                                             IF astr_pass.s[2] = 'Y' THEN //Release Ind = 'Y'
    #                                                                             //For Retro, no need to update the run month of existing budget.
    #                                                             ELSE
    #                                                                             lds_bdgt_wizard_copy.SetItem(ll_bdgt_wizard_ctr, 'bwiz_run_month', ld_sanction_month)       //10.01E
    #                                                             END IF
    #                                             ELSE
    #                                                             lds_bdgt_wizard_copy.SetItem(ll_bdgt_wizard_ctr, 'bwiz_run_month', ld_sanction_month)       //10.01E
    #                                             END IF

    #                                             lds_bdgt_wizard_copy.SetItem(ll_bdgt_wizard_ctr, 'user_id', gs_current_user)
    #                                             lds_bdgt_wizard_copy.SetItem(ll_bdgt_wizard_ctr, 'bwiz_run_date', DateTime(gdt_current_date, now()))
    #                             NEXT
    #             END IF

    #             lstr_bdgt_wizard.db[1] = ldb_run_id
    #             li_bdgt_wizard_copy = gnv_data_access_service.update_service(lds_bdgt_wizard_copy, lds_bdgt_wizard_copy, "Bbmo_u", lstr_bmem_details)

    #             DESTROY lds_bdgt_wizard
    #             DESTROY lds_bdgt_wizard_copy

    #             //** No need to update Submit & Transaction Date, interface will be updating these fields upon successful submission.
    #             ////Update Submit Date
    #             //lstr_submit.db[1] = ldb_run_id
    #             //lstr_submit.db[2] = astr_pass.db[5]
    #             //
    #             //lds_submit_date = CREATE ds_bb_submit_date
    #             //lds_submit_date.SetTransObject(SQLCA)
    #             //lstr_submit_date.db[1] = astr_pass.db[4]
    #             //lstr_submit_date.db[2] = astr_pass.db[5]
    #             //li_submit = gnv_data_access_service.retrieve(lds_submit_date, lds_submit_date,"Oibe_l", lstr_submit_date)
    #             //IF li_submit > 0 THEN
    #             //            lstr_submit.s[1] = lds_submit_date.GetItemString(1, "bwiz_cat_elig_ind")
    #             //END IF
    #             //
    #             //DESTROY lds_submit_date
    #             //
    #             //lstr_submit.s[2] = 'NOTREQ' //Retain Ind
    #             ////Update Submit Date
    #             //This.of_set_submit_date(lstr_submit)
    #             ////Update TXN Success Date
    #             //gnv_online_interface_controller.of_set_txn_success_date(ldb_run_id, astr_pass.db[5])


    #             //** T_Budget_Member
    #             lds_bdgt_member = CREATE n_ds
    #             lds_bdgt_member.DataObject = 'dw_bw_mem'
    #             lds_bdgt_member.SetTransObject(SQLCA)
    #             lds_bdgt_member_copy = CREATE n_ds
    #             lds_bdgt_member_copy.DataObject = 'dw_bw_mem'
    #             lds_bdgt_member_copy.SetTransObject(SQLCA)

    #             //** T_B_Mem_Summary
    #             lds_bmem_summary = CREATE n_ds
    #             lds_bmem_summary.DataObject = 'dw_bb_bmem_sum' //Oibs_l
    #             lds_bmem_summary.SetTransObject(SQLCA)
    #             lds_bmem_summary_copy = CREATE n_ds
    #             lds_bmem_summary_copy.DataObject = 'd_bmem_summary_update' //Bcsu_u
    #             lds_bmem_summary_copy.SetTransObject(SQLCA)

    #             lstr_bdgt_member.db[1] = astr_pass.db[4]
    #             lstr_bdgt_member.db[2] = astr_pass.db[5]

    #             ll_bdgt_member = gnv_data_access_service.retrieve(lds_bdgt_member, lds_bdgt_member, "Bbme_l", lstr_bdgt_member)

    #             IF ll_bdgt_member > 0 THEN
    #                             lds_bdgt_member.RowsCopy(lds_bdgt_member.GetRow(), lds_bdgt_member.RowCount(), Primary!, lds_bdgt_member_copy, 1, Primary!)
    #                             FOR ll_bdgt_member_ctr = 1 TO lds_bdgt_member_copy.Rowcount()
    #                                             lds_bdgt_member_copy.SetItem(ll_bdgt_member_ctr, 'bwiz_run_id', ldb_run_id)
    #                                             //set relationship
    #                                             //set work part status

    #                                             lstr_bmem_summary.db[1] = astr_pass.db[4]
    #                                             lstr_bmem_summary.db[2] = astr_pass.db[5]
    #                                             lstr_bmem_summary.db[3] = lds_bdgt_member_copy.GetItemNumber(ll_bdgt_member_ctr, 'client_id')//need to check for each client
    #                                             ll_bmember_id = lds_bdgt_member_copy.GetItemNumber(ll_bdgt_member_ctr, 'bmember_id')

    #                                             ll_bmem_summary = gnv_data_access_service.retrieve(lds_bmem_summary, lds_bmem_summary, "Oibs_l", lstr_bmem_summary)

    #                                             IF ll_bmem_summary > 0 THEN
    #                                                             ll_currow = lds_bmem_summary_copy.InsertRow(0)
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'bwiz_run_id', ldb_run_id)
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'bwiz_mo_id', astr_pass.db[5])
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'bmember_id', ll_bmember_id)
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'bms_start_date', lds_bmem_summary.GetItemDate(1, 't_bmem_summary_bms_start_date'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'bms_stop_date', lds_bmem_summary.GetItemDate(1, 't_bmem_summary_bms_stop_date'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'tot_earned_inc', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_tot_earned_inc'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'tot_unearned_inc', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_tot_unearned_inc'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'tot_expenses', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_tot_expenses'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'soc_sec_admin_amt', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_soc_sec_admin_amt'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'railroad_ret_amt', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_railroad_ret_amt'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'vet_asst_amt', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_vet_asst_amt'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'other_unearned_inc', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_other_unearned_inc'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'elig_work_deduct', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_elig_work_deduct'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'elig_incent_deduct', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_elig_incent_deduct'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'bms_reason', lds_bmem_summary.GetItemString(1, 't_bmem_summary_bms_reason'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'tot_resources', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_tot_resources'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'unmet_liability', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_unmet_liability'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'supl_sec_inc_amt', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_supl_sec_inc_amt'))
    #                                                             lds_bmem_summary_copy.SetItem(ll_currow, 'child_care_deduct', lds_bmem_summary.GetItemNumber(1, 't_bmem_summary_child_care_deduct'))
    #                                             END IF
    #                             NEXT
    #             END IF

    #             //**Note: T_Budget Member should be updated prior to T_BMem_Summary
    #             lstr_bdgt_member.db[1] = ldb_run_id
    #             li_bdgt_member_copy= gnv_data_access_service.update_service(lds_bdgt_member_copy, lds_bdgt_member_copy, "Bbme_u", lstr_bdgt_member)
    #             str_pass lstr_bmem_summary_copy
    #             li_bmem_summary_copy = gnv_data_access_service.update_service(lds_bmem_summary_copy, lds_bmem_summary_copy, "Bcsu_u", lstr_bmem_summary_copy)


    #             DESTROY lds_bmem_summary
    #             DESTROY lds_bmem_summary_copy
    #             DESTROY lds_bdgt_member
    #             DESTROY lds_bdgt_member_copy

    #             //** T_B_Mem_Details - Income Records
    #             lds_bmem_details = CREATE n_ds
    #             lds_bmem_details.DataObject = 'dw_t_b_mem_details'
    #             lds_bmem_details.SetTransObject(SQLCA)
    #             lds_bmem_details_copy = CREATE n_ds
    #             lds_bmem_details_copy.DataObject = 'dw_t_b_mem_details'
    #             lds_bmem_details_copy.SetTransObject(SQLCA)

    #             //** Audit Trail
    #             uo_audit_trail luo_audit_trail
    #             str_pass lstr_audit_mstr, lstr_audit_dtl, lstr_audit_shared, lstr_audit_adj
    #             luo_audit_trail = CREATE uo_audit_trail

    #             lstr_bmem_details.db[1] = astr_pass.db[4]
    #             lstr_bmem_details.db[2] = astr_pass.db[5]
    #             ll_bmem_details = gnv_data_access_service.retrieve(lds_bmem_details, lds_bmem_details, "Bcmd_l", lstr_bmem_details)

    #             IF ll_bmem_details > 0 THEN
    #                             FOR ll_bmem_details_ctr = 1 TO lds_bmem_details.Rowcount()
    #                                             //10.01B - Build2
    #                                             lds_bmem_details_copy.Reset()
    #                                             lds_bmem_details.RowsCopy(ll_bmem_details_ctr, ll_bmem_details_ctr, Primary!, lds_bmem_details_copy, 1, Primary!)
    #                                             lds_bmem_details_copy.SetItem(1, 'bwiz_run_id', ldb_run_id)

    #                                             lstr_bmem_details.db[1] = ldb_run_id
    #                                             li_bmem_details_copy = gnv_data_access_service.update_service(lds_bmem_details_copy, lds_bmem_details_copy, "Bcmd_u", lstr_bmem_details)

    #                                             ll_bmember_id = lds_bmem_details.GetItemNumber(ll_bmem_details_ctr, 'bmember_id')
    #                                             ll_bdetails_id = lds_bmem_details.GetItemNumber(ll_bmem_details_ctr, 'b_details_id')

    #                                              //** Create Audit Trail
    #                                             lstr_audit_mstr = luo_audit_trail.of_get_audit_mstr(astr_pass.db[4], astr_pass.db[5], ll_bmember_id, ll_bdetails_id)
    #                                             IF Upperbound(lstr_audit_mstr.db[]) > 4 THEN
    #                                                             ldb_audit_id_old = lstr_audit_mstr.db[5] //Existing Audit ID
    #                                                             lstr_audit_mstr.db[1] = ldb_run_id //New Run ID
    #                                                             lstr_audit_mstr = luo_audit_trail.of_create_audit_mstr(lstr_audit_mstr)
    #                                                             IF Upperbound(lstr_audit_mstr.db[]) > 4 THEN //Audit ID Existing
    #                                                                             lstr_audit_dtl = luo_audit_trail.of_get_audit_inc_dtl( astr_pass.db[4], astr_pass.db[5], ll_bmember_id, ll_bdetails_id, ldb_audit_id_old, 1)
    #                                                                             ldb_audit_det_id_old = lstr_audit_dtl.db[9] //Existing Audit Detail ID
    #                                                                             li_audit_inc_orig_count = lstr_audit_dtl.i[1]
    #                                                                             FOR li_audit_inc_ctr = 1 TO  li_audit_inc_orig_count
    #                                                                                             lstr_audit_dtl.db[1] = ldb_run_id //New Run ID
    #                                                                                             lstr_audit_dtl.db[5] = lstr_audit_mstr.db[5] //New Audit ID
    #                                                                                             lstr_audit_dtl = luo_audit_trail.of_create_audit_inc_dtl(lstr_audit_dtl)
    #                                                                                             IF Upperbound(lstr_audit_dtl.db[]) > 8 THEN //Audit Det ID Existing
    #                                                                                                             lstr_audit_adj = luo_audit_trail.of_get_audit_inc_adj( astr_pass.db[4], astr_pass.db[5], ll_bmember_id, ll_bdetails_id, ldb_audit_id_old, ldb_audit_det_id_old, 1)
    #                                                                                                             li_audit_adj_orig_count = lstr_audit_adj.i[1]
    #                                                                                                             FOR li_audit_adj_ctr = 1 TO  li_audit_adj_orig_count
    #                                                                                                                             lstr_audit_adj.db[1] = ldb_run_id //New Run ID
    #                                                                                                                             lstr_audit_adj.db[5] = lstr_audit_mstr.db[5] //New Audit ID
    #                                                                                                                             lstr_audit_adj.db[7] = lstr_audit_dtl.db[9] //New Detail ID
    #                                                                                                                             lstr_audit_adj = luo_audit_trail.of_create_audit_inc_adj(lstr_audit_adj)
    #                                                                                                                             li_audit_adj_currow = li_audit_adj_ctr + 1
    #                                                                                                                             lstr_audit_adj = luo_audit_trail.of_get_audit_inc_adj( astr_pass.db[4], astr_pass.db[5], ll_bmember_id, ll_bdetails_id, ldb_audit_id_old, ldb_audit_det_id_old, li_audit_adj_currow)
    #                                                                                                             NEXT
    #                                                                                             END IF
    #                                                                                             li_audit_inc_currow = li_audit_inc_ctr + 1
    #                                                                                             lstr_audit_dtl = luo_audit_trail.of_get_audit_inc_dtl( astr_pass.db[4], astr_pass.db[5], ll_bmember_id, ll_bdetails_id, ldb_audit_id_old, li_audit_inc_currow)
    #                                                                                             IF Upperbound(lstr_audit_dtl.db[]) > 8 THEN
    #                                                                                                             ldb_audit_det_id_old = lstr_audit_dtl.db[9] //Existing Audit Detail ID            of the following record, 10.01D
    #                                                                                             END IF
    #                                                                             NEXT
    #                                                                             lstr_audit_shared = luo_audit_trail.of_get_audit_trail_shared( astr_pass.db[4], astr_pass.db[5], ll_bmember_id, ll_bdetails_id, ldb_audit_id_old, 1)
    #                                                                             li_audit_shared_orig_count = lstr_audit_shared.i[1]
    #                                                                             IF Upperbound(lstr_audit_shared.db[]) > 5 THEN
    #                                                                                             FOR li_audit_shared_ctr = 1 TO  li_audit_shared_orig_count
    #                                                                                                             lstr_audit_shared.db[1] = ldb_run_id //New Run ID
    #                                                                                                             lstr_audit_shared.db[5] = lstr_audit_mstr.db[5] //New Audit ID
    #                                                                                                             lstr_audit_shared = luo_audit_trail.of_create_audit_trail_shared(lstr_audit_shared)
    #                                                                                                             li_audit_shared_currow = li_audit_shared_ctr + 1
    #                                                                                                             lstr_audit_shared = luo_audit_trail.of_get_audit_trail_shared( astr_pass.db[4], astr_pass.db[5], ll_bmember_id, ll_bdetails_id, ldb_audit_id_old, li_audit_shared_currow)
    #                                                                                             NEXT
    #                                                                             END IF
    #                                                             END IF
    #                                             END IF
    #                             NEXT
    #             END IF

    #             DESTROY lds_bmem_details
    #             DESTROY lds_bmem_details_copy

    #             //** T_Tea_Detail
    #             lds_tea_detail = CREATE n_ds
    #             lds_tea_detail.DataObject = 'd_tea_detail'
    #             lds_tea_detail.SetTransObject(SQLCA)
    #             lds_tea_detail_copy = CREATE n_ds
    #             lds_tea_detail_copy.DataObject = 'd_tea_detail'
    #             lds_tea_detail_copy.SetTransObject(SQLCA)

    #             lstr_tea_detail.db[1] = astr_pass.db[4]
    #             lstr_tea_detail.db[2] = astr_pass.db[5]

    #             ll_tea_detail = gnv_data_access_service.retrieve(lds_tea_detail, lds_tea_detail, "Bctd_l", lstr_tea_detail)

    #             IF ll_tea_detail > 0 THEN
    #                             lds_tea_detail.RowsCopy(lds_tea_detail.GetRow(), lds_tea_detail.RowCount(), Primary!, lds_tea_detail_copy, 1, Primary!)
    #                             FOR ll_tea_detail_ctr = 1 TO lds_tea_detail_copy.Rowcount()
    #                                             lds_tea_detail_copy.SetItem(ll_tea_detail_ctr, 'bwiz_run_id', ldb_run_id)
    #                                             lds_tea_detail_copy.SetItem(ll_tea_detail_ctr, 'sanction_indicator', astr_pass.s[1])
    #                                             IF astr_pass.s[1] <> 'E' THEN
    #                                                             lds_tea_detail_copy.SetItem(ll_tea_detail_ctr, 'sanction', lstr_pass_bdgt.db[7])
    #                                                             lds_tea_detail_copy.SetItem(ll_tea_detail_ctr, 'program_benefit_amount', lstr_pass_bdgt.db[8])
    #                                                             lds_tea_detail_copy.SetItem(ll_tea_detail_ctr, 'reduction', lstr_pass_bdgt.db[9])
    #                                             END IF
    #                             NEXT
    #             END IF

    #             lstr_tea_detail.db[1] = ldb_run_id
    #             li_tea_detail_copy = gnv_data_access_service.update_service(lds_tea_detail_copy, lds_tea_detail_copy, "Bctd_u", lstr_tea_detail)

    #             DESTROY lds_tea_detail
    #             DESTROY lds_tea_detail_copy

    #             //** T_Bu_Mo_Summary
    #             lds_bu_mo_summary = CREATE n_ds
    #             lds_bu_mo_summary.DataObject = 'dw_t_bu_mo_summary'
    #             lds_bu_mo_summary.SetTransObject(SQLCA)
    #             lds_bu_mo_summary_copy = CREATE n_ds
    #             lds_bu_mo_summary_copy.DataObject = 'dw_t_bu_mo_summary'
    #             lds_bu_mo_summary_copy.SetTransObject(SQLCA)

    #             lstr_bu_mo_summary.db[1] = astr_pass.db[4]
    #             lstr_bu_mo_summary.db[2] = astr_pass.db[5]

    #             ll_bu_mo_summary = gnv_data_access_service.retrieve(lds_bu_mo_summary, lds_bu_mo_summary, "Bcms_l", lstr_bu_mo_summary)

    #             IF ll_bu_mo_summary> 0 THEN
    #                             lds_bu_mo_summary.RowsCopy(lds_bu_mo_summary.GetRow(), lds_bu_mo_summary.RowCount(), Primary!, lds_bu_mo_summary_copy, 1, Primary!)
    #                             FOR ll_bu_mo_summary_ctr = 1 TO lds_bu_mo_summary_copy.Rowcount()
    #                                             lds_bu_mo_summary_copy.SetItem(ll_bu_mo_summary_ctr, 'bwiz_run_id', ldb_run_id)
    #                                             IF astr_pass.s[1] <> 'E' THEN
    #                                                             lds_bu_mo_summary_copy.SetItem(ll_bu_mo_summary_ctr, 'bu_sum_result', lstr_pass_bdgt.db[8])
    #                                             END IF
    #                             NEXT
    #             END IF

    #             lstr_bu_mo_summary.db[1] = ldb_run_id
    #             li_bu_mo_summary_copy = gnv_data_access_service.update_service(lds_bu_mo_summary_copy, lds_bu_mo_summary_copy, "Bcms_u", lstr_bu_mo_summary)

    #             DESTROY lds_bu_mo_summary
    #             DESTROY lds_bu_mo_summary_copy

    #             //Need to update Bwiz Eliigibility Indicator to identify the applied sanction on budget used when displaying the zero Grant Amount on Detail Tab.
    #             String ls_elig_ind
    #             ls_elig_ind = 'S' + astr_pass.s[1] //Add S for all Sanction Eligibility Indicator
    #             IF ldb_run_id > 0 THEN //10.01B
    #                             This.of_update_cat_elig_in (ldb_run_id, astr_pass.db[5], ls_elig_ind, 'NOTREQ' )
    #             END IF

    # END IF

    # DESTROY lds_bdgt_sum_tea

    # lstr_pass_bdgt.s[1] = astr_pass.s[1] //10.01B - Need to return the proper value of Sanction Indicator, since online interface is setting it to Null when Old sanction has ended.

    # RETURN lstr_pass_bdgt

    end

    def self.verify_sanction_nonprogtype(astr_pass)
    #             //************************************************************************
    # //*  10.01A        08/16/2007 ANSWER                    Evangeline L. Gutierez
    # //*  PCR#74054 - Created this function for Identifying Non Progressive Type Sanction.
    # //*
    # //*  Parameters:astr_pass
    # //*                      db[1] = Budget Unit ID
    # //*                      db[2] = Run ID
    # //*     db[3] = Month ID
    # //*     db[4] = Service Program ID
    # //*     s[1] = Sanction Flag
    # //*     dates[1] = Run Month
    # //*
    # //* Return Values: lstr_return
    # //*    s[1] = Sanction Indicator
    # //*    s[2] = Sanction Flag
    # //************************************************************************

    # str_pass                                                                           lstr_return, lstr_pass_tea_sanction, lstr_passref, lstr_pass_relationship
    # ds_tea_sanction                           lds_tea_sanction
    # ds_reference_table    lds_reference_table
    # ds_bu_comp_rel                          lds_bu_comp_rel
    # Long                                                                                   ll_san_type_prg, ll_clientid, ll_relation_rows
    # String                                                                                 ls_filter, ls_sanction_type_prg, ls_sanction_type, ls_bu_relationship, ls_sanction, ls_sanction_indicator = 'N'
    # Integer                                                                             li_filter_count, li_cnt
    # Date                                                                                   ld_sanction_begin, ld_sanction_end

    # ls_sanction = astr_pass.s[1]
    # //Set up "Sanction Type which are progressive in nature"
    # lds_tea_sanction = CREATE ds_tea_sanction
    # lds_tea_sanction.SetTransObject(SQLCA)

    # lstr_pass_tea_sanction.db[1] = astr_pass.db[2] //Run ID
    # lstr_pass_tea_sanction.db[2] = astr_pass.db[3] //Month ID
    # lstr_pass_tea_sanction.db[3] = astr_pass.db[4] //Service Program ID

    # gnv_data_access_service.retrieve(lds_tea_sanction,lds_tea_sanction,"Bcts_l", lstr_pass_tea_sanction)

    # lds_reference_table = CREATE ds_reference_table
    # lds_reference_table.SetTransObject(SQLCA)
    # lstr_passref.s[1] = "130"    // domain code value (key) for Sanction Type Progressive
    # ll_san_type_prg = gnv_data_access_service.retrieve(lds_reference_table,lds_reference_table, "Rddw_l", lstr_passref)
    # ls_filter = " "
    # ll_san_type_prg = 1
    # For ll_san_type_prg = 1 to lds_reference_table.rowcount()
    #             ls_sanction_type_prg =                trim(lds_reference_table.getitemstring(ll_san_type_prg,"value"))
    #             if ll_san_type_prg = lds_reference_table.rowcount() then
    #                             ls_filter = ls_filter + "type <> '" + ls_sanction_type_prg + "'"
    #             else
    #                             ls_filter = ls_filter + "type <> '" + ls_sanction_type_prg + "' and "
    #             end if
    # Next
    # DESTROY lds_reference_table

    # //ls_filter = "type <> '28' and type <> 'MP' and type <> '32' and type <> '34' and type <> '31'"
    # lds_tea_sanction.setfilter(ls_filter)
    # lds_tea_sanction.filter()
    # li_filter_count = lds_tea_sanction.rowcount()

    # IF li_filter_count > 0 THEN
    #             li_cnt = 1
    #             Do While ls_sanction = 'N' and li_cnt <= li_filter_count // Loop until found valid Non-Progressive Sanction
    #                             ll_clientid = lds_tea_sanction.getitemnumber(li_cnt,"clientid")
    #                             ls_sanction_type =  lds_tea_sanction.getitemstring(li_cnt,"type")
    #                             ls_filter = "client_id = " + string(ll_clientid)
    #                             lstr_pass_relationship.db[1] = double(ll_clientid)
    #                             lstr_pass_relationship.db[2] = astr_pass.db[1]

    #                             lds_bu_comp_rel = Create ds_bu_comp_rel
    #                             lds_bu_comp_rel.SetTransObject(SQLCA)

    #                             ll_relation_rows = gnv_data_access_service.retrieve(lds_bu_comp_rel, lds_bu_comp_rel , "Bcbt_l", lstr_pass_relationship)

    #                             IF ll_relation_rows > 0 THEN
    #                                             ls_bu_relationship = lds_bu_comp_rel .GetItemString(1, "t_budget_unit_comp_relationship")
    #                                             IF ls_bu_relationship = '00' THEN
    #                                                             ld_sanction_begin = Date(lds_tea_sanction.GetItemDateTime(li_cnt,"effective_beg_date"))
    #                                                             ld_sanction_end = Date(lds_tea_sanction.GetItemDateTime(li_cnt,"expiration_date"))
    #                                                             Choose Case Year(ld_sanction_begin)
    #                                                                             Case Year(astr_pass.dates[1])
    #                                                                                             If Month(ld_sanction_begin) <= Month(astr_pass.dates[1]) then
    #                                                                                                             ls_sanction = "Y"
    #                                                                                             Else
    #                                                                                                             ls_sanction = "N"
    #                                                                                             End if
    #                                                                             Case Is < Year(astr_pass.dates[1])
    #                                                                                             ls_sanction = "Y"
    #                                                                             Case Is > Year(astr_pass.dates[1])
    #                                                                                             ls_sanction = "N"
    #                                                             End Choose

    #                                                             If ls_sanction = 'Y' then
    #                                                                             Choose Case Year(ld_sanction_end)
    #                                                                                             Case Year(astr_pass.dates[1])
    #                                                                                                             If Month(ld_sanction_end) >= Month(astr_pass.dates[1]) then
    #                                                                                                                             ls_sanction = "Y"
    #                                                                                                             Else
    #                                                                                                                             ls_sanction = "N"
    #                                                                                                             End if
    #                                                                                             Case Is < Year(astr_pass.dates[1])
    #                                                                                                             ls_sanction = "N"
    #                                                                                             Case Is > Year(astr_pass.dates[1])
    #                                                                                                             ls_sanction = "Y"
    #                                                                                             End Choose
    #                                                             End if
    #                                             END IF
    #                             END IF
    #                             Destroy lds_bu_comp_rel

    #                             CHOOSE CASE ls_sanction_type
    #                                             CASE '26'
    #                                                             ls_sanction_indicator = 'C'
    #                                             CASE 'IM'
    #                                                             ls_sanction_indicator = 'I'
    #                                             CASE '33'
    #                                                             ls_sanction_indicator = 'P'
    #                                             CASE ELSE
    #                                                             ls_sanction_indicator = 'N'
    #                             END CHOOSE
    #                             li_cnt = li_cnt + 1
    #             LOOP
    # END IF

    # //10.01D - 09-07-07
    # IF ls_sanction = 'N' THEN
    #             ls_sanction_indicator = 'N'
    # END IF

    # lstr_return.s[1]             = ls_sanction_indicator
    # lstr_return.s[2]             = ls_sanction

    # RETURN lstr_return
    # end function

    # public function str_pass of_tea_sanction_retro (str_pass astr_pass);//************************************************************************
    # //*  10.01A        08/16/2007 ANSWER                    Evangeline L. Gutierez
    # //*  PCR#74054 - Created this function to get the Retro Amount for TEA Sanction.
    # //*
    # //* Parameters:
    # //*  astr_pass.db[1]                    = Budget Unit ID
    # //*  astr_pass.db[2]                    = Service Program Id
    # //*  astr_pass.db[3]                    = Client ID
    # //*  astr_pass.dates[1]              = Sanction Month
    # //*  astr_pass.s[1]                       = Sanction Indicator
    # //*  astr_pass.s[2]                       = Release Indicator
    # //* Return Values:
    # //*      lstr_pass_bdgt.db[1] = Run ID
    # //*     lstr_pass_bdgt.db[2] = Month ID
    # //*      lstr_pass_bdgt.db[3] = full_benefit
    # //*     lstr_pass_bdgt.db[4] = reduction
    # //*                      lstr_pass_bdgt.db[5] = sanction
    # //*                      lstr_pass_bdgt.db[6] = tea_benefit_amount
    # //*                      lstr_pass_bdgt.s[1] = Sanction Indicator
    # //*                      lstr_pass_bdgt.s[2] = Sanction Flag (Y/N)
    # //************************************************************************

    # //n_ds lds_bdgt_sum_tea
    # //str_pass lstr_pass_bdgt
    # //Long ll_bdgt_return
    # //
    # //lds_bdgt_sum_tea = CREATE n_ds
    # //lds_bdgt_sum_tea.DataObject = 'dw_bdgt_unit_sum_tea'
    # //lds_bdgt_sum_tea.SetTransObject(SQLCA)
    # //
    # //lstr_pass_bdgt.db[1] = astr_pass.db[1] //Run ID
    # //lstr_pass_bdgt.db[2] = astr_pass.db[2] //Month ID
    # //
    # //ll_bdgt_return = gnv_data_access_service.retrieve(lds_bdgt_sum_tea, lds_bdgt_sum_tea, "Buta_l", lstr_pass_bdgt)
    # //
    # //IF ll_bdgt_return >  0 THEN
    # //        lstr_pass_bdgt.db[3] = lds_bdgt_sum_tea.GetItemNumber(1, 'full_benefit')
    # //        lstr_pass_bdgt.db[4] = lds_bdgt_sum_tea.GetItemNumber(1, 'reduction')
    # //        lstr_pass_bdgt.db[5] = lds_bdgt_sum_tea.GetItemNumber(1, 'sanction')
    # //        lstr_pass_bdgt.db[6] = lds_bdgt_sum_tea.GetItemNumber(1, 'tea_benefit_amount')
    # //        lstr_pass_bdgt.db[7] = lds_bdgt_sum_tea.GetItemNumber(1, 'elig_tot_adjusted')
    # //END IF
    # //
    # //DESTROY lds_bdgt_sum_tea

    # //******* Take the Run ID and Month ID *********************//

    # n_ds lds_bud_month
    # Long ll_row
    # str_pass lstr_pass, lstr_pass_bdgt
    # String ls_filter
    # Date ldt_cutoff_date, ld_bwiz_run_month

    # lds_bud_month = Create ds_bud_month
    # lds_bud_month.SetTransObject(SQLCA)

    # lstr_pass.db[1] = astr_pass.db[1]
    # ll_row = gnv_data_access_service.retrieve(lds_bud_month, lds_bud_month, "Bump_l", lstr_pass)

    # //10.01D //09-04-07
    # IF ll_row > 0 THEN
    #             lds_bud_month.SetSort("txn_success_date A")
    #             lds_bud_month.Sort()
    #             ll_row = lds_bud_month.RowCount()
    #             IF ll_row > 0 THEN
    #                             lstr_pass.dt[1] = lds_bud_month.GetItemDateTime(ll_row,'txn_success_date')
    #                             lstr_pass.db[2] = 0 //Intialized Run ID = 0
    #                             lstr_pass.db[3] = 0 //Intialized Month ID = 0

    #                             //Check for the last 6 working day
    #                              gnv_app.of_get_cutoffdate(astr_pass.db[2], RelativeDate(astr_pass.dates[1], -1), ldt_cutoff_date)

    #                             DO WHILE ll_row > 0
    #                                             IF Date(lstr_pass.dt[1]) <= ldt_cutoff_date THEN
    #                                                             lstr_pass.db[2] = lds_bud_month.GetItemNumber(ll_row,'bwiz_run_id')
    #                                                             lstr_pass.db[3] = lds_bud_month.GetItemNumber(ll_row,'bwiz_mo_id')
    #                                                             ld_bwiz_run_month = lds_bud_month.GetItemDate(ll_row,'bwiz_run_month')
    #                                                             IF ld_bwiz_run_month <= ldt_cutoff_date THEN
    #                                                                             EXIT
    #                                                             END IF
    #                                             END IF
    #                                             ll_row = ll_row - 1
    #                                             IF ll_row > 0 THEN
    #                                                             lstr_pass.dt[1] = lds_bud_month.GetItemDateTime(ll_row,'txn_success_date')                   //10.01C
    #                                             END IF
    #                             LOOP
    #             END IF
    # END IF

    # lstr_pass_bdgt.db[1] = lstr_pass.db[2]
    # lstr_pass_bdgt.db[2] = lstr_pass.db[3]

    # //IF ll_row > 0 THEN
    # //        //Find for the Sanction Month
    # //        ls_filter =  "bwiz_run_month = " + String(astr_pass.dates[1])
    # //        lds_bud_month.SetFilter("")
    # //        lds_bud_month.Filter()
    # //        lds_bud_month.SetFilter(ls_filter)
    # //        lds_bud_month.Filter()
    # //        IF lds_bud_month.RowCount() > 0 THEN //Successfully Submited
    # //                        lds_bud_month.SetSort("txn_success_date A")
    # //                        lds_bud_month.Sort()
    # //                        ll_row = lds_bud_month.RowCount()
    # //        END IF
    # //
    # //        IF ll_row > 0 THEN
    # //                        lstr_pass_bdgt.db[1] = lds_bud_month.GetItemNumber(ll_row,'bwiz_run_id')
    # //                        lstr_pass_bdgt.db[2] = lds_bud_month.GetItemNumber(ll_row,'bwiz_mo_id')
    # //        END IF
    # //END IF

    # DESTROY lds_bud_month

    # //******** Verify Non Porgressive Sanction ******************//

    # str_pass lstr_sanction_nonprogtype_pass, lstr_sanction_nonprogtype_return

    # lstr_sanction_nonprogtype_pass.db[1] = astr_pass.db[1]                                         // Budget Unit ID
    # lstr_sanction_nonprogtype_pass.db[2] = lstr_pass_bdgt.db[1]              // Run ID
    # lstr_sanction_nonprogtype_pass.db[3] = lstr_pass_bdgt.db[2]              // Month ID
    # lstr_sanction_nonprogtype_pass.db[4] = astr_pass.db[2]                                         // Service Program ID
    # lstr_sanction_nonprogtype_pass.s[1] = 'N'                                                                                                                      // Sanction Flag
    # lstr_sanction_nonprogtype_pass.dates[1] = astr_pass.dates[1]             //Run Month

    # lstr_sanction_nonprogtype_return = of_verify_sanction_nonprogtype(lstr_sanction_nonprogtype_pass)
    # lstr_pass_bdgt.s[1] = lstr_sanction_nonprogtype_return.s[1]                 //New Sanction Indicator
    # lstr_pass_bdgt.s[2] = lstr_sanction_nonprogtype_return.s[2]                 //New Sanction Flag
    # astr_pass.s[1] = lstr_sanction_nonprogtype_return.s[1]           //New Sanction Indicator

    # //******** Call Function to Recalculate Benefit for TEA based on Sanction Applied *****************//

    # Double ldb_sanction_percent

    # IF lstr_pass_bdgt.s[2] = 'Y' THEN
    #             IF astr_pass.s[1] = 'F' THEN
    #                             ldb_sanction_percent = 50
    #             ELSE
    #                             ldb_sanction_percent = 25
    #             END IF
    # END IF

    # astr_pass.db[4] = lstr_pass_bdgt.db[1] //Run ID
    # astr_pass.db[5] = lstr_pass_bdgt.db[2] //Month ID
    # astr_pass.db[6] = ldb_sanction_percent //Sanction Percent

    # //lstr_pass_bdgt = of_recalc_benefit_for_tea(astr_pass) // do not call this function directly, it creates budget record

    # Decimal{2}       ldc_tot_gross_inc, ldc_teapartial_grant, ldc_sanctionpartial_grant, ldc_sanction, ldc_sanctionfull_grant
    # Long                                   ll_bdgt_return, ll_red_tea_grant_rows, ll_sanctionfull_rows
    # str_pass                           lstr_bu_size, lstr_red_tea_grant, lstr_sanctionfull_grant
    # Integer                             li_bu_size_rows, li_bu_size
    # String                                 ls_reduced, ls_sanction='N'
    # n_ds                                  lds_bdgt_sum_tea, lds_bu_size
    # ds_tea_grant_amount lds_red_tea_grant_amount

    # lds_bdgt_sum_tea = CREATE n_ds
    # lds_bdgt_sum_tea.DataObject = 'dw_bdgt_unit_sum_tea'
    # lds_bdgt_sum_tea.SetTransObject(SQLCA)

    # lstr_pass_bdgt.db[1] = astr_pass.db[4]
    # lstr_pass_bdgt.db[2] = astr_pass.db[5]

    # ll_bdgt_return = gnv_data_access_service.retrieve(lds_bdgt_sum_tea, lds_bdgt_sum_tea, "Buta_l", lstr_pass_bdgt)

    # IF ll_bdgt_return >  0 THEN
    #             lstr_pass_bdgt.db[3] = lds_bdgt_sum_tea.GetItemNumber(1, 'full_benefit')
    #             lstr_pass_bdgt.db[4] = lds_bdgt_sum_tea.GetItemNumber(1, 'reduction')
    #             lstr_pass_bdgt.db[5] = lds_bdgt_sum_tea.GetItemNumber(1, 'sanction')
    #             lstr_pass_bdgt.db[6] = lds_bdgt_sum_tea.GetItemNumber(1, 'program_benefit_amount')
    #             ldc_tot_gross_inc = lds_bdgt_sum_tea.GetItemNumber(1, 'elig_tot_adjusted')

    #             //Recalculate benefit amount based on new sanction applied
    #             IF astr_pass.db[6] > 0 THEN //Sanction Percent
    #                             //** Take the Budget Unit Size of the last submitted budget
    #                             lstr_bu_size.db[1] = astr_pass.db[4]
    #                             lstr_bu_size.db[2] = astr_pass.db[5]

    #                             lds_bu_size = CREATE n_ds
    #                             lds_bu_size.DataObject = 'dw_bud_totals'
    #                             lds_bu_size.SetTransObject(SQLCA)
    #                             li_bu_size_rows = gnv_data_access_service.retrieve(lds_bu_size, lds_bu_size, "Busp_l", lstr_bu_size)

    #                             IF li_bu_size_rows > 0 THEN
    #                                             li_bu_size = lds_bu_size.GetItemNumber(1, "budget_unit_size")
    #                             END IF

    #                             DESTROY lds_bu_size

    #                             IF li_bu_size > 9 THEN
    #                                             lstr_red_tea_grant.db[1] = 9
    #                             ELSE
    #                                             lstr_red_tea_grant.db[1] = li_bu_size   //budget unit size
    #                             END IF

    #                             lds_red_tea_grant_amount = CREATE ds_tea_grant_amount
    #                             lds_red_tea_grant_amount.SetTransObject(SQLCA)

    #                             lstr_red_tea_grant.s[1] = string(astr_pass.dates[1])  //Run month
    #                             lstr_red_tea_grant.s[2] = "35"          //TEA Partial Grant (50% of TEA Full Grant)

    #                             //Retrieve the grant amount by unit size
    #                             ll_red_tea_grant_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l", lstr_red_tea_grant)

    #                             IF ll_red_tea_grant_rows > 0 THEN
    #                                             ldc_teapartial_grant = lds_red_tea_grant_amount.GetItemNumber(1,"bus_limit_amount")
    #                             ELSE
    #                                             MessageBox(gnv_app.iapp_object.DisplayName,"There is no PARTIAL GRANT standard set up for this budget unit size.")
    #                                             ldc_teapartial_grant = 0
    #                             END IF

    #                             lstr_red_tea_grant.s[2] = '45' //Sanction Partial Grant (50% of Sanction Full 25% Grant)

    #                             If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
    #                                             ll_red_tea_grant_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l",lstr_red_tea_grant)
    #                             Else
    #                                             ll_red_tea_grant_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l",lstr_pass)
    #                             End If

    #                             IF ll_red_tea_grant_rows > 0 THEN
    #                                             ldc_sanctionpartial_grant = lds_red_tea_grant_amount.GetItemNumber(1,"bus_limit_amount")
    #                             ELSE
    #                                             MessageBox(gnv_app.iapp_object.DisplayName,"There is no SANCTION standard set up for this budget unit size.")
    #                                             ldc_sanction = 0
    #                             END IF

    #                             IF ldc_tot_gross_inc > lstr_pass_bdgt.db[3] THEN
    #                                             ls_reduced = 'Y'
    #                             Else
    #                                             ls_reduced = 'N'
    #                             End if

    #                             IF astr_pass.s[1] = 'N' THEN
    #                                             ls_sanction = 'N'
    #                             ELSE
    #                                             ls_sanction = 'Y'
    #                             END IF

    #                             IF astr_pass.s[1] = 'E' THEN
    #                                             //No need to recalculate
    #                                             lstr_pass_bdgt.db[7] = lstr_pass_bdgt.db[5] //Sanction
    #                                             lstr_pass_bdgt.db[8] = lstr_pass_bdgt.db[6] //Grant Amount
    #                                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[4] //Reduction
    #                             ELSE
    #                                             If ls_reduced = 'Y' and ls_sanction = 'Y' then
    #                                                             IF astr_pass.db[6] = 50 THEN
    #                                                                             ldc_sanctionpartial_grant = round((ldc_teapartial_grant * .50),0)
    #                                                             END IF

    #                                                             lstr_pass_bdgt.db[8] = ldc_sanctionpartial_grant //Grant Amount
    #                                                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[3] - ldc_teapartial_grant //Full Grant - Partial Grant
    #                                                             lstr_pass_bdgt.db[7] = lstr_pass_bdgt.db[3] - lstr_pass_bdgt.db[9] - lstr_pass_bdgt.db[8] //FullGrant - Reduction - Sanction

    #                                             Elseif ls_reduced = 'Y' then

    #                                                             lstr_pass_bdgt.db[8] = ldc_teapartial_grant
    #                                                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[3] - ldc_teapartial_grant
    #                                                             lstr_pass_bdgt.db[7] = 0

    #                                             Elseif ls_sanction = 'Y' then

    #                                                             IF li_bu_size > 9 THEN
    #                                                                             lstr_sanctionfull_grant.db[1] = 9
    #                                                             ELSE
    #                                                                             lstr_sanctionfull_grant.db[1] = li_bu_size
    #                                                             END IF
    #                                                             lstr_sanctionfull_grant.s[1] = string(astr_pass.dates[1])
    #                                                             lstr_sanctionfull_grant.s[2] = '40'

    #                                                             ll_sanctionfull_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l", lstr_sanctionfull_grant)

    #                                                             IF ll_sanctionfull_rows > 0 THEN
    #                                                                             ldc_sanctionfull_grant = lds_red_tea_grant_amount.GetItemNumber(1,"bus_limit_amount")
    #                                                             Else
    #                                                                             MessageBox(gnv_app.iapp_object.DisplayName,"There is no SANCTION standard set up for this budget unit size.")
    #                                                                             ldc_sanction = 0
    #                                                             End if

    #                                                             IF astr_pass.db[6] = 50 THEN
    #                                                                             ldc_sanctionfull_grant = round((lstr_pass_bdgt.db[3] * .50),0)
    #                                                             END IF

    #                                                             lstr_pass_bdgt.db[8]  = ldc_sanctionfull_grant //Grant Amount
    #                                                             lstr_pass_bdgt.db[9] = 0 //Reduction
    #                                                             lstr_pass_bdgt.db[7] = lstr_pass_bdgt.db[3] - ldc_sanctionfull_grant //Full Grant - Sanction

    #                                             Else
    #                                                             lstr_pass_bdgt.db[7] = 0
    #                                                             lstr_pass_bdgt.db[8] = lstr_pass_bdgt.db[3]
    #                                                             lstr_pass_bdgt.db[9] = 0
    #                                             End if
    #                             END IF
    #             ELSE
    #                             //When Sanction Flag = N; Full Grant Amount Should be send without applied sanction
    #                             lstr_pass_bdgt.db[8] = lstr_pass_bdgt.db[3]
    #                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[4]
    #                             lstr_pass_bdgt.db[7] = 0 //10.01B
    #             END IF
    #             DESTROY lds_red_tea_grant_amount
    # END IF

    # DESTROY lds_bdgt_sum_tea

    # RETURN lstr_pass_bdgt
    end

    def self.tea_sanction_retro(astr_pass)


    # //******* Take the Run ID and Month ID *********************//

    # n_ds lds_bud_month
    # Long ll_row
    # str_pass lstr_pass, lstr_pass_bdgt
    # String ls_filter
    # Date ldt_cutoff_date, ld_bwiz_run_month

    # lds_bud_month = Create ds_bud_month
    # lds_bud_month.SetTransObject(SQLCA)

    # lstr_pass.db[1] = astr_pass.db[1]
    # ll_row = gnv_data_access_service.retrieve(lds_bud_month, lds_bud_month, "Bump_l", lstr_pass)

    # //10.01D //09-04-07
    # IF ll_row > 0 THEN
    #             lds_bud_month.SetSort("txn_success_date A")
    #             lds_bud_month.Sort()
    #             ll_row = lds_bud_month.RowCount()
    #             IF ll_row > 0 THEN
    #                             lstr_pass.dt[1] = lds_bud_month.GetItemDateTime(ll_row,'txn_success_date')
    #                             lstr_pass.db[2] = 0 //Intialized Run ID = 0
    #                             lstr_pass.db[3] = 0 //Intialized Month ID = 0

    #                             //Check for the last 6 working day
    #                              gnv_app.of_get_cutoffdate(astr_pass.db[2], RelativeDate(astr_pass.dates[1], -1), ldt_cutoff_date)

    #                             DO WHILE ll_row > 0
    #                                             IF Date(lstr_pass.dt[1]) <= ldt_cutoff_date THEN
    #                                                             lstr_pass.db[2] = lds_bud_month.GetItemNumber(ll_row,'bwiz_run_id')
    #                                                             lstr_pass.db[3] = lds_bud_month.GetItemNumber(ll_row,'bwiz_mo_id')
    #                                                             ld_bwiz_run_month = lds_bud_month.GetItemDate(ll_row,'bwiz_run_month')
    #                                                             IF ld_bwiz_run_month <= ldt_cutoff_date THEN
    #                                                                             EXIT
    #                                                             END IF
    #                                             END IF
    #                                             ll_row = ll_row - 1
    #                                             IF ll_row > 0 THEN
    #                                                             lstr_pass.dt[1] = lds_bud_month.GetItemDateTime(ll_row,'txn_success_date')                   //10.01C
    #                                             END IF
    #                             LOOP
    #             END IF
    # END IF

    # lstr_pass_bdgt.db[1] = lstr_pass.db[2]
    # lstr_pass_bdgt.db[2] = lstr_pass.db[3]



    # DESTROY lds_bud_month

    # //******** Verify Non Porgressive Sanction ******************//

    # str_pass lstr_sanction_nonprogtype_pass, lstr_sanction_nonprogtype_return

    # lstr_sanction_nonprogtype_pass.db[1] = astr_pass.db[1]                                         // Budget Unit ID
    # lstr_sanction_nonprogtype_pass.db[2] = lstr_pass_bdgt.db[1]              // Run ID
    # lstr_sanction_nonprogtype_pass.db[3] = lstr_pass_bdgt.db[2]              // Month ID
    # lstr_sanction_nonprogtype_pass.db[4] = astr_pass.db[2]                                         // Service Program ID
    # lstr_sanction_nonprogtype_pass.s[1] = 'N'                                                                                                                      // Sanction Flag
    # lstr_sanction_nonprogtype_pass.dates[1] = astr_pass.dates[1]             //Run Month

    # lstr_sanction_nonprogtype_return = of_verify_sanction_nonprogtype(lstr_sanction_nonprogtype_pass)
    # lstr_pass_bdgt.s[1] = lstr_sanction_nonprogtype_return.s[1]                 //New Sanction Indicator
    # lstr_pass_bdgt.s[2] = lstr_sanction_nonprogtype_return.s[2]                 //New Sanction Flag
    # astr_pass.s[1] = lstr_sanction_nonprogtype_return.s[1]           //New Sanction Indicator

    # //******** Call Function to Recalculate Benefit for TEA based on Sanction Applied *****************//

    # Double ldb_sanction_percent

    # IF lstr_pass_bdgt.s[2] = 'Y' THEN
    #             IF astr_pass.s[1] = 'F' THEN
    #                             ldb_sanction_percent = 50
    #             ELSE
    #                             ldb_sanction_percent = 25
    #             END IF
    # END IF

    # astr_pass.db[4] = lstr_pass_bdgt.db[1] //Run ID
    # astr_pass.db[5] = lstr_pass_bdgt.db[2] //Month ID
    # astr_pass.db[6] = ldb_sanction_percent //Sanction Percent

    # //lstr_pass_bdgt = of_recalc_benefit_for_tea(astr_pass) // do not call this function directly, it creates budget record

    # Decimal{2}       ldc_tot_gross_inc, ldc_teapartial_grant, ldc_sanctionpartial_grant, ldc_sanction, ldc_sanctionfull_grant
    # Long                                   ll_bdgt_return, ll_red_tea_grant_rows, ll_sanctionfull_rows
    # str_pass                           lstr_bu_size, lstr_red_tea_grant, lstr_sanctionfull_grant
    # Integer                             li_bu_size_rows, li_bu_size
    # String                                 ls_reduced, ls_sanction='N'
    # n_ds                                  lds_bdgt_sum_tea, lds_bu_size
    # ds_tea_grant_amount lds_red_tea_grant_amount

    # lds_bdgt_sum_tea = CREATE n_ds
    # lds_bdgt_sum_tea.DataObject = 'dw_bdgt_unit_sum_tea'
    # lds_bdgt_sum_tea.SetTransObject(SQLCA)

    # lstr_pass_bdgt.db[1] = astr_pass.db[4]
    # lstr_pass_bdgt.db[2] = astr_pass.db[5]

    # ll_bdgt_return = gnv_data_access_service.retrieve(lds_bdgt_sum_tea, lds_bdgt_sum_tea, "Buta_l", lstr_pass_bdgt)

    # IF ll_bdgt_return >  0 THEN
    #             lstr_pass_bdgt.db[3] = lds_bdgt_sum_tea.GetItemNumber(1, 'full_benefit')
    #             lstr_pass_bdgt.db[4] = lds_bdgt_sum_tea.GetItemNumber(1, 'reduction')
    #             lstr_pass_bdgt.db[5] = lds_bdgt_sum_tea.GetItemNumber(1, 'sanction')
    #             lstr_pass_bdgt.db[6] = lds_bdgt_sum_tea.GetItemNumber(1, 'program_benefit_amount')
    #             ldc_tot_gross_inc = lds_bdgt_sum_tea.GetItemNumber(1, 'elig_tot_adjusted')

    #             //Recalculate benefit amount based on new sanction applied
    #             IF astr_pass.db[6] > 0 THEN //Sanction Percent
    #                             //** Take the Budget Unit Size of the last submitted budget
    #                             lstr_bu_size.db[1] = astr_pass.db[4]
    #                             lstr_bu_size.db[2] = astr_pass.db[5]

    #                             lds_bu_size = CREATE n_ds
    #                             lds_bu_size.DataObject = 'dw_bud_totals'
    #                             lds_bu_size.SetTransObject(SQLCA)
    #                             li_bu_size_rows = gnv_data_access_service.retrieve(lds_bu_size, lds_bu_size, "Busp_l", lstr_bu_size)

    #                             IF li_bu_size_rows > 0 THEN
    #                                             li_bu_size = lds_bu_size.GetItemNumber(1, "budget_unit_size")
    #                             END IF

    #                             DESTROY lds_bu_size

    #                             IF li_bu_size > 9 THEN
    #                                             lstr_red_tea_grant.db[1] = 9
    #                             ELSE
    #                                             lstr_red_tea_grant.db[1] = li_bu_size   //budget unit size
    #                             END IF

    #                             lds_red_tea_grant_amount = CREATE ds_tea_grant_amount
    #                             lds_red_tea_grant_amount.SetTransObject(SQLCA)

    #                             lstr_red_tea_grant.s[1] = string(astr_pass.dates[1])  //Run month
    #                             lstr_red_tea_grant.s[2] = "35"          //TEA Partial Grant (50% of TEA Full Grant)

    #                             //Retrieve the grant amount by unit size
    #                             ll_red_tea_grant_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l", lstr_red_tea_grant)

    #                             IF ll_red_tea_grant_rows > 0 THEN
    #                                             ldc_teapartial_grant = lds_red_tea_grant_amount.GetItemNumber(1,"bus_limit_amount")
    #                             ELSE
    #                                             MessageBox(gnv_app.iapp_object.DisplayName,"There is no PARTIAL GRANT standard set up for this budget unit size.")
    #                                             ldc_teapartial_grant = 0
    #                             END IF

    #                             lstr_red_tea_grant.s[2] = '45' //Sanction Partial Grant (50% of Sanction Full 25% Grant)

    #                             If gs_connect_type = "CICS" or gs_connect_type = "TP" Then
    #                                             ll_red_tea_grant_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l",lstr_red_tea_grant)
    #                             Else
    #                                             ll_red_tea_grant_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l",lstr_pass)
    #                             End If

    #                             IF ll_red_tea_grant_rows > 0 THEN
    #                                             ldc_sanctionpartial_grant = lds_red_tea_grant_amount.GetItemNumber(1,"bus_limit_amount")
    #                             ELSE
    #                                             MessageBox(gnv_app.iapp_object.DisplayName,"There is no SANCTION standard set up for this budget unit size.")
    #                                             ldc_sanction = 0
    #                             END IF

    #                             IF ldc_tot_gross_inc > lstr_pass_bdgt.db[3] THEN
    #                                             ls_reduced = 'Y'
    #                             Else
    #                                             ls_reduced = 'N'
    #                             End if

    #                             IF astr_pass.s[1] = 'N' THEN
    #                                             ls_sanction = 'N'
    #                             ELSE
    #                                             ls_sanction = 'Y'
    #                             END IF

    #                             IF astr_pass.s[1] = 'E' THEN
    #                                             //No need to recalculate
    #                                             lstr_pass_bdgt.db[7] = lstr_pass_bdgt.db[5] //Sanction
    #                                             lstr_pass_bdgt.db[8] = lstr_pass_bdgt.db[6] //Grant Amount
    #                                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[4] //Reduction
    #                             ELSE
    #                                             If ls_reduced = 'Y' and ls_sanction = 'Y' then
    #                                                             IF astr_pass.db[6] = 50 THEN
    #                                                                             ldc_sanctionpartial_grant = round((ldc_teapartial_grant * .50),0)
    #                                                             END IF

    #                                                             lstr_pass_bdgt.db[8] = ldc_sanctionpartial_grant //Grant Amount
    #                                                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[3] - ldc_teapartial_grant //Full Grant - Partial Grant
    #                                                             lstr_pass_bdgt.db[7] = lstr_pass_bdgt.db[3] - lstr_pass_bdgt.db[9] - lstr_pass_bdgt.db[8] //FullGrant - Reduction - Sanction

    #                                             Elseif ls_reduced = 'Y' then

    #                                                             lstr_pass_bdgt.db[8] = ldc_teapartial_grant
    #                                                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[3] - ldc_teapartial_grant
    #                                                             lstr_pass_bdgt.db[7] = 0

    #                                             Elseif ls_sanction = 'Y' then

    #                                                             IF li_bu_size > 9 THEN
    #                                                                             lstr_sanctionfull_grant.db[1] = 9
    #                                                             ELSE
    #                                                                             lstr_sanctionfull_grant.db[1] = li_bu_size
    #                                                             END IF
    #                                                             lstr_sanctionfull_grant.s[1] = string(astr_pass.dates[1])
    #                                                             lstr_sanctionfull_grant.s[2] = '40'

    #                                                             ll_sanctionfull_rows = gnv_data_access_service.retrieve(lds_red_tea_grant_amount,lds_red_tea_grant_amount,"Bctg_l", lstr_sanctionfull_grant)

    #                                                             IF ll_sanctionfull_rows > 0 THEN
    #                                                                             ldc_sanctionfull_grant = lds_red_tea_grant_amount.GetItemNumber(1,"bus_limit_amount")
    #                                                             Else
    #                                                                             MessageBox(gnv_app.iapp_object.DisplayName,"There is no SANCTION standard set up for this budget unit size.")
    #                                                                             ldc_sanction = 0
    #                                                             End if

    #                                                             IF astr_pass.db[6] = 50 THEN
    #                                                                             ldc_sanctionfull_grant = round((lstr_pass_bdgt.db[3] * .50),0)
    #                                                             END IF

    #                                                             lstr_pass_bdgt.db[8]  = ldc_sanctionfull_grant //Grant Amount
    #                                                             lstr_pass_bdgt.db[9] = 0 //Reduction
    #                                                             lstr_pass_bdgt.db[7] = lstr_pass_bdgt.db[3] - ldc_sanctionfull_grant //Full Grant - Sanction

    #                                             Else
    #                                                             lstr_pass_bdgt.db[7] = 0
    #                                                             lstr_pass_bdgt.db[8] = lstr_pass_bdgt.db[3]
    #                                                             lstr_pass_bdgt.db[9] = 0
    #                                             End if
    #                             END IF
    #             ELSE
    #                             //When Sanction Flag = N; Full Grant Amount Should be send without applied sanction
    #                             lstr_pass_bdgt.db[8] = lstr_pass_bdgt.db[3]
    #                             lstr_pass_bdgt.db[9] = lstr_pass_bdgt.db[4]
    #                             lstr_pass_bdgt.db[7] = 0 //10.01B
    #             END IF
    #             DESTROY lds_red_tea_grant_amount
    # END IF

    # DESTROY lds_bdgt_sum_tea

    # RETURN lstr_pass_bdgt
    end

    def self.tea_sanction_retro_update(astr_pass)
    #             //************************************************************************
    # //*  10.01A        08/20/2007 ANSWER                    Evangeline L. Gutierez
    # //*  PCR#74054 - Created this function to update the Retro Amount for TEA Sanction.
    # //*
    # //* Parameters:
    # //*  astr_pass.db[1]                    = Run ID
    # //*  astr_pass.db[2]                    = Month ID
    # //*  astr_pass.db[3]                    = Sanction
    # //*  astr_pass.db[4]                    = Reducation
    # //*  astr_pass.db[5]                    = Grant Amount
    # //* Return Values:
    # //*      1 - Success
    # //************************************************************************

    # n_ds lds_tea_detail, lds_bu_mo_summary
    # str_pass lstr_tea_detail, lstr_bu_mo_summary
    # Long ll_tea_detail, ll_tea_detail_ctr, ll_bu_mo_summary, ll_bu_mo_summary_ctr
    # Integer li_tea_detail, li_bu_mo_summary

    # //** T_Tea_Detail
    # lds_tea_detail = CREATE n_ds
    # lds_tea_detail.DataObject = 'd_tea_detail'
    # lds_tea_detail.SetTransObject(SQLCA)

    # lstr_tea_detail.db[1] = astr_pass.db[1]
    # lstr_tea_detail.db[2] = astr_pass.db[2]

    # ll_tea_detail = gnv_data_access_service.retrieve(lds_tea_detail, lds_tea_detail, "Bctd_l", lstr_tea_detail)

    #  SELECT
    #                bwiz_run_id, bwiz_mo_id,
    #                elig_gross_earned,
    #                elig_work_deduct,
    #                elig_incent_deduct,
    #                elig_net_income,
    #                elig_tot_unearned,
    #                elig_tot_adjusted,
    #                ben_gross_earned,
    #                ben_work_deduction,
    #                ben_incent_deduct,
    #                ben_net_income,
    #                ben_total_unearned,
    #                ben_total_adjusted,
    #                full_benefit,
    #                reduction,
    #                sanction,
    #                program_benefit_amount,
    #                soc_sec_admin_amt,
    #                railroad_ret_amt,
    #                vet_asst_amt,
    #                other_unearned_inc,
    #                tea_income_limit,
    #                sanction_indicator
    #         FROM  t_tea_detail
    #         WHERE  bwiz_run_id = :rBctd_run_id AND
    #                bwiz_mo_id = :rBctd_month_id;


    # IF ll_tea_detail > 0 THEN
    #             FOR ll_tea_detail_ctr = 1 TO  ll_tea_detail
    #                             lds_tea_detail.SetItem(ll_tea_detail_ctr, 'sanction_indicator', astr_pass.s[1])
    #                             IF astr_pass.s[1] <> 'E' THEN
    #                                             lds_tea_detail.SetItem(ll_tea_detail_ctr, 'sanction', astr_pass.db[3])
    #                                             lds_tea_detail.SetItem(ll_tea_detail_ctr, 'reduction', astr_pass.db[4])
    #                                             lds_tea_detail.SetItem(ll_tea_detail_ctr, 'program_benefit_amount', astr_pass.db[5])
    #                             END IF
    #             NEXT
    # END IF

    # lstr_tea_detail.db[1] = astr_pass.db[1]
    # li_tea_detail = gnv_data_access_service.update_service(lds_tea_detail, lds_tea_detail, "Bctd_u", lstr_tea_detail)
    #  UPDATE t_tea_detail
    #       SET    elig_gross_earned    = :rBctd_elig_gross_earned,
    #              elig_work_deduct     = :rBctd_elig_work_deduct,
    #              elig_incent_deduct   = :rBctd_elig_incent_deduct,
    #              elig_net_income      = :rBctd_elig_net_income,
    #              elig_tot_unearned    = :rBctd_elig_tot_unearned,
    #              elig_tot_adjusted    = :rBctd_elig_tot_adjusted,
    #              ben_gross_earned     = :rBctd_ben_gross_earned,
    #              ben_work_deduction   = :rBctd_ben_work_deduction,
    #              ben_incent_deduct    = :rBctd_ben_incent_deduct,
    #              ben_net_income       = :rBctd_ben_net_income,
    #              ben_total_unearned   = :rBctd_ben_total_unearned,
    #              ben_total_adjusted   = :rBctd_ben_total_adjusted,
    #              full_benefit         = :rBctd_full_benefit,
    #              reduction            = :rBctd_reduction,
    #              sanction             = :rBctd_sanction,
    #              program_benefit_amount   = :rBctd_tea_benefit_amount,
    #              soc_sec_admin_amt    = :rBctd_soc_sec_admin_amt,
    #              railroad_ret_amt     = :rBctd_railroad_ret_amt,
    #              vet_asst_amt         = :rBctd_vet_asst_amt,
    #              other_unearned_inc   = :rBctd_other_unearned_inc,
    #              tea_income_limit     = :rBctd_tea_income_limit,
    #              sanction_indicator   = :rBctd_sanction_indicator
    #        WHERE bwiz_run_id = :rBctd_bwiz_run_id
    #        AND   bwiz_mo_id  = :rBctd_bwiz_mo_id;

    # DESTROY lds_tea_detail

    # //** T_Bu_Mo_Summary
    # lds_bu_mo_summary = CREATE n_ds
    # lds_bu_mo_summary.DataObject = 'dw_t_bu_mo_summary'
    # lds_bu_mo_summary.SetTransObject(SQLCA)

    # lstr_bu_mo_summary.db[1] = astr_pass.db[1]
    # lstr_bu_mo_summary.db[2] = astr_pass.db[2]

    # ll_bu_mo_summary = gnv_data_access_service.retrieve(lds_bu_mo_summary, lds_bu_mo_summary, "Bcms_l", lstr_bu_mo_summary)

    #  SELECT t_bu_mo_summary.bwiz_run_id,
    #                t_bu_mo_summary.bwiz_mo_id,
    #                t_bu_mo_summary.budget_unit_size,
    #                t_bu_mo_summary.tot_earned_inc,
    #                t_bu_mo_summary.tot_unearned_inc,
    #                t_bu_mo_summary.tot_expenses,
    #                t_bu_mo_summary.tot_resources,
    #                t_bu_mo_summary.bu_sum_result,
    #                t_bu_mo_summary.res_pass_fail_ind,
    #                t_bu_mo_summary.budget_eligible_ind
    #         FROM t_bu_mo_summary
    #         WHERE ( t_bu_mo_summary.bwiz_run_id = :rBcms_bwiz_run_id )
    #         AND   ( t_bu_mo_summary.bwiz_mo_id = :rBcms_bwiz_mo_id );


    # IF ll_bu_mo_summary> 0 THEN
    #             FOR ll_bu_mo_summary_ctr = 1 TO lds_bu_mo_summary.Rowcount()
    #                             IF astr_pass.s[1] <> 'E' THEN
    #                                             lds_bu_mo_summary.SetItem(ll_bu_mo_summary_ctr, 'bu_sum_result', astr_pass.db[5])
    #                             END IF
    #             NEXT
    # END IF

    # lstr_bu_mo_summary.db[1] = astr_pass.db[1]
    # li_bu_mo_summary = gnv_data_access_service.update_service(lds_bu_mo_summary, lds_bu_mo_summary, "Bcms_u", lstr_bu_mo_summary)
    #  EXEC SQL SELECT count(*)
    #         INTO :rrow_count
    #         FROM t_bu_mo_summary
    #         WHERE  bwiz_run_id = :iBcms_bwiz_run_id
    #         AND    bwiz_mo_id = :iBcms_bwiz_mo_id;

    #         if (rrow_count > 0)
    #              goto perform_delete;
    #         else
    #              goto perform_insert;

    # perform_delete:
    #         EXEC SQL DELETE
    #         FROM t_bu_mo_summary
    #         WHERE  bwiz_run_id = :iBcms_bwiz_run_id
    #         AND    bwiz_mo_id = :iBcms_bwiz_mo_id;

    #         goto perform_insert;

    # perform_insert:


    #         EXEC SQL INSERT INTO t_bu_mo_summary
    #              (bwiz_run_id,
    #               bwiz_mo_id,
    #               budget_unit_size,
    #               tot_earned_inc,
    #               tot_unearned_inc,
    #               tot_expenses,
    #               tot_resources,
    #               bu_sum_result,
    #               res_pass_fail_ind,
    #               budget_eligible_ind)
    #         VALUES
    #              (:iBcms_bwiz_run_id,
    #               :iBcms_bwiz_mo_id,
    #               :iBcms_budget_unit_size,
    #               :iBcms_tot_earned_inc,
    #               :iBcms_tot_unearned_inc,
    #               :iBcms_tot_expenses,
    #               :iBcms_tot_resources,
    #               :iBcms_bu_sum_result,
    #               :iBcms_res_pass_fail_ind          indicator  :nBcms_res_pass_fail_ind,
    #               :iBcms_budget_eligible_ind        indicator  :nBcms_budget_eligible_ind);

    #         /*EXEC SQL COMMIT;*/

    # DESTROY lds_bu_mo_summary

    # //Need to update Bwiz Eliigibility Indicator to identify the applied sanction on budget used when displaying the zero Grant Amount on Detail Tab.
    # String ls_elig_ind
    # ls_elig_ind = 'S' + astr_pass.s[1] //Add S for all Sanction Eligibility Indicator
    # IF astr_pass.db[1] > 0 THEN //10.01B
    #             This.of_update_cat_elig_in (astr_pass.db[1], astr_pass.db[2], ls_elig_ind, 'NOTREQ' )
    # END IF

    # RETURN 1

    end

    def self.get_last_budget_for_teasanction(adb_bu_id, adb_service_program, adt_sanction_month)
    #             n_ds lds_bud_month
    # Long ll_row
    # str_pass lstr_pass
    # Date ldt_cutoff_date, ld_bwiz_run_month

    # lds_bud_month = Create ds_bud_month
    # lds_bud_month.SetTransObject(SQLCA)

    # lstr_pass.db[1] = adb_bu_id
    # ll_row = gnv_data_access_service.retrieve(lds_bud_month, lds_bud_month, "Bump_l", lstr_pass)
    #  SELECT t_budget_wizard.bwiz_run_month,
    #                t_budget_wizard.bwiz_run_id,
    #                t_budget_wizard.budget_unit_id,
    #                t_budget_wizard.bwiz_mo_id,
    #                t_budget_wizard.service_program_id,
    #                t_budget_wizard.bwiz_run_date,
    #                t_budget_wizard.num_budget_months,
    #                t_budget_wizard.submit_date,
    #                t_budget_wizard.txn_success_date,
    #                t_budget_wizard.bwiz_cat_elig_ind,
    #                t_budget_wizard.retain_ind
    #         FROM t_budget_wizard
    #         WHERE t_budget_wizard.budget_unit_id = :rBucw_budget_unit_id
    #         ORDER BY t_budget_wizard.bwiz_run_date DESC,
    #                t_budget_wizard.bwiz_run_month DESC;

    # IF ll_row > 0 THEN
    #             lds_bud_month.SetSort("txn_success_date A")
    #             lds_bud_month.Sort()
    #             ll_row = lds_bud_month.RowCount()
    #             IF ll_row > 0 THEN
    #                             lstr_pass.dt[1] = lds_bud_month.GetItemDateTime(ll_row,'txn_success_date')
    #                             lstr_pass.db[2] = 0 //Intialized Run ID = 0
    #                             lstr_pass.db[3] = 0 //Intialized Month ID = 0

    #                             //Check for the last 6 working day
    #                              gnv_app.of_get_cutoffdate(adb_service_program, RelativeDate(adt_sanction_month, -1), ldt_cutoff_date)

    #                             DO WHILE ll_row > 0
    #                                             IF Date(lstr_pass.dt[1]) <= ldt_cutoff_date THEN
    #                                                             lstr_pass.db[2] = lds_bud_month.GetItemNumber(ll_row,'bwiz_run_id')
    #                                                             lstr_pass.db[3] = lds_bud_month.GetItemNumber(ll_row,'bwiz_mo_id')
    #                                                             //10.01D, added this code to return the valid month for retro
    #                                                             ld_bwiz_run_month = lds_bud_month.GetItemDate(ll_row,'bwiz_run_month')
    #                                                             IF ld_bwiz_run_month <= ldt_cutoff_date THEN
    #                                                                             EXIT
    #                                                             END IF
    #                                             END IF
    #                                             ll_row = ll_row - 1
    #                                             IF ll_row > 0 THEN
    #                                                             lstr_pass.dt[1] = lds_bud_month.GetItemDateTime(ll_row,'txn_success_date')                   //10.01C
    #                                             END IF
    #                             LOOP

    #             END IF
    # END IF

    # Destroy lds_bud_month

    # RETURN lstr_pass

    end

    def self.determine_tea_prgsv_sanction(adb_run_id, adb_month_id, adb_service_program_id, ad_sanction_month, astr_tea_prgsv_sanction)
    #  #         n_ds                                                      lds_tea_prgsv_sanction, lds_tea_prgsv_sanction_his
    #  # str_pass                                       lstr_pass_return, lstr_pass, lstr_pass2, lstr_pass7
    #  lstr_pass7 = StrPass.new
    #  lstr_pass_return = StrPass.new
    #  # integer                                         li_sanction_percent
    #  # Long                                                              ll_counter, ll_rows
    #  ls_release_ind = 'N'
    #  # n_ds                                                              lds_tea_sanction_his_counter
    #  # n_ds                                                              lds_reference_table
    #  # long                                                               ll_his_rowcount,ll_found
    #  ls_sanction = 'N'
    #  #ls_find_string
    #  # date                                                              ld_sanction_begin, ld_sanction_end,ld_sanction_month
    #  # string                                                            ls_sanction_type
    #  # long                                                               li_filter_count,
    #  ll_clientid = 0
    #  ls_sanction_indicator = 6179
    #  ls_sanction_serve =''
    #  # integer                                         li_cnt = 1

    # # //PCR#68006 - expansion
    # # String ls_member_status, ls_bu_relationship
    # # str_pass lstr_pass_relationship
    # # n_ds lds_bu_comp_rel

    # # //PCR#72489 ELGutierez
    # # str_pass         lstr_pass_sanction_his
    # # n_ds                                                lds_sanction_his
    # # Long                                                ll_rows_sanction_his, ll_sanction_his_RowCount
    # # String                              ls_sanction_percent
    # # String                              ls_budget_elig_ind
    # # str_pass                        lstr_pass_rule, lstr_pass_stds
    # # Decimal{2}    ldc_inc_elig_std
    # # n_cst_budget_unit lnv_bu
    # # n_cst_datetime lnv_datetime
    # # Double                          ld_sanction_hist_id

    #             case adb_service_program_id
    #                             when 1
    #                             #             lds_reference_table = CREATE ds_reference_table
    #                             #             lds_reference_table.SetTransObject(SQLCA)
    #                             #             // PCR 65925 Anand Kotian

    #                             #             //T_Sanction has to be change to T_Prgsv_Sanction
    #                             #             lds_tea_prgsv_sanction = CREATE n_ds
    #                             #             lds_tea_prgsv_sanction.Dataobject = 'dw_tea_prgsv_sanction'
    #                             #             lds_tea_prgsv_sanction.SetTransObject(SQLCA)

    #                             #             //Retrieve the grant amount by unit size
    #                             #             lstr_pass.db[1] = adb_run_id
    #                             #             lstr_pass.db[2] = adb_month_id
    #                             #             lstr_pass.db[3] = adb_service_program_id

    #                             #             lstr_pass2.db[1] = adb_run_id
    #                             #             lstr_pass2.db[2] = adb_month_id
    #                             #             lstr_pass2.db[3] = adb_service_program_id


    #                             lds_tea_prgsv_sanction = Sanction.get_progressive_sanction_details_by_run_id(adb_run_id,adb_month_id,adb_service_program_id)




    #             #             li_filter_count = lds_tea_prgsv_sanction.rowcount()

    #             #             li_cnt = 1
    #                             if lds_tea_prgsv_sanction.present?

    #             #                             lds_tea_sanction_his_counter = CREATE ds_tea_sanction_his_counter
    #             #                             lds_tea_sanction_his_counter.SetTransObject(SQLCA)

    #             #                             lds_tea_prgsv_sanction_his = CREATE n_ds
    #             #                             lds_tea_prgsv_sanction_his.DataObject = 'dw_tea_prgs_sanction_wc'
    #             #                             lds_tea_prgsv_sanction_his.SetTransObject(SQLCA)

    #                                             lds_tea_prgsv_sanction.each do |prgv_sanction| #do while ls_sanction = 'N' and li_cnt <= li_filter_count
    #                                                             ll_clientid = prgv_sanction.client_id
    #                                                             ll_sanctionid = prgv_sanction.id
    #                                                             ls_sanction_type = prgv_sanction.sanction_type
    #                                                             ls_member_status = prgv_sanction.member_status

    #                                                             if ls_member_status == 4468 && ls_sanction == 'N'
    #                                                                             ld_sanction_begin = prgv_sanction.infraction_begin_date #Date(lds_tea_prgsv_sanction.GetItemDateTime(li_cnt,"infraction_beg_dat"))
    #                                                                             ld_sanction_end = prgv_sanction.infraction_end_date #Date(lds_tea_prgsv_sanction.GetItemDateTime(li_cnt,"infraction_end_dat"))

    #             #
    #                                                                             lds_tea_prgsv_sanction_his = SanctionDetail.get_sanction_details_by_sanction_id(ll_sanctionid)
    #                                                                             if lds_tea_prgsv_sanction_his.present?
    #                                                                                             lds_tea_prgsv_sanction_his.each do |sanction_details|
    #                                                                                                             ls_sanction_indicator = sanction_details.sanction_indicator
    #             F                                                                                              ld_sanction_month = sanction_details.sanction_month
    #                                                                                                             ls_release_ind = sanction_details.release_indicatior
    #                                                                                                             ls_sanction_serve           = sanction_details.sanction_served
    #                                                                                                             ld_sanction_hist_id = sanction_details.id

    #                                                                                                             if ls_sanction_indicator == 6114 # legacy ='E', 6114 = close
    #                                                                                                                             ls_sanction = 'N'
    #                                                                                                                             continue
    #                                                                                                             end

    #                                                                                                             if astr_tea_prgsv_sanction.present? && astr_tea_prgsv_sanction.d.present? && astr_tea_prgsv_sanction.d.size > 0#Upperbound(astr_tea_prgsv_sanction.d[]) > 0 THEN
    #                                                                                                                             if lstr_pass7.db[1] == astr_tea_prgsv_sanction.d[1] #THEN //Infraction of modified sanction
    #                                                                                                                                             #//Take the Sanction Indicator and Release Indicator from the Tab, this is not save on the table yet.
    #                                                                                                                                             if ld_sanction_hist_id = astr_tea_prgsv_sanction.d[2] #THEN // Sanction History ID
    #                                                                                                                                                             ls_sanction_indicator = astr_tea_prgsv_sanction.s[1]
    #                                                                                                                                                             ls_release_ind = astr_tea_prgsv_sanction.s[2]
    #                                                                                                                                                             ls_sanction_serve = astr_tea_prgsv_sanction.s[3]
    #                                                                                                                                             end
    #                                                                                                                             else
    #                                                                                                                                             if astr_tea_prgsv_sanction.s[2] == 'Y' #THEN //Release Payment for Retro
    #                                                                                                                                                             #//This sanction is not active
    #                                                                                                                                                             ls_sanction = 'N'
    #                                                                                                                                                             continue
    #                                                                                                                                             end
    #                                                                                                                             end
    #                                                                                                             end

    #             # //10.01E 09-14-2007; this should not be defaulted to Y since serve indicator will be used to determine the Run Month.


    #                                                                                                             # if ld_sanction_month != ld_sanction_begin
    #                                                                                                             #             ld_sanction_begin = ld_sanction_month
    #                                                                                                             # end

    #                                                                                                             # case #ld_sanction_begin
    #                                                                                                             #             when ld_sanction_begin.year == ad_sanction_month.year
    #                                                                                                             #                             if ld_sanction_begin.month <= ad_sanction_month.month
    #                                                                                                             #                                             ls_sanction = "Y"
    #                                                                                                             #                             else
    #                                                                                                             #                                             ls_sanction = "N"
    #                                                                                                             #                             end
    #                                                                                                             #             when ld_sanction_begin.year < ad_sanction_month.year
    #                                                                                                             #                             ls_sanction = "Y"
    #                                                                                                             #             when ld_sanction_begin.year > ad_sanction_month.year
    #                                                                                                             #                             ls_sanction = "N"
    #                                                                                                             # end



    #                                                                                                             # if ls_sanction == 'Y'
    #                                                                                                             #             case #ld_sanction_end
    #                                                                                                             #                             when ld_sanction_end.year == ad_sanction_month.year
    #                                                                                                             #                                             if ld_sanction_end.month >= ad_sanction_month.month
    #                                                                                                             #                                                             ls_sanction = "Y"
    #                                                                                                             #                                             else
    #                                                                                                             #                                                             ls_sanction = "N"
    #                                                                                                             #                                             end
    #                                                                                                             #                             when ld_sanction_end.year < ad_sanction_month.year
    #                                                                                                             #                                             ls_sanction = "N"
    #                                                                                                             #                             when ld_sanction_end.year > ad_sanction_month.year
    #                                                                                                             #                                             ls_sanction = "Y"
    #                                                                                                             #             end
    #                                                                                                             # end

    #                                                                                                              ls_sanction = 'Y' #has to be implemented Rao

    #                                                                                                             if ls_sanction_indicator == 6179 # 'N' = ?
    #                                                                                                                             ls_sanction = 'N'
    #                                                                                                             else
    #                                                                                                                             if ls_sanction == 'Y'

    #                                                                                                                                             if ld_sanction_month >= ad_sanction_month
    #                                                                                                                                                             ll_found = false
    #                                                                                                                                                             ll_found_data = ""
    #                                                                                                                                                             lds_tea_prgsv_sanction_his.each do |l_sanction_detail|
    #                                                                                                                                                                             if Date.civil(ad_sanction_month.year, ad_sanction_month.month, 1) == Date.civil(l_sanction_detail.sanction_month.year, l_sanction_detail.sanction_month.month, 1)
    #                                                                                                                                                                                             ll_found = true
    #                                                                                                                                                                                             ll_found_data = l_sanction_detail
    #                                                                                                                                                                                             break
    #                                                                                                                                                                             end
    #                                                                                                                                                             end


    #                                                                                                                                                             # ls_find_string = "string(sanction_month,'MM/YYYY') = '" + string(ad_sanction_month,'MM/YYYY') + "'"
    #                                                                                                                                                             # #//search for the month/year of the budget from the list service of the history table
    #                                                                                                                                                             # ll_his_rowcount = lds_tea_prgsv_sanction_his.rowcount()
    #                                                                                                                                                             # ll_found = lds_tea_prgsv_sanction_his.Find( ls_find_string,1,ll_his_rowcount)


    #                                                                                                                                                             if ll_found
    #                                                                                                                                                                             #//Sanction found for the Budget Month Run
    #                                                                                                                                                                             ls_sanction = 'Y'
    #                                                                                                                                                                             ls_sanction_serve = ll_found_data.sanction_served
    #             #//10.01E 09-14-2007; this should not be defaulted to Y since serve indicator will be used to determine the Run Month.

    #                                                                                                                                                                             if ls_sanction_serve == 'N'
    #                                                                                                                                                                                             ls_sanction = 'N'
    #                                                                                                                                                                             else
    #                                                                                                                                                                                             ls_sanction = 'Y'
    #                                                                                                                                                                             end
    #                                                                                                                                                             else
    #                                                                                                                                                                             ls_sanction = 'N'
    #                                                                                                                                                             end
    #                                                                                                                                                             break
    #                                                                                                                                             else
    #                                                                                                                                                             #//Sanction should be consider as not acitve
    #                                                                                                                                                             ls_sanction = 'N'
    #                                                                                                                                             end
    #                                                                                                                             end
    #                                                                                                             end
    #                                                                                             end #each

    #             # #                                                                          //10.01D Infraction when adding new sanction with other existing sanction
    #             #                                                                             if astr_tea_prgsv_sanction.present? && astr_tea_prgsv_sanction.d.size > 0
    #             #                                                                                             if lstr_pass7.db[1] == astr_tea_prgsv_sanction.d[1]
    #             #                                                                                                                             if astr_tea_prgsv_sanction.s[1] != 'N'
    #             # #                                                                                                                                          //Check for Sanction History ID that is not on the table yet
    #             #                                                                                                                                             IF ld_sanction_hist_id <> astr_tea_prgsv_sanction.d[2] THEN // Sanction History ID,
    #             #                                                                                                                                                             ls_sanction_indicator = astr_tea_prgsv_sanction.s[1]
    #             #                                                                                                                                                             ld_sanction_month = astr_tea_prgsv_sanction.dates[1]
    #             #                                                                                                                                                             ls_release_ind = astr_tea_prgsv_sanction.s[2]
    #             #                                                                                                                                                             ls_sanction_serve = astr_tea_prgsv_sanction.s[3]




    #             #                                                                                                                                                             IF ld_sanction_month <> ld_sanction_begin THEN
    #             #                                                                                                                                                                             ld_sanction_begin = ld_sanction_month
    #             #                                                                                                                                                             END IF

    #             #                                                                                                                                                             CHOOSE CASE Year(ld_sanction_begin)
    #             #                                                                                                                                                                             CASE Year(ad_sanction_month)
    #             #                                                                                                                                                                                             IF Month(ld_sanction_begin) <= Month(ad_sanction_month) THEN
    #             #                                                                                                                                                                                                             ls_sanction = "Y"
    #             #                                                                                                                                                                                             ELSE
    #             #                                                                                                                                                                                                             ls_sanction = "N"
    #             #                                                                                                                                                                                             END IF
    #             #                                                                                                                                                                             CASE IS < Year(ad_sanction_month)
    #             #                                                                                                                                                                                             ls_sanction = "Y"
    #             #                                                                                                                                                                             CASE IS > Year(ad_sanction_month)
    #             #                                                                                                                                                                                             ls_sanction = "N"
    #             #                                                                                                                                                             END CHOOSE

    #             #                                                                                                                                                             IF ls_sanction = 'Y' THEN
    #             #                                                                                                                                                                             CHOOSE CASE Year(ld_sanction_end)
    #             #                                                                                                                                                                                             CASE Year(ad_sanction_month)
    #             #                                                                                                                                                                                                             IF Month(ld_sanction_end) >= Month(ad_sanction_month) THEN
    #             #                                                                                                                                                                                                                             ls_sanction = "Y"
    #             #                                                                                                                                                                                                             ELSE
    #             #                                                                                                                                                                                                                             ls_sanction = "N"
    #             #                                                                                                                                                                                                             END IF
    #             #                                                                                                                                                                                             CASE IS < Year(ad_sanction_month)
    #             #                                                                                                                                                                                                             ls_sanction = "N"
    #             #                                                                                                                                                                                             CASE IS > Year(ad_sanction_month)
    #             #                                                                                                                                                                                                             ls_sanction = "Y"
    #             #                                                                                                                                                                             END CHOOSE
    #             #                                                                                                                                                             END IF

    #             #                                                                                                                                                             IF ls_sanction = 'Y' THEN
    #             #                                                                                                                                                                             IF ls_sanction_serve = 'N' THEN
    #             #                                                                                                                                                                                             ls_sanction = 'N'
    #             #                                                                                                                                                                             ELSE
    #             #                                                                                                                                                                                             ls_sanction = 'Y'
    #             #                                                                                                                                                                             END IF
    #             #                                                                                                                                                             END IF
    #             #                                                                                                                                             END IF
    #             #                                                                                                                             END IF
    #             #                                                                                             end
    #             #                                                                             end

    #                                                                             else #// No Sanction Details Found on Infraction
    #             #                                                                             //10.01D
    #                                                                                             if astr_tea_prgsv_sanction.present? && astr_tea_prgsv_sanction.d.size > 0
    #                                                                                                             #//Check if it is the same Sanction ID
    #                                                                                                             if lstr_pass7.db[1] = astr_tea_prgsv_sanction.d[1] #//Infraction of newly entered sanction, no other existing sanction to this fraction
    #                                                                                                                             ls_sanction_indicator = astr_tea_prgsv_sanction.s[1]
    #                                                                                                                             ld_sanction_month = astr_tea_prgsv_sanction.dates[1]
    #                                                                                                                             ls_release_ind = astr_tea_prgsv_sanction.s[2]
    #                                                                                                                             ls_sanction_serve = astr_tea_prgsv_sanction.s[3]


    #                                                                                                                             if ld_sanction_month != ld_sanction_begin
    #                                                                                                                                             ld_sanction_begin = ld_sanction_month
    #                                                                                                                             end

    #                                                                                                                             case #ld_sanction_begin.year
    #                                                                                                                                             when ld_sanction_begin.year == ad_sanction_month.year
    #                                                                                                                                                             if ld_sanction_begin.month <= ad_sanction_month.month
    #                                                                                                                                                                             ls_sanction = "Y"
    #                                                                                                                                                             else
    #                                                                                                                                                                             ls_sanction = "N"
    #                                                                                                                                                             end
    #                                                                                                                                             when ld_sanction_begin.year < ad_sanction_month.year
    #                                                                                                                                                             ls_sanction = "Y"
    #                                                                                                                                             when ld_sanction_begin.year > ad_sanction_month.year
    #                                                                                                                                                             ls_sanction = "N"
    #                                                                                                                             end

    #                                                                                                                             if ls_sanction == 'Y'
    #                                                                                                                                             case #ld_sanction_end.year
    #                                                                                                                                                             when ld_sanction_end.year == ad_sanction_month.year
    #                                                                                                                                                                             if ld_sanction_end.month >= ad_sanction_month.month
    #                                                                                                                                                                                             ls_sanction = "Y"
    #                                                                                                                                                                             else
    #                                                                                                                                                                                             ls_sanction = "N"
    #                                                                                                                                                                             end
    #                                                                                                                                                             when ld_sanction_end.year < ad_sanction_month.year
    #                                                                                                                                                                             ls_sanction = "N"
    #                                                                                                                                                             when ld_sanction_end.year > ad_sanction_month.year
    #                                                                                                                                                                             ls_sanction = "Y"
    #                                                                                                                                             end
    #                                                                                                                             end

    #                                                                                                                             if ls_sanction == 'Y'

    #                                                                                                                                             if ls_sanction_serve == 'N'
    #                                                                                                                                                             ls_sanction = 'N'
    #                                                                                                                                             else
    #                                                                                                                                                             ls_sanction = 'Y'
    #                                                                                                                                             end
    #                                                                                                                             end
    #                                                                                                             end
    #                                                                                             end
    #                                                                             end
    #                                                             else
    #                                                                             if ls_sanction != 'N'
    #                                                                                             break
    #                                                                             end

    #                                                             end #d
    #                                             end #each loop
    #                             end #if
    #             end #case


    #                                                                                             # Sanction Indicators

    #                                                                                             # 6114  "Close"     "E"
    #                                                                                             # 6113  "50%"       "F"
    #                                                                                             # 6112  "Suspend 2" "D"
    #                                                                                             #           "25%"       "T"
    #                                                                                             # 6110  "Suspend 1" "B"
    #                                                                                             # 6179  "No Sanction" "N"

    #             case ls_sanction_indicator
    #                             when 6110 #//Suspend 1 = B
    #                                             #//Look for the following 30 days
    #                                             if ls_sanction == 'Y'
    #                                                             li_sanction_percent = 25
    #                                             else
    #                                                             li_sanction_percent = 0
    #                                             end
    #                             when 6111 #//25%
    #                                             li_sanction_percent = 25
    #                             when 6112 #//Suspend 2 'D'
    #                                             #//Look for the following 60 days
    #                                             li_sanction_percent = 25
    #                                             if ls_sanction == 'Y'
    #                                                             li_sanction_percent = 25
    #                                             else
    #                                                             li_sanction_percent = 0
    #                                             end
    #                             when 6113 #//50%
    #                                             li_sanction_percent = 50
    #                             when 61114 #//Close
    #                                             #//No need to recalculate
    #                                                             li_sanction_percent = 25
    #                             when 6179 #//No Sanction  'N'
    #                                             #//No sanction applied
    #                                             li_sanction_percent = 0
    #             end

    # unless ls_release_ind.present? #ls_release_ind.trim == ""
    #             ls_release_ind = 'N'
    # end

    # #//lstr_pass_return.s[2] = ls_sanction //Sanction Flag
    # lstr_pass_return.s[2] = ls_sanction_serve #//Serve Ind //10.01E
    # lstr_pass_return.s[4] = ls_sanction #//Sanction Flag //10.01E
    # if ls_sanction == 'N'#//10.01B - Build2
    #             ls_sanction_indicator = 6179
    #             li_sanction_percent = 0 #//10.01D 09-10-2007 ; Sanction Percent should be zero when recalculating thru budget wizard
    # end
    # lstr_pass_return.s[1] = ls_sanction_indicator #//Sanction Indicator
    # lstr_pass_return.s[3] = ls_release_ind #//Release Ind
    # lstr_pass_return.i[1] = li_sanction_percent #//Sanction Percent

    # #lstr_pass_return.dates[1] = RelativeDate(lnv_datetime.of_LastDayOfMonth(Today()), 1) #//Start Payment

    # lstr_pass_return.db[1] = ll_clientid #//Client ID 10.01D 09-06-07 ; determine who is the current sanction client for the sanction month

    # return      lstr_pass_return

    # # //************************************************************************
    # # //*  Release  Date     Task         Author
    # # //*  Description
    # # //************************************************************************
    # # //*  10.01A    08/02/2007 ANSWER                    Evangeline L. Gutierez
    # # //*  PCR#74054 - Determine Benefit for TEA Progressive Sanction
    # # //*  Return Values: str_pass.s[1] = Sanction Indicator
    # # //*                                                                                    str_pass.s[2] = Sanction Flag
    # # //*                                                                    str_pass.s[3] = Release Indicator
    # # //*                           str_pass.i[1] = Sanction Percent
    # # //*                                                                    str_pass.dates[1] = Sanction Start Date
    # # //*                                                                                    str_pass_bdgt.dt[1] = TEA Sanction Effective Begin Date
    # # //*                                                                                    str_pass.db[1] = Client ID //10.01D //09-06-07
    # # //************************************************************************

    end
    def self.valid_effective_dates(ad_begin_date, ad_end_date)
        #Rails.logger.debug("valid_effective_dates.ad_begin_date = #{ad_begin_date}, ad_end_date = #{ad_end_date}")
        #Rails.logger.debug("@id_month = #{@id_month}")
        ld_begin_date = ad_begin_date
        ld_end_date = ad_end_date
        ls_valid_dates = ''
        # ad_begin_date = 2014-09-01, ad_end_date =
        # @id_month = 2014-01-01
        if !(ld_begin_date.present?)
            ls_valid_dates = 'Y'
        else
            if ld_begin_date.year == @id_month.year
                if ld_begin_date.month <= @id_month.month
                                ls_valid_dates = 'Y'
                else
                                ls_valid_dates = 'N'
                end
            elsif ld_begin_date.year < @id_month.year
                ls_valid_dates = 'Y'
            else ld_begin_date.year > @id_month.year
                ls_valid_dates = 'N'
            end
        end

        if ls_valid_dates.present? && ls_valid_dates == 'Y'
            if !(ld_end_date.present?)
              # ls_valid_dates flag will stay set to "Y"
            else
                if ld_end_date.year == @id_month.year
                    if ld_end_date.month >= @id_month.month
                        ls_valid_dates = 'Y'
                    else
                        ls_valid_dates = 'N'
                    end
                elsif ld_end_date.year < @id_month.year
                    ls_valid_dates = 'N'

                else ld_end_date.year > @id_month.year
                                ls_valid_dates = 'Y'
                end
            end
        end
        return ls_valid_dates
    end
end

