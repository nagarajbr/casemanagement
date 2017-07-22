class ProgramUnitService

    def self.close_tea_program_with_good_reason(arg_program_unit_id,arg_action_date,arg_action_reason)
        # 1. Table - program_unit_participation
        program_unit_participation_object = ProgramUnitParticipation.set_participation_record(arg_program_unit_id,arg_action_date,arg_action_reason,6044)
        # 2. Table -program_unit_representatives
        program_unit_representatives_collection = ProgramUnitRepresentative.get_open_program_unit_representatives(arg_program_unit_id)

        # 3. Table - Payment line items

        # tea bonus payment
        program_unit_object = ProgramUnit.find(arg_program_unit_id)
        program_wizard_object = ProgramWizard.get_latest_payment(arg_program_unit_id)
        #need to revisit client id
        # primary_beneficiary_collection = ProgramUnitMember.get_primary_beneficiary(program_wizard_object.program_unit_id)
        # ld_primary_beneficiary_client_id = primary_beneficiary_collection.first.client_id
        primary_contact = PrimaryContact.get_primary_contact(program_wizard_object.program_unit_id, 6345)
        ld_primary_beneficiary_client_id = primary_contact.client_id
        ldt_payment_month = arg_action_date + 1.month
        ldt_payment_month = ldt_payment_month.strftime("01/%m/%Y").to_date
        program_benefit_detail_collection = ProgramBenefitDetail.get_program_benefit_detail_collection(program_wizard_object.run_id,program_wizard_object.month_sequence)
        ld_program_benefit_amount = program_benefit_detail_collection.first.program_benefit_amount
        #6175 - TEA, 5762 - exit bonus,
        lb_payment_in_last_12_months = InStatePayment.tea_extra_payment_in_last_12_months_found?(arg_program_unit_id,ldt_payment_month)
        if lb_payment_in_last_12_months == false
            payment_line_item_object_for_tea_bonus_object = PaymentLineItem.set_payment_line_item_object(arg_program_unit_id,ldt_payment_month,6175,5762,ld_primary_beneficiary_client_id,6172,ld_program_benefit_amount,6191,program_wizard_object.run_id,6201)
        end
        # 4. Table - Payment line items
        # Transportation Bonus :5763
        ld_transportation_bonus_amount = SystemParam.get_key_value(9,"TRANSPORTATION_BONUS_AMOUNT","transportation bonus of $200.00")
        ld_transportation_bonus_amount = ld_transportation_bonus_amount.to_f
        payment_line_item_object_for_tea_transportation_bonus_object =  PaymentLineItem.set_payment_line_item_object(arg_program_unit_id,ldt_payment_month,6175,5763,ld_primary_beneficiary_client_id,6172,ld_transportation_bonus_amount,6191,program_wizard_object.run_id,6201)

        # 5. action_plan_details
        # open_action_plan_details_collection  = ActionPlanDetail.get_open_activities_for_program_unit(arg_program_unit_id)
        # 6. program_unit_members
        program_unit_members_collection = ProgramUnitMember.sorted_program_unit_members(arg_program_unit_id)

        begin
            ActiveRecord::Base.transaction do
                # 1.
                program_unit_participation_object.save!
                # 2.
                if lb_payment_in_last_12_months == false
                    payment_line_item_object_for_tea_bonus_object.save!
                end
                # 3.
                payment_line_item_object_for_tea_transportation_bonus_object.save!

                # 4.
                program_unit_representatives_collection.each do |each_representative|
                    each_representative.status = 6224
                    each_representative.end_date = arg_action_date
                    each_representative.save!
                end
                # 5.
                # open_action_plan_details_collection.each do |each_activity|
                #  each_activity.end_date = arg_action_date
                #  each_activity.save!
                # end
                #6
                program_unit_members_collection.each do |pu_member|
                    pu_member.member_status = 4471 # "Inactive Closed"
                    pu_member.save!
                end
            end

            msg = "SUCCESS"
        rescue => err
            error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnit-Model","close_tea_program_with_good_reason",err,AuditModule.get_current_user.uid)
            msg = "Failed to close program unit - for more details refer to error ID: #{error_object.id}."
        end
      return msg
    end

    def self.close_tanf_no_good_reason(arg_program_unit_id,arg_action_date,arg_action_reason)
        # 1. Table - program_unit_participation
        program_unit_participation_object = ProgramUnitParticipation.set_participation_record(arg_program_unit_id,arg_action_date,arg_action_reason,6044)
        # 2. Table -program_unit_representatives
        program_unit_representatives_collection = ProgramUnitRepresentative.get_open_program_unit_representatives(arg_program_unit_id)

        # 3. action_plan_details
        # open_action_plan_details_collection  = ActionPlanDetail.get_open_activities_for_program_unit(arg_program_unit_id)
        # 4. program_unit_members
        program_unit_members_collection = ProgramUnitMember.sorted_program_unit_members(arg_program_unit_id)

        begin
            ActiveRecord::Base.transaction do
                # 1.
                program_unit_participation_object.save!

                # 2.
                program_unit_representatives_collection.each do |each_representative|
                    each_representative.status = 6224
                    each_representative.end_date = arg_action_date
                    each_representative.save!
                end
                # 3.
                # open_action_plan_details_collection.each do |each_activity|
                #     each_activity.end_date = arg_action_date
                #     each_activity.save!
                # end
                # 4.
                program_unit_members_collection.each do |pu_member|
                    pu_member.member_status = 4471 # "Inactive Closed"
                    pu_member.save!
                end
            end

          msg = "SUCCESS"
        rescue => err
            error_object = CommonUtil.write_to_attop_error_log_table("ProgramUnit-Model","close_tanf_no_good_reason",err,AuditModule.get_current_user.uid)
            msg = "Failed to close program unit - for more details refer to error ID: #{error_object.id}."
        end
      return msg
    end

    def self.get_parent_list_for_the_program_unit(arg_program_unit)
        clients_associated_with_program_unit = ProgramUnitMember.get_active_program_unit_members(arg_program_unit)
        adult_list = []
        child_list = []
        parents_list = []
        # Separating the childs and adults from the list of clients associated with the application.
        clients_associated_with_program_unit.each do |client|
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

        child_list.each do |child|
            parents = get_parents_list(child,adult_list)
            parents += get_parents_list(child,child_list)
            parents.uniq!
            parents.each do |parent|
                unless parents_list.include?(parent)
                    parents_list << parent
                end
            end
        end
        pgu_members = ProgramUnitMember.where("program_unit_id = ? and client_id in (?)",arg_program_unit,parents_list)
        return pgu_members
    end

    def self.get_parents_list(child,adult_list)
        parents_list = Array.new
        adult_list.each do |parent|
            if ClientRelationship.is_there_a_child_parent_relationship_between_clients(child,parent)
                parents_list << parent
            end
        end
        return parents_list
    end

    def self.determine_case_type_for_program_unit_and_update(arg_program_unit)
        fts = FamilyTypeService.new
        family_type_struct = FamilyTypeStruct.new
        family_type_struct = fts.determine_family_type_for_program_unit(arg_program_unit.id)
        arg_program_unit.case_type = family_type_struct.case_type_integer
        arg_program_unit.save!
    end
end