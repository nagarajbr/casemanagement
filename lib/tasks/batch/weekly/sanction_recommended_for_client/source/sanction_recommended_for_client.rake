# /****                  PROGRAM DESCRIPTION                                  *
#   Weekly possible sanctions should create a task for case manager of a      *
# * . possible sanction                                                       *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : keerthana sheri                                    *
# *                                                                           *
# *  DATE OF WRITTEN     : 05-20-2016.                                        *
# *  DATE OF UPDATE      : 06-08-2016.                                        *
# *****************************************************************************
# *                                                                           *
# *                                                                           *
# *  DESCRIPTION:                   Create a work task to case manager if     *
# *                                 client is Potentially eligible            *
#                                   for sanction                              *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:             NONE                                      *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  NONE                                      *
# *  *
# *  ERROR FILES,LOG FILES         weekly_sanction_recommended,               *
# *                                weekly_log_sanction_recommended            *
# *                                                                           *
# *                                                                           *
# *****************************************************************************
task :sanction_recommended_for_client => :environment do
batch_user = User.where("uid = '555'").first
AuditModule.set_current_user=(batch_user)
filename = "batch_results/weekly/weekly_sanction_recommended/results/weekly_sanction_recommended"+ "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
error_filename = "batch_results/weekly/weekly_sanction_recommended/results/weekly_log_sanction_recommended"+ "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
path = File.join(Rails.root, filename )
error_path = File.join(Rails.root, error_filename )
# # Create new file called 'filename.txt' at a specified path.
file = File.new(path,"w+")
error_file = File.new(error_path,"w+")
total_program_units_extracted = 0
@total_activity_hours_met = 0
@total_activity_hours_not_met = 0
@total_core_activity_hours_client_incomplete = 0
@total_core_activity_hours_client_absent = 0
@work_hours_not_met = 0
@total_work_task_created_count = 0
@already_work_task_exist = 0
@total_fail_in_work_task_creation_count = 0
@no_primary_present_for_program_unit_present = 0
start_date_for_week1 = DateService.date_of_previous("Sunday", Date.today) - 21
end_date_for_week1 = DateService.date_of_previous("Saturday", Date.today) - 14
start_date_for_week2 = DateService.date_of_previous("Sunday", Date.today) - 14
end_date_for_week2 = DateService.date_of_previous("Saturday", Date.today) - 7
file.write("Begin sanction recommendation process 1 on : " + Date.today.to_s + "\n")
file.write("Begin date : " + start_date_for_week1.to_s + "\n")
@days_from_this_week = (Date.today.at_beginning_of_week..Date.today.at_end_of_week).map

step1 = ProgramUnit.joins(" INNER JOIN PROGRAM_UNIT_PARTICIPATIONS ON (PROGRAM_UNITS.ID=PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID
                                       AND PROGRAM_UNIT_PARTICIPATIONS.ID = ( SELECT MAX(ID)

                                     FROM PROGRAM_UNIT_PARTICIPATIONS A

                                     WHERE A.PROGRAM_UNIT_ID = PROGRAM_UNIT_PARTICIPATIONS.PROGRAM_UNIT_ID

                             )
                                       AND PROGRAM_UNIT_PARTICIPATIONS.PARTICIPATION_STATUS = 6043
                                       AND PROGRAM_UNITS.CASE_TYPE IN (6047,6046))
                        ")
step2 = step1.select("PROGRAM_UNITS.*")
open_program_unit = step2
        # mandatory_characteristic_present = false
    begin
    if open_program_unit.present?
		    total_program_units_extracted = open_program_unit.count
		    open_program_unit.each do |program_unit|
				adult_age = SystemParam.get_key_value(6,"child_age","18 is the age to determine adult").to_i
				step1 = ProgramUnitMember.joins("INNER JOIN clients
				              ON program_unit_members.client_id = clients.id")
				step2 = step1.where("program_unit_members.program_unit_id = ? and
				                      program_unit_members.member_status = 4468 and
				                      (clients.dob is null or EXTRACT(YEAR FROM AGE(CLIENTS.DOB)) >= ?)",program_unit.id, adult_age)
				step3 = step2.select("program_unit_members.*")
				pgu_adults_collection = step3

				if mandatory_work_characteristic(pgu_adults_collection,start_date_for_week1,end_date_for_week1)
				sanction_recommandation_upon_not_completing_expected_hours(program_unit, start_date_for_week1,end_date_for_week1,file,error_file)
				end
				if mandatory_work_characteristic(pgu_adults_collection,start_date_for_week2,end_date_for_week2)
				sanction_recommandation_upon_not_completing_expected_hours(program_unit, start_date_for_week2,end_date_for_week2,file,error_file)
				end
		    end#open_program_unit.each do |program_unit|
	    else
	    #open program unit
	    	name = "No open program unit present-  #{arg_program_unit_object.id}"
			arg_path.write(name + "\n")
	    end#open_program_unit.present?
	rescue => err
      error_object = CommonUtil.write_to_attop_error_log_table("sanction_recommended_for_client","Batch",err,AuditModule.get_current_user.uid)
    end

        file.write("Total program units extracted = " + total_program_units_extracted.to_s + "\n")
        file.write("Total program units completed required hours   = " + @total_activity_hours_met.to_s + "\n")
		file.write("Total program units did not completed required hours  = " + @total_activity_hours_not_met.to_s + "\n")
		file.write("Total program units did not completed core hours = " + @total_core_activity_hours_client_incomplete.to_s + "\n")
		file.write("Total program units no activites present = " + @total_core_activity_hours_client_absent.to_s + "\n")
	    file.write("Total primary contact unavaliable = " + @no_primary_present_for_program_unit_present.to_s + "\n")
		file.write("Total already work task exists  = " + @already_work_task_exist.to_s + "\n")
		file.write("Total create work task = " + @total_work_task_created_count.to_s + "\n")
		error_file.write("Total failed to create work task = " + @total_fail_in_work_task_creation_count.to_s + "\n")
	  #
end  #:sanction_recommended_notify_case_manager => :environment do

def mandatory_work_characteristic(arg_pgu_adults_collection,arg_week_start_date,arg_week_end_date)
    mandatory_characteristic_present = false
    if arg_pgu_adults_collection
	    arg_pgu_adults_collection.each do |each_client|
		    mandatory_characteristic = ClientCharacteristic.has_mandatory_work_characteristic_in_a_given_date_range(each_client.id,arg_week_start_date,arg_week_end_date)
			if mandatory_characteristic.present?
			   mandatory_characteristic_present = true
			   break
			end
	    end
    else
    #no adults present
    end
   return mandatory_characteristic_present
end

def sanction_recommandation_upon_not_completing_expected_hours(arg_program_unit_object, arg_week_start_date,arg_week_end_date,arg_path,arg_error_path)
   expected_hours_to_work_object = ActionPlanService.get_expected_work_participation_hours(arg_program_unit_object,arg_week_start_date,arg_week_end_date)
   if expected_hours_to_work_object.present?
   	  expected_total_hours_to_work = expected_hours_to_work_object[:total_hours] if expected_hours_to_work_object.present?
      expected_core_hours_to_work = expected_hours_to_work_object[:min_core_hours] if expected_hours_to_work_object.present?
      expected_non_core_hours_to_work = expected_hours_to_work_object[:non_core_hours] if expected_hours_to_work_object.present?
      core_activity_types = CodetableItem.get_activity_types_for_core_components
	   non_core_activity_types = CodetableItem.get_activity_types_for_non_core_components
	   total_core_and_non_core_activity_hours = ActivityHour.get_activity_hours_by_core_and_non_core_hours(arg_program_unit_object.id,arg_week_start_date,arg_week_end_date)
	   total_core_activity_hours_client = ActivityHour.get_activity_hours_by_core_or_non_core_hours(arg_program_unit_object.id,arg_week_start_date,arg_week_end_date,core_activity_types)
	   total_non_core_activity_hours_client = ActivityHour.get_activity_hours_by_core_or_non_core_hours(arg_program_unit_object.id,arg_week_start_date,arg_week_end_date,non_core_activity_types)
		if total_core_activity_hours_client.present?
			if total_core_activity_hours_client.sum(:completed_hours).to_i >= expected_core_hours_to_work
				if total_core_and_non_core_activity_hours.sum(:completed_hours).to_i >= expected_total_hours_to_work
					work_hours_not_met = false
					# no sanction
					@total_activity_hours_met = @total_activity_hours_met + 1
				else
	                work_hours_not_met = true
	                @total_activity_hours_not_met = @total_activity_hours_not_met + 1
				end
			else
			#minimum required core hours are not completed - sanction recommdation
	             work_hours_not_met = true
	             @total_core_activity_hours_client_incomplete = @total_core_activity_hours_client_incomplete + 1
	        end
		else
			work_hours_not_met = true
			@total_core_activity_hours_client_absent = @total_core_activity_hours_client_absent + 1
			#No core hours present -sanction recommdation
		end#if total_core_activity_hours_client.present?
		if work_hours_not_met == true
		# ls_client_name = Client.get_client_full_name_from_client_id(each_work_characteristic.client_id)
	        primary_contact = PrimaryContact.get_primary_contact(arg_program_unit_object.id, 6345)
	        if primary_contact.present?
			        ls_client_name = Client.get_client_full_name_from_client_id(primary_contact.client_id)
			        ls_action_text = "program unit :#{arg_program_unit_object.id} is potentially eligible for sanction"
					ls_instructions = "This is a system generated task to case manager to manage possible progressive sanction for program unit :#{arg_program_unit_object.id} and primary contact is #{ls_client_name} "
					assigned_to = nil
				if arg_program_unit_object.case_manager_id.present?
					assigned_to = arg_program_unit_object.case_manager_id
				elsif arg_program_unit_object.eligibility_worker_id.present?
					assigned_to = arg_program_unit_object.eligibility_worker_id
				end
				l_days_to_complete_task = SystemParam.get_key_value(18,"6716","Number of days to complete Task -Possible sanctions - Days to complete = 10")
	            l_days_to_complete_task = l_days_to_complete_task.to_i
	            ldt_due_date = Date.today + l_days_to_complete_task
	            work_task_for_case_manager = WorkTask.save_work_task(6716,# arg_task_type,
																	6510, # arg_beneficiary_type -program_unit,#6510 - client,
																	arg_program_unit_object.id, #arg_reference_id program_unit_id,
																	ls_action_text, #arg_action_text,
																	6342, #client,
																	assigned_to, #arg_assigned_to_id,
																	AuditModule.get_current_user.uid,#arg_assigned_by_user_id,
																	6366, #arg_task_category, - client
																	primary_contact.client_id, #arg_client_id
																	ldt_due_date, #arg_due_date
																	ls_instructions, #arg_instructions
																	2188,#arg_urgency,
																	'',#arg_notes,
																	6339, #arg_status
																	arg_program_unit_object.id)
				if work_task_for_case_manager == "NEWRECORD"
					@total_work_task_created_count = @total_work_task_created_count + 1
					name = " New task for program unit -  #{arg_program_unit_object.id} and primary contact - #{ls_client_name}"
					arg_path.write(name + "\n")
				elsif  work_task_for_case_manager == "SUCCESS"
					@already_work_task_exist = @already_work_task_exist + 1
				# pending work task already exists - no need to create one more
				else
					@total_fail_in_work_task_creation_count = @total_fail_in_work_task_creation_count + 1
					error = "unable to create task to case manager to manage current work participation in program unit :#{arg_program_unit_object.id} and primary contact - #{ls_client_name}"
					arg_error_path.write(error + "\n")
				end
	        else
	          error = " No primary contact present for program unit -  #{arg_program_unit_object.id}"
	          @no_primary_present_for_program_unit_present  = @no_primary_present_for_program_unit_present + 1
	          arg_error_path.write(error + "\n")
	        end#primary_contact.present?
	   else
	   end#work_hours_not_met == true
    else
    	error = "Unable to determine mandatory hours for program unit -  #{arg_program_unit_object.id}"
    	arg_error_path.write(error + "\n")
	end#if expected_hours_to_work_object.present?

end#def sanction_recommandation_upon
