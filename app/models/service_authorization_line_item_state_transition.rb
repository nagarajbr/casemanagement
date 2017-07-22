class ServiceAuthorizationLineItemStateTransition < ActiveRecord::Base
  belongs_to :service_authorization_line_item
  def self.get_latest_transition_record(arg_service_authorization_line_item_id)
  	where("service_authorization_line_item_id = ?",arg_service_authorization_line_item_id).order("created_at DESC").first
  end
end
