class CreateAccessRights < ActiveRecord::Migration
  def change
    create_table :access_rights do |t|
      t.references :role, index: true
      t.references :ruby_element, index: true
      t.string :access

      t.timestamps
    end
  end
end
