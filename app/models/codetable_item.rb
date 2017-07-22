class CodetableItem < ActiveRecord::Base
has_paper_trail :class_name => 'CodetableItemVersion',:on => [:update, :destroy]

  belongs_to :code_table

  def self.item_list (code_table_id,description)

  	where("code_table_id = ?", code_table_id ).order ("sort_order, short_description")

  end

 def self.item_list_id (code_table_id,description)

    where("code_table_id = ?", code_table_id ).order ("id")

  end


 def self.items_to_exclude (code_table_id,id,description)
     where("code_table_id = ? and id not in (?) ", code_table_id,id ).order ("short_description")
 end

  # def self.get_inactive_item_list(code_table_id,description)
  #   where("code_table_id = ? and active = false", code_table_id).select(:id)
  # end
  def self.get_code_table_values_by_system_params_and_code_table_id(arg_key,arg_code_table_id)
      step1 = joins("inner join system_params on cast(system_params.value as integer ) = codetable_items.id ")
      step2 = step1.where("system_params.system_param_categories_id = 9  and system_params.key = ? and codetable_items.code_table_id = ? ",arg_key,arg_code_table_id).order ("short_description")
      # step3 = step2.select("codetable_items.*")

  end


 def self.items_to_include (code_table_id,id,description)
     where("code_table_id = ? and id in (?) ", code_table_id,id ).order ("short_description")
 end

  def self.races(code_table_id,description)
  	item_list(code_table_id,description).where("id in(443,439,485,440,486,480)")
  end

  def self.get_short_description (id)
    if id.present?
      where("id = ? ", id ).select("short_description").first.short_description
    end
  end

  def self.get_long_description (id)
    if id.present?
      find(id).long_description
    end
  end

  def self.item_description (code_table_id,id,description)
    if code_table_id.present? && id.present?
      step1 = where("code_table_id = ? and id = ? ", code_table_id,id )
      if step1.present?
        step2 = step1.first.short_description
      else
         ' '
      end
      # where("code_table_id = ? and id = ? ", code_table_id,id ).select(:short_description).first.short_description
    else
      ' '
    end
  end

  # def self.get_child_status_ids
  #   where("code_table_id = 125 and lower(short_description) like '%child%'").select("id")
  # end

  def self.get_all_states_except_arkansas(code_table_id,description)
    where("code_table_id = ? and id != 5793", code_table_id ).order ("short_description")
  end

  # manoj 10/19/2014
  # def self.get_prescreen_household_questions()
  #   where("code_table_id in (137,139,140,142)").order("code_table_id,id")
  # end

  # def self.item_list_sorted_by_id (code_table_id,description)
  #   where("code_table_id = ?", code_table_id ).order ("id")
  # end

  def self.get_client_application_questions()
     where("code_table_id = 146").order("id ASC")
  end

  def self.active_item_list (code_table_id,description)
    where("code_table_id = ? and active = 't'", code_table_id ).order ("short_description")
  end

  def self.item_list_order_by_id(code_table_id,description)
    where("code_table_id = ?", code_table_id ).order ("id")
  end

  def self.items_to_include_order_by_id(code_table_id,id,description)
     where("code_table_id = ? and id in (?) ", code_table_id,id ).order ("id")
  end


  def self.get_sanction_indicator_values(arg_sanction_type,arg_service_program_id)


    system_param_collection = SystemParam.get_key_value_list(19,arg_sanction_type.to_s,"Mapping of Sanction Implication to Sanction Type")
    if system_param_collection.present?
        if arg_sanction_type == 3064 || arg_sanction_type == 3070 || arg_sanction_type == 3073 || arg_sanction_type == 3068 ||arg_sanction_type == 3067 || arg_sanction_type == 3085
          if arg_service_program_id == 4
              # system param values
               where("id in (select cast(a.value as integer) from system_params a where a.system_param_categories_id = 19 and cast(a.key as integer) =?) ",arg_sanction_type).order("id")
          else
             where("code_table_id = 149").order ("id")
          end
        else
          # system param values
           # system param values
               where("id in (select cast(a.value as integer) from system_params a where a.system_param_categories_id = 19 and cast(a.key as integer) =? )",arg_sanction_type).order("id")
        end

    else
       where("code_table_id = 149").order ("id")
    end
  end



  def get_flag_value_description_assessment(arg_flag)

    if arg_flag.present?
      case arg_flag
      when "Y"
        ls_out = "Yes"
      when "N"
        ls_out = "No"
      when "on"
        ls_out = "Yes"
      else
        ls_out = arg_flag
      end
    else
      ls_out = " "
    end
    return ls_out
  end

  def self.get_code_table_id(agr_id)
    find(agr_id).code_table_id
  end

  # def self.get_activity_types_for_barrier_reduction_plan_actions
  #   step1 = joins("INNER JOIN system_params ON CAST(system_params.value AS integer) = codetable_items.id")
  #   step2 = step1.where("system_params.key = 'BARRIER_REDUCTION_PLAN_ACTIONS'")
  # end

  # def self.get_activity_types_for_barrier_reduction_plan_services
  #   step1 = joins("INNER JOIN system_params ON CAST(system_params.value AS integer) = codetable_items.id")
  #   step2 = step1.where("system_params.key = 'BARRIER_REDUCTION_PLAN_SERVICES'")
  # end

  # def self.get_activity_types_for_employment_plan_actions
  #   step1 = joins("INNER JOIN system_params ON CAST(system_params.value AS integer) = codetable_items.id")
  #   step2 = step1.where("system_params.key = 'EMPLOYMENT_PLAN_ACTIONS'")
  # end

  # def self.get_activity_types_for_employment_plan_services
  #   step1 = joins("INNER JOIN system_params ON CAST(system_params.value AS integer) = codetable_items.id")
  #   step2 = step1.where("system_params.key = 'EMPLOYMENT_PLAN_SERVICES'")
  # end

  def self.get_benefit_reducing_sanction_types
    step1 = CodetableItem.joins("INNER JOIN system_params
                                  ON ( CAST(system_params.value AS integer) = codetable_items.id
                                       AND system_params.system_param_categories_id = 9
                                       AND system_params.key = 'BENEFIT_REDUCING_SANCTIONS'
                                     )
                               ")
    sanction_type_list = step1.order("short_description ASC")
    return sanction_type_list
  end

  # def self.item_list_and_long_description(code_table_id,arg_client_id,description)
  #   where("codetable_items.id  in (6527,6528,6529) and codetable_items.id not in  (select codetable_items.id from codetable_items inner join notes on codetable_items.id = notes.notes_type
  #           where( codetable_items.id  in (6527,6528,6529) and codetable_items.code_table_id = ? and notes.entity_type = 6150 and notes.entity_id = ? ))", code_table_id,arg_client_id ).order ("short_description")

  # end

  def self.get_code_table_values_by_system_params(arg_key)
      step1 = joins("inner join system_params on cast(system_params.value as integer ) = codetable_items.id ")
      step2 = step1.where("system_params.system_param_categories_id = 9  and system_params.key = ?",arg_key).order ("short_description")
      # step3 = step2.select("codetable_items.*")

  end

  def self.get_codetable_items_id(arg_code_table_id, arg_short_description)
      # Pass code_table_id and short_description get codetable_items id
      where("code_table_id = ? and short_description = ?",arg_code_table_id,arg_short_description)
  end

  def self.get_code_table_item_object(arg_code_table_id)
      current_application_id = Intake::Application::CURRENT_APP_ID
      step1 = ApplicationAccessRight.joins("Inner Join ruby_elements
                                                   on (application_access_rights.ruby_element_id = ruby_elements.id
                                                       and application_access_rights.access = 'Y')
                                            Inner Join codetable_items
                                                    on codetable_items.id = CAST(coalesce(ruby_elements.element_name, '0') AS integer) ")
      step2 = step1.where("application_access_rights.application_id =? ",current_application_id)
      step3 = step2.select("codetable_items.*")
      if step3.present?
         result = step3.where("code_table_id = ?",arg_code_table_id)
      end
      return result
  end

  def self.item_list_related_to_notes
    where("codetable_items.id  in (6527,6528,6529)")
  end

  def self.get_city_and_state_code_table_item_ids(arg_address_hash)
    result = nil
    # arg_city = arg_address_hash["City"].strip
    arg_state = arg_address_hash["State"].strip
    # city = get_code_table_item_id(arg_city, 10)
    state = get_code_table_item_id(arg_state, 104)
    if state.present? # && city.present?
      result = {}
      # result[:city] = city
      result[:state] = state
    end
    return result
  end

  def self.get_code_table_item_id(arg_short_description, arg_code_table_id)
    result = nil
    result = where("trim(upper(short_description)) = ? and code_table_id = ?",arg_short_description, arg_code_table_id) if arg_short_description.present?
    result = result.first.id if result.present?
    return result
  end

  def self.get_activity_types_associated_with_component_type(arg_component_type, arg_client_id,arg_program_unit_id)
    result = nil
     # Get employmnet goal for the client
    action_plan = ActionPlan.get_open_action_plan_for_client(arg_client_id)
    employment_goal = action_plan.short_term_goal if action_plan.present?

    if employment_goal == 6767
      result = where("codetable_items.id = 6317")
    else
        activity_types = SystemParam.get_possbible_activity_types_from_barriers_associated_with_client(arg_client_id)
        # Filter Activities only that has providers
        activity_types_with_providers = Provider.get_activity_types_that_have_only_valid_providers(activity_types,arg_program_unit_id,employment_goal)

        if activity_types.present?
          step1 = joins("INNER JOIN system_params ON codetable_items.id::text = system_params.value")
          step2 = step1.where("system_params.system_param_categories_id = 16 and codetable_items.code_table_id = ?",arg_component_type)
          step2 = step2.where("codetable_items.id != 6358") if arg_component_type == 174
          keys = step2.select("system_params.key::int")

          #result = where("code_table_id in (181,182) ").where("id in (?)", keys).where("id in (?)",activity_types)


           result1 = item_list(182,"Activity Type For Service").where("id in (?)", keys).where("id in (?)",activity_types_with_providers)
           result = result1 + item_list(181,"Activity Type For Action").where("id in (?)", keys).where("id in (?)",activity_types)
          #result.order("id desc") if result.present?
          # result = result.to_a.map{|x| x.id}
        else
          result = Array.new
        end
    end
    return result
  end

  def self.get_activity_types_associated_with_core_components(arg_client_id,arg_program_unit_id)
    get_activity_types_associated_with_component_type(173, arg_client_id,arg_program_unit_id)
  end

  def self.get_activity_types_associated_with_non_core_components(arg_client_id,arg_program_unit_id)
    get_activity_types_associated_with_component_type(174, arg_client_id,arg_program_unit_id)
  end

  def self.get_activity_types_associated_for_component_type(arg_component_type)
    step1 = joins("INNER JOIN system_params ON codetable_items.id::text = system_params.value")
    step2 = step1.where("system_params.system_param_categories_id = 16 and codetable_items.code_table_id = ?",arg_component_type)
    step2 = step2.where("codetable_items.id != 6358") if arg_component_type == 174
    keys = step2.select("system_params.key::int")
    # item_list(181,"Activity Type For Action").where("id in (?)", keys).select("id")
    where("code_table_id in (181,182)").order("sort_order, short_description").where("id in (?)", keys).select("id")
  end

  def self.get_activity_types_for_core_components
    get_activity_types_associated_for_component_type(173)
  end

  def self.get_activity_types_for_non_core_components
    get_activity_types_associated_for_component_type(174)
  end
end