class ProgramUnitMember < ActiveRecord::Base
has_paper_trail :class_name => 'ProgramUnitMembrVersion',:on => [:update, :destroy]

	include AuditModule

	before_create :set_create_user_fields
	before_update :set_update_user_field
  after_create :set_client_characteristics_based_on_case_type

    belongs_to :program_unit

	validates :program_unit_id,:client_id, :member_status, presence: true
     # Don't allow duplicate clients in the same application
    validates :client_id,:uniqueness => {:scope => [:program_unit_id]}
     # validate :check_only_one primary member per application ID
     # validates :primary_beneficiary, :uniqueness => { :scope => :program_unit_id }, :if => lambda { primary_is_selected? }


    # def primary_is_selected?
    #  primary_beneficiary == "Y"
    #  end

    def set_create_user_fields
        user_id = AuditModule.get_current_user.uid
        self.created_by = user_id
        self.updated_by = user_id

    end

    def set_update_user_field
        user_id = AuditModule.get_current_user.uid
        self.updated_by = user_id
    end

    def self.program_unit_member_count(arg_program_unit_id)
        l_object_collection = ProgramUnitMember.where("program_unit_id = ?", arg_program_unit_id)
        if l_object_collection.present?
            l_return = l_object_collection.size
        else
            l_return = 0
        end
        return l_return
    end

    def self.sorted_program_unit_members(arg_program_unit_id)
      step1 = joins("INNER JOIN clients on clients.id = program_unit_members.client_id")
      step2 = step1.where("program_unit_members.program_unit_id = ?",arg_program_unit_id)
      step3 = step2.select("program_unit_members.*, clients.ssn, clients.dob, clients.gender,  (clients.last_name ||', ' || clients.first_name) as client_full_name").order("program_unit_members.client_id ASC")
    end

    def self.get_program_unit_members(arg_program_unit_id)
      where("program_unit_id = ?",arg_program_unit_id).order("client_id ASC")
    end


    # def self.get_primary_beneficiary(arg_program_unit_id)
    #     l_output_object = self.where("program_unit_id = ? and primary_beneficiary = 'Y'",arg_program_unit_id)
    #     return l_output_object
    # end

    def self.get_primary_beneficiary_name(arg_program_unit_id)
      # step1 = joins("INNER JOIN clients ON program_unit_members.client_id = clients.id")
      # step2 = step1.where("program_unit_members.program_unit_id = ? and program_unit_members.primary_beneficiary = 'Y'",arg_program_unit_id)
      # step3 = step2.select("clients.*")
      # result = step3.present? ? (step3.first.last_name + "," + step3.first.first_name) : " "
      # return result
      result = nil
      primary_contact = PrimaryContact.get_primary_contact(arg_program_unit_id, 6345)
      if primary_contact.present?
        clients = Client.where("id = ?",primary_contact.client_id)
        result = clients.first.last_name + "," + clients.first.first_name if clients.present?
      end
      return result
    end

    def self.update_program_unit_primary_beneficiary(arg_program_unit_id,arg_client_id)
      count = 0
        age = Client.get_age(arg_client_id)
          if age >= 18
                  self.where(program_unit_id: arg_program_unit_id).update_all(primary_beneficiary:"N")
                  program_unit_member = self.where("program_unit_id = ? and client_id = ?",arg_program_unit_id,arg_client_id).first
                  program_unit_member.primary_beneficiary = "Y"
                      if  program_unit_member.save
                        msg = "SUCCESS"
                      else
                        msg = program_unit_member.errors.full_messages[0]
                      end

          else
                  l_case_type = ProgramUnit.find(arg_program_unit_id).case_type
                  if l_case_type == 6049
                      program_unit_members_collection = ProgramUnitMember.sorted_program_unit_members(arg_program_unit_id)
                      program_unit_members_collection.each do |program_member|
                        if  Client.is_adult(program_member.client_id)
                            count = count+1
                        end
                      end # end of do loop
                       if count > 0
                          # adult found in minor parent case but not seleted we are forcing the user to select adult to be self of the program unit
                          msg = "Self of program unit should be an adult."

                      else
                          # in this mionr parent case no adults are present so minor parent can be the self of program unit
                          relationships_collection = ClientRelationship.check_is_he_parent(arg_client_id)
                            if relationships_collection.present?
                              self.where(program_unit_id: arg_program_unit_id).update_all(primary_beneficiary:"N")
                              program_unit_member = self.where("program_unit_id = ? and client_id = ?",arg_program_unit_id,arg_client_id).first
                              program_unit_member.primary_beneficiary = "Y"
                                  if  program_unit_member.save
                                      msg = "SUCCESS"
                                  else
                                      msg = program_unit_member.errors.full_messages[0]
                                  end

                            else
                               msg = "Self of program unit should be an adult."
                            end # relationships_collection.present?
                      end # count>0

                else
                    msg = "Self of program unit should be an adult."
                end  #l_case_type == 6049




          end #  age >= 18
          return msg
    end



    def self.check_open_status_for_a_program(arg_client_id, arg_service_program_id)
        step1 = joins("INNER JOIN program_units ON program_unit_members.program_unit_id = program_units.id")
        step2 = step1.where("program_units.service_program_id = ? and program_units.program_unit_status = 5942 and program_unit_members.client_id = ?",arg_service_program_id, arg_client_id)
        # step3 = step2.select("program_units.id,program_units.program_unit_status,program_units.disposition_status")
        # l_program_unit_collection = step3
        l_program_unit_collection = step2
        has_open_program_unit = false
        if l_program_unit_collection.present?
            l_program_unit_collection.each do |arg_pgu|
               # Get Program Unit Object
                # program_unit_object = ProgramUnit.find(arg_pgu.id)
                program_unit_object = ProgramUnit.find(arg_pgu.program_unit_id)
                # Get the Program participations associated with that program Unit.
                pg_status_collection = program_unit_object.program_unit_participations.order("id DESC")
                 # Get latest Program Unit status.- If Open Program Unit found don't allow.
                if pg_status_collection.present?
                    pg_status_object = pg_status_collection.first
                    if pg_status_object.participation_status == 6043
                       has_open_program_unit = true
                       break
                    end
                end
            end
        end
        return has_open_program_unit
    end

    def self.check_for_closed_tea_case_with_in_last_six_months(arg_client_id)
        # Rule : check for closed tea case with in last 6 months
        # step1


        step1 = joins("INNER JOIN program_units ON program_unit_members.program_unit_id = program_units.id")
        step2 = step1.where("program_units.service_program_id = 1 and program_units.program_unit_status = 5942 and program_unit_members.client_id = ?",arg_client_id)
        # step3 = step2.select("program_units.id,program_units.program_unit_status,program_units.disposition_status")
        # l_program_unit_collection = step3
        l_program_unit_collection = step2

        has_closed_tea_program_unit = false
        if l_program_unit_collection.present?
            l_program_unit_collection.each do |arg_pgu|
                #  get the Program Unit object
                 # program_unit_object = ProgramUnit.find(arg_pgu.id)
                 program_unit_object = ProgramUnit.find(arg_pgu.program_unit_id)
                 # Get Program Participation status associated with the program Unit
                 pg_status_collection = program_unit_object.program_unit_participations.order("id DESC")
                  # Get latest Program Unit status.- If Open Program Unit found don't allow.
                if pg_status_collection.present?
                    pg_status_object = pg_status_collection.first
                    # is it closed and reasons in good reason ()
                    lb_bonus_close_reason_present = SystemParam.tea_bonus_close_reason_present?(pg_status_object.reason)

                    if pg_status_object.participation_status == 6044 && lb_bonus_close_reason_present == true
                    # Good closure reason - no need to check - he can apply for workpays after 6 months also.
                          has_closed_tea_program_unit = true
                          break
                    else
                        # Non Good Reason closure- he can apply for workpays only within 6 months.
                        if (Time.now - 6.months..Time.now).cover?(pg_status_object.action_date)
                            has_closed_tea_program_unit = true
                            break
                        end
                    end # close of pg_status_object.participation_status == 6044
                end
            end
        end

        return has_closed_tea_program_unit
    end


    def self.get_clients_for_representative_selection(arg_program_unit_id)
        step1 = joins("INNER JOIN clients ON clients.id = program_unit_members.client_id")
        step2 = step1.where("program_unit_members.program_unit_id = ? and extract(year from age(clients.dob)) > 18",arg_program_unit_id)
        step3 = step2.select("program_unit_members.client_id")
        if step3.present?
            return step3
        else
            step1 = joins("INNER JOIN program_units ON program_units.id = program_unit_members.program_unit_id")
            step2 = step1.where("program_unit_members.program_unit_id = ? and program_unit_members.primary_beneficiary = 'Y' and program_units.case_type = 6045",arg_program_unit_id)
            step3 = step2.select("program_unit_members.client_id")
            if step3.present?
                return step3
            else
                return []
            end
        end
    end

    def self.get_program_unit_member(arg_program_unit_id,arg_client_id)
        result = where("program_unit_id = ? and client_id = ?",arg_program_unit_id,arg_client_id)
        result = result.first if result.present?
        return result
    end



   # def self.update_member_status(arg_client_id)
   #     where("client_id = ?", arg_client_id).update_all("member_status = 4470")

   # end

  # def self.update_all_clients_in_program_unit_where_only_child_is_turning_18(arg_program_unit_id)
  #    where("program_unit_id = ?", arg_program_unit_id).update_all("member_status = 4470")
  # end



    def self.delete_member(arg_id)
        program_unit_member_object = ProgramUnitMember.find(arg_id)
        l_client_id = program_unit_member_object.client_id
        DataValidation.where("client_id = ?",l_client_id).destroy_all
        ApplicationEligibilityResults.where("client_id = ?",l_client_id).destroy_all
        program_unit_member_object.destroy

    end

    def self.get_active_program_unit_members(arg_program_unit_id)
         where("program_unit_id = ? and member_status = 4468",arg_program_unit_id)
    end

    def self.get_active_program_unit_members_with_resident_address_biographic_change
      step1 = joins(" INNER JOIN program_units ON (program_units.id = program_unit_members.program_unit_id)
                      INNER JOIN program_unit_participations ON (program_units.id = program_unit_participations.program_unit_id and
                      program_unit_participations.participation_status = 6043)
                      INNER JOIN clients ON (clients.id = program_unit_members.client_id)
                      INNER JOIN entity_addresses ON (entity_addresses.entity_id = clients.id and entity_addresses.entity_type = 6150)
                     INNER JOIN addresses ON (entity_addresses.address_id = addresses.id and addresses.address_type = 4664)")
      step2 = step1.where("program_unit_members.member_status = 4468 and
                     (clients.ssn_change = 'Y' or clients.dob_change = 'Y' or clients.name_chgd = 'Y' or addresses.address_chgd = 'Y')")
      step3 = step2.select("clients.*, addresses.*, program_unit_participations.program_unit_id, program_unit_members.client_id")
      return step3
    end

 def self.is_client_acting_as_care_taker_in_any_other_open_program(arg_client_id, arg_program_unit_id)
    step1 = joins("INNER JOIN program_unit_participations ON program_unit_members.program_unit_id = program_unit_participations.program_unit_id")

    step2 = step1.where("program_unit_members.client_id = ?
                and program_unit_members.program_unit_id != ?
                and program_unit_members.member_status = 4470
                and program_unit_members.primary_beneficiary = 'Y'
				and program_unit_participations.participation_status = 6043
                and program_unit_participations.id = (select max(a.id)
                                                      from program_unit_participations a
                                                      where a.program_unit_id = program_unit_members.program_unit_id
                                                      )
    ",arg_client_id, arg_program_unit_id).count > 0
  end

  # def self.is_the_client_active_in_any_program_unit(arg_client_id)
  #   where("client_id = ? and member_status = 4468",arg_client_id).count > 0
  # end

  def self.is_the_client_active_in_work_pays_program_unit(arg_client_id)
    step1 = joins("INNER JOIN program_units ON program_unit_members.program_unit_id = program_units.id")
    step2 = step1.where("program_units.service_program_id = 4 and program_unit_members.member_status = 4468 and program_unit_members.client_id = ?", arg_client_id)
    step2.count > 0
  end

  def self.is_the_client_adult_and_active_in_work_pays_program_unit(arg_client_id)
    step1 = joins("INNER JOIN program_units ON (program_unit_members.program_unit_id = program_units.id)
                  INNER JOIN Clients ON (program_unit_members.client_id = clients.id)")
    step2 = step1.where("program_units.service_program_id = 4 and program_unit_members.member_status = 4468 and (EXTRACT(YEAR FROM AGE(clients.dob))) >= 18 and program_unit_members.client_id = ?", arg_client_id)
    step3 = step2.select("*")
    return step3
  end

  # def self.is_the_client_active_in_given_program_unit(arg_client_id, arg_program_unit_id)
  #   where("client_id = ? and program_unit_id = ? and member_status = 4468",arg_client_id).count > 0
  # end



  def self.get_member_status(arg_program_unit_id,arg_client_id)
    result = nil
    pgu_members = where("program_unit_id = ? and client_id = ?",arg_program_unit_id,arg_client_id)
    if pgu_members.present?
      pgu_member = pgu_members.first
      result = pgu_member.member_status
    end
  end

  # def self.is_the_client_associated_with_any_program_unit?(arg_client_id)
  #   result = nil
  #   pgu_members = where("client_id = ?",arg_client_id).order("id desc")
  #   if pgu_members.present?
  #     result = pgu_members.first.program_unit_id
  #   end
  #   return result
  # end

  # def self.the_client_is_not_associated_with_given_program_unit?(arg_program_unit_id, arg_client_id)
  #   where("program_unit_id =? and client_id = ?",arg_program_unit_id,arg_client_id).count == 0
  # end

  # def self.is_client_open_in_program_unit(arg_client_id)
  #       step1 = joins("INNER JOIN program_units ON program_unit_members.program_unit_id = program_units.id")
  #       step2 = step1.where("program_units.program_unit_status = 5942 and program_unit_members.client_id = ?", arg_client_id)
  #       # step3 = step2.select("program_units.id,program_units.program_unit_status,program_units.disposition_status")
  #       # l_program_unit_collection = step3
  #       l_program_unit_collection = step2
  #       has_open_program_unit = false
  #       if l_program_unit_collection.present?
  #           l_program_unit_collection.each do |arg_pgu|
  #              # Get Program Unit Object
  #               # program_unit_object = ProgramUnit.find(arg_pgu.id)
  #               program_unit_object = ProgramUnit.find(arg_pgu.program_unit_id)
  #               # Get the Program participations associated with that program Unit.
  #               pg_status_collection = program_unit_object.program_unit_participations.order("id DESC")
  #                # Get latest Program Unit status.- If Open Program Unit found don't allow.
  #               if pg_status_collection.present?
  #                   pg_status_object = pg_status_collection.first
  #                   if pg_status_object.participation_status == 6043
  #                      has_open_program_unit = true
  #                      break
  #                   end
  #               end
  #           end
  #       end
  #       return has_open_program_unit
  #   end

  # def self.get_client_ids_of_pgu_members(arg_program_unit_id)
  #   where("program_unit_id = ?",arg_program_unit_id).select("program_unit_members.client_id")
  # end

  def self.is_the_client_associated_with_any_program_unit_which_has_not_been_activated?(arg_client_id, arg_service_program_id)
    result = nil
    step1 = joins("INNER JOIN program_units ON (program_unit_members.program_unit_id = program_units.id)
                  LEFT OUTER JOIN program_unit_participations ON (program_unit_members.program_unit_id = program_unit_participations.program_unit_id)")
    step2 = step1.where("program_unit_members.client_id = ? and program_units.service_program_id = ?
                         and (program_units.disposition_status is null or program_units.disposition_status != 6041)",arg_client_id, arg_service_program_id)
    step3 = step2.select("program_units.id,program_unit_participations.program_unit_id").order("program_units.id desc")
    step3.each do |record|
      if record.program_unit_id.blank?
        result = record.id
        break
      end
    end
    return result
  end


  # Manoj 02/24/2016 - start
     def self.get_adults_in_the_program_unit(arg_program_unit_id)
    adult_age = SystemParam.get_key_value(6,"child_age","18 is the age to determine adult").to_i
    step1 = joins("INNER JOIN clients
                 ON program_unit_members.client_id = clients.id")
    step2 = step1.where("program_unit_members.program_unit_id = ? and
                         (clients.dob is null or EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) >= ?)",arg_program_unit_id, adult_age)
    step3 = step2.select("program_unit_members.*")
    return step3
  end

  # Manoj 02/24/2016 - end

  def self.child_under_six_years_of_age(arg_program_unit_id, arg_start_date, arg_end_date)
    step1 = joins("INNER JOIN clients
                 ON program_unit_members.client_id = clients.id")
    if arg_start_date.present?
      step2 = step1.where("program_unit_members.program_unit_id = ? and
                         (clients.dob is null or EXTRACT(YEAR FROM AGE(?,CLIENTS.DOB)) < 6)",arg_program_unit_id, arg_start_date)
    else
      step2 = step1.where("program_unit_members.program_unit_id = ? and
                         (clients.dob is null or EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) < 6)",arg_program_unit_id)
    end

    step2.select("program_unit_members.*")
  end

  def self.no_child_under_six_years_of_age(arg_program_unit_id, arg_start_date, arg_end_date)
    child_under_six_years_of_age(arg_program_unit_id, arg_start_date, arg_end_date).count == 0
  end

  def self.one_or_more_child_under_six_years_of_age(arg_program_unit_id, arg_start_date, arg_end_date)
    child_under_six_years_of_age(arg_program_unit_id, arg_start_date, arg_end_date).count > 0
  end

  # def self.one_or_more_adult_is_disabled(arg_program_unit_id, arg_start_date, arg_end_date)
  #   min_adult_age = SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i
  #   step1 = joins("INNER JOIN client_characteristics ON program_unit_members.client_id = client_characteristics.client_id
  #                  INNER JOIN codetable_items ON client_characteristics.characteristic_id = codetable_items.id
  #                  INNER JOIN clients ON program_unit_members.client_id = clients.id")
  #   step2 = step1.where("program_unit_members.program_unit_id = ?
  #                        and codetable_items.code_table_id = 114
  #                        and (client_characteristics.start_date <= ? or client_characteristics.start_date between ? and ?)
  #                        and (client_characteristics.end_date is null or client_characteristics.end_date >= ?)
  #                        and EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) >= ?
  #                        and program_unit_members.member_status = 4468",arg_program_unit_id, arg_start_date, arg_start_date, arg_end_date, arg_start_date, min_adult_age).count > 0
  # end

  # def self.one_or_more_adult_is_deferred(arg_program_unit_id, arg_start_date, arg_end_date)
  #   min_adult_age = SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i
  #   step1 = joins("INNER JOIN client_characteristics ON program_unit_members.client_id = client_characteristics.client_id
  #                  INNER JOIN codetable_items ON client_characteristics.characteristic_id = codetable_items.id
  #                  INNER JOIN clients ON program_unit_members.client_id = clients.id")
  #   step2 = step1.where("program_unit_members.program_unit_id = ?
  #                        and codetable_items.code_table_id = 113
  #                        and client_characteristics.characteristic_id != 5667
  #                        and (client_characteristics.start_date <= ? or client_characteristics.start_date between ? and ?)
  #                        and (client_characteristics.end_date is null or client_characteristics.end_date >= ?)
  #                        and EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) >= ?
  #                        and program_unit_members.member_status = 4468",arg_program_unit_id, arg_start_date, arg_start_date, arg_end_date, arg_start_date, min_adult_age).count > 0
  # end

  def set_client_characteristics_based_on_case_type
      pum_object = ProgramUnitMember.find_by_id(self.id)
      program_unit_object = ProgramUnit.find_by_id(pum_object.program_unit_id)
      client_application_object = ClientApplication.find_by_id(program_unit_object.client_application_id)
      #find case type
      #if casetype is single or two parent set work charateristics to ready to work
      characteristic_id = nil
      if program_unit_object.case_type == 6046 || program_unit_object.case_type == 6047 #6046 - single parent and 6047 - two parent
        pgu_members = ProgramUnitMember.get_adults_in_the_program_unit(program_unit_object.id)
        characteristic_id = 5667
      elsif program_unit_object.case_type == 6049 #6049 Minor parent
        pgu_members = ProgramUnitService.get_parent_list_for_the_program_unit(program_unit_object.id)
        characteristic_id = 5701
      end
      if characteristic_id.present?
        pgu_members.each do |each_member|
          client_characteristics_collection = ClientCharacteristic.where("client_id = ? and characteristic_id = ? and (end_date is null or end_date > current_date)",each_member.client_id,characteristic_id)
          if client_characteristics_collection.blank?
            # Now proceed to adding mandatory work characteristics to the adult
            client_characteristic = ClientCharacteristic.populate_client_characteristic_information(each_member.client_id, characteristic_id, "WorkCharacteristic", client_application_object.application_date, nil) # 5667 - "Required to work"
            client_characteristic.save!
          end
        end
      end
  end


end