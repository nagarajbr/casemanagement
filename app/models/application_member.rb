class ApplicationMember < ActiveRecord::Base
has_paper_trail :class_name => 'ApplicationMemberVersion',:on => [:update, :destroy]
	include AuditModule


	before_create :set_create_user_fields
  before_update :set_update_user_field

  belongs_to :client_application
  # check later 09/18/2014
  belongs_to :client
  # validations
  validates :client_application_id,:client_id, :member_status, presence: true
  # client is unique in an application.
  # Don't allow duplicate clients in the same application
  validates :client_id,:uniqueness => {:scope => [:client_application_id]}
  # validate :check_only_one primary member per application ID
  validates :primary_member, :uniqueness => { :scope => :client_application_id }, :if => lambda { primary_is_selected? }

  def primary_is_selected?
    primary_member == "Y"
  end


    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
      # Active -status = 4468
      self.member_status = 4468
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end


    # def check_application_id_present?
    #   if :client_application_id.present?
    #     return true
    #   else
    #     return false
    #   end
    # end

  def self.get_primary_applicant(arg_application_id)
    l_output_object = self.where("client_application_id = ? and primary_member = 'Y'",arg_application_id)
    return l_output_object
  end

  def self.update_primary_applicant_application(arg_application_id,arg_client_id)
       # set primary member to "N" for all application members for passed arg_application_id
      self.where(client_application_id: arg_application_id).update_all(primary_member:"N")
        # find the record and set primary member to "Y"
      application_member = self.where("client_application_id = ? and client_id = ?",arg_application_id,arg_client_id).first
      application_member.primary_member = "Y"
       if  application_member.save
         msg = "SUCCESS"
       else
         msg = "FAIL"
       end
        return msg
  end

  def self.get_clients_list_for_the_application(arg_application_id)
    where("client_application_id = ?",arg_application_id).select("client_id")
  end

  def self.is_primary_member(arg_client_id)
    where("client_id = ? and primary_member = 'Y'",arg_client_id).count > 0
  end

  def self.sorted_application_members(arg_application_id)
     where("client_application_id = ?",arg_application_id).order("primary_member DESC")
  end

  def self.get_application_members_with_client_info(arg_application_id)
      step1 = joins("INNER JOIN clients  ON application_members.client_id = clients.id
                     LEFT OUTER JOIN client_characteristics ON (application_members.client_id = client_characteristics.client_id
                                                                and (client_characteristics.characteristic_type ='LegalCharacteristic'
                                                                     or (client_characteristics.characteristic_type ='DisabilityCharacteristic' and characteristic_id = 5731)
                                                                     or (client_characteristics.characteristic_type ='OtherCharacteristic' and characteristic_id = 5610)
                                                                    )
                                                                and (client_characteristics.end_date is null or client_characteristics.end_date > CURRENT_DATE)
                                                               )")

      step2 = step1.where("application_members.client_application_id = ?",arg_application_id)
      # Clients with SSI or Family Cap should not be considered for eligibility so they come with a status of INACTIVE CLOSED
      # Clients with Legal characterstics should be with status "Inactive partial"
      step3 = step2.select("distinct clients.last_name,clients.first_name,application_members.client_id,clients.dob as dob, CASE  WHEN client_characteristics.characteristic_id is null then 4468 WHEN client_characteristics.characteristic_id in (5610,5731) then 4471 ELSE 4469 END as characterstics")
      step3.each do |record|
        if record.characterstics != 4471
          if Income.is_the_client_recieving_ssi(record.client_id, Date.today)
            record.characterstics = 4471
          end
        end
      end
      return step3
  end

  def self.get_application_member_with_client_info(arg_client_id)
      step1 = joins("INNER JOIN clients  ON application_members.client_id = clients.id
                     LEFT OUTER JOIN client_characteristics ON (application_members.client_id = client_characteristics.client_id
                                                                and (client_characteristics.characteristic_type ='LegalCharacteristic'
                                                                     or (client_characteristics.characteristic_type ='DisabilityCharacteristic' and characteristic_id = 5731)
                                                                     or (client_characteristics.characteristic_type ='OtherCharacteristic' and characteristic_id = 5610)
                                                                    )
                                                                and (client_characteristics.end_date is null or client_characteristics.end_date > CURRENT_DATE)
                                                               )")

      step2 = step1.where("application_members.client_id = ?",arg_client_id)
      # Clients with SSI or Family Cap should not be considered for eligibility so they come with a status of INACTIVE CLOSED
      # Clients with Legal characterstics should be with status "Inactive partial"
      step3 = step2.select("distinct clients.last_name,clients.first_name,application_members.client_id,clients.dob as dob, CASE  WHEN client_characteristics.characteristic_id is null then 4468 WHEN client_characteristics.characteristic_id in (5610,5731) then 4471 ELSE 4469 END as characterstics") # felon_flag = 'Y' or has SSI income then it should return 'M'
      step3.each do |record|
        if record.characterstics != 4471
          if Income.is_the_client_recieving_ssi(record.client_id, Date.today)
            record.characterstics = 4471
          end
        end
      end
      return step3
  end

  def self.get_adults_in_the_application(arg_client_application_id)
    # l_return_collection = ApplicationMember.where("1=2")
    # l_collection = ApplicationMember.where("client_application_id = ?",arg_client_application_id)

    #     l_collection.each do |arg_member|
    #         l_age = Client.get_age(arg_member.client_id)
    #         if  l_age == -1 # DOB is not populated
    #           l_return_collection << arg_member
    #         else
    #           # check if he is adult.
    #           if l_age > 18
    #              l_return_collection << arg_member
    #           end
    #         end
    #     end


    # return l_return_collection
    adult_age = SystemParam.get_key_value(6,"child_age","18 is the age to determine adult").to_i
    step1 = joins("INNER JOIN clients
                 ON application_members.client_id = clients.id")
    step2 = step1.where("application_members.client_application_id = ? and
                         (clients.dob is null or EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) >= ?)",arg_client_application_id, adult_age)
    step3 = step2.select("application_members.*")
    return step3
  end

  def self.get_application_id(arg_client_id)
    application_id = nil
    application_members = where("client_id = ?",arg_client_id)
    if application_members.present?
      application_id = application_members.first.client_application_id
    end
    return application_id
  end

  # def self.filter_application_members_with_race_info(arg_application_members)
  #   step1 = joins("INNER JOIN clients
  #                  ON application_members.client_id = clients.id")
  #   step2 = step1.where("clients.id in (?) and clients.ethnicity is not null",arg_application_members.select("application_members.client_id"))
  #   step2.select("application_members.*")
  # end

  def self.get_application_members_who_has_race_information(arg_application_id)
    step1 = joins("INNER JOIN clients
                 ON application_members.client_id = clients.id")
    step2 = step1.where("application_members.client_application_id = ? and clients.ethnicity is not null",arg_application_id)
    step2.select("application_members.*, clients.ssn, clients.dob, clients.gender,  (clients.last_name ||', ' || clients.first_name) as client_full_name, clients.ethnicity")
  end

  def self.set_application_member_data(arg_application_id,arg_client_id)
    # check if data is present?
    app_member_collection = ApplicationMember.where("client_application_id = ? and client_id = ?",arg_application_id,arg_client_id)
    if app_member_collection.present?
      app_member_object = app_member_collection.first
    else
      app_member_object = ApplicationMember.new
      app_member_object.client_application_id = arg_application_id
      app_member_object.client_id = arg_client_id
    end
    app_member_object.member_status = 4468
    return app_member_object

  end

  def self.sorted_application_members_and_member_info(arg_application_id)
    step1 = joins("INNER JOIN clients ON application_members.client_id = clients.id")
    step2 = step1.where("application_members.client_application_id = ?",arg_application_id)
    step3 = step2.select("application_members.*, clients.ssn, clients.dob, clients.gender,  (clients.last_name ||', ' || clients.first_name) as client_full_name, clients.ethnicity").order("application_members.primary_member DESC")
  end

end





