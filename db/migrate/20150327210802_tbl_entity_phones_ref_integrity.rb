class TblEntityPhonesRefIntegrity < ActiveRecord::Migration
  def change
  	execute <<-SQL
    	ALTER TABLE entity_phones
		ADD CONSTRAINT entity_phones_phone_id_fkey
		    FOREIGN KEY (phone_id)
		    REFERENCES phones(id);
     SQL

       execute <<-SQL
      	CREATE INDEX index_entity_phones_on_phone_id
		  ON entity_phones
		  USING btree
		  (phone_id);
      SQL


  end
end
