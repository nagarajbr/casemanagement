class CreateProviderInvoiceStateTransitions < ActiveRecord::Migration
  def change
    create_table :provider_invoice_state_transitions do |t|
      # t.references :provider_invoice, index: true
      t.integer :provider_invoice_id
      t.string :namespace
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
      t.integer :created_by
      t.string :reason
    end
    add_index(:provider_invoice_state_transitions, :provider_invoice_id, name: "index_provider_invoice_id_st_trns")
  end
end
