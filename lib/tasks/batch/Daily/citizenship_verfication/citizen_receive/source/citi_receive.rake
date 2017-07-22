task :generate_citizenship_verification_receive => :environment do

	batch_user = User.where("uid = '555'").first
	AuditModule.set_current_user=(batch_user)

 	error_filename = "batch_results/daily/citizenship_verfication/citizen_receive/results/errors_citizen_resp_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
  	log_filename = "batch_results/daily/citizenship_verfication/citizen_receive/results/log_citizen_resp_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"

  	error_path = File.join(Rails.root, error_filename)
	log_path = File.join(Rails.root, log_filename)

	error_file = File.new(error_path,"w+")
	log_file = File.new(log_path,"w+")

	log_file.puts("Citizenship verification batch process update start")

  	total_number_of_records  = 0
  	total_number_of_records_updated = 0
  	total_number_of_error_records = 0
  	total_work_task_created_count = 0
  	already_work_task_exist = 0
  	total_fail_in_work_task_creation_count = 0


	f = File.open('batch_results/daily/citizenship_verfication/citizen_receive/inbound/citizen_resp.txt')
	f.each_line do |line|
		error_message = " "
		total_number_of_records = total_number_of_records + 1
		input_code = line[107,1]
		ssn = line[0,9]
		ssn = ssn.to_s

		if input_code == 'A'
			l_sves_type = 4658
		elsif input_code == 'C'
			l_sves_type = 4658
		else
			l_sves_type = 4657
		end

		l_client = Client.where("ssn = ?", ssn).first

		if l_client.present?
			# Provider.where(id: batchid).update_all(status: batchstatus, notes: batchnotes )
			if l_sves_type == 4657
				client_name = Client.get_client_full_name_from_client_id(l_client.id)
				action_text = "Citizenship is not verified for the client: #{client_name}"
				instructions = "This is a system created task- Take necessary steps as citizenship is not verified for the client: #{client_name}"
				due_date = Date.today + 7.days
				program_unit = ProgramUnit.get_open_client_program_units(l_client.id).first
				if program_unit.present?
					work_task_for_case_manager = WorkTask.save_work_task(5878, #arg_task_type = citizenship not verified
												                          6510, #arg_beneficiary_type = client id
												                          l_client.id, #arg_reference_id = client id
												                          action_text, #arg_action_text,
												                          6342, #arg_assigned_to_type = user
												                          program_unit.eligibility_worker_id, #arg_assigned_to_id,
												                          20, #arg_assigned_by_user_id = assigned by batch
												                          6366, #arg_task_category = client
												                          l_client.id, #arg_client_id,
												                          due_date, #arg_due_date = seven days from the day it is run
												                          instructions, #arg_instructions,
												                          2188, #arg_urgency = High
												                          nil, #arg_notes,
												                          6339, #arg_status = pending
												                          program_unit.id)
					if work_task_for_case_manager == "NEWRECORD"
						total_work_task_created_count = total_work_task_created_count + 1
						name = " client name -  #{ls_client_name}"
						file.write(name + "\n")
					elsif  work_task_for_case_manager == "SUCCESS"
						already_work_task_exist = already_work_task_exist + 1
					# pending work task already exists - no need to create one more
					else
						total_fail_in_work_task_creation_count = total_fail_in_work_task_creation_count + 1
						error = "unable to create task to case manager to manage current work participation in program unit :#{each_work_characteristic.id} for Client:#{ls_client_name}"
						error_file.write(error + "\n")
					end
				end
			end
			if Client.where(ssn: ssn).update_all(sves_type: l_sves_type)
				total_number_of_records_updated = total_number_of_records_updated + 1
			else
				total_number_of_error_records = total_number_of_error_records + 1
				error_message = "Update failed for the client with SSN = #{ssn}"
			end
		else
			total_number_of_error_records = total_number_of_error_records + 1
			error_message = "No client found with SSN = #{ssn}"
		end
		if error_message.present?
			error_file.puts(line +":  " +error_message)
		end

	end
	log_file.puts("Total number of clients received = #{total_number_of_records}")
	log_file.puts("Total number of client details updated = #{total_number_of_records_updated}")
	log_file.puts("Total number of records errored = #{total_number_of_error_records}")
	log_file.puts("Total number of records errored = #{total_work_task_created_count}")
	log_file.puts("Total number of records errored = #{already_work_task_exist}")
	log_file.puts("Total number of records errored = #{total_fail_in_work_task_creation_count}")
	log_file.puts("Citizenship verification batch process update end")
	log_file.close
	error_file.close
end


# /*******************************************************************
# *                             MODIFICATION LOG                              *
# *                                                                           *
# * PCR       DATE        SE                 DESCRIPTION                      *
# * --------  ---------   -----------------  ---------------------------------*
# * 76671     02/26/10    Thirumal Rao      Intial program                    *
# ****************************************************************************/

# #include <stdio.h>
# #include <strings.h>
# #include <fcntl.h>
# #include <stdlib.h>
# #include <ctype.h>
# #include "sqlca.h"
# #include "sqlda.h"



#    EXEC SQL INCLUDE SQLCA;
#    EXEC SQL BEGIN DECLARE SECTION;


#     static char id[9]            = "XXXXXXX";
#     static char pass[9]          = "XXXXXXX";
#     static char server[9]        = "aransonl";
#     static char connection[9]    = "xxxxxxxx";

#    EXEC SQL END DECLARE SECTION;

#      int rec_prc =0;
#      int rec_upd =0;
#      int rec_erd =0;
#      char ssn[10]="\0";
#      char citi_enum[3]="\0";
#      char filler[96]="\0";
#      char code;
#      char filler2[42]="\0";

#      FILE *inp_fp;
#      FILE *err_fp;

#      int update_person_biograph(char *, char *);
#      int svrinit();
#      int svrdone();
# main()
# {
#     typedef struct
#     {
#       char ssn[9];
#       char filler[98];
#       char code;
#       char filler2[49];
#     } facts_part;

#     facts_part facts_input;
#     inp_fp=fopen("citizen_resp.txt","r");
#     err_fp=fopen("ciitzen_res.txt","w+");
#     svrinit();
#     fprintf(err_fp,"Proccessing citizenship verification...\n\n");

#     while(!feof(inp_fp))
#     {
#         fread(&facts_input,sizeof(facts_part),1,inp_fp);

#         if(feof(inp_fp))
#           break;
#         rec_prc++;
#         strncpy(ssn,facts_input.ssn,9);
#         ssn[9]='\0';




#         if (facts_input.code == 'A')
#           strcpy (citi_enum, "SV");
#         else if (facts_input.code == 'C')
#            strcpy (citi_enum, "SV");
#            else
#            strcpy (citi_enum, "SN");


# printf(" ssn %s  citinum %s \n",ssn,citi_enum);





#          if(update_person_biograph(ssn,citi_enum))
#         {
#             printf("Record updated for : ssn = %s citi_enum = %s \n", \
#                     ssn,citi_enum);
#             rec_upd++;
#          }
#     }
#     fprintf(err_fp,"\nNumber of records processed = %d",rec_prc);
#     fprintf(err_fp,"\nNumber of records updated in T_PERSON_BIOGRAPH table = %d",rec_upd);
#     fprintf(err_fp,"\nNumber of records errored off = %d",rec_erd);
#     fprintf(err_fp,"\nProper completion of program!\n");
#     fclose(inp_fp);
#     fclose(err_fp);
#     svrdone();
# }

# int svrinit(void)
# {
#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;
#     EXEC SQL INCLUDE SQLCA;


#     printf("Connecting to database\n");

#     EXEC SQL CONNECT TO :server;

#     if (SQLCODE < 0)
#     {
#         printf("Fatal error %ld encountered when logging on to DB2.\n", SQLCODE );
#         printf("Server: %s\nUser: %s\nPassword: %s\n\n", server, id,pass);
#         return(0);
#     }
#     else
#     {
#             if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#             {
#             printf("Warning errors encountered when attempting to log `on to DB2.\n");
#             }
#     }

#     EXEC SQL COMMIT;

#     printf("Database connected \n");

#     return(1);
# }

# int svrdone(void)
# {
#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;

#     /* Close database and then Disconnect from SYBASE */

#     printf ("program about to DISCONNECT\n");

#     EXEC SQL DISCONNECT ALL;
#     printf("finished disconnecting from the database\n");

#     return 1;
# }


# int update_person_biograph(char*  ssn,char* ssn_enum)
# {
#     int ret_code;
#     char   sys_date_time[26];
#     time_t timer;
#     time_t *timer_p;

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     char social[10]="\0";
#     char enumeration[3]="\0";

#     char   syb_sys_date[20];
#     double h_enum_counter;


#     EXEC SQL END DECLARE SECTION;

#         strncpy(social,ssn,9);
#         social[9]='\0';
#         strncpy(enumeration,citi_enum,2);
#         enumeration[2]='\0';


#         timer = time(NULL);
#         strftime( sys_date_time, sizeof(sys_date_time), "%m/%d/%Y %X",localtime( &timer ) );
#         syb_sys_date[0] = sys_date_time[6];
#         syb_sys_date[1] = sys_date_time[7];
#         syb_sys_date[2] = sys_date_time[8];
#         syb_sys_date[3] = sys_date_time[9];
#         syb_sys_date[4] = '-';
#         syb_sys_date[5] = sys_date_time[0];
#         syb_sys_date[6] = sys_date_time[1];
#         syb_sys_date[7] = '-';
#         syb_sys_date[8] = sys_date_time[3];
#         syb_sys_date[9] = sys_date_time[4];
#         syb_sys_date[10] = '-';
#         syb_sys_date[11] = sys_date_time[11];
#         syb_sys_date[12] = sys_date_time[12];
#         syb_sys_date[13] = '.';
#         syb_sys_date[14] = sys_date_time[14];
#         syb_sys_date[15] = sys_date_time[15];
#         syb_sys_date[16] = '.';
#         syb_sys_date[17] = sys_date_time[17];
#         syb_sys_date[18] = sys_date_time[18];
#         syb_sys_date[19] = '\0';



#         EXEC SQL UPDATE dba.t_person_biograph
#         SET SVES_STATUS = 'R',
#             user_id = 'ANSWER2',
#             last_update = :syb_sys_date,
#             SVES_VERIFIED_DATE =:syb_sys_date,
#             SVES_TYPE =:enumeration
#         WHERE ssn = :social;

#     if (SQLCODE < 0)
#     {
#         fprintf(err_fp,"Fatal error %ld encountered when attempting to update the Person Biograph\n", SQLCODE);
#         EXEC SQL ROLLBACK;
#         return(0);
#     }
#     else
#     {
#         if (SQLCODE == 100)
#         {
#            fprintf(err_fp,"No record found for ssn = %s enum = %s \n", social, citi_enum);
#            rec_erd++;
#            return(0);
#         }
#         if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#         {
#             fprintf(err_fp,"\nWarning errors encountered when updating the Person Biograph\n\n");
#         }
#         if (SQLCODE == 0)
#         {
#            EXEC SQL COMMIT; /* PCR # 71090 */
#         }
#     }

#   EXEC SQL insert into DBA.t_citizenship_his
#                  select clientid,SVES_SEND_DATE,SVES_VERIFIED_DATE,SVES_TYPE from dba.t_person_biograph
#                  WHERE ssn = :social;

#     if (SQLCODE == -803)
#      {
#        return(1);
#      }

#     if (SQLCODE < 0)
#     {
#         fprintf(err_fp,"Fatal error %ld encountered when attempting to update the citizenship history  for social %s\n", SQLCODE,social);
#         EXEC SQL ROLLBACK;
#         return(0);
#     }
#     else
#     {
#         if (SQLCODE == 100)
#         {
#            fprintf(err_fp,"No record found for ssn to insert into history= %s enum = %s \n", social, citi_enum);
#            rec_erd++;
#           return(0);
#         }
#         if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#         {
#             fprintf(err_fp,"\nWarning errors encountered when inserting the citizen history\n\n");
#         }
#         if (SQLCODE == 0)
#         {
#            EXEC SQL COMMIT; /* PCR # 71090 */
#         }
#     }

#     return(1);
# }

