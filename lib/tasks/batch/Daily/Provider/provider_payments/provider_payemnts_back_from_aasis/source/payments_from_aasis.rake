task :update_invoice_after_aasis_payment => :environment do
    batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
    log_filename = "batch_results/daily/Provider/provider_payments/provider_payemnts_back_from_aasis/results/wise_log_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
    file = File.open('batch_results/daily/Provider/provider_payments/provider_payemnts_back_from_aasis/inbound/payments_from_aasis.txt', 'r')
    log_path = File.join(Rails.root, log_filename )
    log_file = File.new(log_path,"w+")
    ls_error = 0
    ls_write = 0
    ls_read  = 0
    file.each_line do |line|
        ls_read = ls_read + 1
        ls_wise = line[0,4]
        if ls_wise == 'WISE'
            ls_invoice_id = line[4,12]
            ls_payment_id = line[16,12]
            payment = PaymentLineItem.where(id: ls_payment_id).first
            invoice = ProviderInvoice.where(id: ls_invoice_id).first
            if payment.present? && invoice.present?
                ls_warrant_num = line[82,13]
                ls_aasis_pay_date = line[95,8].to_date
                ls_new_payment_status = 6193
                PaymentLineItem.update_return_payment(ls_payment_id, ls_warrant_num, ls_aasis_pay_date, ls_new_payment_status)
                ls_invoice_status = 6184
                ProviderInvoice.update_new_status(ls_invoice_id, ls_invoice_status)
                ls_new_serv_auth_status = 6171
                ServiceAuthorizationLineItem.update_line_items_status(ls_invoice_id, ls_new_serv_auth_status)
                # close work task
                arg_object = CommonEventManagementArgumentsStruct.new
                arg_object.provider_invoice_id = invoice.id
                arg_event_to_action_mapping_object = EventToActionsMapping.new
                arg_event_to_action_mapping_object.task_type = 2144
                WorkTaskService.complete_work_task(arg_object,arg_event_to_action_mapping_object)

                # if found delete from queue
                arg_object = CommonEventManagementArgumentsStruct.new
                arg_object.queue_reference_type = 6383
                arg_object.queue_reference_id = invoice.id
                arg_event_to_action_mapping_object = EventToActionsMapping.new
                arg_event_to_action_mapping_object.queue_type = 6653
                QueueService.delete_queue(arg_object,arg_event_to_action_mapping_object)


                ls_write = ls_write + 1
            else
                log_record = 'Payment not found for:  ' + line.to_s
                ls_error = ls_error + 1
                log_file.puts(log_record)
            end
        else
            log_record = 'Not WISE payment:       ' + line.to_s
            ls_error = ls_error + 1
            log_file.puts(log_record)
        end
    end
    if ls_read == 0
        log_record = 'No payment from AASIS '
        log_file.puts(log_record)
    end
    log_record = 'Number of records read: ' + ls_read.to_s
    log_file.puts(log_record)
    log_record = 'Number of invoice records updated: ' + ls_write.to_s
    log_file.puts(log_record)
    log_record = 'Number of error records written: ' + ls_error.to_s
    log_file.puts(log_record)
    log_file.close
    file.close
end