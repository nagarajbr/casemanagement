class Members
  include ActiveModel::Model

  attr_accessor :client_id, :member_status,:member_sequence,:dob

  def self.generate_members_list(arg_family_struct)
    members_list = arg_family_struct.members
  	members = []
    i = 0
  	members_list.each do |client_id|
  		# unless Client.date_of_death_present(client_id)
    #     status = nil
    #     if Client.is_adult(client_id)
    #       arg_family_struct.adults_struct.each do |adult|
    #         if (adult.parent_id.present? && adult.parent_id == client_id) || (adult.caretaker_id.present? && adult.caretaker_id == client_id)
    #           status = adult.status
    #         end
    #       end
    #     else
    #       status = 4468
    #     end
    #     if status.present?# && status != 4471
    #       i += 1
    #       client = Client.find(client_id)
    #       members << Members.new(client_id: "#{client.id}", member_status: "#{status}", member_sequence: "#{i}", dob: "#{client.dob}")
    #     end
  		# end
      client = Client.find(client_id)
      members << Members.new(client_id: "#{client.id}", member_status: "#{arg_family_struct.member_status[client_id]}", member_sequence: "#{i}", dob: "#{client.dob}") if arg_family_struct.member_status[client_id] != 4471
  	end
  	return members
  end

end