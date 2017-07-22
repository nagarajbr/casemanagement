class AlterClientAddQuestionFields < ActiveRecord::Migration
  def change
  	add_column :clients, :felon_flag, "char(1)"
  	add_column :clients, :rcvd_tea_out_of_state_flag, "char(1)"
  	add_column :clients, :register_to_vote_flag, "char(1)"
  end
end
