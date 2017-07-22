class ProviderInvoiceStateTransition < ActiveRecord::Base
  belongs_to :provider_invoice
  def self.get_latest_transition_record(arg_provider_invoice_id)
  	where("provider_invoice_id = ?",arg_provider_invoice_id).order("created_at DESC").first
  end
end
