class AlterProviderAgreementStateTransitions < ActiveRecord::Migration
  def change
  		add_column :provider_agreement_state_transitions, :created_by, :integer
  		add_column :provider_agreement_state_transitions, :reason, :string
  end
end
