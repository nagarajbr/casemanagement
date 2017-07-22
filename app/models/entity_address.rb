class EntityAddress < ActiveRecord::Base
has_paper_trail :class_name => 'EntityAddressVersion',:on => [:update, :destroy]


   include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field
    # Manoj 05/12/2016 - start
    after_save :update_client_residency_flag
    # Manoj 05/12/2016 - end

    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id

    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end


    def update_client_residency_flag
        # Rails.logger.debug("address_object = #{self.inspect}")
        if self.entity_type? && self.entity_id? && self.address_id?
          if self.entity_type == 6150
            # entity = client
            address_object = Address.find(self.address_id)
            if address_object.address_type == 4664
              # physical address
              client_object = Client.find(self.entity_id)
              previous_residency = client_object.residency
              if address_object.state == 5793
                  client_object.residency = 'Y'
              else
                  client_object.residency = 'N'
              end
              client_object.save if client_object.residency != previous_residency
            end
          end
        end # END OF self.entity_type? && self.entity_id? && self.address_id?

    end#save_residency_by_checking_address



    def self.destroy_by_address_id(arg_address_id)
        address = where("address_id = ?",arg_address_id)
        if address.present?
            address.first.destroy
        end
    end


    def self.update_residential_address_id_with_household_res_address_id(arg_client_id,arg_new_residential_address_id)
      step1 = EntityAddress.joins("INNER JOIN addresses
                                   ON (entity_addresses.address_id = addresses.id
                                       and addresses.address_type = 4664
                                       and entity_addresses.entity_type = 6150
                                    )
                                  ")
      step2 = step1.where("entity_addresses.entity_id = ?",arg_client_id)
      if step2.present?
        old_client_address_object = step2.first
        # get entity address object - so that we can update new client with passed residential address_id
        update_address_object = EntityAddress.find(old_client_address_object.id)
        update_address_object.address_id = arg_new_residential_address_id
        update_address_object.save

        # if there are no client addresses found for old address delete it.
        old_address_referenced_client_collection = EntityAddress.where("entity_addresses.entity_type = 6150
                                                                       and entity_addresses.address_id = ?", old_client_address_object.address_id)
        if old_address_referenced_client_collection.blank?
          Address.where("id = ?",old_client_address_object.address_id).destroy_all
        end
      end
    end


    # HOUSEHOLD ADDRESS CHANGE WIZARD METHODS - MANOJ 03/31/2016 -START

    def self.get_clients_living_in_this_address(arg_address_id)
      step1 = Client.joins(" INNER JOIN entity_addresses
                           ON (clients.id = entity_addresses.entity_id
                               AND entity_type = 6150
                              )
                           ")
      step2 = step1.where("entity_addresses.address_id = ?",arg_address_id)
      clients_living_in_this_address_collection = step2
      return clients_living_in_this_address_collection
    end

    def self.members_dropdown_not_moved_to_new_address(arg_household_id,arg_address_id)
      # all household members
      step1 = Client.joins("INNER JOIN household_members
                           ON (clients.id = household_members.client_id
                               and household_members.member_status = 6643)
                           ")
      step2 = step1.where("household_members.household_id = ?",arg_household_id)
      all_household_members_collection = step2

      # how many of these hh members are already in this new address
      step1 = Client.joins("INNER JOIN entity_addresses
                           ON (clients.id = entity_addresses.entity_id
                               AND entity_type = 6150
                              )
                          ")
      step2 = step1.where("entity_addresses.address_id = ?",arg_address_id)
      members_living_in_this_address_collection = step2

      if all_household_members_collection.present?
        if members_living_in_this_address_collection.present?
          dropdowm_values_of_members = all_household_members_collection - members_living_in_this_address_collection
        else
          dropdowm_values_of_members = all_household_members_collection
        end
      else
        dropdowm_values_of_members = nil
      end

      return dropdowm_values_of_members

    end


    def self.save_client_entity_address(arg_address_id,arg_client_id)
      client_entity_address_collection = EntityAddress.where("entity_type = 6150 and entity_id = ? and address_id = ?",arg_client_id,arg_address_id)
      if client_entity_address_collection.present?
        msg = "SUCCESS"
      else
        client_entity_address = EntityAddress.new
        client_entity_address.entity_type = 6150
        client_entity_address.entity_id = arg_client_id
        client_entity_address.address_id = arg_address_id
        if client_entity_address.save
          msg = "SUCCESS"
        else
          msg = client_entity_address.errors.full_messages.last
        end

      end
      return msg

    end

    def self.remove_client_from_address(arg_client_id,arg_address_id)
      client_entity_address_collection = EntityAddress.where("entity_type = 6150 and entity_id = ? and address_id = ?",arg_client_id,arg_address_id)
      if client_entity_address_collection.present?
        client_entity_address_collection.destroy_all
      end
    end

    def self.all_household_members_moved_to_new_address?(arg_household_id,arg_address_id)
      all_household_members_collection = HouseholdMember.where("household_id = ? and member_status = 6643",arg_household_id)
      clients_sharing_new_address_collection = EntityAddress.where("entity_type = 6150 and address_id = ? and entity_id in (select client_id
                                                                                                                            from household_members
                                                                                                                            where member_status = 6643
                                                                                                                            and household_id = ?)",arg_address_id,arg_household_id
                                                                  )
      if clients_sharing_new_address_collection.size == all_household_members_collection.size
        return true
      else
        return false
      end
    end

    # HOUSEHOLD ADDRESS CHANGE WIZARD METHODS - MANOJ 03/31/2016 -END

end

