class ProgramUnitRepresentative < ActiveRecord::Base
has_paper_trail :class_name => 'ProgramUnitReprztatvVersion',:on => [:update, :destroy]

	include AuditModule
	#before_create :set_create_user_fields, :client_and_representative_type_uniquness
  before_create :set_create_user_fields
  before_update :set_update_user_field

  	def set_create_user_fields
	  	user_id = AuditModule.get_current_user.uid
	  	self.created_by = user_id
	  	self.updated_by = user_id
        self.start_date = Date.today
	end

	def set_update_user_field
		user_id = AuditModule.get_current_user.uid
		self.updated_by = user_id
	end

	 HUMANIZED_ATTRIBUTES = {
      client_id: "Representative",
      representative_type: "Representative type",
      status: "Status",
      start_date: "Start Date",
      end_date: "End Date"
    }

    validates_presence_of :client_id, message: "is required."
    validates_presence_of :representative_type,message: "is required."
    # validates_presence_of :start_date,message: "is required"
    validates_presence_of :status,message: "is required."



    # Ashish Added uniqueness 1/27/2015

    validates_uniqueness_of :client_id, :scope => [:program_unit_id],conditions: -> {where("end_date is null")},message: " exists as another representative type."
    validates_uniqueness_of :representative_type, :scope => [:program_unit_id],conditions: -> {where("representative_type = 4381 and end_date is null")},message: "already assigned."
    validates_uniqueness_of :representative_type, scope: [:client_id], conditions: -> {where("representative_type=4381 and end_date is null")}, message: " is active as a primary representative in another program unit."
    validate :primary_must_exist_before_secondary?, :on => :create


    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    def self.get_all_program_unit_representatives_for_program_unit(arg_program_unit_id)
    	where("program_unit_id=?",arg_program_unit_id).order("representative_type ASC")
    end

    def primary_must_exist_before_secondary?
      lb_return = true
      if representative_type == 4382
        primary_rep_count = ProgramUnitRepresentative.get_primary_representative_count(program_unit_id)
        if primary_rep_count == 0
           local_message = "Secondary representative cannot exist before primary representative for this program unit."
           errors[:base] << local_message
           lb_return =  false
        end
      end
       return lb_return
    end

  def self.get_primary_representative_count(arg_program_unit_id)
    primary_count = where("program_unit_id=? and representative_type = 4381 and end_date is null ",arg_program_unit_id).count
    return primary_count
  end


    def self.primary_representative_found?(arg_program_unit_id,arg_payment_date)
      where("program_unit_id = ? and representative_type = 4381 and (end_date is null OR (? >= start_date and ? <= end_date) )",arg_program_unit_id,arg_payment_date,arg_payment_date).count > 0
    end


    def self.set_data_for_primary_representative(arg_program_unit_id)
        # primary_benificiary_client_collection =  ProgramUnitMember.get_primary_beneficiary(arg_program_unit_id)
        # primary_benificiary_client_object = primary_benificiary_client_collection.first
        primary_contact = PrimaryContact.get_primary_contact(arg_program_unit_id, 6345)
         l_new_primary_representative = ProgramUnitRepresentative.new
         l_new_primary_representative.program_unit_id = arg_program_unit_id
         l_new_primary_representative.client_id = primary_contact.client_id if primary_contact.present?
         l_new_primary_representative.representative_type = 4381 # primary
         l_new_primary_representative.status = 6223 # active
         l_new_primary_representative.start_date = Date.today
         return l_new_primary_representative

    end

    def self.get_account_if_exist(arg_client_id,arg_representative_type)
      step1 = ProgramUnitRepresentative.joins("INNER JOIN account_numbers ON account_numbers.representative_id = program_unit_representatives.id")
      step2 = step1.where("program_unit_representatives.client_id = ? and program_unit_representatives.representative_type = ?",arg_client_id,arg_representative_type)
      step3 = step2.select("account_numbers.account_number")
    end

    def self.get_account_of_primary_of_program_unit(arg_program_unit_id)
        step1 = joins("INNER JOIN account_numbers ON account_numbers.representative_id = program_unit_representatives.id")
        step2 = step1.where("program_unit_representatives.program_unit_id = ? and program_unit_representatives.representative_type = 4381",arg_program_unit_id)
        step3 = step2.select("program_unit_representatives.id,account_numbers.account_number")
    end

    def self.get_representatives_from_program_units(arg_program_unit,arg_representative_type)
      #representative_type - primary 4381 and secondary- 4382
      step1 = joins("inner join program_units on (program_unit_representatives.program_unit_id = program_units.id
                                                                        and program_unit_representatives.end_date is null
                                                                        )
         INNER JOIN PROGRAM_UNIT_PARTICIPATIONS ON (program_units.id = PROGRAM_UNIT_PARTICIPATIONS.program_unit_id
                                               AND PROGRAM_UNIT_PARTICIPATIONS.ID = ( SELECT MAX(ID) FROM PROGRAM_UNIT_PARTICIPATIONS A WHERE A.PROGRAM_UNIT_ID = PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID)
                                               AND PROGRAM_UNIT_PARTICIPATIONS.PARTICIPATION_STATUS = 6043
                                               )")
      step2 = step1.where("program_units.id = ? and  program_unit_representatives.representative_type = ? ", arg_program_unit ,arg_representative_type)
    end

    # def self.get_secondary_representatives_of_program_units_activated_since(arg_activate_date)
    #   step1 = joins("INNER JOIN program_unit_participations ON
    #            program_unit_representatives.program_unit_id = program_unit_participations.program_unit_id")
    #   step2 = step1.where("program_unit_participations.status_date >= ? and
    #           program_unit_participations.participation_status = 6043 and
    #           (program_unit_representatives.representative_type = 4382 or program_unit_representatives.representative_type = 7777) and
    #           program_unit_representatives.end_date is null", arg_activate_date.to_time)
    # end

    # def self.get_new_adds(arg_extract_date)
    #   step1 = joins("INNER JOIN account_numbers ON account_numbers.representative_id = program_unit_representatives.id")
    #   step2 = step1.where("account_numbers.updated_at >= ? and program_unit_representatives.end_date is null", arg_extract_date.to_time)
    #   step3 = step2.select("account_numbers.account_number, program_unit_representatives.client_id,program_unit_representatives.updated_by,
    #                        program_unit_representatives.program_unit_id, program_unit_representatives.representative_type")
    # end

    # def self.get_new_deactivates(arg_extract_date)
    #   step1 = joins("INNER JOIN account_numbers ON account_numbers.representative_id = program_unit_representatives.id")
    #   step2 = step1.where("program_unit_representatives.end_date >= ? and program_unit_representatives.representative_type != 4381", arg_extract_date.to_time)
    #   step3 = step2.select("account_numbers.account_number, program_unit_representatives.program_unit_id, program_unit_representatives.representative_type")
    # end

    # def self.get_biographic_and_address_changes(arg_extract_date)
    #   step1 = joins("INNER JOIN account_numbers ON account_numbers.representative_id = program_unit_representatives.id
    #                  INNER JOIN entity_addresses ON entity_addresses.entity_id = program_unit_representatives.client_id
    #                  INNER JOIN addresses ON addresses.id = entity_addresses.address_id")
    #           .where("addresses.updated_at >= ? and program_unit_representatives.end_date is null",arg_extract_date)
    #   step2 = step1.select("program_unit_representatives.id,account_numbers.account_number, program_unit_representatives.client_id,program_unit_representatives.updated_by,
    #                        program_unit_representatives.program_unit_id, program_unit_representatives.representative_type")

    #   step3 = joins("INNER JOIN account_numbers ON account_numbers.representative_id = program_unit_representatives.id
    #                  INNER JOIN clients ON program_unit_representatives.client_id = clients.id")
    #           .where("program_unit_representatives.end_date is null and (clients.ssn_change = 'Y' or clients.dob_change = 'Y' or clients.name_change = 'Y')")
    #   step4 = step3.select("program_unit_representatives.id,account_numbers.account_number, program_unit_representatives.client_id,program_unit_representatives.updated_by,
    #                        program_unit_representatives.program_unit_id, program_unit_representatives.representative_type")

    #   step5 = step2 + step4
    #   final_array = Array.new
    #   step5.each do |each_object|
    #     step6 = {}
    #     step6["account_number"] = each_object.account_number
    #     step6["id"] = each_object.id
    #     step6["program_unit_id"] = each_object.program_unit_id
    #     step6["client_id"] = each_object.client_id
    #     step6["representative_type"] = each_object.representative_type
    #     step6["updated_by"] = each_object.updated_by
    #     final_array << step6
    #   end
    #   final_array = final_array.uniq
    #   return final_array
    # end

    def self.get_prior_program_unit(arg_account_number)
      program_unit_rep_collection = joins("INNER JOIN account_numbers ON account_numbers.representative_id = program_unit_representatives.id")
              .where("account_numbers.account_number = ?", arg_account_number).order("id DESC")
      l_count = 0
      program_unit_rep_collection.each do |each_object|
        l_count = l_count + 1
        if l_count == 2
          return each_object.program_unit_id
        end
      end
    end

    def self.get_open_program_unit_representatives(arg_program_unit_id)
      where("program_unit_id = ? and end_date is null", arg_program_unit_id)
    end

    def self.set_primary_program_unit_representative_to_active(arg_program_unit_id)
     primary_member = where("program_unit_id = ? and representative_type = 4381", arg_program_unit_id).first
     primary_member.status = 6223
     primary_member.end_date = nil
     return primary_member
    end

    def self.is_representative_of_an_open_program_unit(arg_client_id)
      step1 = joins("INNER JOIN program_unit_participations ON
                program_unit_representatives.program_unit_id = program_unit_participations.program_unit_id")
      step2 = step1.where("program_unit_participations.participation_status = 6043
                          and program_unit_representatives.client_id = ?", arg_client_id)
      step2.count > 0
    end




end