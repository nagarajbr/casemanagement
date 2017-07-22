class AlterEmployersTable1 < ActiveRecord::Migration
  def change
  	change_column :employers, :federal_ein, :integer, null:true
  	change_column :employers, :employer_name, :string, null:true
  	change_column :employers, :employer_address_line1, :string, null:true
  	change_column :employers, :employer_city, :string, null:true
  	change_column :employers, :employer_state, :integer, null:true
  	change_column :employers, :employer_postal_code, :integer, null:true
  	rename_column :employers, :optinal_address_line1, :optional_employer_address_line1
  	rename_column :employers, :optinal_employer_address_line2, :optional_employer_address_line2
  	rename_column :employers, :optinal_employer_address_line3, :optional_employer_address_line3
  	rename_column :employers, :optinal_employer_city, :optional_employer_city
  	rename_column :employers, :optinal_employer_state, :optional_employer_state
  	rename_column :employers, :optinal_employer_postal_code, :optional_employer_postal_code
  	rename_column :employers, :optinal_employer_zip_4, :optional_employer_zip_4
  	rename_column :employers, :optinal_employer_country_code, :optional_employer_country_code
  	rename_column :employers, :employer_optional_hone_number, :employer_optional_home_number
    change_column :employers, :employer_phone_number, :string, limit: 10
    change_column :employers, :employer_optional_home_number, :string, limit: 10
  end
end
