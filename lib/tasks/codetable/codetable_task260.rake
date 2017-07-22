namespace :populate_codetable260 do
desc "SSN Enumeration which cannot be selected made inactive  "
task :ssn_enumeration_status_inactive => :environment do
   CodetableItem.where("id in (4354,4353,4351,4350,4349,4348,4347,4346,4345)").update_all(active:"FALSE")

end
end
