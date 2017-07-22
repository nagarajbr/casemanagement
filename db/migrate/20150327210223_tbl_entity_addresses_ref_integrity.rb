class TblEntityAddressesRefIntegrity < ActiveRecord::Migration
  def change
  	 execute <<-SQL
    	ALTER TABLE entity_addresses
		ADD CONSTRAINT entity_addresses_address_id_fkey
		    FOREIGN KEY (address_id)
		    REFERENCES addresses(id);
     SQL

      execute <<-SQL
      	CREATE INDEX index_entity_addresses_on_address_id
		  ON entity_addresses
		  USING btree
		  (address_id);
      SQL


  end
end
