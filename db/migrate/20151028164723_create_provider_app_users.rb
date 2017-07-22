class CreateProviderAppUsers < ActiveRecord::Migration
  def change
    create_table :provider_app_users do |t|
    	t.string    :name , lenght:50
		t.string    :email
		t.string    :uid, :string
		t.string    :organisation_slug
		t.string    :organisation_content_id
		t.string   :permissions, array:true
		t.boolean   :remotely_signed_out, :default => "N"
		t.boolean   :disabled, :default => "N"
		t.string    :created_by
		t.string   :updated_by
        t.timestamps
    end
  end
end
