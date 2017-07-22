class ProviderAgreementStateTransition < ActiveRecord::Base
  belongs_to :provider_agreement

	  def self.get_latest_transition_record(arg_provider_agreement_id)
	  	where("provider_agreement_id = ?",arg_provider_agreement_id).order("created_at DESC").first
	  end
end
