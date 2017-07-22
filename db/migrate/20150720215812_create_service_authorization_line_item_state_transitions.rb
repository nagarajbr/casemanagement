class CreateServiceAuthorizationLineItemStateTransitions < ActiveRecord::Migration
  def change
    create_table :service_authorization_line_item_state_transitions do |t|
      # t.references :service_authorization_line_item, index: true
      t.integer :service_authorization_line_item_id
      t.string :namespace
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
      t.integer :created_by
      t.string :reason
    end
    add_index(:service_authorization_line_item_state_transitions, :service_authorization_line_item_id, name: "index_servc_auth_line_item_id_st_trns")
  end
end
