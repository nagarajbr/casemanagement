class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
    t.integer 			:federal_ein , null:false
    t.integer 			:state_ein
    t.string  			:employer_name, null:false
	t.string			:employer_address_line1, null:false
	t.string			:employer_address_line2
	t.string			:employer_address_line3
	t.string			:employer_city, null:false
	t.integer			:employer_state, null:false
	t.integer			:employer_postal_code, null:false
	t.integer			:employer_zip_4
	t.integer			:employer_country_code
	t.integer			:employer_phone_number
	t.integer			:employer_phone_extension
	t.string			:employer_contact
	t.string			:optinal_address_line1
	t.string			:optinal_employer_address_line2
	t.string			:optinal_employer_address_line3
	t.string			:optinal_employer_city
	t.integer			:optinal_employer_state
	t.integer			:optinal_employer_postal_code
	t.integer			:optinal_employer_zip_4
	t.integer			:optinal_employer_country_code
	t.integer			:employer_optional_hone_number
	t.integer			:employer_optional_contact_extension
	t.string			:employer_optional_contact
    t.integer 			:created_by , null:false
	t.integer 			:updated_by , null:false
    t.timestamps
    end
  end
end
