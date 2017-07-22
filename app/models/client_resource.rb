class ClientResource < ActiveRecord::Base
has_paper_trail :class_name => 'ClientResourceVersion',:on => [:update, :destroy]

  include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field
  after_create :set_resource_step_as_incomplete

  belongs_to :client
  belongs_to :resource

  def set_create_user_fields
    user_id = AuditModule.get_current_user.uid
    self.created_by = user_id
    self.updated_by = user_id
  end

  def set_update_user_field
    user_id = AuditModule.get_current_user.uid
    self.updated_by = user_id
  end

  def self.clients_sharing_resource(arg_resource_id,arg_client_id)
    Client.joins(:client_resources).where("resource_id = ? and client_id <> ?",arg_resource_id,arg_client_id)
  end

   # Manoj - 10/01/2014
  # Resource for Benefit members
  def self.get_benefit_members_resources(arg_program_wizard_id,arg_run_month)
    step1 = ClientResource.joins("INNER JOIN resources ON client_resources.resource_id = resources.id
                                  INNER JOIN program_benefit_members ON client_resources.client_id = program_benefit_members.client_id
                                  INNER JOIN resource_details ON resource_details.resource_id = resources.id")
    step2 = step1.where("program_benefit_members.program_wizard_id = ?",arg_program_wizard_id)
    step3 = step2.where(" (
                            ( ? >= resources.date_assert_acquired AND resources.date_assert_disposed is null)
                            OR
                            (? BETWEEN  resources.date_assert_acquired AND resources.date_assert_disposed)
                            )",arg_run_month,arg_run_month
                        )

    step4 = step3.select("client_resources.client_id,
                         resources.resource_type,
                         resource_details.resource_value,
                         resource_details.resource_valued_date")
    benefit_member_resource_collection = step4
    return benefit_member_resource_collection
  end

  def self.get_resource_details_for_a_client(arg_client_id,arg_rule_id,arg_first_of_budget_month,arg_end_of_budget_month)
    step1 = joins("INNER JOIN resources ON resources.id = client_resources.resource_id
                   INNER JOIN rule_details ON rule_details.codetable_items_id = resources.resource_type
                   INNER JOIN resource_details ON resources.id = resource_details.resource_id")
    step2 = step1.where("client_resources.client_id in(?)
                         AND rule_details.rule_id= ?
                         AND rule_details.code_table_id = 34
                         AND (resources.date_assert_acquired <= ?  OR  resources.date_assert_acquired IS NULL)
                         AND (resources.date_assert_disposed >= ? OR resources.date_assert_disposed IS NULL)
                         AND resource_details.id = (select a.id from resource_details a where a.resource_id = resources.id order by resource_valued_date desc limit 1)", arg_client_id, arg_rule_id, arg_end_of_budget_month, arg_first_of_budget_month)
    step3 = step2.select("resources.id,
                resources.resource_type,
                resource_details.resource_value,
                resource_details.id as resource_details_id,
                resource_details.resource_valued_date,
                resource_details.first_of_month_value,
                resource_details.res_value_basis,
                resource_details.res_ins_face_value,
                resource_details.amount_owned_on_resource,
                rule_details.rule_id,
                client_resources.client_id,
                resources.number_of_owners")
  end

  def self.get_resource_vehicle_details_for_clients(arg_client_id,arg_first_of_budget_month,arg_end_of_budget_month)
    Rails.logger.debug("arg_first_of_budget_month#{arg_first_of_budget_month}")
    Rails.logger.debug("arg_end_of_budget_month#{arg_end_of_budget_month}")
    step1 = joins("INNER JOIN resources ON resources.id = client_resources.resource_id and resources.resource_type in (2446,2494,2429)
                   INNER JOIN resource_details ON resources.id = resource_details.resource_id")
    step2 = step1.where("client_resources.client_id in ( ? )
                         AND (resources.date_assert_acquired <= ?  OR  resources.date_assert_acquired IS NULL)
                         AND (resources.date_assert_disposed >= ? OR resources.date_assert_disposed IS NULL)
                         AND resource_details.id = (select a.id from resource_details a
                                                    where a.resource_id = resources.id and resource_valued_date <= ?
                                                    order by resource_valued_date desc limit 1)", arg_client_id,arg_first_of_budget_month, arg_end_of_budget_month,arg_end_of_budget_month)
    step3 = step2.select("resources.id,
                resources.resource_type,
                resource_details.resource_value,
                resource_details.id as resource_detail_id,
                resource_details.resource_valued_date,
                resource_details.first_of_month_value,
                resource_details.res_value_basis,
                resource_details.res_ins_face_value,
                resource_details.amount_owned_on_resource,
                client_resources.client_id,
                resources.number_of_owners").order("resource_details.first_of_month_value desc")
  end



def self.get_resource_burial_details_for_a_client(arg_client_id,arg_end_of_budget_month,arg_first_of_budget_month)
    step1 = joins("INNER JOIN resources ON resources.id = client_resources.resource_id and resources.resource_type in (2449)
                   INNER JOIN resource_details ON resources.id = resource_details.resource_id")
    step2 = step1.where("client_resources.client_id in (?)
                         AND (resources.date_assert_acquired <= ?  OR  resources.date_assert_acquired IS NULL)
                         AND (resources.date_assert_disposed >= ? OR resources.date_assert_disposed IS NULL)
                         AND resource_details.id = (select a.id from resource_details a
                                                    where a.resource_id = resources.id and resource_valued_date <= ?
                                                    order by first_of_month_value desc limit 1)", arg_client_id, arg_end_of_budget_month, arg_first_of_budget_month,arg_end_of_budget_month)
    step3 = step2.select("resources.id,
                resources.resource_type,
                resource_details.resource_value,
                resource_details.id as resource_detail_id,
                resource_details.resource_valued_date,
                resource_details.first_of_month_value,
                resource_details.res_value_basis,
                resource_details.res_ins_face_value,
                resource_details.amount_owned_on_resource,
                client_resources.client_id,
                resources.number_of_owners").order("resource_details.first_of_month_value desc")
  end

  def set_resource_step_as_incomplete
    resource_object = Resource.find(self.resource_id)

      HouseholdMemberStepStatus.update_one_step_for_client_given_step_partial(self.client_id,'household_member_resources_step','I')

  end





end
