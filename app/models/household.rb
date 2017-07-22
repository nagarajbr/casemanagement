class Household < ActiveRecord::Base

  # virtual fields of household member yes/no/skip fields
  attr_accessor :member_education_add_flag,
                :member_expense_add_flag,
                :member_resource_add_flag,
                :member_earned_income_flag,
                :member_unearned_income_flag,
                :member_job_offer_flag,
                :member_currently_working_flag


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

	 #Manoj 09/06/2014
    # Application - Multi step form creation of data. - start
    attr_writer :current_step,:process_object

   #  last_step is dummy step - after 'household_member_questions_step' it will go to index page
    #  def steps
    #   %w[
    #       household_member_demographics_step
    #       household_member_race_step
    #       household_member_citizenship_step
    #       household_member_contact_step
    #       household_member_address_step
    #       household_member_education_step
    #       household_member_questions_step
    #       household_member_relations_step
    #       household_member_incomes_step
    #       household_member_expenses_step
    #       household_member_resources_step
    #       household_member_general_health_characteristics_step
    #       household_member_disability_characteristics_step
    #       household_member_mental_health_characteristics_step
    #       household_member_substance_abuse_characteristics_step
    #       household_member_domestic_violance_characteristics_step
    #       household_member_legal_characteristics_step
    #       household_member_pregnancy_characteristics_step
    #     ]
    # end

    # 12/17/2015 - Manoj Patil - JIra ACM-1002 - Remove Characteristic steps from Intake -start
    #  def steps
    #   %w[
    #       household_member_demographics_step
    #       household_member_race_step
    #       household_member_citizenship_step
    #       household_member_contact_step
    #       household_member_address_step
    #       household_member_education_step
    #       household_member_questions_step
    #       household_member_relations_step
    #       household_member_incomes_step
    #       household_member_expenses_step
    #       household_member_resources_step
    #     ]
    # end
    # 12/17/2015 - Manoj Patil - JIra ACM-1002 - Remove Characteristic steps from Intake -end

     # 01/03/2016 - Manoj Patil - Final Intake steps
     def steps
      %w[
          household_member_demographics_step
          household_member_address_step
          household_member_address_search_results_step
          household_member_citizenship_step
          household_member_education_step
          household_member_employments_step
          household_member_assessment_employment_step
          household_member_incomes_step
          household_member_unearned_incomes_step
          household_member_expenses_step
          household_member_resources_step
          household_member_relations_step
        ]
    end

    def step_headings
      ['Demographics',
          'Address',
          'Residential address',
          'Citizenship',
          'Education',
          'Employment',
          'Employment assessment',
          'Earned income',
          'Unearned income',
          'Expense',
          'Resource',
          'Relationships'
        ]
    end


    def current_step
      @current_step || steps.first
    end

    def next_step
      self.current_step = steps[steps.index(current_step)+1]
    end

    def previous_step
      self.current_step = steps[steps.index(current_step)-1]
    end

    def first_step?
      current_step == steps.first
    end

    def last_step?
      current_step == steps.last
    end

    def get_process_object
      self.process_object = steps[steps.index(current_step)-1]
    end


    # Application - Multi step form creation of data. - End


    def self.get_household_name(arg_household_id)
      ls_household_name = ' '
      if arg_household_id.present?
        household_object = Household.find(arg_household_id)
        ls_household_name = household_object.name
      end

      return ls_household_name
    end

    def self.get_household_name_from_application_id(arg_application_id)
      result = nil
      step1 = joins("INNER JOIN client_applications on client_applications.household_id = households.id")
      step2 = step1.where("client_applications.id = ?",arg_application_id)
      step3 = step2.select("households.*")
      result = step3.first.name if step3.present?
      return result
    end


    # HOUSEHOLD ADDRESS CHANGE WIZARD METHODS -START
    # Manoj 03/30/2016
    def self.members_moving_from_one_household_to_another_process(arg_current_household_object,arg_new_address_object,arg_selected_household_object,arg_selected_address_object)

      # 1. update hh members with 'out of household' in current household
      step1 = HouseholdMember.joins("INNER JOIN entity_addresses
                                    ON (household_members.client_id = entity_addresses.entity_id
                                        AND entity_addresses.entity_type = 6150
                                       )
                                      ")
      step2 = step1.where("entity_addresses.address_id = ?",arg_new_address_object.id).order("household_members.id ASC")
      members_moved_to_new_address_collection_from_current_household = step2
      # 2. new hh members with selected household_id
      # 3. change entity address with address_id of selected Household to reflect - they live in the same household as the selected Household.
      clients_in_new_address_collection = EntityAddress.where("entity_type = 6150 and address_id = ?",arg_new_address_object.id)

      ls_msg = nil
      begin
          ActiveRecord::Base.transaction do
            # 1.
            members_moved_to_new_address_collection_from_current_household.each do |each_member|
              each_member.member_status = 6644 # out of household
              each_member.save!
            end
            # 2. create new hh members and associate with selected Household
             members_moved_to_new_address_collection_from_current_household.each do |each_member|
                new_hh_member = HouseholdMember.set_household_member_data(arg_selected_household_object.id,each_member.client_id)
                new_hh_member.save!
             end

             # 3.
             clients_in_new_address_collection.each do |each_entity|
               each_entity.address_id = arg_selected_address_object.id
               each_entity.save!
             end

             # 4. since we did not use the new addres as the members decide to move to other household - we can delete the new address
             arg_new_address_object.destroy!

             # 5. delete process record
             new_address_collection_for_household = ChangeHouseholdAddressProcess.where("household_id = ?",arg_current_household_object.id)
             new_address_collection_for_household.each do |each_record|
                each_record.destroy!
             end
          end # end of ActiveRecord::Base.transaction
           ls_msg = "SUCCESS"
      rescue => err
          error_object = CommonUtil.write_to_attop_error_log_table("Household","members_moving_from_one_household_to_another_process",err,current_user.uid)
          ls_msg = "Failed to join selected household - for more details refer to error ID: #{error_object.id}."
      end

      return ls_msg

    end

    def self.new_household_id_for_members_moved_out_of_old_household(arg_household_object,arg_old_address_object,arg_new_address_object)
        ldt_ed_run_month = Date.today.strftime("01/%m/%Y").to_date

        step1 = step1 = HouseholdMember.joins("INNER JOIN entity_addresses
                                             ON (household_members.client_id = entity_addresses.entity_id
                                                AND entity_type = 6150
                                                )
                                              ")
        step2 = step1.where("entity_addresses.address_id = ?",arg_new_address_object.id)
        members_moved_to_new_address_collection = step2

        step1 = step1 = Client.joins("INNER JOIN entity_addresses
                                     ON (clients.id = entity_addresses.entity_id
                                         AND entity_type = 6150
                                        )
                                    ")
        step2 = step1.where("entity_addresses.address_id = ?",arg_new_address_object.id).order("clients.id DESC")
        clients_moved_to_new_address_collection = step2

        entity_clients_in_old_address_who_moved_to_new_address_collection = EntityAddress.where("entity_type = 6150
                                                                                                 and address_id = ?
                                                                                                 and entity_id in (select entity_id
                                                                                                                   from entity_addresses
                                                                                                                   where entity_type = 6150
                                                                                                                   and address_id = ?)
                                                                                                ",arg_old_address_object.id,arg_new_address_object.id
                                                                                                )

         ls_msg = nil
        begin
          ActiveRecord::Base.transaction do
            # 1. # make those members as out of household who moved to out of household from old household
            members_moved_to_new_address_collection.each do |each_member|
              each_member.member_status = 6644 # out of household
              each_member.save!

              # get the latest program unit in which this client is present and if that pgu is not closed - then make the member status - inactive closed.
              pgu_collection = ProgramUnitMember.where("client_id = ?",each_member.client_id).order("program_unit_id DESC")
              if pgu_collection.present?
                latest_pgu_object = pgu_collection.first
                # is this pgu is closed?
                pgu_status_collection = ProgramUnitParticipation.where("program_unit_id = ?",latest_pgu_object.program_unit_id).order("id DESC")
                if pgu_status_collection.present?
                  latest_pgu_status_object = pgu_status_collection.first
                  if latest_pgu_status_object.participation_status == 6043 # open
                    # open
                    pgu_member_object = ProgramUnitMember.where("client_id = ? and program_unit_id = ?",each_member.client_id,latest_pgu_object.program_unit_id).first
                    pgu_member_object.member_status = 4471 # inactive closed
                    pgu_member_object.save!
                    # make entry into Night batch process.
                    CommonEntityService.create_batch_process_entry_if_needed(6524, latest_pgu_object.program_unit_id, 6526, 6768, each_member.client_id, ldt_ed_run_month, 'Y')
                  end
                else
                  # PGU is not activated yet
                   pgu_member_object = ProgramUnitMember.where("client_id = ? and program_unit_id = ?",each_member.client_id,latest_pgu_object.program_unit_id).first
                   pgu_member_object.member_status = 4471 # inactive closed
                   pgu_member_object.save!
                   # make entry into Night batch process.
                   CommonEntityService.create_batch_process_entry_if_needed(6524, latest_pgu_object.program_unit_id, 6526, 6768, each_member.client_id, ldt_ed_run_month, 'Y')
                end
              end
            end

            # 2. create new household for these members.
            first_client_object_moving_to_new_address = clients_moved_to_new_address_collection.first
            new_household_object = Household.new
            new_household_object.name = first_client_object_moving_to_new_address.last_name
            new_household_object.processing_location_id = arg_household_object.processing_location_id # put old household's processing location.
            new_household_object.intake_worker_id = AuditModule.get_current_user.uid
            new_household_object.save!

            # 3. update the new household in household_member_step_statuses
             members_moved_to_new_address_collection.each do |each_member|
              # update each step of the client to new household id
              HouseholdMemberStepStatus.update_household_id_to_client_steps_with_save_bang(each_member.client_id,new_household_object.id)
             end

            # 4. create new household members.
            clients_moved_to_new_address_collection.each do |each_client|
              new_hh_member_object = HouseholdMember.set_household_member_data(new_household_object.id,each_client.id)
              new_hh_member_object.save!
            end

            # 5. delete the entity_address which associated these clients to old address. (scenario 2 clients out of 5 moved to other house.)
              entity_clients_in_old_address_who_moved_to_new_address_collection.each do |each_moved_client|
                each_moved_client.destroy!
              end


            # 6. delete process record
            new_address_collection_for_household = ChangeHouseholdAddressProcess.where("household_id = ?",arg_household_object.id)
            new_address_collection_for_household.each do |each_record|
              each_record.destroy!
            end
          end
           ls_msg = "SUCCESS"
        rescue => err
          error_object = CommonUtil.write_to_attop_error_log_table("Household","new_household_id_for_members_moved_out_of_old_household",err,AuditModule.get_current_user.uid)
          ls_msg = "Failed to create household - for more details refer to error ID: #{error_object.id}."
        end
        return ls_msg
    end

    # HOUSEHOLD ADDRESS CHANGE WIZARD METHODS -END



end
