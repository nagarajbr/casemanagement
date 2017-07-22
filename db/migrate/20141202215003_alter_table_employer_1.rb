class AlterTableEmployer1 < ActiveRecord::Migration
  def up
  	remove_column :employers, :employer_address_line1
  	remove_column :employers, :employer_address_line2
  	remove_column :employers, :employer_address_line3
  	remove_column :employers, :employer_city
  	remove_column :employers, :employer_state
  	remove_column :employers, :employer_postal_code
  	remove_column :employers, :employer_zip_4
  	remove_column :employers, :employer_phone_number
  	remove_column :employers, :employer_phone_extension
  	remove_column :employers, :optional_employer_address_line1
  	remove_column :employers, :optional_employer_address_line2
  	remove_column :employers, :optional_employer_address_line3
  	remove_column :employers, :optional_employer_city
  	remove_column :employers, :optional_employer_state
  	remove_column :employers, :optional_employer_postal_code
  	remove_column :employers, :optional_employer_zip_4
  	remove_column :employers, :optional_employer_country_code
  	remove_column :employers, :employer_optional_home_number
  	remove_column :employers, :employer_optional_contact_extension


  end
end

