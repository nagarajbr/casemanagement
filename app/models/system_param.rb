class SystemParam < ActiveRecord::Base
has_paper_trail :class_name => 'SystemParamVersion',:on => [:update, :destroy]

   belongs_to :system_param_category
    include AuditModule
    before_create :set_create_user_fields
    before_update :set_update_user_field


      def set_create_user_fields
       user_id = AuditModule.get_current_user.uid
       self.created_by = user_id
       self.updated_by = user_id
     end

     def set_update_user_field
       user_id = AuditModule.get_current_user.uid
       self.updated_by = user_id
     end

  # show description for given ID.
  def self.description(arg_id)
    where(id: arg_id).first.description
  end


  # return list for given param_category_id
  def self.param_values_list(arg_category_id,arg_description)
    # Order by number of months - that way it will be easy to see vaccinationation by months of child.
    where(system_param_categories_id: arg_category_id).order("CAST(value AS integer) ASC")
  end

  # def self.description_item_list (arg_category_id,arg_description)
  #     where(system_param_categories_id: arg_category_id ).order ("id")
  # end

  def self.inverse_relationship_exists?(arg_relationship_type)
    if arg_relationship_type.present?
      inverse_relation_object = where("system_param_categories_id = 5 and key = ?",arg_relationship_type.to_s)
      if inverse_relation_object.present?
        return true
      else
        return false
      end
    else
      return false
    end

  end

  def self.get_inverse_relationship_object(arg_relationship_type)
    inverse_relation_object = where("system_param_categories_id = 5 and key = ?",arg_relationship_type.to_s)
  end

  def self.get_pagination_records_per_page
    l_object_collection = SystemParam.where("id = 150")
    if l_object_collection.present?
      l_object = l_object_collection.first
      return l_object.value
    else
      return 10
    end



  end

   def self.get_pra_text_for_pre_screening()
      SystemParam.where("system_param_categories_id = 8 and key = 'PRA_PRESCREENING' ").first.description
   end

   def self.get_reinstate_days_limit()

      system_param_collection = SystemParam.where("key = 'REINSTATE_DAYS_LIMIT' and system_param_categories_id = 9")
      if system_param_collection.present?
        l_days = system_param_collection.first.value.to_i
      else
        l_days = 30
      end
      return l_days
   end

   #  def self.get_app_screening_days_limit()

   #    system_param_collection = SystemParam.where("key = 'APP_SCREENING_DAYS_LIMIT' and system_param_categories_id = 9")
   #    if system_param_collection.present?
   #      l_days = system_param_collection.first.value.to_i
   #    else
   #      l_days = 30
   #    end
   #    return l_days
   # end

    def self.get_state_limits_count()
      SystemParam.where("key = 'STATE_TIME_LIMITS' ").first.value.to_i
    end

    def self.get_federal_limits_count()
      SystemParam.where("key = 'FEDERAL_TIME_LIMITS' ").first.value.to_i
    end

    def self.get_key_value(arg_category,arg_key,arg_comments)
      l_object = SystemParam.where("key = ? and system_param_categories_id = ?",arg_key,arg_category).first
      return l_object.value
    end

    def self.get_key_value_list(arg_category,arg_key,arg_comments)
      ls_value = SystemParam.where("key = ? and system_param_categories_id = ?",arg_key,arg_category)
      return ls_value
    end

    def self.get_county_id(arg_zip_code)
      result = SystemParam.where("value = ? and system_param_categories_id = 12",arg_zip_code.to_s)
      if result.present?
        county_id = result.first.key.to_i
      else
        county_id = nil
      end
      return county_id
    end

    def self.get_key_list(arg_system_param_categories_id, arg_value)
      result = SystemParam.where("value = ? and system_param_categories_id = ? ",arg_value.to_s,arg_system_param_categories_id)
      if result.present?
         result = result.first.key
      else
         result = nil
      end
      return result
    end

  # def self.value_item_list(arg_system_param_categories_id,description)
  #   where("system_param_categories_id = ?", arg_system_param_categories_id).order ("value")
  # end

  # def self.get_description_from_key_and_value(arg_key, arg_value)
  #   where("key = ? and value = ?",arg_key, arg_value)
  # end

  def self.tea_bonus_close_reason_present?(arg_close_reason)
    ls_close_reason = arg_close_reason.to_s
    close_reason_collection = SystemParam.where("system_param_categories_id = 9 and key='TEA_BONUS_CLOSE_REASONS' and value=?",ls_close_reason)
    if close_reason_collection.present?
      return true
    else
      return false
    end
  end

  def self.get_barrier_id_for_given_activity_type(arg_activity_id, arg_client_id)
    # param_values_list(20,"Employment Action Barrier Mapped to Activity Type").where("value = ?",arg_activity_id).first.key.to_i
    # where("system_param_categories_id in (20,21,22,23)").order("CAST(value AS integer) ASC").where("value = ?",arg_activity_id).first.key.to_i
    barrier_id = nil
    if arg_activity_id.to_i == 6770 # "Job Readiness"
      barrier_id = AssessmentService.get_barrier_id_for_the_client(arg_client_id)
    else
      step1 = joins("INNER JOIN assessment_barriers ON assessment_barriers.barrier_id::text = system_params.key
                   INNER JOIN client_assessments ON client_assessments.id = assessment_barriers.client_assessment_id
                   INNER JOIN barriers ON assessment_barriers.barrier_id = barriers.id")
      step2 = step1.where("client_assessments.client_id = ?
                           and system_param_categories_id in (20,21,22,23)",arg_client_id).order("CAST(value AS integer) ASC")
      barrier_id = step2.where("value = ?",arg_activity_id).first.key.to_i
    end
    return barrier_id
  end

  def self.get_component_type_for_given_activity_type(arg_activity_id, arg_component_type)
    # param_values_list(16,"action/service mappings to federal components").where("key = ?",arg_activity_id).first.value.to_i
    step1 = joins("INNER JOIN codetable_items ON codetable_items.id::text = system_params.value")
    step1.where("system_params.system_param_categories_id = 16 and codetable_items.code_table_id = ? and system_params.key = ?",arg_component_type, arg_activity_id).first.value.to_i
  end

  def self.get_possbible_activity_types_from_barriers_associated_with_client(arg_client_id)
      step1 = joins("INNER JOIN assessment_barriers ON assessment_barriers.barrier_id::text = system_params.key
                   INNER JOIN client_assessments ON client_assessments.id = assessment_barriers.client_assessment_id
                   INNER JOIN barriers ON assessment_barriers.barrier_id = barriers.id")
      step2 = step1.where("client_assessments.client_id = ?
                           and system_param_categories_id in (20,21,22,23)",arg_client_id)
      step2.select("distinct system_params.value::int")
    # where("system_param_categories_id in (20,21,22,23)").where("key::int in (?)",arg_barriers).select("distinct value::int ")
  end
end
