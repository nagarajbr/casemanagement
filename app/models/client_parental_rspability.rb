class ClientParentalRspability < ActiveRecord::Base
has_paper_trail :class_name => 'ClntParentRspabilityVersion',:on => [:update, :destroy]

	include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field

	belongs_to :client_relationship

   HUMANIZED_ATTRIBUTES = {
     deprivation_code: "Deprivation Code",
     client_relationship_id: "Parent",
     parent_status: "Parent Status",
     good_cause: "Good Cause",
     amount_collected: "Amount Collected",
     court_ordered_amount: "Court Ordered Amount",
     paternity_established: "Paternity Established",
     court_order_number: "Court Order Number",
     child_support_referral: "Child Support Referral Type"
    }

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end


 # validates_presence_of :client_relationship_id,message: "is required."
 # validates_presence_of :parent_status,message: "is required."
 validates_presence_of :deprivation_code,message: "is required."
 # validate :good_cause_present?
 # validates :client_relationship_id,:uniqueness => {:scope => [:parent_status],message: "with same Status exits."}
 validate :court_ordered_amount?
 validate :amount_collected?
 # validates_uniqueness_of :client_relationship_id,message: "already added for child."

    # def good_cause_present?
    #     if self.parent_status == 6076
    #       if self.good_cause.present?
    #           return true
    #       else
    #          errors[:base] << "Good cause is required if parent status is absent."
    #          return false
    #       end
    #     else
    #       return true
    #     end
    # end


	 def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end


    def self.get_parenatl_responsibility_list_for_client(arg_client_id)
      step1 = ClientParentalRspability.joins("INNER JOIN client_relationships ON client_parental_rspabilities.client_relationship_id = client_relationships.id")
      step2 = step1.where("client_relationships.from_client_id = ?",arg_client_id)
      client_rspabilities_collection = step2.order("client_relationships.id ASC")
      return client_rspabilities_collection
    end




    def self.is_there_a_deprivation_code_associated(arg_client_id)
      # where("client_relationship_id in (select id from client_relationships where from_client_id = #{arg_client_id}
      #         and relationship_type in (select id from codetable_items where code_table_id = 123)) and deprivation_code is not null").count > 0

      step1 = ClientParentalRspability.joins("INNER JOIN client_relationships ON client_parental_rspabilities.client_relationship_id = client_relationships.id")
      step2 = step1.where("client_relationships.from_client_id = ?",arg_client_id)
      step3 = step2.where("deprivation_code is not null").count > 0
   end

   def court_ordered_amount?
      if (court_ordered_amount.present? && ((court_ordered_amount.to_s =~ /\A\d{0,6}(\.{1}\d{0,2})?\z/).nil?))
        errors[:base] << "Court ordered amount should be maximum 6 digits and 2 decimals."
        return false
      else
        return true
      end
  end
  def amount_collected?
      if (amount_collected.present? && ((amount_collected.to_s =~ /\A\d{0,6}(\.{1}\d{0,2})?\z/).nil?))
        errors[:base] << "Amount collected should be maximum 6 digits and 2 decimals."
        return false
      else
        return true
      end
  end

  def self.is_an_absent_parent_of_an_active_child_in_program_unit(arg_client_id)
    step1 = joins("INNER JOIN client_relationships ON client_parental_rspabilities.client_relationship_id = client_relationships.id
                   INNER JOIN program_benefit_members ON program_benefit_members.client_id = client_relationships.from_client_id")
    step2 = step1.where("client_relationships.to_client_id = ? and client_parental_rspabilities.parent_status = 6076
                         and program_benefit_members.member_status = 4468",arg_client_id)
    step2.count > 0
  end

   def self.get_absent_parenatl_responsibility_list_for_household(arg_household_id)
        # Postgresql QUery *********************************************
        #     SELECT client_parental_rspabilities.ID,
        #        CHILDREN.ID AS CHILD_CLIENT_ID,
        #        household_members.HOUSEHOLD_ID,
        #        PARENT.ID AS PARENT_CLIENT_ID,
        #        children.last_name ||', '|| children.FIRST_name as childs_name,
        #        CHILDREN.SSN AS CHILD_SSN,
        #        PARENT.last_name ||', '|| PARENT.FIRST_name as PARENT_name,
        #        PARENT.SSN AS PARENT_SSN,
        #        client_parental_rspabilities.deprivation_code,
        #        client_parental_rspabilities.good_cause
        #  FROM client_parental_rspabilities
        #  INNER JOIN client_relationships
        #  ON client_parental_rspabilities.client_relationship_id = client_relationships.ID
        # INNER JOIN CLIENTS AS CHILDREN
        # ON (client_relationships.from_client_id = CHILDREN.id)
        # INNER JOIN CLIENTS AS PARENT
        # ON (client_relationships.to_client_id = PARENT.id)
        # INNER JOIN household_members
        # ON household_members.CLIENT_ID = client_relationships.from_client_id
        # WHERE client_relationshipS.RELATIONSHIP_TYPE = 5977
        # AND client_parental_rspabilities.parent_status = 6076
        # AND household_members.HOUSEHOLD_ID = 372
        # ORDER BY children.last_name ||', '|| children.FIRST_name DESC
        # Postgresql QUery *********************************************

      step1 = ClientParentalRspability.joins("INNER JOIN client_relationships
                                              ON client_parental_rspabilities.client_relationship_id = client_relationships.ID
                                              INNER JOIN CLIENTS AS CHILDREN
                                              ON (client_relationships.from_client_id = CHILDREN.id)
                                              INNER JOIN CLIENTS AS PARENT
                                              ON (client_relationships.to_client_id = PARENT.id)
                                              INNER JOIN household_members
                                              ON household_members.CLIENT_ID = client_relationships.from_client_id
                                              ")
      step2 = step1.where("client_relationshipS.RELATIONSHIP_TYPE = 5977
                          AND client_parental_rspabilities.parent_status = 6076
                          AND household_members.HOUSEHOLD_ID = ?",arg_household_id)
      step3 = step2.select("client_parental_rspabilities.id,
                            CHILDREN.ID AS CHILD_CLIENT_ID,
                            household_members.HOUSEHOLD_ID,
                           PARENT.ID AS PARENT_CLIENT_ID,
                           children.last_name ||', '|| children.FIRST_name as childs_name,
                           CHILDREN.SSN AS child_ssn,
                           PARENT.last_name ||', '|| PARENT.FIRST_name as parents_name,
                           PARENT.SSN AS parent_ssn,
                           client_parental_rspabilities.deprivation_code,
                           client_parental_rspabilities.good_cause"
                           ).order("client_parental_rspabilities.ID ASC")
      client_rspabilities_collection = step3
      return client_rspabilities_collection
    end


    def self.get_relationship_record_for_absent_parent(arg_client_parental_rspability_id)
      client_parental_rspability_object = ClientParentalRspability.find(arg_client_parental_rspability_id)
      relationship_object = ClientRelationship.find(client_parental_rspability_object.client_relationship_id)
      return relationship_object
    end


  # 03/17/2016 - Manoj Patil - step process start
     attr_writer :current_step,:process_object

    def steps
      %w[
          household_absent_parent_registration_step
          household_absent_parent_address_step
          household_children_with_no_absent_parent_data_step
          household_absent_parent_responsibility_step
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

  # 03/17/2016 - Manoj Patil - step process end


  def self.children_dropdown_with_no_absent_parent(arg_household_id,arg_absent_parent_client_id)
    # all household memebrs - children in dob is entered.


    # all household memebrs - children in dob is not entered.


    step1 = Client.joins("INNER JOIN  household_members
                          ON (clients.id = household_members.client_id
                              and household_members.member_status = 6643
                              and clients.dob is not null
                              and clients.death_date is null
                              and EXTRACT(YEAR FROM AGE(clients.DOB))<= (SELECT CAST(VALUE AS INTEGER) FROM SYSTEM_PARAMS WHERE SYSTEM_PARAM_CATEGORIES_ID = 6)
                              )
                         ")
    step2 = step1.where("household_members.household_id = ?",arg_household_id)
    step3 = step2.select("clients.id,
                         clients.last_name ||', '||clients.first_name as client_name").order("clients.id ASC")
    household_children = step3
    # --------------------------------

    step1 = Client.joins("INNER JOIN  household_members
                          ON (clients.id = household_members.client_id
                              and household_members.member_status = 6643
                              and clients.dob is null
                              and clients.death_date is null)
                         ")
    step2 = step1.where("household_members.household_id = ?",arg_household_id)
    step3 = step2.select("clients.id,
                         clients.last_name ||', '||clients.first_name as client_name").order("clients.id ASC")
    household_members_for_household_with_no_dob = step3
    # ----------------------------------------------

    # clients already having absent parent in this household.

    # step1 = Client.where("id in (SELECT     CHILDREN.ID AS client_id
    #                              FROM client_parental_rspabilities
    #                              INNER JOIN client_relationships
    #                              ON client_parental_rspabilities.client_relationship_id = client_relationships.ID
    #                             INNER JOIN CLIENTS AS CHILDREN
    #                             ON (client_relationships.from_client_id = CHILDREN.id)
    #                             INNER JOIN CLIENTS AS PARENT
    #                             ON (client_relationships.to_client_id = PARENT.id)
    #                             INNER JOIN household_members
    #                             ON household_members.CLIENT_ID = client_relationships.from_client_id
    #                             WHERE client_relationshipS.RELATIONSHIP_TYPE = 5977
    #                             AND client_parental_rspabilities.parent_status = 6076
    #                             AND household_members.HOUSEHOLD_ID = ? )",arg_household_id)
   step1 = Client.where("id in (SELECT  CHILDREN.ID AS client_id
                                FROM client_relationships
                                INNER JOIN CLIENTS AS CHILDREN
                                ON (client_relationships.from_client_id = CHILDREN.id)
                                INNER JOIN CLIENTS AS PARENT
                                ON (client_relationships.to_client_id = PARENT.id)
                                INNER JOIN household_members
                                ON household_members.CLIENT_ID = client_relationships.from_client_id
                                WHERE client_relationships.RELATIONSHIP_TYPE = 5977
                                AND household_members.HOUSEHOLD_ID = ?
                                AND PARENT.id = ?)",arg_household_id,arg_absent_parent_client_id)
   step2 = step1.select("clients.id,
                         clients.last_name ||', '||clients.first_name as client_name").order("clients.id ASC")

   clients_with_absent_parent_collection = step2
   # --------------------------------------
    # clients already having absent parent in this household.

    step1 = Client.where("id in (SELECT     CHILDREN.ID AS client_id
                                 FROM client_parental_rspabilities
                                 INNER JOIN client_relationships
                                 ON client_parental_rspabilities.client_relationship_id = client_relationships.ID
                                INNER JOIN CLIENTS AS CHILDREN
                                ON (client_relationships.from_client_id = CHILDREN.id)
                                INNER JOIN CLIENTS AS PARENT
                                ON (client_relationships.to_client_id = PARENT.id)
                                INNER JOIN household_members
                                ON household_members.CLIENT_ID = client_relationships.from_client_id
                                WHERE client_relationships.RELATIONSHIP_TYPE = 5977
                                AND client_parental_rspabilities.parent_status = 6076
                                AND household_members.HOUSEHOLD_ID = ? )",arg_household_id)
    step2 = step1.select("clients.id,
                         clients.last_name ||', '||clients.first_name as client_name").order("clients.id ASC")
    clients_with_responsibility_data = step2


   clients_with_no_absent_parent_collection = ( (household_children + household_members_for_household_with_no_dob) - clients_with_absent_parent_collection)
   clients_with_no_absent_parent_collection = clients_with_no_absent_parent_collection - clients_with_responsibility_data


  end


  def self.is_absent_parents_address_same_as_focus_household_address(arg_absent_parent_client_id,arg_household_id)
    # Rails.logger.debug("arg_absent_parent_client_id = #{arg_absent_parent_client_id}")
    # Rails.logger.debug("arg_household_id = #{arg_household_id}")

    return_message = nil
    absent_parent_physical_address_object = nil
    household_physical_address_object = nil

    # get the physical (residential) address of absent parent
    step1 = Address.joins("INNER JOIN entity_addresses
                           ON (addresses.id = entity_addresses.address_id
                               AND entity_addresses.entity_type = 6150
                               AND addresses.address_type = 4664
                               AND addresses.effective_end_date IS NULL)
                          ")
    step2 = step1.where("entity_addresses.entity_id = ?",arg_absent_parent_client_id).order("id DESC")
    if step2.present?
      absent_parent_physical_address_object = step2.first
    else
      return_message = "Residential address not found for absent parent"
    end
    # Rails.logger.debug("absent_parent_physical_address_object = #{absent_parent_physical_address_object.inspect}")
    if absent_parent_physical_address_object.present?
      # get the residential address for the household.
      # step1 - collection of inhousehold members from household.
      in_household_members_collection = HouseholdMember.where("member_status = 6643
                                                               and household_id = ?",arg_household_id
                                                               ).order("id ASC")
      if in_household_members_collection.present?
        first_household_member_object = in_household_members_collection.first
        # get the physical (residential) address of household/ first client with inhousehold status.
        # Household with 'Inhousehold' status means they are living in the same residential address
        step1 = Address.joins("INNER JOIN entity_addresses
                           ON (addresses.id = entity_addresses.address_id
                               AND entity_addresses.entity_type = 6150
                               AND addresses.address_type = 4664
                               AND addresses.effective_end_date IS NULL)
                          ")
        step2 = step1.where("entity_addresses.entity_id = ?",first_household_member_object.client_id).order("id DESC")
        if step2.present?
          household_physical_address_object = step2.first
          # Rails.logger.debug("household_physical_address_object = #{household_physical_address_object.inspect}")
        else
           return_message = "Residential address not found for household"
        end

      else
        return_message = "No members with status -Inhousehold found"
      end
    end

    if absent_parent_physical_address_object.present? && household_physical_address_object.present?

        # absent_parent_physical_address_object
        ap_ls_address_line1 = absent_parent_physical_address_object.address_line1.downcase.strip
        if absent_parent_physical_address_object.address_line2.present?
            ap_ls_address_line2 = absent_parent_physical_address_object.address_line2.downcase.strip
        else
            ap_ls_address_line2 = 'NOT_POPULATED'.downcase.strip
        end
        ap_ls_city = absent_parent_physical_address_object.city.downcase.strip
        ap_li_state = absent_parent_physical_address_object.state
        ap_ls_zip = absent_parent_physical_address_object.zip.downcase.strip

        # household_physical_address_object

        hh_ls_address_line1 = household_physical_address_object.address_line1.downcase.strip
        if household_physical_address_object.address_line2.present?
            hh_ls_address_line2 = household_physical_address_object.address_line2.downcase.strip
        else
            hh_ls_address_line2 = 'NOT_POPULATED'.downcase.strip
        end
        hh_ls_city = household_physical_address_object.city.downcase.strip
        hh_li_state = household_physical_address_object.state
        hh_ls_zip = household_physical_address_object.zip.downcase.strip

        # check if absent parent address contents same as household address contents
        # Rails.logger.debug("ap_ls_address_line1 = #{ap_ls_address_line1}")
        # Rails.logger.debug("hh_ls_address_line1 = #{hh_ls_address_line1}")
        # Rails.logger.debug("ap_ls_address_line2 = #{ap_ls_address_line2}")
        # Rails.logger.debug("hh_ls_address_line2 = #{hh_ls_address_line2}")
        # Rails.logger.debug("ap_ls_city = #{ap_ls_city}")
        # Rails.logger.debug("hh_ls_city = #{hh_ls_city}")
        # Rails.logger.debug("ap_li_state = #{ap_li_state}")
        # Rails.logger.debug("hh_li_state = #{hh_li_state}")
        # Rails.logger.debug("ap_ls_zip = #{ap_ls_zip}")
        # Rails.logger.debug("hh_ls_zip = #{hh_ls_zip}")
        if ( (ap_ls_address_line1 == hh_ls_address_line1) &&
             (ap_ls_address_line2 == hh_ls_address_line2) &&
             (ap_ls_city == hh_ls_city) &&
             (ap_li_state == hh_li_state) &&
             (ap_ls_zip == hh_ls_zip)
           )
          return_message = "Y"
        else
          return_message = "N"
        end
    end
    # Rails.logger.debug("return_message = #{return_message}")
    return return_message

  end


  def self.get_children_of_absent_parent_for_household(arg_absent_parent_client_id,arg_household_id)
    step1 = Client.where("id in (SELECT     CHILDREN.ID AS client_id
                                 from client_relationships
                                 INNER JOIN CLIENTS AS CHILDREN
                                 ON (client_relationships.from_client_id = CHILDREN.id)
                                 INNER JOIN CLIENTS AS PARENT
                                 ON (client_relationships.to_client_id = PARENT.id)
                                 INNER JOIN household_members
                                 ON household_members.CLIENT_ID = client_relationships.from_client_id
                                 WHERE client_relationshipS.RELATIONSHIP_TYPE = 5977
                                 AND household_members.HOUSEHOLD_ID = ?
                                 AND PARENT.id = ?)",arg_household_id,arg_absent_parent_client_id
                        ).order("clients.first_name ASC")
    children_of_absent_parent_list = step1
    return children_of_absent_parent_list


  end

  def self.get_parental_responsibility_data_for_absent_parent(arg_absent_parent_client_id,arg_child_client_id)
    ab_parent_responsibility_object = nil
    step1 =  ClientParentalRspability.where("client_relationship_id in (select id from client_relationships
                                                   where from_client_id = ?
                                                   and to_client_id = ?
                                                   and relationship_type = 5977
                                                  )
                                          ",arg_child_client_id,arg_absent_parent_client_id)
    if step1.present?
      ab_parent_responsibility_object = step1.first
    end
    return ab_parent_responsibility_object
  end


  def self.absent_parent_responsibility_data_populated_for_absent_parent_for_household(arg_absent_parent_client_id,arg_household_id)

    ls_msg = nil
    # get childrens of absent parent in this household
    children_of_absent_parent_collection = ClientParentalRspability.get_children_of_absent_parent_for_household(arg_absent_parent_client_id,arg_household_id)
    if children_of_absent_parent_collection.present?
      children_of_absent_parent_collection.each do |each_child_object|
          absent_parent_relations_object = ClientRelationship.where("from_client_id = ? and to_client_id = ? and relationship_type = 5977",each_child_object.id,arg_absent_parent_client_id).first
          absent_parent_responsibility_collection = ClientParentalRspability.where("client_relationship_id = ?",absent_parent_relations_object.id)
          ls_msg = "SUCCESS"
          if absent_parent_responsibility_collection.blank?
            ls_msg = "Absent parent Responsibility Data not found"
            break
          end
      end
    else
      ls_msg = " Parent relationship not found "
    end
    return ls_msg
  end

  def self.change_absent_parent_for_selected_client(arg_absent_parent_id,arg_responsibility_id,arg_household_id)

      responsibility_collection = ClientParentalRspability.where("id = ?",arg_responsibility_id)
      responsibility_object = responsibility_collection.first
      client_relation_object = ClientRelationship.find(responsibility_object.client_relationship_id)
       # insert relations record.- with child and new absent parent
      new_relationship_object = ClientRelationship.new
      new_relationship_object.from_client_id = client_relation_object.from_client_id
      new_relationship_object.relationship_type = 5977
      new_relationship_object.to_client_id = arg_absent_parent_id
      new_relationship_object.save

        # update responsibility record. ClientParentalRspability.where("id = ?",arg_responsibility_id).update_all("")
        responsibility_object.client_relationship_id = new_relationship_object.id
        responsibility_object.save
         # since old relationship does not exist - delete  relation record.
       # delete relations record - between old absent parent and child
        ClientRelationship.where("id = ?",client_relation_object.id).destroy_all

       selected_child_list = Client.where("id = ?",new_relationship_object.from_client_id)
      return selected_child_list

  end



  def self.absent_parent_rejoins_the_household_process(arg_household_object,arg_absent_parent_client_object,arg_absent_parent_responsibility_object)

    # 2. make the current address as prior address
    # 3. make this absent parent client id -part of household's residential address
    # 4. make the household member status 'Inhousehold'
    # 5. if pending application present - add this client as application member
    # else add new application & add this absent parent client id as application member

    # # 1.change deprivation code to 'Not deprived' and parent status 'Present'
      arg_absent_parent_responsibility_object.parent_status =  6077 # present
      arg_absent_parent_responsibility_object.deprivation_code = 3116 # Not deprived

    # # 2. make the current physical address as prior address
     step1 = Address.joins("INNER JOIN entity_addresses
                           ON addresses.id = entity_addresses.address_id
                           and addresses.address_type = 4664
                           and addresses.effective_end_date is null
                           and entity_addresses.entity_type = 6150
                           ")

     step2 = step1.where("entity_addresses.entity_id = ?",arg_absent_parent_client_object.id)
     physical_address_collection = step2

     # 3.make this absent parent client id -part of household's residential address
     hh_members_in_household_collection = HouseholdMember.get_all_members_in_the_household(arg_household_object.id)
     hh_member_object = hh_members_in_household_collection.first
     # current household physical address
     step1 = Address.joins("INNER JOIN entity_addresses
                           ON addresses.id = entity_addresses.address_id
                           and addresses.address_type = 4664
                           and addresses.effective_end_date is null
                           and entity_addresses.entity_type = 6150
                           ")
     step2 = step1.where("entity_addresses.entity_id = ?",hh_member_object.client_id)
     current_household_physical_address_collection = step2


     # old household id of absent parent.
     absent_parent_in_household_collection = HouseholdMember.where("client_id = ? and member_status = 6643",arg_absent_parent_client_object.id)




      ls_msg = nil
        begin
          ActiveRecord::Base.transaction do
            # 1.change deprivation code to 'Not deprived' and parent status 'Present'
            arg_absent_parent_responsibility_object.save!
            # 2.make the current physical address as prior address
            if physical_address_collection.present?
              current_physical_address_object = physical_address_collection.first
              current_physical_address_object.effective_end_date = Date.today
              current_physical_address_object.address_type = 5769 # prior physical
              current_physical_address_object.save!
            end
            # 3.make this absent parent client id -part of household's residential address
            if current_household_physical_address_collection.present?
              current_household_physical_address_object = current_household_physical_address_collection.first
              entity_address_collection = EntityAddress.where("entity_type = 6150
                                                               and address_id = ?
                                                               and entity_id = ?",current_household_physical_address_object.id,arg_absent_parent_client_object.id
                                                             )
              if entity_address_collection.blank?
                entity_address_object = EntityAddress.new
                entity_address_object.entity_type = 6150
                entity_address_object.address_id = current_household_physical_address_object.id
                entity_address_object.entity_id = arg_absent_parent_client_object.id
                entity_address_object.save!
              end
            end

            # 4.make the household member status 'Inhousehold'
            household_member_object = HouseholdMember.set_household_member_data(arg_household_object.id,arg_absent_parent_client_object.id)
            household_member_object.save!

            # 5. make the absent parent out of household from his current household.
            if absent_parent_in_household_collection.present?
              absent_parent_in_household_object = absent_parent_in_household_collection.first
              absent_parent_in_household_object.member_status = 6644  # out of household
              absent_parent_in_household_object.save!
            end



            # 6.
            client_application_object = nil
            not_disposed_application_collection = ClientApplication.where("household_id = ? and application_disposition_status is null",arg_household_object.id).order("id DESC")
            if not_disposed_application_collection.present?
              client_application_object = not_disposed_application_collection.first
              client_application_object.save!
            else
              client_application_object = ClientApplication.new
              client_application_object.application_date = Date.today
              client_application_object.application_status = 5942
              client_application_object.application_origin = 6025
              user_local_office_object = UserLocalOffice.where("user_id = ?", AuditModule.get_current_user.uid).order("id ASC").first
              client_application_object.application_received_office = user_local_office_object.local_office_id
              client_application_object.household_id = arg_household_object.id
              client_application_object.save!
            end

            # 7. add absent parent to application members list
            application_member_object = ApplicationMember.set_application_member_data(client_application_object.id,arg_absent_parent_client_object.id)
            application_member_object.save!

            # 8. household steps.
            HouseholdMemberStepStatus.update_household_id_to_client_steps(arg_absent_parent_client_object.id,arg_household_object.id)


          end
          ls_msg = "SUCCESS"
        rescue => err
          error_object = CommonUtil.write_to_attop_error_log_table("Household","new_household_id_for_members_moved_out_of_old_household",err,AuditModule.get_current_user.uid)
          ls_msg = "Failed to create household - for more details refer to error ID: #{error_object.id}."
        end
        return ls_msg
  end







end
