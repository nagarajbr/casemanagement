class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
    t.string  :provider_name
	t.integer :provider_type
	t.string  :contact_person
    t.string  :provider_physical_address_line1, null:false
	t.string  :provider_physical_address_line2
	t.string  :provider_physical_address_line3
	t.string  :provider_physical_city, null:false
	t.integer :provider_physical_state, null:false
	t.integer :provider_physical_postal_code, null:false
	t.integer :provider_physical_zip_4
    t.string  :provider_mailing_address_line1, null:false
    t.string  :provider_mailing_address_line2
    t.string  :provider_mailing_address_line3
    t.string  :provider_mailing_city, null:false
    t.integer :provider_mailing_state, null:false
    t.integer :provider_mailing_postal_code, null:false
    t.integer :provider_mailing_zip_4
	t.integer :provider_country_code
	t.integer :provider_phone_number
	t.integer :provider_phone_extension
    t.integer :classification
    t.string  :license_number
    t.date    :license_expire_dt
    t.string  :tax_id_ssn
    t.string  :email_address
    t.string  :web_address
    t.integer :created_by , null:false
	t.integer :updated_by , null:false
    t.timestamps
    end
  end
end
