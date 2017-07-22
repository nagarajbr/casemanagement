class Employer < ActiveRecord::Base
has_paper_trail :class_name => 'EmployerVersion',:on => [:update, :destroy]


	include AuditModule
     after_initialize do |obj|
    @l_service_object = CommonService.new
  end

     before_validation :set_empty_attributes_to_nil
    before_create :set_create_user_fields#, :format_phone_number
	before_update :set_update_user_field#, :format_phone_number


	def set_create_user_fields
    	user_id = AuditModule.get_current_user.uid
    	self.created_by = user_id
    	self.updated_by = user_id

    end

    def set_update_user_field
	    user_id = AuditModule.get_current_user.uid
	    self.updated_by = user_id
    end


    # def format_phone_number
    #     if self.employer_phone_number.present?
    #         self.employer_phone_number = self.employer_phone_number.scan(/\d/).join
    #     end
    #     if self.employer_optional_home_number.present?
    #         self.employer_optional_home_number = self.employer_optional_home_number.scan(/\d/).join
    #     end
    # end

    HUMANIZED_ATTRIBUTES = {
        federal_ein: "Federal EIN",
        state_ein: "State EIN",
        employer_name: " Employer Name",
        employer_country_code: "Country",
        employer_contact: "Contact Person",
        employer_optional_contact: " Optional Contact Person",
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
    attr_accessor :flag

    def self.search(params)
        if params[:federal_ein].present?
            where("federal_ein = ?" ,"#{params[:federal_ein]}")
        elsif params[:state_ein].present?
            where("state_ein = ?" ,"#{params[:state_ein]}")
        elsif params[:employer_name].present? && (params[:employer_name].length)>1
             self.where("lower(employer_name) like ?", "#{params[:employer_name]}%".downcase).order("employer_name ASC")
        end
    end

    validates_presence_of :employer_name, message: "is required"
    validates_uniqueness_of :federal_ein, :if =>  lambda { federal_ein.present?},message: "is already assigned in the system."
    validates_presence_of :federal_ein,:employer_contact, :if =>  lambda { flag.to_i == 1}, message: "is required"
    # validate :validate_data_for_employer


    def self.address_created_for_employer(arg_federal_ein)
        # returns true if address is already created for employer.
        step1 = joins("INNER JOIN entity_addresses ON employers.id = entity_addresses.entity_id
                       INNER JOIN addresses ON entity_addresses.address_id = addresses.id")
        step2 = step1.where("employers.federal_ein = ? and addresses.address_type in (4664,4665)", arg_federal_ein)
        step2.size > 0
    end

    def self.get_employer_information_from_federal_ein(arg_federal_ein)
        where("federal_ein = ?",arg_federal_ein)
    end



     def self.get_employer_name(arg_employer_id)
         where("id = ?",arg_employer_id)
     end

     def set_empty_attributes_to_nil
        @l_service_object.set_empty_attributes_to_nil(self)
    end



end
