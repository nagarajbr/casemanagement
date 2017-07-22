class PseudoSsnSequence < ActiveRecord::Migration


 def up
    execute "CREATE SEQUENCE ssn_seq INCREMENT 1 MINVALUE 900100001 START 900100008"
  end


end
