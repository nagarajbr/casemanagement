class ApplicationAccessRights < ActiveRecord::Migration
  def change
    create_table :application_access_rights do |t|
      t.integer :application_id
      t.integer :ruby_element_id
      t.string  :access, limit: 2
      t.timestamp :created_at
      t.timestamp :updated_at

    end
  end
end
