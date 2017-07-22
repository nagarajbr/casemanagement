class ClientRace < ActiveRecord::Base
  has_paper_trail :class_name => 'ClientRaceVersion',:on => [:create,:destroy]
	include AuditModule
  before_create :set_create_user_fields
  before_update :set_update_user_field
  belongs_to :client
  belongs_to :race

  # Model Validations .

  validates_presence_of :race

  def set_create_user_fields
    user_id = AuditModule.get_current_user.uid
    self.created_by = user_id
    self.updated_by = user_id
  end

  def set_update_user_field
    user_id = AuditModule.get_current_user.uid
    self.updated_by = user_id
  end

  def self.get_client_races(arg_client_id)
    where("client_id = ?",arg_client_id)
  end

  def self.has_race(arg_client_id)
    get_client_races(arg_client_id).count > 0
  end

end
