task :update_providers_from_aasis_after_verification => :environment do
    log_filename = "lib/tasks/batch/Daily/provider/provider_management/provider_back_from_aasis/results/wisevend0711_log_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
    file = File.open('lib/tasks/batch/Daily/provider/provider_management/provider_back_from_aasis/inbound/providers_from_aasis.txt')
    batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
    log_path = File.join(Rails.root, log_filename )
    log_file = File.new(log_path,"w+")
    ls_error = 0
    ls_write = 0
    ls_read  = 0
    log_record = 'Begin provider verification from AASIS'
    log_file.puts(log_record)
    file.each_line do |line|
        ls_read = ls_read + 1
        batchid = line[4,8]
        if (line.include? "already exists")
                batchstatus = 6156.to_s
            elsif (line[12..-1]).blank? == true
                batchstatus = 6156.to_s
            else
                batchnotes = (line[12..-1])
                batchstatus = 6174.to_s
        end
        provider_collection = Provider.get_provider_information_from_id(batchid).first
        if provider_collection.present?
            Provider.where(id: batchid).update_all(status: batchstatus, notes: batchnotes )
            ls_write = ls_write + 1
            puts batchid + batchstatus
        else
            log_record = 'Provider not found: ' + batchid.to_s
            log_file.puts(log_record)
            ls_error = ls_error + 1
        end
    end
    if ls_read == 0
        log_record = 'No verification from AASIS '
        log_file.puts(log_record)
    end
    log_record = 'Number of records read: ' + ls_read.to_s
    log_file.puts(log_record)
    log_record = 'Number of records updated: ' + ls_write.to_s
    log_file.puts(log_record)
    log_record = 'Number of error records written: ' + ls_error.to_s
    log_file.puts(log_record)
    log_record = 'End provider verification from AASIS'
    log_file.puts(log_record)
    log_file.close
    file.close
end










