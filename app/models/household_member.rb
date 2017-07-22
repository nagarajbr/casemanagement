class HouseholdMember < ActiveRecord::Base
  belongs_to :household

  # after_update :add_deemed_no_finance_data_if_answered_no

    include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field
    after_create  :add_client_characteristics_for_client_if_dob_after_application_date


    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

  def self.get_all_members_of_household(arg_household_id)
    step1 = HouseholdMember.joins("household_members INNER JOIN clients on clients.id = household_members.client_id")
    step2 = step1.where("household_members.household_id = ?",arg_household_id)
    step3 = step2.select("household_members.*,clients.ssn, clients.dob, clients.gender,  (clients.last_name ||', ' || clients.first_name) as client_full_name").order("household_members.id ASC")
  end

  def self.get_all_members_in_the_household(arg_household_id)
    step1 = HouseholdMember.joins("household_members INNER JOIN clients on clients.id = household_members.client_id")
    step2 = step1.where("household_members.household_id = ? and household_members.member_status = 6643",arg_household_id)
    step3 = step2.select("household_members.*,clients.ssn, clients.dob, clients.gender,  (clients.last_name ||', ' || clients.first_name) as client_full_name").order("household_members.id ASC")
  end

  # def self.get_non_hoh_members_in_the_household(arg_household_id)
  #   HouseholdMember.where("household_members.household_id = ? and head_of_household_flag = 'N'",arg_household_id).order("head_of_household_flag DESC")
  # end

  # def self.get_hoh_name(arg_household_id)
  #   ls_name = ' '
  #   hoh_member_collection = HouseholdMember.where("household_id = ? and head_of_household_flag = 'Y'",arg_household_id)
  #   if hoh_member_collection.present?
  #     hoh_object = hoh_member_collection.first
  #     client_object = Client.find(hoh_object.client_id)
  #     ls_name = client_object.get_full_name
  #   end
  #   return ls_name
  # end

  # def self.get_head_of_household_member(arg_household_id)
  #   HouseholdMember.where("household_id = ? and head_of_household_flag = 'Y'",arg_household_id)
  # end

  def self.populate_member_address_with_hoh_address(arg_hoh_client_id,arg_non_hoh_client_id)
        # get HOH mailing address
        step1 = Address.joins(" INNER JOIN entity_addresses
                              ON addresses.id = entity_addresses.address_id
                              and addresses.address_type in (4664,4665)
                              and entity_addresses.entity_type = 6150")
        step2 = step1.where("entity_addresses.entity_id = ?",arg_hoh_client_id)
        hoh_addresses = step2
        if hoh_addresses.present?
            hoh_addresses.each do |each_address|
              # Manoj 03/03/2015 - commented
              #  always creating new address for client
              #  residence address needs to shared and mailing address needs to be new.

              if each_address.address_type == 4665
                  # mailing separate address
                  non_hoh_address_object = Address.new
                  non_hoh_address_object.address_type = each_address.address_type
                  non_hoh_address_object.address_line1 = each_address.address_line1
                  non_hoh_address_object.address_line2 = each_address.address_line2 if each_address.address_line2.present?
                  non_hoh_address_object.city =each_address.city
                  non_hoh_address_object.state =each_address.state
                  non_hoh_address_object.zip =each_address.zip
                  non_hoh_address_object.zip_suffix =each_address.zip_suffix if each_address.zip_suffix.present?
                  non_hoh_address_object.effective_begin_date =each_address.effective_begin_date
                  non_hoh_address_object.county = each_address.county
                  non_hoh_address_object.in_care_of = each_address.in_care_of if each_address.in_care_of.present?
                  # Manoj 02/12/2016 - virtual field client_id is populated in address table , it is being used in Address Model method save_residency_by_checking_address
                  #  to populate client.residency flag
                  non_hoh_address_object.client_id = arg_non_hoh_client_id
                  non_hoh_address_object.save

                # save entity address
                 non_hoh_entity_address = EntityAddress.new
                 non_hoh_entity_address.entity_type = 6150
                 non_hoh_entity_address.entity_id = arg_non_hoh_client_id
                 non_hoh_entity_address.address_id = non_hoh_address_object.id
                 non_hoh_entity_address.save
              else
                # Residence same address
                 non_hoh_entity_address = EntityAddress.new
                 non_hoh_entity_address.entity_type = 6150
                 non_hoh_entity_address.entity_id = arg_non_hoh_client_id
                 non_hoh_entity_address.address_id = each_address.id
                 non_hoh_entity_address.save

                 # managing residency flag
                 client_object = Client.find(arg_non_hoh_client_id)
                 if each_address.state == 5793 # arkansas
                    client_object.residency = 'Y'
                 else
                   client_object.residency = 'N'
                 end
                 client_object.save
              end
            end
        end
  end


  def self.sorted_household_members(arg_household_id)
    HouseholdMember.where("household_id = ? ",arg_household_id).order("id ASC")
  end

   def self.sorted_household_members_with_names(arg_household_id)
      step1 = HouseholdMember.joins(" INNER JOIN clients
                              ON household_members.client_id = clients.id ")
      step2 = step1.where("household_id = ? ",arg_household_id).order("household_members.id ASC")
      step3 = step2.select("clients.last_name ||', '|| clients.first_name as name,household_members.member_status as status,household_members.client_id as client_id,household_members.household_id as household_id")
  end




  def self.get_household_member_object_for_client(arg_client_id)
    result = where("client_id = ? and member_status = 6643",arg_client_id)
    if result.present?
      result = result.first
    end
    return result
  end

  def self.get_all_adults_with_in_household(arg_household_id)
    min_age = SystemParam.get_key_value(6,"child_age","19 is the age to determine adult ").to_i
    step1 = joins("INNER JOIN clients on clients.id = household_members.client_id")
    step2 = step1.where("household_members.household_id = ? and date_part('year',age(clients.dob)) > ?",arg_household_id,min_age)
    step3 = step2.select("household_members.*")
  end


  def self.is_the_client_present_within_the_household(arg_household_id, arg_client_id)
    where("household_id = ? and client_id = ? and member_status = 6643",arg_household_id, arg_client_id).count > 0
  end



  def self.set_household_member_data(arg_household_id,arg_client_id)
    member_collection = HouseholdMember.where("household_id = ? and client_id = ?",arg_household_id,arg_client_id)
    if member_collection.present?
      member_object = member_collection.first
      member_object.member_status = 6643 # IN HOUSEHOLD STATUS
    else
      member_object = HouseholdMember.new
      member_object.household_id = arg_household_id
      member_object.client_id = arg_client_id
      member_object.start_date = Date.today
      member_object.member_status = 6643 # IN HOUSEHOLD STATUS
    end
    return member_object

  end


  def self.get_household_member_collection(arg_household_id,arg_client_id)
     HouseholdMember.where(" household_id = ? and client_id = ?",arg_household_id,arg_client_id)
  end

  def self.get_all_parents_with_in_household(arg_household_id)
    # min_age = SystemParam.get_key_value(6,"child_age","18 is the age to determine adult").to_i
    step1 = joins("INNER JOIN client_relationships on client_relationships.from_client_id = household_members.client_id")
    step2 = step1.where("household_members.household_id = ? and client_relationships.relationship_type = 6009
                        and client_relationships.to_client_id in (select household_members.client_id from household_members
                        where household_members.household_id = ?)",arg_household_id, arg_household_id)
    step3 = step2.select("household_members.*")
  end





  def self.get_anyone_in_household_over_age_fifteen(arg_household_id)
    step1 = joins("INNER JOIN clients on clients.id = household_members.client_id")
    step2 = step1.where("household_members.household_id = ? and date_part('year',age(clients.dob)) > 15",arg_household_id)
    step3 = step2.select("household_members.*")
  end

  def self.get_household_members_with_inhousehold_status(arg_household_id)
    where("household_id = ? and member_status = 6643",arg_household_id).order("id")
  end

  def add_client_characteristics_for_client_if_dob_after_application_date
      # household_member = HouseholdMember.find(self.id)
      # Client.add_client_characteristics_for_client(household_member.client_id)
       Client.add_client_characteristics_for_client(self.client_id)
  end



end
