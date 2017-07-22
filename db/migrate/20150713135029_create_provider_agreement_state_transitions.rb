class CreateProviderAgreementStateTransitions < ActiveRecord::Migration
  def change
    create_table :provider_agreement_state_transitions do |t|
      # t.references :provider_agreement, index: true
      t.integer :provider_agreement_id
      t.string :namespace
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
        add_index(:provider_agreement_state_transitions, :provider_agreement_id, name: "index_prvdr_agrmnt_id_st_trns")
  end
end
