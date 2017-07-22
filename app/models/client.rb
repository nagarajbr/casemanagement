class Client < ActiveRecord::Base
has_paper_trail :class_name => 'ClientVersion', :on => [:update, :destroy]
# Manoj 12/29/2015
# after_save :add_default_mandatory_work_characteristic_to_adult,:residency_informantion_changed,:complete_citizenship_step
after_save :residency_informantion_changed,:complete_citizenship_step

 	include AuditModule
	   before_create :set_create_user_fields
	   before_update :set_update_user_field
	   after_update :readjust_household_member_registration_steps_if_dob_is_updated,:check_for_famliy_cap_when_new_member_added_to_program_unit

    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
      @client_record = Client.find(self.id)
    end

attr_accessor :ssn_not_found
  #  instantiate Common service object
  after_initialize do |obj|
    @l_service_object = CommonService.new
  end

	before_validation :set_empty_attributes_to_nil
	before_validation :ssn_validation
	#before_create :ssn_validation
	#before_update :ssn_validation
	#Alien

	has_one :alien, dependent: :destroy

	#RACE
     has_many :client_races, dependent: :destroy

     has_many :races, through: :client_races
     # validates_presence_of :races


	#Address
    # has_many :client_addresses, dependent: :destroy
    # has_many :addresses,through: :client_addresses



	#Phone
    has_many :phones, dependent: :destroy
    # accepts_nested_attributes_for :phones

    #Income
	has_many :client_incomes, dependent: :destroy
	has_many :incomes,through: :client_incomes, source: :income

    #Expense
	has_many :client_expenses, dependent: :destroy
	has_many :expenses,through: :client_expenses, source: :expense

	# pregnancies
	has_many :pregnancies, dependent: :destroy

	#Resource
	has_many :client_resources, dependent: :destroy
	has_many :shared_resources, through: :client_resources, source: :resource


	#Employment
	has_many :employments, dependent: :destroy

	#Education
	has_many :educations, dependent: :destroy





	# Immunizations
	 has_many :immunizations, dependent: :destroy

	 # sanctions
	has_many :sanctions, dependent: :destroy

	 # time limits
	has_many :time_limits, dependent: :destroy

	#Client Characteristics - Kiran 08/27/2014

	# Disability Characteristics
    # has_many :client_characteristics, dependent: :destroy
    # has_many :disability_characteristics, through: :client_characteristics, source: :characteristic, source_type: "DisabilityCharacteristic"

    # #Health Characteristics
    # has_many :client_characteristics, dependent: :destroy
    # has_many :health_characteristics, through: :client_characteristics, source: :characteristic, source_type: "HealthCharacteristic"

    #Work Characteristics
    # has_many :client_characteristics, dependent: :destroy
    # has_many :work_characteristics, through: :client_characteristics, source: :characteristic, source_type: "WorkCharacteristic"

    #Other Characteristics
    # has_many :client_characteristics, dependent: :destroy
    # has_many :other_characteristics, through: :client_characteristics, source: :characteristic, source_type: "OtherCharacteristic"

    # #Other Characteristics
    # has_many :client_characteristics, dependent: :destroy
    # has_many :mental_characteristics, through: :client_characteristics, source: :characteristic, source_type: "MentalCharacteristic"







     # Model Validations .
     HUMANIZED_ATTRIBUTES = {
     	first_name: "First Name",
     	last_name: "Last Name",
     	middle_name: "Middle Name",
    	ssn: "Social Security Number ",
    	ssn_not_found: "Assign Psuedo SSN",
    	ssn_enumeration_type: "SSN Enumeration Status",
    	dob: "Date of Birth",
    	identification_type: "Provide Identification",
    	gender: "Gender",
    	marital_status: "Marital Status",
    	primary_language: "Primary Language",
    	death_date: "Date of Death",
    	veteran_flag: "Veteran",
    	felon_flag: "Answer to Felon question",
    	rcvd_tea_out_of_state_flag: "Received TANF payment in other state"
  	}

  	def self.human_attribute_name(attr,options={})
    	HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end


	validates_presence_of :first_name, :last_name,:ssn,:felon_flag,:rcvd_tea_out_of_state_flag, message: "is required"

	#validates_presence_of :first_name, message: "is required"
	#validates_presence_of :last_name, message: "is required"
	#validates_presence_of :ssn, message: "is required"



     validates :suffix, allow_blank: true, format: { with: /\A^[a-zA-Z0-9_ ]*$+\z/,
    								 message: "only allows letters, numbers and spaces."
    							   }

    validates_uniqueness_of :ssn, message: "is already assigned in the system."
    validates :ssn, :numericality => true, :allow_blank => true,length: { is:9 }
    validates :middle_name, :allow_blank => true, length: { maximum: 35 }
	validates :suffix, :allow_blank => true,length: { maximum:4 }
    validate :validate_death_of_date_if_dob_present?
    validate :perform_custom_validation




	# validates_format_of :first_name, with: /[a-zA-Z]/
	# validates_exclusion_of :first_name, in: /[0-9]/, message: 'First name should not contain numbers'
	# validates_presence_of :last_name
	# validates_format_of :last_name, with: /[a-zA-Z]/
	# validates_exclusion_of :last_name, in: /[0-9]/, message: 'Last name should not contain numbers'
	#validates_presence_of :ethnicity



	validates_inclusion_of :dob, :allow_blank => true,:in => Date.civil(1900, 1, 1)..Date.today, message: " must be later than 01/01/1900 and prior to current date"

	validates :death_date,:allow_blank => true,:inclusion => { :in => Date.civil(1900, 1, 1)..Date.today, message: " must be after 01/01/1900 and prior to current date." }
	validate :death_date_greater_than_birth_date
	# validate :gender_for_pregnancy
	before_update :gender_for_pregnancy



    #Change Name,DOB and SSN flags when these parameters change

	before_update do |client|
	 client.name_chgd = 'Y' if client.last_name_changed?
     client.name_chgd = 'Y' if client.first_name_changed?
     client.dob_change = 'Y' if client.dob_changed?
     client.ssn_change = 'Y' if client.ssn_changed?
     client.sves_status = 'S' if client.last_name_changed?
     client.sves_status = 'S' if client.first_name_changed?
     client.sves_status = 'S' if client.dob_changed?
     client.sves_status = 'S' if client.ssn_changed?
     end

   # Manoj Patil 05/27/2015
	# after_update :biographic_information_changed
	# after_update :citizenship_data_changed

	# validates :client_email, allow_blank: true, format: { with: /\A\S+@.+\.\S+\z/,
 #                                 message: "email"}


    # def valid_email_address?
    # 	result = ""
    # 	if (self.client_email.present? && ((self.client_email.to_s =~ /\A\S+@.+\.\S+\z/).nil?))
	   #  	result = "Email address is required. It must be in the format: username@domain.com"
    # 	end
    # end

     def perform_custom_validation
    	if self.identification_type.present? && self.identification_type.to_i == 4599
	       validates_presence_of :other_identification_document, message: "is required"
	    end
    end

    def self.get_client_full_name_from_client_id(arg_client_id)
		client_id = self.find(arg_client_id)
		client_name = "#{client_id.last_name}, #{client_id.first_name}"
		return client_name

	end

	# def self.get_primary_client_full_name_from_program_unit(arg_program_unit)
	# 	step1 = joins("inner join program_unit_members on clients.id = program_unit_members.client_id")
 #    	step2 = step1.where("program_unit_id = ? and primary_beneficiary = 'Y'",arg_program_unit)
 #    	step3 = step2.select("clients.first_name,clients.last_name,clients.middle_name")

 #     return step3



	# end





	# Manoj 07/21/2014
	# Allow length allowed by Database field width. -start



	# Manoj 07/21/2014 - End

	def set_empty_attributes_to_nil
		# This method makes sure - empty string does not save in the database.
		# example: SSN - empty string was getting saved in the database- it was giving unique constraint error - while saving nil SSNs
		# hence this method.
   #  	@attributes.each do |key,value|
			# self[key] = nil if value.blank?
   #      end
   		@l_service_object.set_empty_attributes_to_nil(self)
	end


	def death_date_greater_than_birth_date
	  	if (death_date.present?) && (dob.present?)
		 	   if death_date < dob
			    errors.add(:death_date, "must be after Date of Birth")
			   end
	 	end
	end


    def self.search(params)
    	result = nil
    	step1 = Client.joins("LEFT OUTER JOIN household_members
    		                 ON clients.id = household_members.client_id")

    	if params[:ssn].present?
    		# where("ssn = ?" ,"#{params[:ssn]}")
	      	sql_first = step1.where("clients.ssn = ?" ,"#{params[:ssn]}")
	      	if sql_first.blank?
				result = "No results found"
			else
				result = apply_other_search_filters(sql_first,params)
			end
	  	else
	  	 	# search by name
			if params[:last_name].present? && params[:first_name].present?
				if (params[:last_name].length)>0 && (params[:first_name].length)>0
					last_name = "#{params[:last_name]}".strip.downcase + "%"
					first_name = "#{params[:first_name]}".strip.downcase + "%"
					# sql_first = self.where("lower(trim(last_name)) like ? and lower(trim(first_name)) like ?" ,last_name,first_name).order("last_name, first_name ASC")
					sql_first = step1.where("lower(trim(clients.last_name)) like ? and lower(trim(clients.first_name)) like ?" ,last_name,first_name).order("clients.last_name, clients.first_name ASC")
					# order(first_name: :asc)
					# check if gender entered.
					if sql_first.present?
						result = apply_other_search_filters(sql_first,params)
					end

					if result.blank?
						result = "No results found"
					end
				else
					result = "Please enter atleast 2 characters in the search fields"
				end
				# return sql_third
				return result
			end
	  	end
	end

	def self.apply_other_search_filters(sql_first,params)
		sql_second = nil
		sql_third = nil
		if params[:ssn].blank? && params[:gender].present?
			sql_second = sql_first.where("clients.gender = ?",params[:gender])
		else
			sql_second = sql_first
		end

		# check if DOB is entered,
		if params[:ssn].blank? && params[:dob].present?
			sql_third = sql_second.where("clients.dob = ?",params[:dob].to_date)
		else
			sql_third = sql_second
		end

		# every client should be present in household member
		# sql_fourth = sql_third.where("id in (select client_id from household_members)")
		result = sql_third.select("clients.id as client_id,
			                           household_members.household_id,
			                           household_members.member_status,
			                           clients.last_name,
			                           clients.first_name,
			                           clients.ssn,
			                           clients.dob,
			                           clients.gender
			                           ").order("clients.last_name, clients.first_name ASC")
	end

	def get_full_name
		"#{last_name}, #{first_name}"
		# first_name + " " + last_name
	end

	def get_client_name
		"#{last_name}, #{first_name}"

	end

	def gender_for_pregnancy
		if self.pregnancies.count > 0 && gender != 4478
			errors[:base] << "Gender for this client cannot be male, due to pregnancy information on file."
			return false
		else
			return true
		end
	end


	def set_ssn_seq_sequence
	  self.class.connection.select_value("SELECT nextval('ssn_seq')")
	end

	def ssn_validation
		if !(self.ssn.present?) and self.ssn_not_found == "Y"
			self.ssn = set_ssn_seq_sequence()
		end
		if self.ssn.present?
  			self.ssn = self.ssn.scan(/\d/).join
  		end
	end

	def self.has_ssn(arg_client_id)
		where("id = ? and ssn is not null",arg_client_id).count > 0
	end

	def self.get_ssn(arg_client_id)
		client_info = self.find_by("id = ? ",arg_client_id)
		l_ssn = client_info.ssn
		return l_ssn
	end

	def self.has_dob(arg_client_id)
		where("id = ? and dob is not null",arg_client_id).count > 0
	end

	def self.get_dob(arg_client_id)
		client_info = self.find_by("id = ? ",arg_client_id)
		l_dob = client_info.dob
		return l_dob
	end

	def self.has_felon_characteristics(arg_client_id)
		where("id = ? and felon_flag = 'Y'",arg_client_id).count > 0
	end

	def self.has_received_any_tea_out_of_state_payments(arg_client_id)
		where("id = ? and rcvd_tea_out_of_state_flag = 'Y'",arg_client_id).count > 0
	end

	def self.is_adult(arg_client_id)
		step1 = where("id = ? and EXTRACT(YEAR FROM AGE(CLIENTS.DOB))>= (SELECT CAST(VALUE AS INTEGER) FROM SYSTEM_PARAMS WHERE SYSTEM_PARAM_CATEGORIES_ID = 6)",arg_client_id).first
        if step1.present?
        	return true
        else
        	return false
        end

	end

	def self.is_child(arg_client_id)
		step1 = where("id = ? and EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) < (SELECT CAST(VALUE AS INTEGER) FROM SYSTEM_PARAMS WHERE SYSTEM_PARAM_CATEGORIES_ID = 6)",arg_client_id).first
        if step1.present?
        	return true
        else
        	return false
        end
	end


	def self.get_age(arg_client_id)
		client_ret = where("id = ?",arg_client_id).first
		if client_ret.dob.present?
			age = Date.today.year - client_ret.dob.year
	    	age -= 1 if Date.today < client_ret.dob + age.years
	    	return age
	    else
	    	return -1
    	end
	end

	def self.get_age_in_months(arg_client_id)
		result = nil
		clients = where("id = ?", arg_client_id)
		result = clients.select("EXTRACT(MONTH FROM AGE(CLIENTS.DOB)) as age").first.age if clients.present?
		return result
	end

	def self.get_age_in_days(arg_client_id)
		result = nil
		clients = where("id = ?", arg_client_id)
		result = clients.select("EXTRACT(DAY FROM AGE(CLIENTS.DOB)) as age").first.age if clients.present?
		return result
	end

	def self.child_turns_adult_in_a_given_month(arg_client_id, arg_date)
		result = false
		client = find(arg_client_id)
		if client.present? && client.dob?
			age = arg_date.year - client.dob.year
			if (age == SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i) && (client.dob.month == arg_date.month)
				result = true
			end
		end
		return result
	end

	# def self.is_male(arg_client_id)
	# 	where("id = ? and gender = 4479",arg_client_id).count > 0
	# end



	# def self.is_female(arg_client_id)
	# 	where("id = ? and gender = 4478",arg_client_id).count > 0
	# end

	def self.is_exempted_from_immunization(arg_client_id)
		where("id = ? and exempt_from_immunization = 'Y'",arg_client_id).count > 0
	end

	 def validate_death_of_date_if_dob_present?
    if death_date.present?
      if dob.present?
        return true
      else
        errors[:base] << "Date of birth is required if date of death is present"
        return false
      end
    else
      return true
    end
  end


  # Manoj 10/15/2014
  # def self.is_ssn_present_in_the_system?(arg_ssn)
  #     Client.where("ssn = ?",arg_ssn).count > 0
  # end

  def self.search_for_intake_queue(arg_potential_client_id)

  	l_potential_client_object = PotentialIntakeClient.find(arg_potential_client_id)
  	# search if this client is present in Client table.
  	# First name and Last name are mandatory
  	lower_case_last_name = l_potential_client_object.last_name.downcase.strip
  	lower_case_first_name = l_potential_client_object.first_name.downcase.strip

  	step1_result = Client.where("lower(last_name) = ? and lower(first_name) = ?", lower_case_last_name,lower_case_first_name)

	# DOB search
	if l_potential_client_object.date_of_birth.present?
		step2_result = step1_result.where("dob = ?", l_potential_client_object.date_of_birth)
	else
		step2_result = step1_result
	end

	# SSN search
	if l_potential_client_object.ssn.present?
		step3_result = step2_result.where("ssn = ?", l_potential_client_object.ssn)
	else
		step3_result = step2_result
	end
	step3_result = step3_result.order("last_name ASC")
	return step3_result

  end


  # Service Authorization validation Start - Manoj 01/12/2015

    #  def self.check_client_srvc_authorization_overlapping_dates(arg_client_id,arg_service_type,arg_start_date,arg_end_date)
    #  #    Testing the range "start1 to end1" against the range "start2 to end2" is done by testing if...
    #  # ( start1 <= end2 and start2 <= end1 )
    #  #    If TRUE, then the ranges overlap.
    #     lb_return = false
    #     srvc_authorization_collection = ServiceAuthorization.where("client_id = ? and service_type = ?",arg_client_id,arg_service_type).order("service_end_date DESC")
    #     if srvc_authorization_collection.present?
    #         latest_srvc_authorization_object = srvc_authorization_collection.first
    #       if ( (arg_start_date <= latest_srvc_authorization_object.service_end_date) and (latest_srvc_authorization_object.service_start_date <= arg_end_date) )
    #             lb_return = true
    #       end
    #     end
    #     return lb_return
    # end

    # def self.check_client_srvc_authorization_overlapping_dates_update(arg_client_id,arg_service_type,arg_start_date,arg_end_date,arg_srvc_authorization_id)
    #      # other than current record search other record.
    #           #    Testing the range "start1 to end1" against the range "start2 to end2" is done by testing if...
    #  # ( start1 <= end2 and start2 <= end1 )
    #  #    If TRUE, then the ranges overlap.
    #     lb_return = false
    #     srvc_authorization_collection = ServiceAuthorization.where("client_id = ? and service_type = ? and id != ?",arg_client_id,arg_service_type,arg_srvc_authorization_id).order("service_end_date DESC")
    #     if srvc_authorization_collection.present?
    #         latest_srvc_authorization_object = srvc_authorization_collection.first
    #         if ( (arg_start_date <= latest_srvc_authorization_object.service_end_date) and (latest_srvc_authorization_object.service_start_date <= arg_end_date) )
    #             lb_return = true
    #         end
    #     end
    #     return lb_return
    # end

  # Service Authorization validation End - Manoj 01/12/2015

# def create_work_task()

# 	WorkTask.create_task(1,1,
# 	                           1,
# 	                           1,
# 	                           1,
# 	                           1,
# 	                           1,
# 	                           '2015-02-01',
# 	                           '2015-02-01',
# 	                           'action_text',
# 	                           'instructions',
# 	                           1,
# 	                           'notes',
# 	                           1,
# 	                           1)

# end


	  def self.get_clients_age_routine
	    step1 = joins("INNER JOIN PROGRAM_UNIT_MEMBERS ON (PROGRAM_UNIT_MEMBERS.CLIENT_ID = CLIENTS.ID and PROGRAM_UNIT_MEMBERS.MEMBER_STATUS = 4468)
					   INNER JOIN PROGRAM_UNITS ON (PROGRAM_UNIT_MEMBERS.PROGRAM_UNIT_ID = PROGRAM_UNITS.ID AND (PROGRAM_UNITS.SERVICE_PROGRAM_ID =  1 OR  PROGRAM_UNITS.SERVICE_PROGRAM_ID = 4))
					   INNER JOIN PROGRAM_UNIT_PARTICIPATIONS ON (PROGRAM_UNITS.ID=PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID
	                                           AND PROGRAM_UNIT_PARTICIPATIONS.ID = ( SELECT MAX(ID) FROM PROGRAM_UNIT_PARTICIPATIONS A WHERE A.PROGRAM_UNIT_ID = PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID)
	                                           AND PROGRAM_UNIT_PARTICIPATIONS.PARTICIPATION_STATUS = 6043
	                                           )")
		step2 = step1.select("clients.id,PROGRAM_UNIT_MEMBERS.program_unit_id, clients.dob")

		step3 = step2.where("clients.DOB IS NOT NULL
	                 AND (case when (EXTRACT(month FROM age(CLIENTS.DOB))=0
	                 AND EXTRACT(year FROM age(CLIENTS.DOB)) = (SELECT CAST(VALUE AS INTEGER) FROM SYSTEM_PARAMS WHERE SYSTEM_PARAM_CATEGORIES_ID = 6))
	                            then  date_part('year',age(clients.dob)) = (SELECT CAST(VALUE AS INTEGER) FROM SYSTEM_PARAMS WHERE SYSTEM_PARAM_CATEGORIES_ID = 6)
	                      end)")
	    dob_return = step3
	     return dob_return
	  end



	def biographic_information_changed

		lb_information_changed = false
		if (first_name_changed? || last_name_changed? || middle_name_changed? ||
			suffix_changed? || ssn_changed? || dob_changed? ||citizenship_changed?||gender_changed? #||
			 #|| marital_status_changed? || death_date_changed?
			)
			lb_information_changed = true
		end
		return lb_information_changed
	end

	def residency_informantion_changed
    	 client_object = Client.find(id)
    	 if (residency_changed? && ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(self.id))
    	 	msg = ClientDemographicsService.call_event_management_service(client_object)
         end

    end
     def self.is_a_state_resident(arg_client_id)
         where("id = ? and residency = 'Y'",arg_client_id).count > 0
     end

    def self.get_the_youngest_child_in_the_household(arg_program_unit_id)
    	# Rails.logger.debug("--> get_list_of_active_child_under_six_years")
	    step1 = joins("INNER JOIN program_benefit_members ON clients.id = program_benefit_members.client_id
	    			   INNER JOIN program_wizards ON program_wizards.run_id = program_benefit_members.run_id")
	    # step2 = step1.where("program_wizards.program_unit_id = ? and program_wizards.selected_for_planning = 'Y'
    	# 					 and to_char(clients.dob, 'MMDD') between to_char(to_date(?,'yyyy-mm-dd'), 'MMDD') and to_char(to_date(?,'yyyy-mm-dd'), 'MMDD') and EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) < 6",arg_program_unit_id, arg_start_date.to_time, arg_end_date.to_time)
		step2 = step1.where("program_wizards.program_unit_id = ?
    						 and EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) < 18",arg_program_unit_id)
		step3 = step2.present? ? step2.select("clients.*").order("dob").first : ""
	    return step3
	end

	def self.date_of_death_present(arg_client_id)
		step1 = self.where("death_date is not null and id = ?",arg_client_id)
		if step1.present?
			return true
		else
			return false
		end

	end

	def self.get_list_of_active_clients_in_open_program_unit
		step1 = joins("inner join program_unit_members on program_unit_members.client_id = clients.id
			inner join program_unit_participations on program_unit_members.program_unit_id = program_unit_participations.program_unit_id
			inner join program_units on program_unit_members.program_unit_id = program_units.id")
		step2 = step1.where(" program_unit_members.member_status = 4468
							and program_unit_participations.participation_status = 6043")
		step3 = step2.select("distinct clients.*,program_unit_participations.program_unit_id,program_units.service_program_id")
	end


	def self.get_client_dob(arg_client_id)
		dob = nil
		client = find(arg_client_id)
		if client.present?
			dob = client.dob
		end
		return dob
	end

	def self.get_work_characteristic_mandatory_for_program_unit
      month_end_date = nil
      a = Date.today - 1.month
      month_end_date = a.end_of_month

       step1 = joins("INNER JOIN program_unit_members on program_unit_members.client_id = clients.id and program_unit_members.member_status = 4468
       	              INNER JOIN program_units on program_units.id = program_unit_members.program_unit_id
                      INNER JOIN client_characteristics on(program_unit_members.client_id = client_characteristics.client_id
                                        AND client_characteristics.characteristic_type= 'WorkCharacteristic'
                                        AND client_characteristics.characteristic_id = 5667
                                        AND client_characteristics.id = (select client_characteristics.id
                                                                          FROM client_characteristics
                                                                          WHERE client_characteristics.client_id = program_unit_members.client_id
                                                                          order by client_characteristics.start_date desc limit 1
                                                                          )

                                                            )
                      INNER JOIN PROGRAM_UNIT_PARTICIPATIONS ON (PROGRAM_UNITS.ID=PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID
	                                           AND PROGRAM_UNIT_PARTICIPATIONS.ID = ( SELECT MAX(ID) FROM PROGRAM_UNIT_PARTICIPATIONS A WHERE A.PROGRAM_UNIT_ID = PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID)
	                                           AND PROGRAM_UNIT_PARTICIPATIONS.PARTICIPATION_STATUS = 6043
	                                           )")
       step2 = step1.where("(client_characteristics.end_date is null or client_characteristics.end_date >= ?) ",month_end_date ) # minor parentcase what we will do ?

       step3 = step2.select("distinct program_units.id").order("program_units.id DESC")
     return step3
    end

    # def add_default_mandatory_work_characteristic_to_adult
    # 	# Rule: If date of birth is populated
    # 	# and if age is >=18
    # 	# and client characteristics is empty
    # 	# then manadatory work characteristics should be populated.
    # 	if self.dob.present? && self.id.present?
    # 		# calculate age.
    # 		if Client.is_adult(self.id) == true
    # 			# check if client characteristics is empty.
    # 			client_characteristics_collection = ClientCharacteristic.where("client_id = ? and characteristic_id = 5667 and (end_date is null or end_date > current_date)",self.id)
    # 			if client_characteristics_collection.blank?
    # 				# Now proceed to adding mandatory work characteristics to the adult
    # 				client_characteristic = ClientCharacteristic.populate_client_characteristic_information(self.id, 5667, "WorkCharacteristic", Date.today, nil) # 5667 - "Required to work"
    # 				client_characteristic.save!
    # 			end
    # 		end
    # 	end
    # end

	def self.search_for_add_household_member(arg_household_id,params)
    	result = nil
    	# Client should not be in current household.
    	step1 = Client.joins("INNER JOIN household_members
    		                 ON (clients.id = household_members.client_id
    		                 	)
    		                 ")

    	if params[:ssn].present?
	      	sql_first = step1.where("clients.ssn = ? and household_members.household_id !=?" ,params[:ssn],arg_household_id)
			if sql_first.present?
				result = apply_other_search_filters(sql_first,params)
			end
			if result.blank?
				# Client has not yet made it to household
				step1 = Client.joins("LEFT OUTER JOIN household_members
    		                				 ON clients.id = household_members.client_id
    		                 				")
				sql_first = step1.where("clients.ssn = ? and household_members.household_id is null","#{params[:ssn]}")
				if sql_first.blank?
					result = "No results found"
				else
					result = apply_other_search_filters(sql_first,params)
				end
			end
	  	else
	  	 	# search by name
			if params[:last_name].present? && params[:first_name].present?
				if (params[:last_name].length)>0 && (params[:first_name].length)>0
					last_name = "#{params[:last_name]}".strip.downcase + "%"
					first_name = "#{params[:first_name]}".strip.downcase + "%"
					# sql_first = self.where("lower(trim(last_name)) like ? and lower(trim(first_name)) like ?" ,last_name,first_name).order("last_name, first_name ASC")
					sql_first = step1.where("lower(trim(clients.last_name)) like ? and lower(trim(clients.first_name)) like ? and household_members.household_id !=?" ,last_name,first_name,arg_household_id).order("clients.last_name, clients.first_name ASC")
					# order(first_name: :asc)
					# check if gender entered.
					if sql_first.present?
						result = apply_other_search_filters(sql_first,params)
					end
					if result.blank?
						# Client has not yet made it to household
						step1 = Client.joins("LEFT OUTER JOIN household_members
    		                				 ON clients.id = household_members.client_id
    		                 				")
						sql_first = step1.where("lower(trim(clients.last_name)) like ? and lower(trim(clients.first_name)) like ? and household_members.household_id is null" ,last_name,first_name).order("clients.last_name, clients.first_name ASC")
						if sql_first.present?
							result = apply_other_search_filters(sql_first,params)
						end
						if result.blank?
							result = "No results found"
						end
					end
				else
					result = "Please enter atleast 2 characters in the search fields"
				end
				return result
			end
	  	end
	end


	def self.receiving_benefit?(arg_client_id)
		# Manoj 02/08/2016
		# Description: if passed client is found in Open program unit - returns True/ else false.

		step1 = ProgramUnit.joins("INNER JOIN program_unit_members
			                       ON program_unit_members.program_unit_id = program_units.id
			                       ")
        step2 = step1.where("program_units.program_unit_status = 5942
        	                 and program_unit_members.client_id = ?",arg_client_id
        	               )

        l_program_unit_collection = step2
        has_open_program_unit = false
        if l_program_unit_collection.present?
            l_program_unit_collection.each do |arg_pgu|
               # Get Program Unit Object
                # program_unit_object = ProgramUnit.find(arg_pgu.id)
                program_unit_object = ProgramUnit.find(arg_pgu.id)
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



	def complete_citizenship_step
        if self.citizenship.present?
        	HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(self.id,'household_member_citizenship_step','Y')
        end
    end

    def readjust_household_member_registration_steps_if_dob_is_updated
    	if self.dob.present?
    		# get client registration steps
    		HouseholdMemberStepStatus.readjust_steps_after_dob_is_populated_or_changed(self.id)
    	end
    end

    def self.add_client_characteristics_for_client(arg_client_id)
   		step1 = Client.joins("inner join household_members on household_members.client_id = clients.id
						  inner join client_applications on client_applications.household_id = household_members.household_id
						  inner join program_units on program_units.client_application_id = client_applications.id")
		step2 = step1.where("clients.id = ?",arg_client_id)
		step3 = step2.select("program_units.id,household_members.household_id as household_id, program_units.service_program_id as service_program_id ").order("program_units.id desc")
		record_collection = step3.first
		if record_collection.present?
			new_household_member = HouseholdMember.where("id = ?",record_collection.household_id).first
			program_participation_collection = ProgramUnitParticipation.get_participation_status(record_collection.id)
			program_participation = program_participation_collection.first
			client_object = Client.find(arg_client_id)
			if (client_object.dob.present? && program_participation.present?)
				if program_participation.status_date <= client_object.dob
					if (record_collection.service_program_id == 1 && (program_participation.participation_status == 6043 || (program_participation.participation_status == 6044 && program_participation.status_date - 6.months <= Date.today)))
					#create family cap charateristic
					other_charatertics_collection = ClientCharacteristic.open_characteristics_for_client("OtherCharacteristic",client_object.id)
						unless other_charatertics_collection.present?
						client_characteristic = ClientCharacteristic.populate_client_characteristic_information(client_object.id, 5610, "OtherCharacteristic",client_object.dob, nil) # 5610 - "Family Cap Child"
						client_characteristic.save
						end
					end
				end
			end
		end
    end

    def check_for_famliy_cap_when_new_member_added_to_program_unit
    	if dob_changed?
	    	client_id = Client.find(self.id)
	    	Client.add_client_characteristics_for_client(self.id)
        end

	end



end
