class ClientRelationship < ActiveRecord::Base
has_paper_trail :class_name => 'ClientRelationshipVersion',:on => [:create, :destroy]

  # Author : Manoj Patil
  # Date : 09/20/2014

   include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field
    after_create :set_relationship_step_as_complete
     # has_many :client_parental_rspabilities
    has_many :client_parental_rspability, dependent: :destroy

    attr_accessor :update_flag

  # belongs_to :client,foreign_key: :from_client_id
  # belongs_to :client,foreign_key: :to_client_id
  validates_presence_of :from_client_id, :relationship_type, :to_client_id, message: "is required."

  HUMANIZED_ATTRIBUTES = {
    from_client_id: "",
    relationship_type: "Relationship",
      to_client_id: "Related client"

}

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end


  validate :cannot_add_same_fromclientId_and_toclientId
  validates :relationship_type,:uniqueness => {:scope => [:from_client_id,:to_client_id]}
  validates :from_client_id,:uniqueness => {:scope => [:to_client_id],message: "Relationship between these clients is already established."}



    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end



  def cannot_add_same_fromclientId_and_toclientId
      if from_client_id == to_client_id
        errors.add(:to_client_id, 'must be someone other than the client')
      end
  end

  # def self.get_inverse_relationship_record(arg_relationship_type,arg_from_client_id,arg_to_client_id)
  #   self.where("relationship_type = ? and from_client_id = ? and to_client_id = ?",arg_relationship_type,arg_to_client_id,arg_from_client_id)
  # end

  def self.get_client_inverse_relationship_record(arg_from_client_id,arg_to_client_id)
    self.where("from_client_id = ? and to_client_id = ?",arg_to_client_id,arg_from_client_id)
  end

  # def self.get_relationship_id(arg_relationship_type,arg_from_client_id,arg_to_client_id)
  #   relation_object=self.where("relationship_type = ? and from_client_id = ? and to_client_id = ?",arg_relationship_type,arg_from_client_id,arg_to_client_id).first
  #   l_relationship_id = relation_object.id
  #   return l_relationship_id
  # end

  def self.delete_relationship(arg_id)
    # client_relations-table-record -destroy
    client_relationship = self.find(arg_id)
    # relationship type
    l_relationship_type = client_relationship.relationship_type
    l_from_client_id = client_relationship.from_client_id
    l_to_client_id = client_relationship.to_client_id
    # Delete the inverse relation record
    inverse_client_relationship_object = self.get_client_inverse_relationship_record(l_from_client_id,l_to_client_id)
      if inverse_client_relationship_object.present?
        begin
          ActiveRecord::Base.transaction do
            ClientRelationship.trigger_events_for_client_reletionship(client_relationship, l_from_client_id,345)
            inverse_client_relationship_object.first.destroy!
            client_relationship.destroy!
          end
          msg = "SUCCESS"
        rescue
          msg = "FAIL"
        end
      else
        # No inverse relation found just delete one record.-No transaction object required -ACtive record takes care of transaction.
        client_relationship.destroy
        msg = "SUCCESS"
      end
   end


  def self.create_relationships(arg_from_client_id,arg_relationship_type,arg_to_client_id)

    client_relationship = self.new
    # From client is Focus Applicant
    client_relationship.from_client_id =  arg_from_client_id
    # to client is - searched client
    client_relationship.to_client_id = arg_to_client_id
    client_relationship.relationship_type =  arg_relationship_type

    if SystemParam.inverse_relationship_exists?(arg_relationship_type)
        inversr_system_param_object = SystemParam.get_inverse_relationship_object(arg_relationship_type).first
        inverse_client_relationship = self.new
        inverse_client_relationship.to_client_id =  arg_from_client_id
        inverse_client_relationship.from_client_id = arg_to_client_id
        inverse_client_relationship.relationship_type = inversr_system_param_object.value.to_i

        begin
          ActiveRecord::Base.transaction do
            ClientRelationship.trigger_events_for_client_reletionship(client_relationship, arg_from_client_id,343)
            client_relationship.save!
            inverse_client_relationship.save!
          end
          msg = "SUCCESS"

           rescue => err
           msg = err.message
        end
    else
      if client_relationship.save
        msg = "SUCCESS"
      else
         msg = "FAIL"
      end
    end
    return msg
  end

  def self.trigger_events_for_client_reletionship(arg_client_reletionship_object, arg_client_id,arg_event_id)
    if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_id)
      common_action_argument_object = CommonEventManagementArgumentsStruct.new
      common_action_argument_object.client_id = arg_client_id
      common_action_argument_object.logged_in_user_id = AuditModule.get_current_user.uid
      common_action_argument_object.program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
      if arg_event_id.present?
        common_action_argument_object.event_id = arg_event_id #event id for out of state payments controller
      else
        common_action_argument_object.model_object = arg_client_reletionship_object
        common_action_argument_object.changed_attributes = arg_client_reletionship_object.changed_attributes().keys
        common_action_argument_object.is_a_new_record = arg_client_reletionship_object.new_record?
      end
      ls_msg = EventManagementService.process_event(common_action_argument_object)
    end
  end


  # def self.get_relationship_maintenance_index_list(arg_focus_client_id)
  #   # arg_focus_client_id = A
  #   # from_client_id   To_client_id
  #   #        A              B
  #   #        A              C
  #   #        B              A
  #   #        C              A
  #   #        B              C
  #   #        C              B

  #   step1 = self.where("from_client_id = ? OR to_client_id = ?",arg_focus_client_id,arg_focus_client_id)
  #   relationship_list = step1.where("relationship_type not in (select id from codetable_items where code_table_id = 123)")
  #   # logger.debug "first - relationship_list-inspect = #{relationship_list.inspect}"
  #   l_other_to_client_ids = Array.new

  #   if relationship_list.present?
  #      relationship_list.each do |arg_relation|
  #         if arg_relation.from_client_id != arg_focus_client_id
  #           # B & C are captured here.
  #           l_other_to_client_ids << arg_relation.from_client_id
  #         end
  #      end
  #     # convert array into comma separated string - to be used in IN clause.
  #     ls_other_to_client_ids = l_other_to_client_ids.map(&:inspect).join(', ')

  #     l_other_relationship_list = self.where("from_client_id in (?)",ls_other_to_client_ids)
  #     l_other_relationship_list = l_other_relationship_list.where("to_client_id in (?)",ls_other_to_client_ids)
  #     #  merge into one resultset object
  #    if l_other_relationship_list.present?
  #        l_other_relationship_list.each do |other_reln|
  #         relationship_list << other_reln
  #       end
  #    end

  #   end


  #   return relationship_list

  # end



  # def self.update_client_relationship(arg_id,arg_from_client_id,arg_relationship_type,arg_to_client_id)
  #   # get the record from database
  #   object_modified = self.where("id = ?",arg_id).first

  #   #  set with user entered modified values
  #   object_modified.from_client_id = arg_from_client_id
  #   object_modified.to_client_id = arg_to_client_id
  #   object_modified.relationship_type = arg_relationship_type


  #   inverse_relation_object = self.where("from_client_id = ? and to_client_id = ?", arg_to_client_id,arg_from_client_id)
  #   if inverse_relation_object.present?

  #     #  Get the Inverse relation type from system param table.
  #     if SystemParam.inverse_relationship_exists?(arg_relationship_type)

  #          inverse_system_param_object = SystemParam.get_inverse_relationship_object(arg_relationship_type).first
  #         l_inverse_object = inverse_relation_object.first
  #         #  set data
  #         l_inverse_object.from_client_id = arg_to_client_id
  #         l_inverse_object.to_client_id = arg_from_client_id
  #         l_inverse_object.relationship_type = inverse_system_param_object.value.to_i
  #         begin
  #            ActiveRecord::Base.transaction do
  #               object_modified.save!
  #               l_inverse_object.save!
  #           end
  #             msg = "SUCCESS"
  #         rescue
  #             msg = "FAIL"
  #         end
  #     else

  #       # iNVESRSE RELATION WAS found earlier - current modified relationship does not have inverse relation - so delete that
  #       # delete
  #       inverse_relation_object.first.destroy
  #     end
  #   else

  #     # else of inverse client relation object
  #     #  just update Normal record.
  #     if object_modified.save
  #       msg = "SUCCESS"
  #     else
  #       msg = "FAIL"
  #     end

  #   end

  #   return msg
  # end


  # def self.prepare_application_member_relationship_data(arg_application_id)

  #   #  Get application members for given application ID.
  #   l_application_members = ApplicationMember.where("client_application_id = ?",arg_application_id)
  #   #  Relationship records = l_application_members.count * l_application_members.count - 1
  #   # If 3 application members are there then 3 * 2 = 6 relationship records need to be created.
  #   # l_needed_relationship_record_count = l_application_members.count * (l_application_members.count - 1)
  #   #  Needed client relationship records
  #   l_from_client_array = Array.new
  #   l_to_client_array = Array.new

  #   l_application_members.each do |arg_member|
  #     l_from_client_array << arg_member.client_id
  #     l_to_client_array << arg_member.client_id
  #   end

  #   final_relation_objects_collection = self.where("1=2")

  #   # example set up 3* 2 = 6 records
  #   l_from_client_array.each do |l_outer|
  #     first_client = l_outer
  #     l_to_client_array.each do |l_inner|
  #       second_client = l_inner
  #       if second_client != first_client
  #         l_object = self.new
  #         l_object.from_client_id = first_client
  #         l_object.to_client_id = second_client
  #         final_relation_objects_collection << l_object
  #       end
  #     end
  #   end

  #   #  if relationship there then set the values
  #   final_relation_objects_collection.each do |arg_rel|
  #      step1 = self.where("from_client_id = ? and to_client_id = ?",arg_rel.from_client_id,arg_rel.to_client_id)
  #      # current_relation_object = self.where("from_client_id = ? and to_client_id = ?",arg_rel.from_client_id,arg_rel.to_client_id)
  #      current_relation_object = step1.where("relationship_type not in (select id from codetable_items where code_table_id = 123)")
  #      if current_relation_object.present?
  #         arg_rel.relationship_type = current_relation_object.first.relationship_type
  #         arg_rel.update_flag = "Y"
  #       else
  #         arg_rel.update_flag = "N"
  #      end
  #   end

  #   return final_relation_objects_collection
  # end


   def self.prepare_application_member_relationship_data_one_direction(arg_application_id)
      #  Get application members for given application ID.
      # l_application_members = ApplicationMember.where("client_application_id = ?",arg_application_id).order("primary_member DESC")
      l_application_members = ApplicationMember.sorted_application_members(arg_application_id)
      l_from_client_array = Array.new
      l_to_client_array = Array.new

      l_application_members.each do |arg_member|
        l_from_client_array << arg_member.client_id
        l_to_client_array << arg_member.client_id
      end

      final_relation_objects_collection = self.where("1=2")
       # example set up 3* 2 = 6/2 = 3 records
       li_counter = 0
        for i in 0 .. (l_to_client_array.length - 2)
          for j in (i + 1) .. (l_from_client_array.length - 1)
            li_counter = li_counter + 1
             logger.debug "i = #{i}"
             logger.debug "j = #{j}"
             logger.debug "li_counter = #{li_counter}"
              l_object = self.new

              # l_object.to_client_id = l_to_client_array[j]
              # l_object.from_client_id = l_from_client_array[i]
               l_object.to_client_id = l_to_client_array[i]
              l_object.from_client_id = l_from_client_array[j]
              final_relation_objects_collection << l_object
          end
        end

       #  if relationship there then set the values
      final_relation_objects_collection.each do |arg_rel|
        step1 = self.where("from_client_id = ? and to_client_id = ?",arg_rel.from_client_id,arg_rel.to_client_id)
        # current_relation_object = self.where("from_client_id = ? and to_client_id = ?",arg_rel.from_client_id,arg_rel.to_client_id)
        current_relation_object = step1.where("relationship_type not in (select id from codetable_items where code_table_id = 123)")
         if current_relation_object.present?
            arg_rel.relationship_type = current_relation_object.first.relationship_type
            arg_rel.update_flag = "Y"
          else
            arg_rel.update_flag = "N"
         end
      end
      final_relation_objects_collection.order("to_client_id ASC")
    return final_relation_objects_collection

  end





  # def self.update_multiple_relationships(arg_relations_array)

  #   result_object_collection = self.where("1=2")
  #   # error_collection = []
  #   arg_relations_array.each do |arg_relation|
  #     l_update_flag = arg_relation[:update_flag]
  #     if l_update_flag == "Y"
  #         step1 = self.where("from_client_id = ? and to_client_id = ?", arg_relation[:from_client_id],arg_relation[:to_client_id])
  #         step2 = step1.where("relationship_type not in (select id from codetable_items where code_table_id = 123)")
  #         # l_object = self.where("from_client_id = ? and to_client_id = ?", arg_relation[:from_client_id],arg_relation[:to_client_id]).first
  #          l_object = step2.first
  #         l_object.relationship_type = arg_relation[:relationship_type]
  #         if l_object.valid?
  #            l_object.save
  #            l_object.update_flag = "Y"
  #            result_object_collection << l_object
  #         else
  #            l_object.update_flag = "Y"
  #            result_object_collection << l_object
  #         end
  #     else
  #         l_object = self.new
  #         l_object.from_client_id = arg_relation[:from_client_id]
  #         l_object.to_client_id = arg_relation[:to_client_id]
  #         l_object.relationship_type = arg_relation[:relationship_type]
  #         if l_object.valid?
  #            l_object.save
  #            l_object.update_flag = "Y"
  #            result_object_collection << l_object
  #         else
  #           l_object.update_flag = "N"
  #           result_object_collection << l_object
  #         end
  #         logger.debug "result_object_collection-inspect = #{result_object_collection.inspect}"
  #     end

  #   end

  #    return result_object_collection


  # end



  def self.update_multiple_relationships_with_inverse_relation(arg_relations_array)

    result_object_collection = self.where("1=2")
    # error_collection = []
    arg_relations_array.each do |arg_relation|
      l_update_flag = arg_relation[:update_flag]
      if l_update_flag == "Y"
          # l_object = ClientRelationship.update_client_relationship(arg_relation.id,arg_relation.from_client_id,arg_relation.relationship_type,arg_relation.to_client_id)
          step1 = self.where("from_client_id = ? and to_client_id = ?", arg_relation[:from_client_id],arg_relation[:to_client_id])
          step2 = step1.where("relationship_type not in (select id from codetable_items where code_table_id = 123)")

          # l_object = self.where("from_client_id = ? and to_client_id = ?", arg_relation[:from_client_id],arg_relation[:to_client_id]).first
          l_object = step2.first

          l_object.relationship_type = arg_relation[:relationship_type]
          if l_object.valid?
             # l_object.save
             l_object.update_flag = "Y"

             # Save inverse relationship
            inverse_system_param_object = SystemParam.get_inverse_relationship_object(arg_relation[:relationship_type]).first
            inverse_client_relation_object = ClientRelationship.get_client_inverse_relationship_record(arg_relation[:from_client_id].to_i,arg_relation[:to_client_id].to_i).first
            inverse_client_relation_object.relationship_type = inverse_system_param_object.value.to_i
            begin
                ActiveRecord::Base.transaction do
                  l_object.save!
                  inverse_client_relation_object.save!
                end
                msg = "SUCCESS"
             rescue => err
               msg = err.message
               l_object.errors[:base] << msg
            end

            result_object_collection << l_object
            # l_object = ClientRelationship.update_inverse_relationship(arg_relation[:from_client_id].to_i,arg_relation[:relationship_type].to_i,arg_relation[:to_client_id].to_i)
             # result_object_collection << l_object
              # msg =  ClientRelationship.update_client_relationship(arg_relation.id,arg_relation.from_client_id,arg_relation.relationship_type,arg_relation.to_client_id)
          else
             l_object.update_flag = "Y"
             result_object_collection << l_object
          end
      else
          l_object = self.new
          l_object.from_client_id = arg_relation[:from_client_id].to_i
          l_object.to_client_id = arg_relation[:to_client_id].to_i
          l_object.relationship_type = arg_relation[:relationship_type].to_i
          if l_object.valid?
             # l_object.save
             l_object.update_flag = "N"
             # result_object_collection << l_object

             # Save Inverse Relationship.
              inversr_system_param_object = SystemParam.get_inverse_relationship_object(arg_relation[:relationship_type]).first
              inverse_client_relationship_object = self.new
              inverse_client_relationship_object.to_client_id =  arg_relation[:from_client_id].to_i
              inverse_client_relationship_object.from_client_id = arg_relation[:to_client_id].to_i
              inverse_client_relationship_object.relationship_type = inversr_system_param_object.value.to_i

            begin
                ActiveRecord::Base.transaction do
                  l_object.save!
                  inverse_client_relationship_object.save!
                end
                msg = "SUCCESS"
             rescue => err
               msg = err.message
               l_object.errors[:base] << msg
            end

            result_object_collection << l_object


             # l_object = ClientRelationship.insert_inverse_relationship(arg_relation[:from_client_id].to_i,arg_relation[:relationship_type].to_i,arg_relation[:to_client_id].to_i)
             # msg =  ClientRelationship.create_relationships(arg_relation.id,arg_relation.from_client_id,arg_relation.relationship_type,arg_relation.to_client_id)
              # result_object_collection << l_object
          else
            l_object.update_flag = "N"
            result_object_collection << l_object
          end

      end
      logger.debug "result_object_collection-inspect = #{result_object_collection.inspect}"
    end

     return result_object_collection


  end




  def self.get_apllication_member_relationships(arg_application_id)
    #  Relationship between Application form members for the passed application ID.
    l_query1 = ClientRelationship.where("from_client_id in (select client_id from application_members where client_application_id = ?)",arg_application_id)
    application_relationships = l_query1.where("to_client_id in (select client_id from application_members where client_application_id = ?)" ,arg_application_id)
    last_step = application_relationships.where("relationship_type not in (select id from codetable_items where code_table_id = 123)").order("to_client_id ASC")
    return last_step
  end

  def self.get_relationships_for_given_clients(arg_client_ids)
    l_query1 = ClientRelationship.where("from_client_id in (?)",arg_client_ids)
    application_relationships = l_query1.where("to_client_id in (?)" ,arg_client_ids)
    last_step = application_relationships.where("relationship_type not in (select id from codetable_items where code_table_id = 123)").order("to_client_id ASC")
    return last_step
  end

  def self.get_program_unit_member_relationships(arg_program_unit_id)
    #  Relationship between Application form members for the passed application ID.
    l_query1 = ClientRelationship.where("from_client_id in (select client_id from program_unit_members where program_unit_id = ?)",arg_program_unit_id)
    program_unit_relationships = l_query1.where("to_client_id in (select client_id from program_unit_members where program_unit_id = ?)", arg_program_unit_id)
    last_step = program_unit_relationships.where("relationship_type not in (select id from codetable_items where code_table_id = 123)").order("to_client_id ASC")
    return last_step
  end


  def self.prepare_program_unit_member_relationship_data_one_direction(arg_program_unit_id)
    #  Get application members for given application ID.

      l_program_unit_members = ProgramUnitMember.sorted_program_unit_members(arg_program_unit_id)
      l_from_client_array = Array.new
      l_to_client_array = Array.new

      l_program_unit_members.each do |arg_member|
        l_from_client_array << arg_member.client_id
        l_to_client_array << arg_member.client_id
      end

      final_relation_objects_collection = self.where("1=2")
       # example set up 3* 2 = 6/2 = 3 records
       li_counter = 0
        for i in 0 .. (l_to_client_array.length - 2)
          for j in (i + 1) .. (l_from_client_array.length - 1)
            li_counter = li_counter + 1
             logger.debug "i = #{i}"
             logger.debug "j = #{j}"
             logger.debug "li_counter = #{li_counter}"
              l_object = self.new

               l_object.to_client_id = l_to_client_array[i]
              l_object.from_client_id = l_from_client_array[j]
              final_relation_objects_collection << l_object
          end
        end

       #  if relationship there then set the values
      final_relation_objects_collection.each do |arg_rel|
         step1 = self.where("from_client_id = ? and to_client_id = ?",arg_rel.from_client_id,arg_rel.to_client_id)
         # current_relation_object = self.where("from_client_id = ? and to_client_id = ?",arg_rel.from_client_id,arg_rel.to_client_id)
          current_relation_object = step1.where("relationship_type not in (select id from codetable_items where code_table_id = 123)")
         if current_relation_object.present?
            arg_rel.relationship_type = current_relation_object.first.relationship_type
            arg_rel.update_flag = "Y"
          else
            arg_rel.update_flag = "N"
         end
      end
      final_relation_objects_collection.order("to_client_id ASC")
    return final_relation_objects_collection

  end

  def self.get_program_unit_member_relationships(arg_program_unit_id)

    #  #  Relationship between Program Unit members for the passed application ID.
    l_result1 = ClientRelationship.where("from_client_id in (select client_id from program_unit_members where program_unit_id = ?)",arg_program_unit_id)
    l_result2 = l_result1.where("to_client_id in (select client_id from program_unit_members where program_unit_id = ?)",arg_program_unit_id)
    l_result3 = l_result2.where("relationship_type not in (select id from codetable_items where code_table_id = 123)").order("to_client_id ASC")
    return l_result3
  end


#  Manoj 10/25/2014
  def self.get_parent_collection_for_child(arg_child_id)
    where("from_client_id = ? and relationship_type = 5977", arg_child_id)
  end

  def self.get_child_collection_for_parent(arg_parent_id)
    where("from_client_id = ? and relationship_type = 6009", arg_parent_id)
  end

  def self.focus_client_relationships(arg_focus_client)
    where(" to_client_id = ?",arg_focus_client)
  end

  def self.get_the_spouse_relation_for_the_client(arg_client_id)
    result = where("from_client_id = ? and relationship_type = 5991",arg_client_id)
    if result.present?
      result = result.first
    end
    return result
  end

  def self.is_there_a_spouse_relation_for_the_client(arg_client_id)
    where("from_client_id = ? and relationship_type = 5991",arg_client_id).count > 0
  end

  def self.is_there_a_relationship_between_clients(arg_client1,arg_client2)
    where("from_client_id = ? and to_client_id = ?",arg_client1,arg_client2).count > 0
  end

  def self.is_there_a_child_parent_relationship_between_clients(arg_child,arg_parent)
    where("from_client_id = ? and to_client_id = ? and relationship_type = 5977",arg_child, arg_parent).count > 0
  end

  def self.is_there_a_spouse_relationship_between_clients(client1,client2)
    where("relationship_type = 5991 and from_client_id = ? and to_client_id = ?",client1,client2).count > 0
  end

  # def self.is_there_a_parent_child_relationship(arg_child, ids)
  #   where("to_client_id = ? and relationship_type in (?)",arg_child, arg_parent, ids).count > 0
  # end

#  Kiran - End 09/24/2014

  def self.is_there_a_parent_relationship(arg_client_id)
    where("to_client_id = ? and relationship_type = 5977",arg_client_id).count > 0
  end

  def self.check_is_he_parent(arg_client_id)
    where("to_client_id = ? and relationship_type = 5977",arg_client_id)
  end


  # def self.is_there_a_care_taker_relationship_between_clients(arg_child_id, arg_adult_id)
  #   where("from_client_id = ? and to_client_id = ? and relationship_type = 6097",arg_child_id, arg_adult_id).count > 0
  # end

  # def self.is_there_any_child_who_is_less_than_six_years(arg_client_id)
  #   min_dob = Date.today - 6.years
  #   step1 = joins("INNER JOIN clients ON client_relationships.to_client_id = clients.id")
  #   step2 = step1.where("client_relationships.to_client_id = ? and relationship_type = 5977 and  clients.dob between ? and ?",arg_client_id, min_dob, Date.today)
  #   step2.count > 0
  # end

  def self.relationship_between_clients(arg_client1,arg_client2)
    where("from_client_id = ? and to_client_id = ?",arg_client1,arg_client2)
  end

  def self.get_household_member_relationships(arg_household_id)
    #  Relationship between household members for the passed household_id
    l_query1 = ClientRelationship.where("from_client_id in
                                                         (select client_id
                                                          from household_members
                                                          where household_id = ?
                                                          and household_members.member_status = 6643
                                                          )",arg_household_id
                                       )
    application_relationships = l_query1.where("to_client_id in
                                                              (select client_id
                                                               from household_members
                                                               where household_id = ?
                                                               and household_members.member_status = 6643
                                                               )" ,arg_household_id
                                              )
    last_step = application_relationships.where("relationship_type not in
                                                                        (select id
                                                                         from codetable_items
                                                                         where code_table_id = 123)"
                                                ).order("to_client_id ASC")
    return last_step
  end

   def self.prepare_household_member_relationship_data_one_direction(arg_household_id)
      #  Get household members for given household ID.
      # l_household_members = HouseholdMember.sorted_household_members(arg_household_id)
      l_household_members = HouseholdMember.get_household_members_with_inhousehold_status(arg_household_id)
      l_from_client_array = Array.new
      l_to_client_array = Array.new

      l_household_members.each do |arg_member|
        l_from_client_array << arg_member.client_id
        l_to_client_array << arg_member.client_id
      end

      final_relation_objects_collection = self.where("1=2")
       # example set up 3* 2 = 6/2 = 3 records
       li_counter = 0
        for i in 0 .. (l_to_client_array.length - 2)
          for j in (i + 1) .. (l_from_client_array.length - 1)
            li_counter = li_counter + 1
             # logger.debug "i = #{i}"
             # logger.debug "j = #{j}"
             # logger.debug "li_counter = #{li_counter}"
              l_object = self.new

              # l_object.to_client_id = l_to_client_array[j]
              # l_object.from_client_id = l_from_client_array[i]
               l_object.to_client_id = l_to_client_array[i]
              l_object.from_client_id = l_from_client_array[j]
              final_relation_objects_collection << l_object
          end
        end

       #  if relationship there then set the values
      final_relation_objects_collection.each do |arg_rel|
        step1 = self.where("from_client_id = ? and to_client_id = ?",arg_rel.from_client_id,arg_rel.to_client_id)
        # current_relation_object = self.where("from_client_id = ? and to_client_id = ?",arg_rel.from_client_id,arg_rel.to_client_id)
        current_relation_object = step1.where("relationship_type not in (select id from codetable_items where code_table_id = 123)")
         if current_relation_object.present?
            arg_rel.relationship_type = current_relation_object.first.relationship_type
            arg_rel.update_flag = "Y"
          else
            arg_rel.update_flag = "N"
         end
      end
      final_relation_objects_collection.order("to_client_id ASC")
    return final_relation_objects_collection

  end


  def set_relationship_step_as_complete
    # find the household id
    household_member_collection = HouseholdMember.where("client_id = ?",self.from_client_id).order("updated_at DESC")
    if household_member_collection.present?
        household_member_object = household_member_collection.first
        client_relations = ClientRelationship.get_household_member_relationships(household_member_object.household_id)
          # check if relations are added?
          l_members_count = HouseholdMember.where("household_id = ? and member_status = 6643",household_member_object.household_id).count
          l_expected_relationship_count = l_members_count * (l_members_count - 1)
          l_db_relationship_count = client_relations.size
          if  l_expected_relationship_count == l_db_relationship_count
            # update client steps - Manoj 01/14/2016 - start
            HouseholdMemberStepStatus.update_relationship_step_for_all_clients_in_household_with_passed_status(household_member_object.household_id,'Y')
            # update client steps - Manoj 01/14/2016 - end
          else
            HouseholdMemberStepStatus.update_relationship_step_for_all_clients_in_household_with_passed_status(household_member_object.household_id,'I')
          end
    end
  end


  def self.save_absent_parent_relationships(arg_child_client_id,arg_parent_client_id)

      client_relationship = nil
      inverse_client_relationship = nil
      msg = nil

      relations_collection = ClientRelationship.where("from_client_id = ? and relationship_type = 5977 and to_client_id = ?",arg_child_client_id,arg_parent_client_id)
      if relations_collection.present?
        msg = "SUCCESS"
        # all is well data exists
      else
        # data not found insert
        client_relationship = self.new
        client_relationship.from_client_id =  arg_child_client_id
        client_relationship.to_client_id = arg_parent_client_id
        client_relationship.relationship_type =  5977 # parent

        inverse_relation_collection = ClientRelationship.where("to_client_id = ? and relationship_type = 6009 and from_client_id = ?",arg_child_client_id,arg_parent_client_id)
        # inverse relation object.
        if inverse_relation_collection.blank?
          
          inverse_client_relationship = self.new
          inverse_client_relationship.to_client_id =  arg_child_client_id
          inverse_client_relationship.from_client_id = arg_parent_client_id
          inverse_client_relationship.relationship_type = 6009 # child
        end
        

        begin
            ActiveRecord::Base.transaction do
              client_relationship.save!
              inverse_client_relationship.save! if inverse_client_relationship.present?
            end
            msg = "SUCCESS"

        rescue => err
           msg = err.message
        end
      end  
      # Rails.logger.debug("msg = #{msg}") 
      return msg 
  end    

  def self.delete_absent_parent_relationship_with_child(arg_child_client_id,arg_absent_parent_client_id)
    # delete dependent parental relationship records
    ClientParentalRspability.where("client_relationship_id in (select id from client_relationships
                                                   where from_client_id = ?
                                                   and to_client_id = ?
                                                   and relationship_type = 5977      
                                                  )
                                          ",arg_child_client_id,arg_absent_parent_client_id).destroy_all

    # delete relationship records
    ClientRelationship.where("from_client_id = ?
                                      and to_client_id = ?
                                      and relationship_type = 5977",arg_child_client_id,arg_absent_parent_client_id).destroy_all

    # delete inverse relations
    ClientRelationship.where("to_client_id = ?
                              and from_client_id = ?
                              and relationship_type = 6009",arg_child_client_id,arg_absent_parent_client_id).destroy_all



  end




end
