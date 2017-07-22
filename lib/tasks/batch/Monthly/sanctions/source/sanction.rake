
# /****                  PROGRAM DESCRIPTION                                  *
# * For all open TANF program units, If a program unit is currently open or   *
# * was closed in the month of batch run and had member(s) currently          *
# * sanctioned, a line for following month sanction should be added           *
# *  to sanction detail based on the sanction as per schedule.                                                                         *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *                                                                           *
# *  DATE OF WRITTEN     : 10-30-2015.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:                   Add sanction for the following month.     *
# *                                 This batch is scheduled to run end of     *
#                                   every month                               *
# *                                                                           *
# *                                                                           *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:             NONE                                      *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  NONE                                      *
# *                                                                           *
# *  ERROR FILES,LOG FILES         sanction_, log_sanction                    *
# *                                                                           *
# *                                                                           *
# *                                                                           *
# *****************************************************************************
task :sanctions_monthly => :environment do

# batch_user = User.find()
batch_user = User.where("uid = '555'").first
AuditModule.set_current_user = (batch_user)
filename = "batch_results/monthly/sanctions/results/sanction_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
log_filename = "batch_results/monthly/sanctions/results/log_sanction" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
path = File.join(Rails.root, filename)
log_path = File.join(Rails.root, log_filename)
# Create new file called 'filename.txt' at a specified path.
my_file = File.new(path,"w+")
log_file = File.new(log_path,"w+")

   count_to_add_sanctions_for_next_month = 0
   sanction_for_next_month_present = 0
   sanction_released_records = 0
   count_for_sanction_details_insert = 0
   count_for_sanction_served_update_fail = 0
   count_for_sanction_details_sanction_indicator_closed = 0
   count_for_sanction_details_insert_failed = 0
   no_sanction_details_present = 0

   step1 = Sanction.joins("inner join program_benefit_members d on sanctions.client_id = d.client_id
                           inner join program_wizards on program_wizards.run_id = d.run_id and program_wizards.month_sequence = d.month_sequence
                           inner join (select program_unit_id
                                     from program_unit_participations a
                                     where a.participation_status = 6043 and
                                     id = ( select max(id) from program_unit_participations where program_unit_id = a.program_unit_id)
                                  union
                                     select program_unit_id
                                     from program_unit_participations a
                                     where a.participation_status = 6044 and
                                     (Extract(month from action_date) = Extract(month from current_date)and  Extract(year from action_date) = Extract(year from current_date)) and
                                     id = ( select max(id) from program_unit_participations where program_unit_id = a.program_unit_id))  c
                                    on program_wizards.program_unit_id = c.program_unit_id")
    step2 = step1.where("program_wizards.run_id = ( select run_id
                       from program_wizards x
                       where program_wizards.program_unit_id = x.program_unit_id and x.submit_date is not null order by x.submit_date asc fetch first row only)
                       and ((Extract(month from sanctions.infraction_end_date) >= Extract(month from current_date) and  Extract(year from sanctions.infraction_end_date) = Extract(year from current_date))  or sanctions.infraction_end_date is null)")
    step3 = step2.select("distinct sanctions.*")

    sanction_collection = step3
    # Rails.logger.debug("sanction_collection = #{sanction_collection.inspect}")
    count_to_add_sanctions_for_next_month = sanction_collection.length
    sanction_collection.each do |sanction|
     # Rails.logger.debug("sanction**** = #{sanction.inspect}")
      @sanction_details = SanctionDetail.where("sanction_id = ?", sanction.id).order("sanction_month desc")
      @number_of_months = @sanction_details.length
        if @sanction_details.present?
           @next_month = Date.today.beginning_of_month + 1.month
           @sanction_detail =  @sanction_details.first
           # Rails.logger.debug("@next_month = #{@next_month.inspect}")
           # Rails.logger.debug("@sanction_detail.sanction_month = #{@sanction_detail.sanction_month.inspect}")
            # Rails.logger.debug("sanction_month = #{(@sanction_detail.sanction_month >= @next_month).inspect}")
           if @sanction_detail.sanction_month >= @next_month
            #we have sanction for future month
              sanction_for_next_month_present = sanction_for_next_month_present + 1

           else
              if (@sanction_detail.release_indicatior == "1")
                  sanction_released_records = sanction_released_records + 1
              else
                # if sanction details not present for next month and release indicator is not yes for current month  then update sanction_served to  yes for current month
                   if @sanction_detail.update_column(:sanction_served, "1")
                   else #if @sanction_detail.update_column(:sanction_served, "1")
                       count_for_sanction_served_update_fail = count_for_sanction_served_update_fail + 1
                       error = "For #{sanction.id} could not upated with sanction served for month -#{@sanction_detail.sanction_month}\n "
                       log_file.write(error)
                   end #if @sanction_detail.update_column(:sanction_served, "1")
                   #-------------------------------------------------------------------------------
               sanction = Sanction.find(@sanction_detail.sanction_id)
               if (@sanction_detail.sanction_indicator == 6114) #6114 -closed
                sanction = "sanction_details_sanction_indicator_closed = #{sanction.id},#{sanction.service_program_id},#{sanction.sanction_type}\n"
                my_file.write(sanction)
                count_for_sanction_details_sanction_indicator_closed = count_for_sanction_details_sanction_indicator_closed + 1
               else #if (@sanction_detail.sanction_indicator == 6114)
                @new_sanction_detail_object = SanctionDetail.new
                @new_sanction_detail_object.sanction_month = @next_month
                @new_sanction_detail_object.sanction_id = @sanction_detail.sanction_id
                @new_sanction_detail_object.release_indicatior = "0"
                @new_sanction_detail_object.sanction_served = "1"
                  if (sanction.sanction_type == 3081 || sanction.sanction_type == 3062 || sanction.sanction_type == 6349)
                     if SanctionDetail.where("sanction_id = ? and sanction_month = ?",sanction.id,@next_month).count > 0
                        sanction_for_next_month_present = sanction_for_next_month_present + 1
                     else
                      @new_sanction_detail_object.sanction_indicator = 6111
                          @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                          if @inserted_from_batch == "SUCCESS"
                             count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                             sanction = " sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                             my_file.write(sanction)
                          else
                            count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                            error = "sanction_details_error 1 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                            log_file.write(error)
                          end
                      end
                  elsif (sanction.service_program_id == 4 && (sanction.sanction_type == 3064 || sanction.sanction_type ==3070|| sanction.sanction_type ==3073||sanction.sanction_type ==3068||sanction.sanction_type ==3067||sanction.sanction_type ==3085))
                     if SanctionDetail.where("sanction_id = ? and sanction_month = ?",sanction.id,@next_month).count > 0
                        sanction_for_next_month_present = sanction_for_next_month_present + 1
                     else
                        case @number_of_months
                           when 1
                              if (SanctionDetail.where("sanction_id = ? and sanction_indicator = 6113", sanction.id ).count == 1)
                                  @new_sanction_detail_object.sanction_indicator = 6113
                                  @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                  if @inserted_from_batch == "SUCCESS"
                                     count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                     sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                     my_file.write(sanction)
                                  else
                                     count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                     error = "sanction_details_error 2 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                     log_file.write(error)
                                  end
                              end#(@sanctiondetails.where("sanction_indicator = 6113").count == 1)
                            when 2
                              if (SanctionDetail.where("sanction_id = ? and sanction_indicator = 6113",sanction.id).count == 2)
                                @new_sanction_detail_object.sanction_indicator = 6114
                                @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                if @inserted_from_batch == "SUCCESS"
                                   count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                   sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                   my_file.write(sanction)
                                else
                                   count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                   error = "sanction_details_error 3- For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                   log_file.write(error)
                                end
                              end#(@sanctiondetails.where("sanction_indicator = 6113").count == 2)
                        else# case @number_of_months

                        end # case @number_of_months
                    end#unless SanctionDetail.where("sanction_id = ? and sanction_month = ?",sanction.id,@next_month).count > 0
                  elsif (sanction.sanction_type == 6225)
                     if SanctionDetail.where("sanction_id = ? and sanction_month = ?",sanction.id,@next_month).count > 0
                        sanction_for_next_month_present = sanction_for_next_month_present + 1
                     else
                          case @number_of_months
                           when 1
                              if (SanctionDetail.where("sanction_id = ? and sanction_indicator = 6111",sanction.id ).count == 1)
                                @new_sanction_detail_object.sanction_indicator = 6111
                                @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                if @inserted_from_batch == "SUCCESS"
                                   count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                   sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                   my_file.write(sanction)
                                else
                                    count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                    error = "sanction_details_error 4 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                    log_file.write(error)
                                end
                              end
                           when 2
                              if (SanctionDetail.where("sanction_id = ? and sanction_indicator = 6111",sanction.id).count == 2)
                                 @new_sanction_detail_object.sanction_indicator = 6111
                                @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                if @inserted_from_batch == "SUCCESS"
                                   count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                   sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                   my_file.write(sanction)
                                else
                                     count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                     error = "sanction_details_error 5- For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                    log_file.write(error)
                                 end
                              end
                          else
                              if (SanctionDetail.where("sanction_id = ? and sanction_indicator = 6111",sanction.id).count >= 3)
                                 @new_sanction_detail_object.sanction_indicator = 6113
                                 @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                 if @inserted_from_batch == "SUCCESS"
                                   count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                   sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                   my_file.write(sanction)
                                 else
                                    count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                    error = "sanction_details_error 6 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                    log_file.write(error)
                                  end
                              end
                          end
                      end
                  else
                     if @number_of_months > 0
                        @indicator = @sanction_detail.sanction_indicator
                        if @indicator == 6110
                              @new_sanction_detail_object.sanction_indicator = 6111
                              @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                             if @inserted_from_batch == "SUCCESS"
                               count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                               sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                               my_file.write(sanction)
                             else
                              count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                              error = "sanction_details_error 7 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                    log_file.write(error)
                             end
                        end #if @indicator == 6110

                        if @indicator == 6111
                           count_25 = SanctionDetail.where("sanction_id = ? and sanction_indicator = 6111",sanction.id).count
                           if count_25 == 1
                                  @new_sanction_detail_object.sanction_indicator = 6111
                                  @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                  if @inserted_from_batch == "SUCCESS"
                                     count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                     sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                     my_file.write(sanction)
                                  else
                                    count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                    error = "sanction_details_error 8 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                    log_file.write(error)
                                 end
                           elsif count_25 == 2
                                 @new_sanction_detail_object.sanction_indicator = 6111
                                 @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                  if @inserted_from_batch == "SUCCESS"
                                     count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                     sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                     my_file.write(sanction)
                                  else
                                    count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                    error = "sanction_details_error 9 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                    log_file.write(error)
                                 end
                          elsif count_25 == 3
                                 @new_sanction_detail_object.sanction_indicator = 6112
                                 @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                  if @inserted_from_batch == "SUCCESS"
                                     count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                     sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                     my_file.write(sanction)
                                  else
                                       count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                       error = "sanction_details_error 10 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                       log_file.write(error)
                                  end
                              end
                        end #if @indicator == 6111

                        if @indicator == 6112
                           count_suspend2 = SanctionDetail.where("sanction_id = ? and sanction_indicator = 6112",sanction.id).count
                             if count_suspend2 == 1
                                 @new_sanction_detail_object.sanction_indicator = 6112
                                 @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                  if @inserted_from_batch == "SUCCESS"
                                     count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                     sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                     my_file.write(sanction)
                                  else
                                    count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                    # @array_error_hash["error_sanction_details_update"] = "For #{sanction.id} could not create sanction detail for the month of #{@next_month}\n"
                                    # log_file.write(@array_error_hash["error_sanction_details_update"])
                                    error = "sanction_details_error 11 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                    log_file.write(error)
                                 end
                             elsif count_suspend2 == 2
                                @new_sanction_detail_object.sanction_indicator = 6113
                                @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                if @inserted_from_batch == "SUCCESS"
                                   count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                   sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                   my_file.write(sanction)
                                else
                                  count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                  error = "sanction_details_error 12 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                  log_file.write(error)
                                end
                             end
                        end #if @indicator == 6112

                        if @indicator == 6113
                           count_50 = SanctionDetail.where("sanction_id = ? and sanction_indicator = 6113",sanction.id).count
                           if count_50 == 1
                                @new_sanction_detail_object.sanction_indicator = 6113
                                @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                  if @inserted_from_batch == "SUCCESS"
                                     count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                     sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                     my_file.write(sanction)
                                  else
                                    count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                    error = "sanction_details_error 13 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                    log_file.write(error)
                                 end
                             elsif count_50 == 2
                                 @new_sanction_detail_object.sanction_indicator = 6113
                                 @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                  if @inserted_from_batch == "SUCCESS"
                                     count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                     sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                     my_file.write(sanction)
                                  else
                                    count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                    error = "sanction_details_error 14 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                    log_file.write(error)
                                end
                             elsif count_50 == 3
                                 @new_sanction_detail_object.sanction_indicator = 6114
                                 @inserted_from_batch = SanctionDetailService.save_sanction_details(sanction.client_id,@new_sanction_detail_object,@next_month)
                                  if @inserted_from_batch == "SUCCESS"
                                     count_for_sanction_details_insert = count_for_sanction_details_insert + 1
                                     sanction = "sanction id = #{sanction.id} ,sanction detail id = #{@new_sanction_detail_object.id},sanction month = #{@new_sanction_detail_object.sanction_month},sanction implication = #{@new_sanction_detail_object.sanction_indicator}\n"
                                     my_file.write(sanction)
                                  else
                                    count_for_sanction_details_insert_failed = count_for_sanction_details_insert_failed + 1
                                    error = "sanction_details_error 15 - For #{sanction.id} could not create sanction detail for the month of-#{@next_month}\n "
                                    log_file.write(error)
                                 end
                             end #end for count_50
                        end #if @indicator == 6113

                     end #if @number_of_months > 0
                  end #if (sanction.sanction_type == 3081 || sanction.sanction_type == 3062)
               end #if (@sanction_detail.sanction_indicator == 6114)
             end #unless (@sanction_detail.release_indicatior == "1")
            end #if @sanction_detail.sanction_month == @next_month
        else
          no_sanction_details_present = no_sanction_details_present + 1
        end #if @sanction_details.present?
    end #sanction_collection.each do |sanction|
     my_file.write("Total sanction record present = " + count_to_add_sanctions_for_next_month.to_s + "\n")
      my_file.write("Total records - no sanction details present  = " + no_sanction_details_present.to_s + "\n")
     my_file.write("Total sanction record has next month sanction detail record   = " + sanction_for_next_month_present.to_s + "\n")
     my_file.write("Total sanction details records inserted  = " + count_for_sanction_details_insert.to_s + "\n")
     my_file.write("Total records sanction is released = " + sanction_released_records.to_s + "\n")
     my_file.write("count_for_sanction_details_sanction_indicator_closed = " +  count_for_sanction_details_sanction_indicator_closed.to_s + "\n")
     my_file.write("count_for_sanction_details_insert_failed =" + count_for_sanction_details_insert_failed.to_s + "\n")
     my_file.write("count_for_sanction_served_update_fail =" + count_for_sanction_served_update_fail.to_s + "\n")

# Close the file.
my_file.close
end

