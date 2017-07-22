class ProgramBenefitMember < ActiveRecord::Base
has_paper_trail :class_name => 'ProgramBenftMembrVersion',:on => [:update, :destroy]


	include AuditModule
	belongs_to :program_wizard

	before_create :set_create_user_fields
	before_update :set_update_user_field

  belongs_to :program_wizard
  validates_presence_of  :client_id,:member_status, message: "is required."


      HUMANIZED_ATTRIBUTES = {
      client_id: "Benefit Member",
      member_status: "Status"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end


	def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id

    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end



    # def self.save_members(arg_program_wizard_id,arg_member_array,arg_member_status_array)
    # 	msg = "SUCCESS"
    # 	# Delete members for program Wizard ID - if present.
    # 	ProgramBenefitMember.where("program_wizard_id = ?",arg_program_wizard_id).destroy_all()
    # 	# Get Run ID and Month sequence for the arg_program_wizard_id.
    #   program_wizard_object = ProgramWizard.find(arg_program_wizard_id)
    #   member_status_array_index = 0
    #   li = 1
    #   arg_member_array.each do |arg_member|
    #   		l_new_object = ProgramBenefitMember.new
    #   		l_new_object.program_wizard_id = arg_program_wizard_id
    #       l_new_object.run_id = program_wizard_object.run_id
    #       l_new_object.month_sequence = program_wizard_object.month_sequence
    #   		l_new_object.client_id = arg_member.to_i
    #       l_new_object.member_status = arg_member_status_array[member_status_array_index] #4468 # ACtive
    #       l_new_object.member_sequence = li
    #   		if l_new_object.save
    #   			msg = "SUCCESS"
    #   		else
    #   			msg = l_new_object.errors.full_messages[0]
    #   			break
    #   		end
    #       li = li + 1
    #       member_status_array_index = member_status_array_index + 1
    # 	end
    # 	return msg
    # end


  def self.get_client_id(arg_run_id,arg_month_sequence,arg_member_sequence)
    member_object = ProgramBenefitMember.where("run_id = ? and month_sequence = ? and member_sequence = ?",arg_run_id,arg_month_sequence,arg_member_sequence ).first
    return member_object.client_id
  end


    # Thirumal & Kiran
	def self.program_benefit_member_dob(arg_run_id,arg_mo_seq)
	    step1 = joins("INNER JOIN clients ON clients.id = program_benefit_members.client_id")
	    step2 = step1.where("program_benefit_members.run_id = ? and program_benefit_members.month_sequence = ?", arg_run_id, arg_mo_seq)
	    step3 = step2.select("program_benefit_members.client_id,
	    				program_benefit_members.member_status, program_benefit_members.member_sequence, clients.dob")
  end

  def self.get_client_ids_associated_with_run_id(arg_run_id)
    where("run_id = ?", arg_run_id).select("client_id")
  end





  def self.get_active_adult_client_ids_associated_with_run_id(arg_run_id)
      arg_category = 6
      arg_key = "child_age"
      arg_comments = "get adult age"
      l_adult_age = SystemParam.get_key_value(arg_category,arg_key,arg_comments)
      l_adult = l_adult_age.to_i
      l_return_collection = where("1=2")
      step1 = where("program_benefit_members.run_id = ? and program_benefit_members.member_status = 4468",arg_run_id)
      step1.each do |active_member|
        l_age = Client.get_age(active_member.client_id)
        if l_age >= l_adult
           l_return_collection << active_member
        end
      end
      return l_return_collection
  end

  def self.get_program_benefit_memebers_from_wizard_id(arg_program_wizard_id)
    where("program_wizard_id = ?", arg_program_wizard_id).order("client_id ASC")
  end

  def self.get_program_benefit_members_from_run_id_and_month_sequence(arg_run_id,arg_month_sequence)
    where("run_id = ? and month_sequence = ?",arg_run_id,arg_month_sequence)
  end



  def self.get_benefit_member_status(arg_program_wizard_id,arg_client_id)
    where("program_wizard_id = ? and client_id = ?",arg_program_wizard_id,arg_client_id)
  end

  def self.get_active_members_from_run_id_and_month_sequence(arg_run_id,arg_month_sequence)
      where("member_status = 4468 and run_id = ? and month_sequence = ?",arg_run_id,arg_month_sequence)
  end

  def self.get_next_member_sequence(arg_program_wizard_id)
    l_count = ProgramBenefitMember.where("program_wizard_id = ?",arg_program_wizard_id).count
    if l_count == 0
      l_count = 1
    else
      l_count = l_count + 1
    end
    return l_count

  end

  # def self.get_available_program_unit_members(arg_program_wizard_id)
  #   step1 = ProgramUnitMember.joins("INNER JOIN program_wizards
  #                                   ON program_unit_members.program_unit_id = program_wizards.program_unit_id
  #                                   INNER JOIN clients
  #                                   ON program_unit_members.client_id = clients.id")
  #   step2 = step1.where("program_wizards.id = ?",arg_program_wizard_id)
  #   step3 = step2.select("program_unit_members.client_id as client_id,
  #                        (clients.last_name ||', '||clients.first_name) as client_name")
  #   program_unit_member_collection = step3
  #   logger.debug("program_unit_member_collection = #{program_unit_member_collection.inspect}")


  #   step4 = ProgramBenefitMember.joins("INNER JOIN clients
  #                                      ON program_benefit_members.client_id = clients.id")
  #   step5 = step4.where("program_benefit_members.program_wizard_id = ?",arg_program_wizard_id)
  #   step6 = step5.select("program_benefit_members.client_id as client_id,
  #                        (clients.last_name ||', '||clients.first_name) as client_name")
  #   program_benefit_member_collection = step6
  #    logger.debug("program_benefit_member_collection = #{program_benefit_member_collection.inspect}")
  #   available_members = program_unit_member_collection - program_benefit_member_collection
  #    logger.debug("available_members = #{available_members.inspect}")
  #   # available_members = available_members.sort!{ |a,b| a.client_id <=> b.client_id }
  #   return available_members
  # end

  def self.get_available_program_unit_members_query(arg_program_wizard_id)

      step1 = Client.joins("INNER JOIN program_unit_members on clients.id = program_unit_members.client_id
                            INNER JOIN program_wizards ON program_unit_members.program_unit_id = program_wizards.program_unit_id").
                    where("program_wizards.id = ?",arg_program_wizard_id).
                    select("clients.id")

      step2 = Client.joins("INNER JOIN program_benefit_members on program_benefit_members.client_id = clients.id").
                     where("program_benefit_members.program_wizard_id = ?",arg_program_wizard_id).
                     select("clients.id")

      available_members = step1 - step2
    # Old code start---------------------
    # step1 = Client.joins("INNER JOIN (
    #                                   select program_unit_members.client_id as client_id
    #                                   from program_unit_members
    #                                   INNER JOIN program_wizards
    #                                   ON program_unit_members.program_unit_id = program_wizards.program_unit_id
    #                                   where program_wizards.id = #{arg_program_wizard_id}

    #                                   EXCEPT

    #                                   select program_benefit_members.client_id as client_id
    #                                   from program_benefit_members
    #                                   where program_benefit_members.program_wizard_id = #{arg_program_wizard_id}
    #                                   )available_members
    #                       ON clients.id =  available_members.client_id")

    # step2 = step1.select("clients.*")

    # step3 = step2.order("clients.id ASC")

    # available_members = step3
    # old code end --------------------------------

    return available_members


  end


  def self.primary_member_selected(arg_program_wizard_id)
    ls_primary_found = "N"
    program_wizards = ProgramWizard.where("id = ?",arg_program_wizard_id)
    if program_wizards.present?
      step1 = joins("INNER JOIN primary_contacts
                   ON primary_contacts.client_id = program_benefit_members.client_id")
      step2 = step1.where("primary_contacts.reference_id = ? and primary_contacts.reference_type = 6345",program_wizards.first.program_unit_id)
      if step2.present?
        ls_primary_found = "Y"
      end
    end
    return ls_primary_found
  end

  def self.check_if_client_has_valid_status_for_ssi_validation(arg_client_id, arg_program_wizard_id)
    where("client_id = ? and program_wizard_id = ? and member_status in (4468, 4469)",arg_client_id, arg_program_wizard_id).count > 0
  end

  # def self.is_the_member_active(arg_client_id, arg_program_wizard_id)
  #   where("program_wizard_id =? and client_id = ? and member_status = 4468",arg_program_wizard_id, arg_client_id).count > 0
  # end

  def self.get_active_program_benefit_memebers_from_wizard_id(arg_program_wizard_id)
    where("program_wizard_id = ? and member_status = 4468", arg_program_wizard_id).order("client_id ASC")
  end

  def self.atleast_one_active_child_present(arg_program_wizard_id)
      step1 = ProgramBenefitMember.joins("INNER JOIN clients
                                          ON program_benefit_members.client_id = clients.id")
      step2 = step1.where("program_benefit_members.program_wizard_id = ?
                           and program_benefit_members.member_status = 4468
                          and (EXTRACT(YEAR FROM AGE(clients.dob)) < (SELECT CAST(VALUE AS INTEGER) FROM SYSTEM_PARAMS WHERE SYSTEM_PARAM_CATEGORIES_ID = 6))",arg_program_wizard_id)


      active_child_member_collection = step2

      if active_child_member_collection.present?
        ls_active_client_found = "Y"
      else
        step1 = ProgramBenefitMember.joins("INNER JOIN clients
                                          ON program_benefit_members.client_id = clients.id")
        step2 = step1.where("program_benefit_members.program_wizard_id = ?
                             and program_benefit_members.member_status = 4468
                            and (EXTRACT(YEAR FROM AGE(clients.dob)) = (SELECT CAST(VALUE AS INTEGER) FROM SYSTEM_PARAMS WHERE SYSTEM_PARAM_CATEGORIES_ID = 6))",arg_program_wizard_id)
        clients = step2.select("clients.*")
        if clients.present? && clients.first.dob.month == Date.today.month
          ls_active_client_found = "Y"
        else
          ls_active_client_found = "N"
        end
      end

      return ls_active_client_found

  end

  def self.get_latest_program_benefit_members(arg_program_unit_id)
    step1 = ProgramBenefitMember.joins("INNER JOIN program_wizards on program_benefit_members.program_wizard_id = program_wizards.id
                                        Inner join clients on clients.id = program_benefit_members.client_id ")
    step2 = step1.where("PROGRAM_WIZARDS.PROGRAM_UNIT_ID = ? and PROGRAM_WIZARDS.submit_date IS NOT NULL  ",arg_program_unit_id).order("submit_date DESC")

    first_run_id = step2.first.run_id
    step3 = step2.where("program_benefit_members.run_id = ?",first_run_id).order("clients.dob  asc")
    step4 = step3.select("clients.first_name, clients.last_name,program_benefit_members.*")
    result = step4
    return result
  end


   def self.atleast_one_active_adult_present(arg_program_wizard_id)
      step1 = ProgramBenefitMember.joins("INNER JOIN clients
                                          ON program_benefit_members.client_id = clients.id")
      step2 = step1.where("program_benefit_members.program_wizard_id = ?
                           and program_benefit_members.member_status = 4468
                          and (EXTRACT(YEAR FROM AGE(clients.dob)) >= (SELECT CAST(VALUE AS INTEGER) FROM SYSTEM_PARAMS WHERE SYSTEM_PARAM_CATEGORIES_ID = 6))",arg_program_wizard_id)


      active_adult_member_collection = step2
      if active_adult_member_collection.present?
        ls_active_adult_found = "Y"
      else
        ls_active_adult_found = "N"
      end

      return ls_active_adult_found

  end

  def self.get_care_taker_list(arg_program_wizard_id)
    step1 = ProgramBenefitMember.joins("INNER JOIN program_wizards
                                        ON (program_benefit_members.program_wizard_id = program_wizards.id
                                            and program_benefit_members.member_status = 4470
                                            )
                                        INNER JOIN program_unit_members
                                        ON (program_wizards.program_unit_id = program_unit_members.program_unit_id
                                            and program_unit_members.primary_beneficiary = 'Y'
                                           )
                                        "
                                    )
    step2 = step1.where("program_benefit_members.program_wizard_id = ?
                        and program_benefit_members.client_id = program_unit_members.client_id
                        ",arg_program_wizard_id
                        )
    caretaker_collection = step2
    return caretaker_collection
  end


  def self.reset_member_sequence_for_benefit_members(arg_program_wizard_id)
    program_benefit_member_collection = ProgramBenefitMember.where("program_wizard_id = ?",arg_program_wizard_id).order("created_at ASC")
    if program_benefit_member_collection.present?
         counter = 1
        program_benefit_member_collection.each do |each_member|
            program_benefit_member_object = ProgramBenefitMember.find(each_member.id)
            program_benefit_member_object.member_sequence = counter
            program_benefit_member_object.save
            counter = counter + 1
        end
    end

  end


  def self.get_active_program_benefit_memebers_client_id_from_wizard_id_for_batch(arg_program_wizard_id)
    step1 = where("program_wizard_id = ? and member_status = 4468", arg_program_wizard_id).order("client_id ASC")
   benfit_members_array = []
    if step1.present?
      step1.each do |each_member|
    benfit_members_array << each_member.client_id
      end
    end
    return benfit_members_array
  end

  def self.get_count_of_active_adults_present(arg_program_wizard_id)
      step1 = ProgramBenefitMember.joins("INNER JOIN clients
                                          ON program_benefit_members.client_id = clients.id")
      step2 = step1.where("program_benefit_members.program_wizard_id = ?
                           and program_benefit_members.member_status = 4468
                          and (EXTRACT(YEAR FROM AGE(clients.dob)) >= (SELECT CAST(VALUE AS INTEGER) FROM SYSTEM_PARAMS WHERE SYSTEM_PARAM_CATEGORIES_ID = 6))",arg_program_wizard_id)


      active_adult_member_collection = step2
       return active_adult_member_collection

  end


  # def self.get_program_benefit_members_first_time_activation(arg_program_unit_id)
  #   step1 = ProgramBenefitMember.joins("INNER JOIN program_wizards on program_benefit_members.program_wizard_id = program_wizards.id
  #                                       Inner join clients on clients.id = program_benefit_members.client_id ")
  #   step2 = step1.where("PROGRAM_WIZARDS.PROGRAM_UNIT_ID = ? ",arg_program_unit_id)
  #   step3 = step2.select("clients.first_name, clients.last_name,program_benefit_members.*")
  #   return step3
  # end



    def self.get_active_adult_client_ids_associated_with_program_wizard_id(arg_program_wizard_id)
      arg_category = 6
      arg_key = "child_age"
      arg_comments = "get adult age"
      l_adult_age = SystemParam.get_key_value(arg_category,arg_key,arg_comments)
      l_adult = l_adult_age.to_i
      result = []
      step1 = where("program_benefit_members.program_wizard_id = ?",arg_program_wizard_id)
      step1.each do |member|
        l_age = Client.get_age(member.client_id)
        if l_age >= l_adult
           result << member
        end
      end
      return result
    end

    def self.get_program_benefit_members(arg_run_id)
      step1 = ProgramBenefitMember.joins("program_benefit_members INNER JOIN clients on program_benefit_members.client_id = clients.id")
      step2 = step1.where("program_benefit_members.run_id = ?",arg_run_id)
      step3 = step2.select("program_benefit_members.*, clients.id, clients.ssn, clients.gender, clients.dob, (clients.last_name ||', ' || clients.first_name) as client_full_name")
    end

    def self.get_program_benefit_memebers_and_client_details_from_wizard_id(arg_program_wizard_id)
      step1 = ProgramBenefitMember.joins("program_benefit_members INNER JOIN clients on program_benefit_members.client_id = clients.id")
      step2 = step1.where("program_benefit_members.program_wizard_id = ?",arg_program_wizard_id)
      step3 = step2.select("program_benefit_members.*, clients.id, clients.ssn, clients.gender, clients.dob, (clients.last_name ||', ' || clients.first_name) as client_full_name").order("program_benefit_members.client_id ASC")
    end

end


