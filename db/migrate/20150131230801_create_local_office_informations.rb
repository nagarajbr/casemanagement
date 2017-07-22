class CreateLocalOfficeInformations < ActiveRecord::Migration
  def change
    create_table :local_office_informations do |t|
      t.references :code_table_item, index: true
      t.text    :street_address1
      t.text    :street_address2
      t.integer :street_address_city
      t.integer :street_address_state
      t.text :street_address_zip, limit: 5
      t.text :street_address_zip_suffix, limit: 4
      t.text    :mailing_address1
      t.text    :mailing_address2
      t.integer :mailing_address_city
      t.integer :mailing_address_state
      t.text :mailing_address_zip, limit: 5
      t.text :mailing_address_zip_suffix, limit: 4
      t.text    :phone_number
      t.text    :fax_number
      t.integer :created_by , null:false
	  t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
