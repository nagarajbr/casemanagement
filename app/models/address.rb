class Address < ActiveRecord::Base
has_paper_trail :class_name => 'AddressVersion' ,:on => [:update, :destroy]
    include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field, :validate_presence_of_save_prior_address
    before_save :populate_county
	#Dependencies

    after_save :save_residency_by_checking_address



    attr_accessor :save_prior_mailing_address,:save_prior_non_mailing_address, :non_mailing_addr_same_as_mailing, :notes,
                  :non_mailing_address_line1, :non_mailing_address_line2, :non_mailing_city, :non_mailing_state, :non_mailing_zip,
                  :non_mailing_zip_suffix, :non_mailing_county, :non_mailing_in_care_of, :non_mailing_address_type, :new_mailing_address,
                  :new_non_mailing_address, :save_prior_address, :primary, :secondary, :other, :email_address, :overwrite_mailing_address,
                  :overwrite_non_mailing_address, :required_mailing_address_confirmation, :required_non_mailing_address_confirmation,
                  :client_id ,:overwrite_household_address#, :primary_contact




    # Model Validations .

    validates_presence_of :address_type, :address_line1,:city,:state,message: "is required."
    validates :address_line1, length: { maximum: 50 }
    validates :address_line2, allow_blank: true, length: { maximum: 50  }
    validates :city, length: { maximum: 50 }
    validates_length_of :zip, minimum:5, maximum:5,allow_blank:false, message: " of 5 digits is required."
    validates_length_of :zip_suffix, minimum:4, maximum:4,allow_blank:true, message: " of 4 digits is required."
    validates_length_of :primary, is:10, if: 'primary.present?', message: " number should be of 10 digits."
    validates_length_of :secondary, is:10, if: 'secondary.present?', message: " number should be of 10 digits."
    validates_length_of :other, is:10, if: 'other.present?', message: " number should be of 10 digits."
    validates :email_address, if: 'email_address.present?', format: { with: /\A\S+@.+\.\S+\z/,
                                     message: " address is required. It must be in the format: username@domain.com."
                                   }

    # validates :zip_suffix, allow_blank: true,length: { is: 4 }

    # after_update :address_data_changed

    HUMANIZED_ATTRIBUTES = {
    :address_line1 => "Address Line1",
    :address_line2 => "Address Line2",
    :city => "City",
    :state => "State",
    :zip => "Zip",
    :zip_suffix => "Zip Suffix",
    :county => "County",
    :in_care_of => "Care Of",
    :non_mailing_address_line1 => "Address Line1",
    :non_mailing_address_line2 => "Address Line2",
    :non_mailing_city => "City",
    :non_mailing_state => "State",
    :non_mailing_zip => "Zip",
    :non_mailing_zip_suffix => "Zip Suffix",
    :non_mailing_county => "County",
    :non_mailing_in_care_of => "Care Of",
    :save_prior_address => "Save Prior Address?",
    :living_arrangement => "Living Arrangement",
    :effective_begin_date => "Move In Date",
    primary: "Primary Phone",
    secondary: "Secondary Phone",
    other: "Other Phone",
    client_email: "Email",
    notes: "Comments"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
    #MANOJ 07/22/2014 -Virtual fields for Mailing Address - start
    # attr_accessor :mailing_address_line1,:mailing_address_line2,:mailing_addr_city,:mailing_addr_state,:mailing_addr_zip,:mailing_addr_zip_suffix,:mailing_addr_county,:mailing_addr_address_notes,:mailing_addr_in_care_of


    #MANOJ 07/22/2014 -Virtual fields for Address - end


    #MANOJ 07/22/2014 -Virtual fields for Residential Address - start
    # attr_accessor :mailing_addr_same_as_residential
    attr_accessor :mailing_addr_same_as_non_mailing_addr
    # def after_initialize
 #        self.mailing_addr_same_as_residential = "N"
    # end

    # attr_accessor :home_address_line1,:home_address_line2,:home_addr_city,:home_addr_state,:home_addr_zip,:home_addr_zip_suffix,:home_addr_county,:home_addr_address_notes,:home_addr_in_care_of


   #Change address change  flags when these parameters change

    before_update do |addresses|
     addresses.address_chgd = 'Y' if addresses.address_line1_changed?
     addresses.address_chgd = 'Y' if addresses.address_line2_changed?
     addresses.address_chgd = 'Y' if addresses.city_changed?
     addresses.address_chgd = 'Y' if addresses.state_changed?
     addresses.address_chgd = 'Y' if addresses.zip_changed?
     addresses.address_chgd = 'Y' if addresses.zip_suffix_changed?

     end

    #MANOJ 07/22/2014 -Virtual fields for Residential Address - end

      # validates_presence_of :clients

    def set_create_user_fields
        user_id = AuditModule.get_current_user.uid
        self.created_by = user_id
        self.updated_by = user_id
        if self.effective_begin_date.present?
        else
           self.effective_begin_date = Date.today
        end

        #
    end

    def set_update_user_field
        user_id = AuditModule.get_current_user.uid
        self.updated_by = user_id
    end

     def save_residency_by_checking_address
        # Rails.logger.debug("address_object = #{self.inspect}")
            if self.address_type == 4664 && self.client_id.present? #PHYSICAL ADDRESSES
                # entity_addresses = EntityAddress.where("address_id = ? and entity_type = 6150",self.id).order("updated_at desc")
                # clientid = nil
                # if entity_addresses.present?
                #     clientid = entity_addresses.first.entity_id
                # else
                #     # Rails.logger.debug("self.client_id = #{self.client_id}")
                #     clientid = self.client_id
                # end
                # Rails.logger.debug("self.id = #{self.inspect}")
                clientid = self.client_id
                client_residency = Client.find(clientid)
                previous_residency = client_residency.residency
                if self.state == 5793
                    client_residency.residency = 'Y'
                else
                    client_residency.residency = 'N'
                end
                client_residency.save if client_residency.residency != previous_residency
            end# address_type == 4664 and state == 5793

            # MANOJ 05/12/2016 -START
            # Rule: If address state is changed to different state - all the impacted client's residency flag should be changed.
            if self.address_type == 4664
                # are there any entity_addresses for this address_id ?
                entity_addresses_collection = EntityAddress.where("address_id = ? and entity_type = 6150",self.id)
                if entity_addresses_collection.present?
                    entity_addresses_collection.each do |each_entity_address|
                        client_object = Client.find(each_entity_address.entity_id)
                        previous_residency = client_object.residency
                        if self.state == 5793
                            client_object.residency = 'Y'
                        else
                             client_object.residency = 'N'
                        end
                        client_object.save if client_object.residency != previous_residency
                    end
                end
            end

            # MANOJ 05/12/2016 -END

          # end#entity_addresses.present?
    end#save_residency_by_checking_address

    def self.has_address(arg_client_id)
        #joins(:entity_addresses).where("entity_id = ?",arg_client_id).count > 0
        step1 = joins("INNER JOIN entity_addresses ON entity_addresses.address_id = addresses.id")
        step1.where("entity_addresses.entity_id = ? and entity_addresses.entity_type = 6150 and addresses.address_type in (4664,4665)",arg_client_id).count > 1
    end

    def self.get_provider_address(arg_provider_id)

        step1 =  joins("INNER JOIN entity_addresses ON entity_addresses.address_id = addresses.id INNER JOIN providers ON entity_addresses.entity_id = providers.id
                                    ")
        step2 = step1.where("entity_addresses.entity_type = 6151  and addresses.address_type = 4664 and providers.id = ?",arg_provider_id)

        step3 = step2.select("addresses.*")
        address_return = step3
        return address_return
    end

    def validate_presence_of_save_prior_address
        unless self.save_prior_address.present?
            errors[:save_prior_address] << "Save prior address field is required to be populated."
        end
    end

    def self.get_entity_addresses(arg_client_id,arg_entity_type)
        step1 = joins("INNER JOIN entity_addresses ON entity_addresses.address_id = addresses.id")
        step1.where("entity_addresses.entity_id = ? and entity_addresses.entity_type = ? and addresses.address_type in (4665,4664)",arg_client_id,arg_entity_type).order(address_type: :desc)
    end

    def self.destroy_by_id(arg_address_id)
        address = where("id = ?",arg_address_id)
        if address.present?
            address.first.destroy
        end
    end

    def self.get_non_mailing_address(arg_entity_id, arg_entity_type)
         get_address(arg_entity_id, arg_entity_type, 4664)
    end

    def self.get_mailing_address(arg_entity_id, arg_entity_type)
        get_address(arg_entity_id, arg_entity_type, 4665)
    end

    def self.get_address(arg_entity_id, arg_entity_type, arg_address_type)
        step1 = joins("INNER JOIN entity_addresses ON addresses.id = entity_addresses.address_id")
        step2 = step1.where("entity_addresses.entity_id = ? and entity_addresses.entity_type = ? and addresses.address_type = ?", arg_entity_id, arg_entity_type, arg_address_type)
        step3 = step2.select("addresses.*")
    end


    # def self.get_client_id_from_addresses_id(arg_addresses_id)
    #     step1 = Address.joins("inner join entity_addresses on addresses.id = entity_addresses.address_id and entity_addresses.entity_type = 6150 ")
    #     step2 = step1.where("addresses.id = ? ",arg_addresses_id)
    #     step3 = step2.select("entity_addresses.entity_id")
    #     step4 = step3.first.entity_id
    #     return step4
    # end

   def populate_county
        if self.zip.present?
            self.county = SystemParam.get_county_id(self.zip)
        end
    end

    def self.search_any_household_in_this_address(arg_physical_address_id)
        # Rule : Find are there address records found with same
        # address_line1,address_line2,city,state,zip other than passed arg_physical_address_id.
        #  along with household ID other than passed address_id

        # EXAMPLE:
        # select *
        # from addresses
        # INNER JOIN entity_addresses
        # ON (addresses.id = entity_addresses.address_id
        #    AND entity_addresses.entity_type = 6150
        #    AND addresses.address_type = 4664
        #    AND addresses.effective_end_date IS NULL)
        # INNER JOIN household_members
        # ON (entity_addresses.entity_id = household_members.client_id
        #     AND entity_addresses.entity_type = 6150
        #    )
        # WHERE lower(trim(addresses.address_line1)) = lower(trim('2 Capitol Mall'))
        # AND ( lower(trim(addresses.address_line2)) = lower(trim('NOT_POPULATED'))
        #      OR lower(trim('NOT_POPULATED')) = lower(trim('NOT_POPULATED'))
        #      )
        # AND lower(trim(city)) = lower(trim('Little Rock'))
        # AND state = 5793
        # AND lower(trim(zip)) = lower(trim('72223'))


        address_object = Address.find(arg_physical_address_id)
        ls_address_line1 = address_object.address_line1.downcase.strip
        if address_object.address_line2.present?
            ls_address_line2 = address_object.address_line2.downcase.strip
        else
            ls_address_line2 = 'NOT_POPULATED'.downcase.strip
        end
        ls_city = address_object.city.downcase.strip
        li_state = address_object.state
        ls_zip = address_object.zip.downcase.strip

        step1 = Address.joins(" INNER JOIN entity_addresses
                                ON (addresses.id = entity_addresses.address_id
                                AND entity_addresses.entity_type = 6150
                                AND addresses.address_type = 4664
                                AND addresses.effective_end_date IS NULL)
                                INNER JOIN household_members
                                ON (entity_addresses.entity_id = household_members.client_id
                                   AND entity_addresses.entity_type = 6150
                                  )
                                INNER JOIN households
                                ON household_members.household_id = households.id
                                INNER JOIN codetable_items
                                ON addresses.state = codetable_items.id
                            ")
        step2 = step1.where("lower(trim(addresses.address_line1)) = ?
                            AND ( lower(trim(addresses.address_line2)) = ?
                                 OR lower(trim('NOT_POPULATED')) = ?
                                 )
                            AND lower(trim(addresses.city)) = ?
                            AND addresses.state = ?
                            AND lower(trim(addresses.zip)) = ?
                            AND addresses.id != ?",
                            ls_address_line1,
                            ls_address_line2,
                            ls_address_line2,
                            ls_city,
                            li_state,
                            ls_zip,
                            arg_physical_address_id)
        step3 = step2.select(" distinct households.id as household_id,
                               households.name as household_name,
                               addresses.address_line1 as address_line1,
                               coalesce(addresses.address_line2,'') as address_line2,
                               addresses.city as address_city,
                               codetable_items.short_description as address_state,
                               addresses.zip as address_zip,
                               addresses.id as address_id
                           ").order("households.name ASC")
        address_collection = step3
        return address_collection
    end

    def self.get_client_residential_addresses(arg_client_id)
        step1 = joins("INNER JOIN entity_addresses
                       ON entity_addresses.address_id = addresses.id")
        step1.where("entity_addresses.entity_id = ?
                     and entity_addresses.entity_type = 6150
                     and addresses.address_type = 4664
                     and addresses.effective_end_date IS NULL
                     ",arg_client_id)
    end

    def self.is_physical_address_verified_for_the_client(arg_client_id)
        step1 = joins("INNER JOIN entity_addresses
                       ON entity_addresses.address_id = addresses.id")
        step1.where("addresses.address_type = 4664 and entity_addresses.entity_id = ? and addresses.verified = 'Y'",arg_client_id).count > 0
    end

end