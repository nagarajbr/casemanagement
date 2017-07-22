task :update_ssn_enemuration_from_aasis_after_verification => :environment do
    batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
    log_filename = "batch_results/monthly/ssn_enumeration/ssn_enumeration_from_ssa/results/ssn_enum_ext_log"+ ".txt"
    file = File.open('batch_results/monthly/ssn_enumeration/ssn_enumeration_from_ssa/inbound/ssn_enum_ext.txt')
    log_path = File.join(Rails.root, log_filename )
    log_file = File.new(log_path,"w+")
    total_number_of_records  = 0
    total_number_of_records_updated = 0
    total_number_of_error_records = 0
    log_record = 'Begin ssn enumeration verification from ssa'
    log_file.puts(log_record)
        file.each_line do |line|
            error_message = " "
            total_number_of_records = total_number_of_records + 1
            input_code = line[97,1]
            reasons_collection = line[106,42]
            # Rails.logger.debug("input_code = #{input_code.inspect}" )
            # Rails.logger.debug("reasons_collection = #{reasons_collection.inspect}" )
            ssn = line[0,9]
            # Rails.logger.debug("ssn = #{ssn.inspect}" )
            client_information = Client.where("ssn = ?", ssn ).first
            # Rails.logger.debug("client_information = #{client_information.inspect}" )
            # Rails.logger.debug("client_information = #{client_information.ssn_enumeration_type.inspect}" )
            if client_information.present?
            #     l_ssn_enemuration = ' '
                if input_code == ' '
                    l_ssn_enemuration = 4354
                else
                    if client_information.ssn_enumeration_type == 4343
                    #4343 dws verified
                    else
                        case input_code
                        when '1'
                            l_ssn_enemuration = 4346  #1 == 'M1' == 4346 'Mismatch-Not on file'
                        when '2'
                            l_ssn_enemuration = 4347  #2 ==  M2  == 4347 'Mismatch-Gender'
                        when '3'
                            l_ssn_enemuration = 4348  #3 ==  M3  == 4348 'Mismatch-Birth Date'
                        when '4'
                            l_ssn_enemuration = 4349  #4 ==  M4  == 4349 'Mismatch-Gender & Birth'
                        when '5'
                            l_ssn_enemuration = 4350  #5 ==  M5 ==  4350 'Mismatch-Name'
                        when 'A'
                            l_ssn_enemuration = 4351  #A ==  M6 ==  4351 'Mismatch-Other SSNs'
                        when 'B'
                            l_ssn_enemuration = 4349  #B ==  M4 ==  4349 'Mismatch-Gender & Birth'
                        when 'C'
                            l_ssn_enemuration = 4351  #C ==  M6 ==  4351 'Mismatch-Other SSNs'
                        when 'D'
                            l_ssn_enemuration = 4349  #D ==  M4 ==  4349 'Mismatch-Gender & Birth'
                        end
                    end

                end

                unless (l_ssn_enemuration == 4354 or l_ssn_enemuration ==4343)
                    reason = CodetableItem.get_short_description(l_ssn_enemuration)
                    ls_client_name = Client.get_client_full_name_from_client_id(client_information.id)
                    action_text = "SSN Mismatch"
                    instructions ="#{reason} for the client #{ls_client_name}" + "\n" + "#{reasons_collection}" + "\n"

                    open_program_unit_object = ProgramUnit.get_open_client_program_units(client_information.id).first
                    if (open_program_unit_object.present? and open_program_unit_object.eligibility_worker_id.present?)
                        month_end_date = nil
                        if Date.today.strftime("%d").to_i >= 25
                            month_end_date = Date.today.end_of_month.next_month
                        elsif Date.today.strftime("%d").to_i < 5
                            month_end_date = Date.today.end_of_month
                        else
                            month_end_date = Date.today.end_of_month
                        end
                        work_task_collection = WorkTask.save_work_task(2158,#arg_task_type,
                                                                    6510, #arg_beneficiary_type = client
                                                                    client_information.id, #arg_reference_id = client_id
                                                                    action_text, #arg_action_text,
                                                                    6342, #arg_assigned_to_type = user
                                                                    open_program_unit_object.eligibility_worker_id,#arg_assigned_to_id,
                                                                    20, #arg_assigned_by_user_id = assigned by batch
                                                                    6366, #arg_task_category = client
                                                                    client_information.id, #arg_client_id,
                                                                    month_end_date,#arg_due_date,
                                                                    instructions, #arg_instructions,
                                                                    2188, #arg_urgency = High
                                                                    nil, #arg_notes,
                                                                    6339, #arg_status = pending
                                                                    open_program_unit_object.id)

                        if work_task_collection == "NEWRECORD"
                            total_number_of_records = total_number_of_records + 1
                            name = " client name -  #{ls_client_name}"
                            file.write(name + "\n")

                        elsif  work_task_collection == "SUCCESS"
                            # pending work task already exists - no need to create one more
                        else
                             total_number_of_error_records = total_number_of_error_records + 1
                             error_message = "unable to create task to case manager to manage current work characteristic in program unit :#{open_program_unit_object.id} for Client:#{ls_client_name}"
                             # log_file.write(error_message + "\n")
                        end
                    else
                        total_number_of_error_records = total_number_of_error_records + 1
                        error_message = "eligibility worker was not found for the client #{ls_client_name} with client id #{client_information.id}"
                    end
                end

                    if Client.where(ssn: ssn).update_all(ssn_enumeration_type: l_ssn_enemuration)
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
                log_file.puts(line +":  " +error_message + "\n")
            end

        end
    log_file.puts("Total number of clients received = #{total_number_of_records}")
    log_file.puts("Total number of client details updated = #{total_number_of_records_updated}")
    log_file.puts("Total number of records errored = #{total_number_of_error_records}")
    log_file.puts("End ssn enumeration verification from ssa")
    log_file.close


end


#         if (facts_input.ssn_enum == ' ')
#           strcpy (ssn_enum, "SS");
#         else if (facts_input.ssn_enum == '1')
#           strcpy (ssn_enum, "M1");
#         else if (facts_input.ssn_enum == '2')
#           strcpy (ssn_enum, "M2");
#         else if (facts_input.ssn_enum == '3')
#           strcpy (ssn_enum, "M3");
#         else if (facts_input.ssn_enum == '4')
#           strcpy (ssn_enum, "M4");
#         else if (facts_input.ssn_enum == '5')
#           strcpy (ssn_enum, "M5");
#         else if (facts_input.ssn_enum == 'A')
#           strcpy (ssn_enum, "M6");
#         else if (facts_input.ssn_enum == 'B')
#           strcpy (ssn_enum, "M4");
#         else if (facts_input.ssn_enum == 'C')
#           strcpy (ssn_enum, "M6");
#         else if (facts_input.ssn_enum == 'D')
#           strcpy (ssn_enum, "M4");
#           CASE d.ENUMERATION
#         when 'WW' THEN '4352'
#         when 'M4' THEN '4349'
#         when 'M5' THEN '4350'
#         when 'SS' THEN '4354'
#         when 'M1' THEN '4346'
#         when 'DD' THEN '4345'
#         when 'PP' THEN '4352'
#         when 'AA' THEN '4352'
#         when 'M3' THEN '4348'
#         when 'RR' THEN '4353'
#         when 'M2' THEN '4347'
#         when 'M6' THEN '4351'
#         when 'BB' THEN '4343'
#         when 'CC' THEN '4352'
#         when 'RR' THEN '4353'
#         when '99' THEN NULL
#         END as ENUMERATION



# 4354    Verified
# 4353    Reported
# 4352    Provided
# 4351    Mismatch-Other SSNs
# 4350    Mismatch-Name
# 4349    Mismatch-Gender & Birth
# 4348    Mismatch-Birth Date
# 4347    Mismatch-Gender
# 4346    Mismatch-Not on file
# 4345    Disqualified
# 4343    Verified DWS





#     end

#     log_record = 'Number of records read: ' + ls_read.to_s
#     log_file.puts(log_record)
#     log_record = 'Number of records updated: ' + ls_write.to_s
#     log_file.puts(log_record)
#     log_record = 'Number of error records written: ' + ls_error.to_s
#     log_file.puts(log_record)
#     log_record = 'End provider verification from AASIS'
#     log_file.puts(log_record)
#     log_file.close
#     file.close
# end
# # /********************************************************************
# # *                             MODIFICATION LOG                              *
# # *                                                                           *
# # * PCR       DATE        SE                 DESCRIPTION                      *
# # * --------  ---------   -----------------  ---------------------------------*
# # * 71090     12/21/04    Naga Goriparthi   Added SQL COMMIT                  *
# # * 74562     02/06/08    John Davis        adde enum_counter calculation     *
# # ****************************************************************************/

# # #include <stdio.h>
# # #include <strings.h>
# # #include <fcntl.h>
# # #include <stdlib.h>
# # #include <ctype.h>
# # #include "sqlca.h"
# # #include "sqlda.h"

# #    EXEC SQL INCLUDE 'commbat1.h';
# #    EXEC SQL INCLUDE 'comm_err22.h';
# #    EXEC SQL INCLUDE SQLCA;
# #    EXEC SQL BEGIN DECLARE SECTION;


# #     static char id[9]            = "XXXXXXX";
# #     static char pass[9]          = "XXXXXXX";
# #     static char server[9]        = "aransonl";
# #     static char connection[9]    = "xxxxxxxx";

# #    EXEC SQL END DECLARE SECTION;

# #      int rec_prc =0;
# #      int rec_upd =0;
# #      int rec_erd =0;
# #      char ssn[10]="\0";
# #      char ssn_enum[3]="\0";
# #      char county[3]="\0";
# #      FILE *inp_fp;
# #      FILE *err_fp;

# #      int update_person_biograph(char *, char *,char *);
# #      int svrinit();
# #      int svrdone();
# # main()
# # {
# #     typedef struct
# #     {
# #       char ssn[9];
# #       char lname[13];
# #       char fname[10];
# #       char mname[7];
# #       char dob[8];
# #       char sex;
# #       char filler1[49];
# #       char ssn_enum;
# #       char filler2[13];
# #       char mssn[50];
# #     } facts_part;

# #     facts_part facts_input;
# #     inp_fp=fopen("ssn_enum_ext.txt","r");
# #     err_fp=fopen("enum_res.txt","w+");
# #     svrinit();
# #     fprintf(err_fp,"Proccessing ssn enumeration...\n\n");

# #     while(!feof(inp_fp))
# #     {
# #         fread(&facts_input,sizeof(facts_part),1,inp_fp);
# #         if(feof(inp_fp))
# #           break;
# #         rec_prc++;
# #         strncpy(ssn,facts_input.ssn,9);
# #         ssn[9]='\0';
# #         if (facts_input.ssn_enum == ' ')
# #           strcpy (ssn_enum, "SS");
# #         else if (facts_input.ssn_enum == '1')
# #           strcpy (ssn_enum, "M1");
# #         else if (facts_input.ssn_enum == '2')
# #           strcpy (ssn_enum, "M2");
# #         else if (facts_input.ssn_enum == '3')
# #           strcpy (ssn_enum, "M3");
# #         else if (facts_input.ssn_enum == '4')
# #           strcpy (ssn_enum, "M4");
# #         else if (facts_input.ssn_enum == '5')
# #           strcpy (ssn_enum, "M5");
# #         else if (facts_input.ssn_enum == 'A')
# #           strcpy (ssn_enum, "M6");
# #         else if (facts_input.ssn_enum == 'B')
# #           strcpy (ssn_enum, "M4");
# #         else if (facts_input.ssn_enum == 'C')
# #           strcpy (ssn_enum, "M6");
# #         else if (facts_input.ssn_enum == 'D')
# #           strcpy (ssn_enum, "M4");
# # printf(" ssn %s \n", ssn);
# # printf(" ssn_enum %s \n", ssn_enum);
# #         strcpy (county,"\0");
# #         if(update_person_biograph(ssn,ssn_enum,county))
# #         {
# #             printf("Record updated for : ssn = %s ssn_enum = %s \n", \
# #                     ssn,ssn_enum);
# #             rec_upd++;
# #          }
# #     }
# #     fprintf(err_fp,"\nNumber of records processed = %d",rec_prc);
# #     fprintf(err_fp,"\nNumber of records updated in T_PERSON_BIOGRAPH table = %d",rec_upd);
# #     fprintf(err_fp,"\nNumber of records errored off = %d",rec_erd);
# #     fprintf(err_fp,"\nProper completion of program!\n");
# #     fclose(inp_fp);
# #     fclose(err_fp);
# #     svrdone();
# # }

# # int svrinit(void)
# # {
# #     EXEC SQL WHENEVER SQLERROR continue;
# #     EXEC SQL WHENEVER SQLWARNING continue;
# #     EXEC SQL WHENEVER NOT FOUND continue;
# #     EXEC SQL INCLUDE SQLCA;


# #     printf("Connecting to database\n");

# #     EXEC SQL CONNECT TO :server;

# #     if (SQLCODE < 0)
# #     {
# #         printf("Fatal error %ld encountered when logging on to DB2.\n", SQLCODE );
# #         printf("Server: %s\nUser: %s\nPassword: %s\n\n", server, id,pass);
# #         return(0);
# #     }
# #     else
# #     {
# #             if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
# #             {
# #             printf("Warning errors encountered when attempting to log `on to DB2.\n");
# #             }
# #     }

# #     EXEC SQL COMMIT;

# #     printf("Database connected \n");

# #     return(1);
# # }

# # int svrdone(void)
# # {
# #     EXEC SQL WHENEVER SQLERROR continue;
# #     EXEC SQL WHENEVER SQLWARNING continue;
# #     EXEC SQL WHENEVER NOT FOUND continue;

# #     EXEC SQL INCLUDE SQLCA;

# #     /* Close database and then Disconnect from SYBASE */

# #     printf ("program about to DISCONNECT\n");

# #     EXEC SQL DISCONNECT ALL;
# #     printf("finished disconnecting from the database\n");

# #     return 1;
# # }


# # int update_person_biograph(char*  ssn,char* ssn_enum,char* county)
# # {
# #     int ret_code;
# #     char   sys_date_time[26];
# #     time_t timer;
# #     time_t *timer_p;

# #     EXEC SQL WHENEVER SQLERROR continue;
# #     EXEC SQL WHENEVER SQLWARNING continue;
# #     EXEC SQL WHENEVER NOT FOUND continue;

# #     EXEC SQL INCLUDE SQLCA;
# #     EXEC SQL BEGIN DECLARE SECTION;

# #     char social[10]="\0";
# #     char enumeration[3]="\0";
# #     char h_county[3]="\0";
# #     char   syb_sys_date[20];
# #     double h_enum_counter;


# #     EXEC SQL END DECLARE SECTION;

# #         strncpy(social,ssn,9);
# #         social[9]='\0';
# #         strncpy(enumeration,ssn_enum,2);
# #         enumeration[2]='\0';
# #         strncpy(h_county,county,2);
# #         h_county[2]='\0';

# #         timer = time(NULL);
# #         strftime( sys_date_time, sizeof(sys_date_time), "%m/%d/%Y %X",localtime( &timer ) );
# #         syb_sys_date[0] = sys_date_time[6];
# #         syb_sys_date[1] = sys_date_time[7];
# #         syb_sys_date[2] = sys_date_time[8];
# #         syb_sys_date[3] = sys_date_time[9];
# #         syb_sys_date[4] = '-';
# #         syb_sys_date[5] = sys_date_time[0];
# #         syb_sys_date[6] = sys_date_time[1];
# #         syb_sys_date[7] = '-';
# #         syb_sys_date[8] = sys_date_time[3];
# #         syb_sys_date[9] = sys_date_time[4];
# #         syb_sys_date[10] = '-';
# #         syb_sys_date[11] = sys_date_time[11];
# #         syb_sys_date[12] = sys_date_time[12];
# #         syb_sys_date[13] = '.';
# #         syb_sys_date[14] = sys_date_time[14];
# #         syb_sys_date[15] = sys_date_time[15];
# #         syb_sys_date[16] = '.';
# #         syb_sys_date[17] = sys_date_time[17];
# #         syb_sys_date[18] = sys_date_time[18];
# #         syb_sys_date[19] = '\0';

# #         EXEC SQL SELECT enum_counter
# #              INTO   :h_enum_counter
# #              FROM   dba.t_person_biograph
# #              WHERE  ssn = :social;

# #     if (SQLCODE < 0)
# #     {
# #         fprintf( err_fp,"Fatal error %ld occured when attempting to get enum counter \
# # n",SQLCODE);
# #         return(0);
# #     }
# #     else
# #     {
# #         if (SQLCODE == 100)
# #         {
# #     fprintf(err_fp,"No record found for ssn = %s enum = %s County is %s\n", social,
# #     enumeration,h_county);
# #            rec_erd++;
# #            return(0);
# #         }
# #     }
# #     if ((strcmp(enumeration,"SS") != 0) && (strcmp(enumeration,"CC") != 0))
# #     {
# #         h_enum_counter += 1;
# #     }

# #         EXEC SQL UPDATE dba.t_person_biograph
# #         SET enumeration = :enumeration,
# #             user_id = 'ANSWER2',
# #             enum_counter = :h_enum_counter,
# #             last_update = :syb_sys_date
# #         WHERE ssn = :social;

# #     if (SQLCODE < 0)
# #     {
# #         fprintf(err_fp,"Fatal error %ld encountered when attempting to update the Person Biograph\n", SQLCODE);
# #         EXEC SQL ROLLBACK;
# #         return(0);
# #     }
# #     else
# #     {
# #         if (SQLCODE == 100)
# #         {
# #            fprintf(err_fp,"No record found for ssn = %s enum = %s County is %s\n", social, enumeration,h_county);
# #            rec_erd++;
# #            return(0);
# #         }
# #         if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
# #         {
# #             fprintf(err_fp,"\nWarning errors encountered when updating the Person Biograph\n\n");
# #         }
# #         if (SQLCODE == 0)
# #         {
# #            EXEC SQL COMMIT; /* PCR # 71090 */
# #         }
# #     }
# #     return(1);
# # }
