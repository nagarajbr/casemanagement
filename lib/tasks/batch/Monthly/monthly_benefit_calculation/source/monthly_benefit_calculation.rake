task :monthly_benefit_calculation => :environment do


filename = 'batch_results/monthly/monthly_benefit_calculation/results/monthly_benefit_' + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
batch_user = User.where("uid = '555'").first
AuditModule.set_current_user=(batch_user)
path = File.join(Rails.root, filename)

# Create new file called 'filename.txt' at a specified path.
 my_file = File.new(path,"w+")

 clients = Client.get_clients_for_enumeration()
clients.each do |client|
      name = client.first_name + "\n"
       # Write text to the file.
      my_file.write(name)
		end
# Close the file.
my_file.close

end