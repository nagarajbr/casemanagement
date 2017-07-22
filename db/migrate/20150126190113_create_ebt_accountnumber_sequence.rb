class CreateEbtAccountnumberSequence < ActiveRecord::Migration
  def change
     execute "CREATE SEQUENCE ebt_account_number_seq"
  end
end
