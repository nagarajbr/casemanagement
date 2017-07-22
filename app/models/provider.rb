class Provider < ActiveRecord::Base
has_paper_trail :class_name => 'ProviderVersion',:on => [:update, :destroy]

	include AuditModule

	before_create :set_create_user_fields
	before_update :is_there_is_an_open_agreement,:set_update_user_field
    before_validation :set_empty_attributes_to_nil
    # before_update :is_there_is_an_open_agreement

  after_initialize do |obj|
    @l_service_object = CommonService.new
  end


    has_many :provider_languages,  dependent: :destroy
    has_many :provider_services, dependent: :destroy
    has_many :provider_agreements, dependent: :destroy
	def set_create_user_fields
    	user_id = AuditModule.get_current_user.uid
    	self.created_by = user_id
    	self.updated_by = user_id

    end

    def set_update_user_field
	    user_id = AuditModule.get_current_user.uid
	    self.updated_by = user_id
    end

    def set_empty_attributes_to_nil
        # This method makes sure - empty string does not save in the database.
        # example: SSN - empty string was getting saved in the database- it was giving unique constraint error - while saving nil SSNs
        # hence this method.
   #    @attributes.each do |key,value|
            # self[key] = nil if value.blank?
   #      end
        @l_service_object.set_empty_attributes_to_nil(self)
    end


    HUMANIZED_ATTRIBUTES = {
        provider_name: "Provider Name",
        provider_type: "Provider Type",
        contact_person: "Contact Person",
        provider_country_code: "Country Code",
        classification: "W9 Classification",
        license_number: "License Number",
        license_expire_dt: "License Expiration Date",
        tax_id_ssn: "Tax ID / SSN",
        email_address: "Email Address",
        web_address: "Web Address",
        status: "Status"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
    attr_accessor :physical_addr_same_as_mailing


    validates_presence_of :provider_name, :provider_type,:contact_person,message: "is required"
    validate :tax_id_ssn_for_head_provider?
    validate :valid_license_expire_date?
    validates_uniqueness_of :tax_id_ssn, :allow_blank => true, message: "is already assigned in the system."
    #validates :email_address, length: { maximum: 50 }, :if =>  lambda {validate_on_update?}
    validates :email_address, allow_blank: true, format: { with: /\A\S+@.+\.\S+\z/,message: " must be in the format: username@domain.com"}



    def tax_id_ssn_for_head_provider?
        lb_return = true
        if head_office_provider_id.blank? && tax_id_ssn.blank?
            local_message = "Tax ID/ SSN is required"
            errors[:base] << local_message
            lb_return =  false
        else
            if id.present?
                # update - make sure fed ID is not deleted.
                if id == head_office_provider_id && tax_id_ssn.blank?
                     local_message = "Tax ID/ SSN is required"
                    errors[:base] << local_message
                    lb_return =  false
                end
            end
        end
        return lb_return
    end



    def valid_license_expire_date?
        if self.license_expire_dt.present?
            if license_expire_dt < Date.civil(1900,1,1)
                errors.add(:license_expire_dt, "must be after 01/01/1900")
                return false
            else
                 return true
            end
        else
             return true
        end
    end

    def self.search(params)
        result = ""
        if params[:tax_id_ssn].present?
           result = where("tax_id_ssn = ?","#{params[:tax_id_ssn]}")
        end

        if params[:provider_name].present? && (params[:provider_name].length)>1
           result = where("lower(provider_name) like ?", "#{params[:provider_name]}%".downcase).order("provider_name ASC")
        end

        if (params[:local_office].present? && params[:service].present? )
             step1 = joins("INNER JOIN provider_services ON providers.id = provider_services.provider_id
                            INNER JOIN provider_service_areas ON provider_services.id = provider_service_areas.provider_service_id")
             result = step1.where("provider_service_areas.local_office_id = ? and provider_services.service_type = ?", "#{params[:local_office]}" ,"#{params[:service]}").distinct
        else
            if params[:local_office].present?
            step1 = joins("INNER JOIN provider_services ON providers.id = provider_services.provider_id
                           INNER JOIN provider_service_areas ON provider_services.id = provider_service_areas.provider_service_id")
            result = step1.where("provider_service_areas.local_office_id = ? ", "#{params[:local_office]}").distinct
            end
        end
        return result
    end



    def self.is_language_present(arg_provider_id,arg_language_type)
        ProviderLanguage.where("provider_id = ? and language_type = ? and end_date is null",arg_provider_id,arg_language_type).count >= 1
    end

    #  Provider service Validations start - Manoj 01/08/2014

    def self.is_service_present(arg_provider_id,arg_service_type)
        ProviderService.where("provider_id = ? and service_type = ? and end_date is null",arg_provider_id,arg_service_type).count >= 1
    end


     def self.is_service_present_update(arg_provider_id,arg_service_type,arg_srvc_id)
       # other than current record search other record.
        ProviderService.where("provider_id = ? and service_type = ? and end_date is null and id != ?",arg_provider_id,arg_service_type,arg_srvc_id).count >= 1
    end


     def self.check_service_overlapping_dates(arg_provider_id,arg_service_type,arg_start_date,arg_end_date)
     #    Testing the range "start1 to end1" against the range "start2 to end2" is done by testing if...
     # ( start1 <= end2 and start2 <= end1 )
     #    If TRUE, then the ranges overlap.
        lb_return = false
        provider_service_collection = ProviderService.where("provider_id = ? and service_type = ?",arg_provider_id,arg_service_type).order("end_date DESC")
        if provider_service_collection.present?
            latest_provider_service_object = provider_service_collection.first
            if latest_provider_service_object.end_date.present?
                if arg_end_date.present?
                    if ( (arg_start_date <= latest_provider_service_object.end_date) and (latest_provider_service_object.start_date <= arg_end_date) )
                        lb_return = true
                    end
                else
                    if ((arg_start_date >= latest_provider_service_object.start_date) and (arg_start_date <= latest_provider_service_object.end_date))
                        lb_return = true
                    end
                end
            end
        end
        return lb_return
    end

    def self.check_service_overlapping_dates_update(arg_provider_id,arg_service_type,arg_start_date,arg_end_date,arg_service_id)
         # other than current record search other record.
              #    Testing the range "start1 to end1" against the range "start2 to end2" is done by testing if...
     # ( start1 <= end2 and start2 <= end1 )
     #    If TRUE, then the ranges overlap.
         lb_return = false
        provider_service_collection = ProviderService.where("provider_id = ? and service_type = ? and id != ?",arg_provider_id,arg_service_type,arg_service_id).order("end_date DESC")
        if provider_service_collection.present?
            latest_provider_service_object = provider_service_collection.first
            if latest_provider_service_object.end_date.present?
                if arg_end_date.present?
                    if ( (arg_start_date <= latest_provider_service_object.end_date) and (latest_provider_service_object.start_date <= arg_end_date) )
                        lb_return = true
                    end
                else
                    if ((arg_start_date >= latest_provider_service_object.start_date) and (arg_start_date <= latest_provider_service_object.end_date))
                        lb_return = true
                    end
                end
            else
                # end date is not present in table.
                # (Open service record exists.Passed start_date and end date should not be more than database start date. )
                if  arg_end_date.present?
                    if ( (latest_provider_service_object.start_date > arg_start_date ) and (latest_provider_service_object.start_date < arg_end_date))
                        lb_return = true
                    end
                end
            end
        end
        return lb_return
    end


    #  Provider service Validations end - Manoj 01/08/2014

    def self.provider_not_present_in_employer(arg_tax_id_ssn)

        employer = Employer.where("federal_ein=?",arg_tax_id_ssn)
        if employer.present?
            return false
        else
            return true
        end

    end

    def self.if_tax_id_ssn_is_not_present(arg_federal_ein)
        where("tax_id_ssn = ?",arg_federal_ein.to_s).count == 0
    end

    def self.address_created_for_provider(arg_tax_id_ssn)
        step1 = joins("INNER JOIN entity_addresses ON providers.id = entity_addresses.entity_id
                       INNER JOIN addresses ON entity_addresses.address_id = addresses.id")
        step2 = step1.where("providers.tax_id_ssn = ? and addresses.address_type in (4664,4665)", arg_tax_id_ssn)
        step2.size > 0
    end

    def self.get_provider_city(arg_id)
        step1 = joins("INNER JOIN entity_addresses ON (providers.id = entity_addresses.entity_id and entity_type = 6151)
                       INNER JOIN addresses ON entity_addresses.address_id = addresses.id")
        step2 = step1.where("providers.id = ? and addresses.address_type = 4664", arg_id)
        step3 = step2.select("addresses.city")
    end
    def self.get_provider_information_from_tax_id_ssn(arg_tax_id_ssn)
        where("tax_id_ssn = ?" ,arg_tax_id_ssn)
    end

    def self.get_provider_information_from_id(arg_id)
        where("id = ?" ,arg_id)
    end

    def self.get_brabch_offices(arg_provider_id)
        where("head_office_provider_id = ? and id <> head_office_provider_id",arg_provider_id)
    end

    def self.update_branch_office_with_head_provider_id(arg_head_provider_id)
        where(:id => arg_head_provider_id).update_all(:head_office_provider_id => arg_head_provider_id)
        # where("id = ? ",arg_head_provider_id).update_all("head_office_provider_id = ?", arg_head_provider_id)
    end

    def self.sync_header_provider_status_to_branches(arg_head_provider_id,arg_provider_status)
        # where("head_office_provider_id = ? and (status != 6157 OR status is null)", arg_head_provider_id).update_all(:status => arg_provider_status)
        where("head_office_provider_id = ? ", arg_head_provider_id).update_all(:status => arg_provider_status)
    end

    def self.get_tax_id_ssn_for_provider(arg_provider_id)
        provider_object = Provider.find(arg_provider_id)
        if provider_object.id == provider_object.head_office_provider_id
            ls_tax_id_ssn = provider_object.tax_id_ssn
        else
            # This is branch office get the head office
            head_provider_object = Provider.find(provider_object.head_office_provider_id)
            ls_tax_id_ssn = head_provider_object.tax_id_ssn
        end
        return ls_tax_id_ssn
    end

    def self.providers_with_approved_agreement_for_service_type_date_range(arg_service_type,arg_start_date,arg_end_date,arg_program_unit_id)
        # Give first priority to providers in the Program unit's processing location.
        # Only AASIS verified providers and providers with open agreement
        program_unit_object = ProgramUnit.find(arg_program_unit_id)
        if program_unit_object.processing_location.present?
            step1 = joins("INNER JOIN provider_agreements
                            ON ( providers.id = provider_agreements.provider_id
                                and  providers.status = 6156)
                           INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
                           INNER JOIN provider_agreement_areas ON provider_agreement_areas.provider_agreement_id = provider_agreements.id
                     ")
            step2 = step1.where("provider_agreements.state = 6166 and provider_services.service_type = ? and  ? >= agreement_start_date and  ? <= agreement_end_date and provider_agreement_areas.served_local_office_id = ?",arg_service_type,arg_start_date,arg_end_date, program_unit_object.processing_location)
            if step2.present?
                step3 = step2.select("distinct providers.id,providers.provider_name")
                step4 = step3.order("providers.provider_name ASC")
                providers_list = step4
            else
                # If program unit processing location is not there then - show all providers with approved agreements
                step1 = joins("INNER JOIN provider_agreements ON providers.id = provider_agreements.provider_id
                       INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
                     ")
                step2 = step1.where("provider_agreements.state = 6166 and provider_services.service_type = ? and  ? >= agreement_start_date and  ? <= agreement_end_date",arg_service_type,arg_start_date,arg_end_date)
                step3 = step2.select("distinct providers.id,providers.provider_name")
                step4 = step3.order("providers.provider_name ASC")
                providers_list = step4
            end

        else
             # If program unit processing location is not there then - show all providers with approved agreements
            step1 = joins("INNER JOIN provider_agreements ON providers.id = provider_agreements.provider_id
                       INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
                     ")
            step2 = step1.where("provider_agreements.state = 6166 and provider_services.service_type = ? and  ? >= agreement_start_date and  ? <= agreement_end_date",arg_service_type,arg_start_date,arg_end_date)
            step3 = step2.select("distinct providers.id,providers.provider_name")
            step4 = step3.order("providers.provider_name ASC")
            providers_list = step4
        end
        return providers_list
    end


    # def self.providers_with_approved_agreement_for_service_type_and_start_date(arg_service_type,arg_start_date)
    #     step1 = joins("INNER JOIN provider_agreements ON providers.id = provider_agreements.provider_id
    #                    INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
    #                  ")
    #     step2 = step1.where("provider_agreements.state = 6166 and provider_services.service_type = ? and  ? >= agreement_start_date ",arg_service_type,arg_start_date)
    #     step3 = step2.select("distinct providers.id,providers.provider_name")
    #     step4 = step3.order("providers.provider_name ASC")
    #     providers_list = step4
    #     return providers_list
    # end

    def self.providers_with_approved_agreement_for_start_date(arg_start_date)
        step1 = joins("INNER JOIN provider_agreements
                       ON (providers.id = provider_agreements.provider_id
                           and  providers.status = 6156
                          )
                       INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
                       INNER JOIN codetable_items ON (codetable_items.id = provider_services.service_type and codetable_items.code_table_id = 182)
                     ")
        step2 = step1.where("provider_agreements.state = 6166 and  ? >= provider_agreements.agreement_start_date  and ? <= provider_agreements.agreement_end_date ",Date.today,Date.today)
        step3 = step2.select("distinct providers.id,providers.provider_name,provider_services.service_type")
        step4 = step3.order("provider_services.service_type ASC")
        providers_list = step4
        return providers_list
    end

    def self.providers_with_approved_agreement_for_start_date_and_occupation(arg_start_date, arg_occupation)
        step1 = joins("INNER JOIN provider_agreements
                       ON (providers.id = provider_agreements.provider_id
                           and  providers.status = 6156
                          )
                       INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
                       INNER JOIN codetable_items ON (codetable_items.id = provider_services.service_type and codetable_items.code_table_id = 182)
                     ")
        step2 = step1.where("provider_agreements.state = 6166
                             and  ? >= provider_agreements.agreement_start_date
                             and ? <= provider_agreements.agreement_end_date
                             and trim(provider_services.occupation) = ?",Date.today,Date.today, arg_occupation)
        step3 = step2.select("distinct providers.id,providers.provider_name,provider_services.service_type")
        step4 = step3.order("provider_services.service_type ASC")
        providers_list = step4
        return providers_list
    end

    def self.providers_with_approved_agreement_for_start_date_and_service_type(arg_start_date,arg_service_type)
        step1 = joins("INNER JOIN provider_agreements ON (providers.id = provider_agreements.provider_id
                                                          and  providers.status = 6156
                                                          )
                       INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
                     ")
        step2 = step1.where("provider_agreements.state = 6166 and  ? >= agreement_start_date and provider_services.service_type = ?",arg_start_date,arg_service_type)
        step3 = step2.select("distinct providers.id,providers.provider_name")
        step4 = step3.order("providers.provider_name ASC")
        providers_list = step4
        return providers_list
    end

    def self.get_non_transport_provider_with_open_agreement()
        step1 = Provider.joins("INNER JOIN provider_agreements ON (providers.id = provider_agreements.provider_id
                                                                   and  providers.status = 6156
                                                                   and provider_agreements.state = 6166
                                                                   )
                       INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
                       INNER JOIN codetable_items ON (codetable_items.id = provider_services.service_type and (codetable_items.code_table_id = 168 and codetable_items.id not in (6214,6215)))")
        step2 = step1.order("providers.provider_name ASC")
        return step2
    end


    def self.providers_with_approved_agreement_for_service_type_date_range_zip(arg_service_type,arg_start_date,arg_end_date,arg_start_zip)

        step1 = joins("INNER JOIN provider_agreements ON (providers.id = provider_agreements.provider_id
                                                          AND providers.status = 6156
                                                          AND provider_agreements.state = 6166
                                                          )
                       INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
                       INNER JOIN provider_agreement_areas ON provider_agreement_areas.provider_agreement_id = provider_agreements.id
                       INNER JOIN
                        (
                          SELECT LOCAL_OFFICE_TO_COUNTY.*,COUNTY_TO_ZIP_CODE.VALUE as zip_code
                          FROM
                          (
                            select local_office.id as local_office_id,
                            local_office.short_description AS LOCAL_OFFICE,
                            county.short_description AS COUNTY,
                            CAST(Location_to_county.value AS INTEGER) AS COUNTY_ID
                            from
                                (select * from system_params
                                 where system_param_categories_id = 14)Location_to_county
                                 inner join
                                 (select * from codetable_items where code_table_id = 2)local_office
                                  on cast(Location_to_county.key as integer)= local_office.id
                                 inner join
                                (select * from codetable_items where code_table_id = 12)county
                                ON cast(Location_to_county.value as integer) = county.id

                        )LOCAL_OFFICE_TO_COUNTY
                        inner join
                        (
                        select * from system_params
                        where system_param_categories_id = 12
                        )COUNTY_TO_ZIP_CODE
                        ON LOCAL_OFFICE_TO_COUNTY.COUNTY_ID = CAST(COUNTY_TO_ZIP_CODE.key AS INTEGER)
                        )local_office_county_zip_code_collection

                    ON provider_agreement_areas.served_local_office_id = local_office_county_zip_code_collection.LOCAL_OFFICE_ID
            ")

           step2 = step1.where("provider_services.service_type = ?
                                and  ? >= agreement_start_date
                                and  ? <= agreement_end_date
                                and local_office_county_zip_code_collection.zip_code = ?",arg_service_type,arg_start_date,arg_end_date,arg_start_zip)
            if step2.present?
                step3 = step2.select("distinct providers.id,providers.provider_name")
                step4 = step3.order("providers.provider_name ASC")
                providers_list = step4
            else
                # If no provider found in that zip code show all approved providers.
                step1 = joins("INNER JOIN provider_agreements ON (providers.id = provider_agreements.provider_id
                                                                  AND providers.status = 6156
                                                                  and provider_agreements.state = 6166
                                                                  )
                               INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
                             ")
                step2 = step1.where("provider_services.service_type = ?
                                     and  ? >= agreement_start_date
                                     and  ? <= agreement_end_date",arg_service_type,arg_start_date,arg_end_date
                                    )
                step3 = step2.select("distinct providers.id,providers.provider_name")
                step4 = step3.order("providers.provider_name ASC")
                providers_list = step4
            end


        return providers_list
    end

    def self.get_provider_name(arg_provider_id)
        provider_object = Provider.find(arg_provider_id)
        return provider_object.provider_name
    end


      def is_there_is_an_open_agreement

        lb_return = true
        if self.status == 6157 || tax_id_ssn_changed?
           provider_agreements_collection =  ProviderAgreement.get_provider_agreements(self.id)
           provider_agreements_collection.each do |each_provider_agreement|
              if each_provider_agreement.termination_date.present?
                if each_provider_agreement.termination_date > Time.now.to_date
                if self.status == 6157
                  errors[:base] = "Open Agreement exists cannot Inactivate provider"
                end
                # if provider_name_changed?
                #    errors[:provider_name] = "cannot be changed as open agreement is present "
                # end
                if tax_id_ssn_changed?
                    errors[:tax_id_ssn] = "cannot be changed as open agreement is present "
                end
                # if classification_changed?
                #     errors[:classification] = "cannot be changed as open agreement is present "
                # end

                lb_return = false
                    break

                end
               else
                  if each_provider_agreement.agreement_end_date.present? && each_provider_agreement.agreement_end_date > Time.now.to_date
                   if self.status == 6157
                      errors[:base] = "Open Agreement exists cannot Inactivate provider"
                    end
                    # if provider_name_changed?
                    #    errors[:provider_name] = "cannot be changed as open agreement is present"
                    # end
                    if tax_id_ssn_changed?
                        errors[:tax_id_ssn] = "cannot be changed as open agreement is present"
                    end
                    # if classification_changed?
                    #     errors[:classification] = "cannot be changed as open agreement is present "
                    # end

                    lb_return = false
                    break

                   end#each_provider_agreement.agreement_end_date.present?
               end#each_provider_agreement.termination_date.present?
            end#|each_provider_agreement|
        end# self.status == 6157
        return lb_return
      end#

def self.providers_with_approved_agreement_and_for_a_location(arg_program_unit_id)
        # Give first priority to providers in the Program unit's processing location.
        # Only AASIS verified providers and providers with open agreement

        if arg_program_unit_id.present?
            program_unit_object = ProgramUnit.find(arg_program_unit_id)
            if program_unit_object.processing_location.present?
                step1 = joins("INNER JOIN provider_agreements
                                ON ( providers.id = provider_agreements.provider_id
                                    and  providers.status = 6156)
                               INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
                               INNER JOIN provider_agreement_areas ON provider_agreement_areas.provider_agreement_id = provider_agreements.id ")
                step2 = step1.where("provider_agreements.state = 6166   and  agreement_end_date > current_date and provider_agreement_areas.served_local_office_id = ? and provider_services.occupation is not null", program_unit_object.processing_location)
                step3 = step2.select("distinct provider_services.occupation as occupation")
                providers_list = step3
            else
                # If program unit processing location is not there then - show all providers with approved agreements
                step1 = joins("INNER JOIN provider_agreements ON providers.id = provider_agreements.provider_id
                           INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id ")
                step2 = step1.where("provider_agreements.state = 6166 and  agreement_end_date > current_date and  provider_services.occupation is not null ")
                step3 = step2.select("distinct provider_services.occupation as occupation")
                providers_list = step3

            end
        else
             # If program unit processing location is not there then - show all providers with approved agreements
            step1 = joins("INNER JOIN provider_agreements ON providers.id = provider_agreements.provider_id
                       INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id ")
            step2 = step1.where("provider_agreements.state = 6166 and  agreement_end_date > current_date and  provider_services.occupation is not null ")
            step3 = step2.select("distinct provider_services.occupation as occupation")
            providers_list = step3
        end
        return providers_list
end


    def self.get_activity_types_that_have_only_valid_providers(arg_activities,arg_program_unit_id,arg_occupation)
        # Give first priority to providers in the Program unit's processing location.
        # Only AASIS verified providers and providers with open agreement

        if arg_program_unit_id.to_i > 0
            program_unit_object = ProgramUnit.find(arg_program_unit_id)
            if program_unit_object.processing_location.present?
                step1 = joins("INNER JOIN provider_agreements
                                ON ( providers.id = provider_agreements.provider_id
                                    and  providers.status = 6156)
                               INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id
                               INNER JOIN provider_agreement_areas ON provider_agreement_areas.provider_agreement_id = provider_agreements.id ")
                step2 = step1.where("provider_agreements.state = 6166   and  agreement_end_date > current_date and provider_agreement_areas.served_local_office_id = ? and provider_services.service_type in (?)", program_unit_object.processing_location,arg_activities)
                # For now assuming that occupation not to be considered for activity type Particpate in GED Certication, this list might increase going forward
                step2 = step2.where("provider_services.occupation = ?",arg_occupation) unless arg_activities.where("system_params.value = '6772'").present?
                step3 = step2.select("distinct provider_services.service_type as id")
                providers_list = step3
            else
                # If program unit processing location is not there then - show all providers with approved agreements
                step1 = joins("INNER JOIN provider_agreements ON providers.id = provider_agreements.provider_id
                           INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id ")
                step2 = step1.where("provider_agreements.state = 6166 and  agreement_end_date > current_date and  provider_services.occupation is not null ")
                step3 = step2.select("distinct provider_services.service_type as id")
                providers_list = step3

            end


        else
             # If program unit processing location is not there then - show all providers with approved agreements
            step1 = joins("INNER JOIN provider_agreements ON providers.id = provider_agreements.provider_id
                       INNER JOIN provider_services ON  provider_agreements.provider_service_id = provider_services.id ")
            step2 = step1.where("provider_agreements.state = 6166   and  agreement_end_date > current_date  and provider_services.occupation = ? and provider_services.service_type in (?)", arg_occupation,arg_activities)
            step3 = step2.select("distinct provider_services.service_type as id")
            providers_list = step3
        end
        return providers_list
    end


end





