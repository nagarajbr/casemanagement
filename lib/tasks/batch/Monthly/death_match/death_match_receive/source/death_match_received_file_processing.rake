task :death_match_received => :environment do
    batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
    error_filename = "batch_results/monthly/death_match/death_match_receive/results/error_death_match_receive_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
    error_path = File.join(Rails.root, error_filename )
    error_file = File.new(error_path,"w+")

    log_filename = "batch_results/monthly/death_match/death_match_receive/results/log_death_match_receive_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
    log_path = File.join(Rails.root, log_filename )
    log_file = File.new(log_path,"w+")

    log_file.puts("Death match receive batch process start: #{Date.today.strftime("%m-%d-%Y")}"+" "+"#{Time.now.strftime("%H-%M-%S")}")
    number_of_records = 0
    number_of_records_updated = 0
    number_of_records_failed = 0
    number_of_batch_records_created = 0
    current_date = Date.today.strftime("%Y-%m-%d")


    f = File.open('batch_results/monthly/death_match/death_match_receive/inbound/death_match_input.txt')
    f.each_line do |line|
    	error_message = " "
		number_of_records = number_of_records + 1
		ssn = line[28,9].to_s
		program_unit_id = line[45,10].to_s
		date_of_death = line[103,8]
		date_of_death = date_of_death[0,4] +"-"+ date_of_death[4,2] +"-"+ date_of_death[6,2]
		date_of_death = date_of_death.to_s
		# Rails.logger.debug("date_of_death = #{date_of_death}")
		client = Client.where("ssn = '#{ssn}'").first
		if client.present?
			if client.update(:death_date => date_of_death)
				if ProgramUnitParticipation.is_program_unit_participation_status_open(program_unit_id) == true
					night_batch = NightlyBatchProcess.new
					night_batch.entity_type = 6524
					night_batch.entity_id = program_unit_id
					night_batch.process_type = 6526
					night_batch.reason = 6608
					night_batch.client_id = client.id
					night_batch.processed = "N"
					night_batch.submit_flag = 'N'
					night_batch.run_month = current_date
					night_batch_record = NightlyBatchProcess.where("entity_type = 6524 and
																	entity_id = ? and
																	process_type = 6526 and
																	reason = 6608 and
																	client_id = ? and
																	processed = 'N' and
																	run_month = ?",
																	program_unit_id,client.id, current_date)
					unless night_batch_record.present?
						night_batch.save
						number_of_batch_records_created = number_of_batch_records_created + 1
					end
					number_of_records_updated = number_of_records_updated + 1
				else
					error_file.puts(line + "  Client not open in program unit"+ "\n")
					number_of_records_failed = number_of_records_failed + 1
				end
			else
				error_file.puts(line + "  Failed to update client record"+ "\n")
				number_of_records_failed = number_of_records_failed + 1
			end
		else
			error_file.puts(line + "  Client record is missing"+ "\n")
			number_of_records_failed = number_of_records_failed + 1
		end
    end
    log_file.puts("Number of records Processed: #{number_of_records}")
    log_file.puts("Number of records updated: #{number_of_records_updated}")
    log_file.puts("Number of batch records created: #{number_of_batch_records_created}")
    log_file.puts("Number of records errored: #{number_of_records_failed}- look at error file for detailed records and the reason for error")
    log_file.puts("Death match receive batch process end: #{Date.today.strftime("%m-%d-%Y")}"+" "+"#{Time.now.strftime("%H-%M-%S")}")
    error_file.close
    log_file.close
end

# /****************************************************************************
# *****************************************************************************
# *                                                                           *
# *  PROGRAM ID:                    task_creation.sqc                         *
# *                                                                           *
# *  DESCRIPTION:                   This program processes the file sent by   *
# *                                 the Health Department. It reads the date  *
# *                                 of death from the file and updates the    *
# *                                 t_person_biograph table and also creates a*
# *                                 task assigned to the generic worker in    *
# *                                 that county for a follow up action.       *
# *                                                                           *
# *  ENTRY POINT:                   Main()                                    *
# *                                                                           *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:                                                       *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  task_creation_input.txt                   *
# *                                                                           *
# *  PORTABILITY NEEDS:             ANSI, POSIX                               *
# *                                                                           *
# *****************************************************************************
# *                             MODIFICATION LOG                              *
# *                                                                           *
# * Version   DATE        SE                 DESCRIPTION                      *
# * --------  ---------   -----------------  ---------------------------------*
# *  1.000    04/16/2004  Samatha B         INITIAL RELEASE, PCR # 69938      *
# * pcr71789  10/14/2005  john davis        changed task due date to 10 days  *
# *                                         from the creation date            *
# * pcr 72934 11/13/2006  Sujeet Patil      Changed to load all Death Matchs, *
# *                                         related to service_county(65,66,67*
# *                                         68,69 to AREA"6" (961G" value)    *
# * pcr 73720 01/25/07    Sujeet Patil      No abend when no record existin   *
# *                                         person_biograph table for SSN     *
# ****************************************************************************/

# /*** INCLUDES ***/
# #include "debug.h"        /* Debug switch                                   */
# #include <stdio.h>        /* UNIX                                           */
# #include <stdlib.h>       /* UNIX                                           */
# #include <malloc.h>       /* UNIX                                           */
# #include <ctype.h>        /* UNIX                                           */
# #include <strings.h>      /* UNIX                                           */
# /*#include <fcntl.h>         file control                                   */
# #include <errno.h>        /* error number for file processing               */
# /*#include <unistd.h>   */    /* for reading flat files                         */
# #include <time.h>         /* DATETIME                                       */
# #include "sqlca.h"        /* Sybase ESQL                                    */
# #include "sqlda.h"        /* Sybase ESQL                                    */

# /* define default error handling routines for SQL calls */

# EXEC SQL INCLUDE SQLCA;
# EXEC SQL BEGIN declare section;

#     static char server[9]        = "aransonl";


# EXEC SQL END declare section;

# int    svrinit(void);
# int    svrdone(void);

# int    ins_cnt =0;
# int    upd_cnt =0;
# char   sys_date_time[26]= "\0";
# char   syb_sys_date[20]= "\0";
# time_t timer;

# FILE    *inputfl;
# FILE    *errfl;
# FILE    *resfl;
# #define    INPUT_FILE            "task_creation_input.txt"
# #define    ERROR_FILE            "task_error_file.txt"
# #define    RESULTS_FILE            "task_creation_results.txt"
# #define    ASSIGNED_TO           "961G"

# void initialise_struct ();
# int update_person_biograph (void);
# int check_open_pend (double);
# int create_task(double, double, int);

# struct file_input
# {
#     char job_execution_date[5];/*julian date*/
#     char full_name[23];
#     char ssn[9];
#     char dob[8];
#     char family_id[10];
#     char service_prog_id[2];
#     char enumeration[1];
#     char name[45];
#     char date_of_death[8];
#     char date_of_birth[8];
#     char backspace;
# } file_info;

# /***************************************************************************
# *                                                                          *
# *  FUNCTION:                 main()                                        *
# *                                                                          *
# *  DESCRIPTION:                                                            *
# *                                                                          *
# *  INPUT PARAMETERS:         None.                                         *
# *                                                                          *
# *  RETURN/EXIT VALUE:        None.                                         *
# *                                                                          *
# *  SPECIAL NOTES:            None.                                         *
# *                                                                          *
# ****************************************************************************/

# int main()
# {
#     char job_execution_date[6];/*julian date*/
#     char full_name[24];
#     char dob[9];
#     char family_id[11];
#     char service_prog_id[3];
#     char enumeration[2];
#     char name[46];
#     char date_of_birth[9];
#     char adh_dob[9];
#     char date_of_death[9];

#     /*  Declarations */
#     int initializations();
#     int shutdown(void);

#     int return_code = 0;
#     int ret_upd = 0;
#     int sz = sizeof(file_info);
#     int len = 0;
#     int n = 0, i = 1;

#     EXEC SQL BEGIN DECLARE SECTION;
#          char ssn[10]= "\0";
#          double clientid = 0;
#     EXEC SQL END DECLARE SECTION;

#     inputfl = fopen(INPUT_FILE, "r");

#     if ( inputfl == NULL)
#     {
#         printf ("Error opening the input file, code = %d\n",inputfl);
#         return(0);
#     }

#     errfl = fopen(ERROR_FILE, "w");
#     if ( errfl == NULL)
#     {
#         printf ("Error opening the Error file, code = %d\n",errfl);
#         return(0);
#     }
#     resfl = fopen(RESULTS_FILE, "w");
#     if ( resfl == NULL)
#     {
#         printf ("Error opening the Results file, code = %d\n",resfl);
#         return(0);
#     }

#     if (( return_code = initializations( ) ) == 0 )
#         return shutdown();
#     fseek (inputfl, 0, SEEK_END);
#     len = ftell(inputfl);
#     n = len/sz;
#     fprintf (resfl,"No of records %d\n",n);


#     while(i <= n)
#     {
#         initialise_struct ();
#         fseek (inputfl, (i-1)*sz, SEEK_SET);
#         i++;
#         fread(&file_info,sizeof(struct file_input), 1, inputfl);
#         strncpy(job_execution_date,file_info.job_execution_date,5);
#         job_execution_date[5] = '\0';
#         strncpy(full_name,file_info.full_name,23);
#         full_name[23] = '\0';
#         strncpy(ssn,file_info.ssn,9);
#         ssn[9] = '\0';
#         strncpy(dob,file_info.dob,8);
#         dob[8] = '\0';
#         strncpy(family_id,file_info.family_id,10);
#         family_id[10] = '\0';
#         strncpy(service_prog_id,file_info.service_prog_id,2);
#         service_prog_id[2] = '\0';
#         strncpy(enumeration,file_info.enumeration,1);
#         enumeration[1] = '\0';
#         strncpy(name,file_info.name,45);
#         name[45] = '\0';
#         strncpy(adh_dob,file_info.date_of_birth,8);
#         adh_dob[8] = '\0';
#         date_of_birth[0] = adh_dob[0];
#         date_of_birth[1] = adh_dob[1];
#         date_of_birth[2] = adh_dob[2];
#         date_of_birth[3] = adh_dob[3];
#         date_of_birth[4] = adh_dob[4];
#         date_of_birth[5] = adh_dob[5];
#         date_of_birth[6] = adh_dob[6];
#         date_of_birth[7] = adh_dob[7];
#         date_of_birth[8] = '\0';
#         strncpy(date_of_death,file_info.date_of_death,8);
#         date_of_death[8] = '\0';
#         printf("%s>>>\n",ssn);
#         if (strcmp (dob, date_of_birth) == 0)
#         {
#             ret_upd =update_person_biograph();
#             if(ret_upd == -1)
#             {
#                 fprintf(errfl,"Error returned from update_person_biograph function\n");
#                 return(-1);
#             }
#             if (ret_upd == 0)
#                 continue;
#              EXEC SQL SELECT CLIENTID
#                       INTO :clientid
#                       FROM DBA.T_PERSON_BIOGRAPH
#                       WHERE SSN = :ssn;

#              if(SQLCODE < 0)
#              {
#                fprintf(errfl,"Error while selecting clientid\n");
#                return(-1);
#              }
#              else if(SQLCODE == 100)
#              {
#                fprintf(resfl,"Clientid not found in T_Person_Biograph for SSN : %s\n",ssn);
#              }
#              else if (SQLCODE ==0)
#              {
#                upd_cnt++;
#                check_open_pend(clientid);
#              }
#         }
#     }

#     fclose(inputfl);
#     fprintf(resfl,"Total Number of Records Updated in T_Person_Biograph table = %d\n",upd_cnt);
#     fprintf(resfl,"Total Number of Records Inserted to T_Work_Order_Task table = %d\n",ins_cnt);
#     fprintf(resfl,"Proper completion of the program!\n");
#     fclose(errfl);
#     fclose(resfl);
#     return (0);
# }

# int initializations()
# {    /* Function:        initializations

#     Description:    Initializes application variables,
#                     report file, allocates memory for the global pointers.
#                     Calls functions to make the initial connect
#                     types of errors that get written to the errored
#                     to the ANSWER database.

#     Input Parameters:

#     Output Parameters:
#                     return value
#     Return Value:
#                    -1  FAILURE
#                     0  FAILURE
#                     1  SUCCESSFUL
# --------------------------------------------------------------------------------
#                              Modifications:

# Version   Comments
# --------------------------------------------------------------------------------
# 1.000         Initial Release
# --------------------------------------------------------------------------------
#     */
#     int return_code = 0;
#     char sys_date_time[26];

#     printf("Starting initializations\n");

#     return_code = svrinit();
#     if(return_code == 0)
#         return (0);
#     else
#         printf("Successful svrinit\n");

#     /* Acquire DATETIME from system */
#     timer = time(NULL);

#     strftime( sys_date_time, sizeof(sys_date_time), "%m/%d/%Y %X",
#               localtime( &timer ) );

#     /* format time for UDB compliance */

#     syb_sys_date[0] = sys_date_time[6];
#     syb_sys_date[1] = sys_date_time[7];
#     syb_sys_date[2] = sys_date_time[8];
#     syb_sys_date[3] = sys_date_time[9];
#     syb_sys_date[4] = '-';
#     syb_sys_date[5] = sys_date_time[0];
#     syb_sys_date[6] = sys_date_time[1];
#     syb_sys_date[7] = '-';
#     syb_sys_date[8] = sys_date_time[3];
#     syb_sys_date[9] = sys_date_time[4];
#     syb_sys_date[10] = '-';
#     syb_sys_date[11] = sys_date_time[11];
#     syb_sys_date[12] = sys_date_time[12];
#     syb_sys_date[13] = '.';
#     syb_sys_date[14] = sys_date_time[14];
#     syb_sys_date[15] = sys_date_time[15];
#     syb_sys_date[16] = '.';
#     syb_sys_date[17] = sys_date_time[17];
#     syb_sys_date[18] = sys_date_time[18];
#     syb_sys_date[19] = '\0';

#     /* end of time format */

#     return 1;
# }

# /**************************************************************************/
# /*                          svrinit function                              */
# /*                                                                        */
# /*   This function is called to establish a connection to the Sybase      */
# /*   SQL Server.                                                          */
# /*                                                                        */
# /**************************************************************************/
# int svrinit(void)
# {    /*
#     Function:       svrinit
#     Description:    This function is called to establish
#                     a connection to the Sybase SQL Server.
#     Input Parameters:
#         none

#     Output Parameters:
#     Return Value:
#              0  FAILURE
#              1  SUCCESSFUL
# --------------------------------------------------------------------------------
#                              Modifications:

# Version   Comments
# --------------------------------------------------------------------------------
# 1.000         Initial Release
# --------------------------------------------------------------------------------
#     */
#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;
#     EXEC SQL INCLUDE SQLCA;


#     printf("Connecting to database\n");

#     /* Open database Connect to DB2 */
#      EXEC SQL CONNECT TO :server;

#     if (SQLCODE < 0)
#     {
#         printf("Fatal error %ld encountered when logging on to DB2.\n", SQLCODE );
#         printf("Server: %s\n\n", server);
#         return(0);
#     }
#     else
#     {
#             if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#             {
#             printf("Warning errors encountered when attempting to logon to DB2.\n");
#             }
#     }

#     EXEC SQL COMMIT;

#     printf("Database connected \n");

#     return(1);
# }

# /***************************************************************************
# *                              SHUTDOWN                                    *
# *                                                                          *
# *  Close all files that were opened from the file openers fn.  Part of the *
# *  finalizations fn.                                                       *
# *                                                                          *
# ***************************************************************************/
# int shutdown()
# {    /*
#     Function:       shutdown
#     Description:    Close all files that were opened from
#                     the file openers fn.  Part of the
#                     finalizations fn.
#     Input Parameters:
#         none

#     Output Parameters:
#     Return Value:
#              1  SUCCESSFUL
# --------------------------------------------------------------------------------
#                              Modifications:

# Version   Comments
# --------------------------------------------------------------------------------
# 1.000     Initial Release
# --------------------------------------------------------------------------------
#     */
#     svrdone();
#     return 1;
# }

# /**************************************************************************/
# /*                          svrdone function                              */
# /*                                                                        */
# /*   This function is called to disconnect from the Sybase SQL Server.    */
# /*                                                                        */
# /**************************************************************************/
# int svrdone()
# {    /*
#     Function:        svrdone
#     Description:    This function is called to disconnect
#                     from the Sybase SQL Server.
#     Input Parameters:
#         none

#     Output Parameters:
#     Return Value:
#              1  SUCCESSFUL
# --------------------------------------------------------------------------------
#                              Modifications:

# Version   Comments
# --------------------------------------------------------------------------------
# 1.000         Initial Release
# --------------------------------------------------------------------------------
#     */
#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;

#     /* Close database and then Disconnect from DB2 */

#     printf ("program about to DISCONNECT\n");

#     EXEC SQL DISCONNECT ALL;
#     printf("finished disconnecting from the database\n");

#     return 1;
# }

# void initialise_struct ()
# {
#     file_info.job_execution_date[0] = '\0';
#     file_info.full_name[0] = '\0';
#     file_info.ssn[0] = '\0';
#     file_info.dob[0] = '\0';
#     file_info.family_id[0] = '\0';
#     file_info.service_prog_id[0] = '\0';
#     file_info.enumeration[0] = '\0';
#     file_info.backspace = '\0';
# }

# int check_open_pend(double clientid)
# {
#     int status_flag = 0;

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#          short nclientid = 0;
#          short nbudget_unit_id = 0;
#          short nparticipation_stat = 0;
#          short napplication_status = 0;
#          short ncurr_bmem_status = 0;
#          short napplication_flag = 0;

#          short icount = 0;

#          double iclientid=0;
#          double curr_clientid=0;
#          double prev_clientid=0;
#          double ibudget_unit_id=0;
#          char icurr_bmem_status[3]="\0";
#          char   iapplication_status[3] = "\0";
#          char iapplication_flag[2] = "\0";

#     EXEC SQL END DECLARE SECTION;

#     iclientid = clientid;

#     EXEC SQL DECLARE clients_crs CURSOR FOR
#     SELECT BUDGET_UNIT_ID,
#            CURR_BMEM_STATUS,
#            APPLICATION_FLAG
#     FROM DBA.T_BUDGET_UNIT_COMP
#     WHERE (CURR_BMEM_STATUS = '01'
#     OR APPLICATION_FLAG = 'R')
#     AND CLIENTID = :iclientid
#     ORDER BY BUDGET_UNIT_ID
#     FOR READ ONLY;

#     EXEC SQL OPEN clients_crs;

#     EXEC SQL FETCH clients_crs
#              INTO :ibudget_unit_id indicator :nbudget_unit_id,
#                   :icurr_bmem_status indicator :ncurr_bmem_status,
#                   :iapplication_flag  indicator :napplication_flag;
#     if(SQLCODE < 0)
#     {
#        printf("Fatal error occured in cursor clients_crs, SQLCODE = %d\n",SQLCODE);
#        EXEC SQL CLOSE clients_crs;
#        return(-1);
#     }

#     while(SQLCODE == 0)
#     {
#         if(strcmp(icurr_bmem_status,"01") == 0)
#         {
#            EXEC SQL SELECT COUNT(*)
#                     INTO :icount
#                     FROM DBA.T_BUDGET_UNIT_PART BUP1
#                     WHERE BUP1.BUDGET_UNIT_ID = :ibudget_unit_id
#                     AND BUP1.PARTICIPATION_STAT = '02'
#                     AND BUP1.BUDGET_UNIT_PH_ID = (SELECT MAX(BUP2.BUDGET_UNIT_PH_ID)
#                                                   FROM DBA.T_BUDGET_UNIT_PART BUP2
#                                                   WHERE BUP2.BUDGET_UNIT_ID = :ibudget_unit_id);
#           if(SQLCODE < 0)
#           {
#              printf("Fatal error occured in curr_bmem_status check, SQLCODE = %d\n",SQLCODE);
#              EXEC SQL CLOSE clients_crs;
#              return(-1);
#           }

#            if(icount >= 1)
#               status_flag =1;

#         }
#         if((strcmp(iapplication_flag,"R")== 0) && status_flag !=1)
#         {

#            EXEC SQL SELECT COUNT(*)
#                     INTO :icount
#                     FROM DBA.T_BUDGET_UNIT_PART BUP1
#                     WHERE BUP1.BUDGET_UNIT_ID = :ibudget_unit_id
#                     AND BUP1.APPLICATION_STATUS = '01'
#                     AND BUP1.BUDGET_UNIT_PH_ID = (SELECT MAX(BUP2.BUDGET_UNIT_PH_ID)
#                                                   FROM DBA.T_BUDGET_UNIT_PART BUP2
#                                                   WHERE BUP2.BUDGET_UNIT_ID = :ibudget_unit_id);
#           if(SQLCODE < 0)
#           {
#              printf("Fatal error occured in application_flag check, SQLCODE = %d\n",SQLCODE);
#              EXEC SQL CLOSE clients_crs;
#              return(-1);
#           }


#            if(icount >= 1)
#               status_flag =2;
#         }

#         if(status_flag !=0)
#         {
#            create_task(iclientid,ibudget_unit_id, status_flag);
#         }

#         status_flag =0;
#         icount = 0;
#         ibudget_unit_id = 0;
#         icurr_bmem_status[0] = '\0';
#         iapplication_flag[0] = '\0';


#         EXEC SQL FETCH clients_crs
#              INTO :ibudget_unit_id indicator :nbudget_unit_id,
#                   :icurr_bmem_status indicator :ncurr_bmem_status,
#                   :iapplication_flag  indicator :napplication_flag;
#     }

#     EXEC SQL CLOSE clients_crs;
#     EXEC SQL COMMIT;
#     return(1);
# }


# int create_task (double clientid, double budget_unit_id,int status_flag )
# {

#     int ct_status_flag =0;
#     int ct_insert_flag =0;
#     int svc_pgm = 0;
#     int batch_reg_no = 0;
#     char dod_fmt[11] = "\0";

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;

#     EXEC SQL BEGIN DECLARE SECTION;
#              short ntemp_task_id =0;
#              short nct_service_program_id =0;
#              short nct_family_id =0;
#              short nct_batch_register_no =0;
#              short nct_service_county =0;
#              short nct_assigned_to =0;
#              short nct_svc_pgm_text = 0;

#              char temp_task_id[61] = "\0";
#              char temp_svc_pgm_id[5] = "\0";
#              char temp_btch_rgtr_no[13] = "\0";

#              double ct_task_id = 0;
#              double ct_householdid = 0;
#              double ct_budget_unit_id = 0;
#              double ct_service_program_id =0;
#              char   ct_family_id[11] = "\0";
#              char   ct_bu_service_county[3] = "\0";
#              double ct_batch_register_no =0;
#              char ct_create_date[30] ="\0";
#              char ct_due_date[30] ="\0";
#              char ct_task[24] = "\0";
#              char ct_task_type[3] = "\0";
#              char ct_instructions[251] = "\0";
#              char ct_status[3] = "\0";
#              char ct_urgency[3] = "\0";
#              char ct_user_id_update[9] = "\0";
#              char ct_last_update_date[30] = "\0";
#              char ct_assigned_by[9] ="\0";
#              char ct_assigned_to[9] ="\0";
#              char ct_svc_pgm_text[36] = "\0";

#     EXEC SQL END DECLARE SECTION;

#     ct_budget_unit_id = budget_unit_id;
#     ct_status_flag = status_flag;


# /* Get the Household id etc columns from T_Budget_Unit table*/

#     EXEC SQL SELECT HOUSEHOLDID,
#                     SERVICE_PROGRAM_ID,
#                     FAMILY_ID,
#                     BATCH_REGISTER_NO,
#                     BU_SERVICE_COUNTY
#              INTO :ct_householdid,
#                   :ct_service_program_id indicator :nct_service_program_id,
#                   :ct_family_id indicator :nct_family_id,
#                   :ct_batch_register_no indicator :nct_batch_register_no,
#                   :ct_bu_service_county indicator :nct_service_county
#              FROM DBA.T_BUDGET_UNIT
#              WHERE BUDGET_UNIT_ID = :ct_budget_unit_id;

#     if(SQLCODE < 0)
#     {
#        fprintf(errfl,"Fatal error while selecting the household id for budget_unit_id = %lf\n", ct_budget_unit_id);
#        return(-1);
#     }
#     else if(SQLCODE ==100)
#     {
#        fprintf(errfl,"No record found for budget_unit_id = %lf\n",ct_budget_unit_id);
#        return(-1);
#     }
#     svc_pgm = ct_service_program_id;

#    switch(svc_pgm)
#    {
#       case 13:
#       case 14:
#       case 33:
#       case 34:
#       case 35:
#       case 43:
#       case 44:
#       case 45:
#                ct_insert_flag = 1;
#                break;
#       default:
#                break;
#    }


# /* Populate Create Date */

#    EXEC SQL SELECT CURRENT TIMESTAMP
#             INTO :ct_create_date
#             FROM SYSIBM.SYSDUMMY1;
#    if(SQLCODE < 0)
#     {
#        fprintf(errfl,"Fatal error while selecting the create date\n");
#        return(-1);
#     }
#     else if(SQLCODE ==100)
#     {
#        fprintf(errfl,"No record found while selecting the create date\n");
#        return(-1);
#     }

# /* Compute Due Date */
# /* pcr 71789 change due date to 10 days into future*/

#     EXEC SQL SELECT (CURRENT TIMESTAMP + 10 DAYS)
#              INTO :ct_due_date
#              FROM SYSIBM.SYSDUMMY1;
#     if(SQLCODE < 0)
#     {
#        fprintf(errfl,"Fatal error while computing the due date\n");
#        return(-1);
#     }
#     else if(SQLCODE ==100)
#     {
#        fprintf(errfl,"No record found while computing the due date\n");
#        return(-1);
#     }

# /* Popupate Task */

#      strcpy(ct_task, file_info.full_name);
#      ct_task[23] = '\0';

# /* Popupate Task Type */

#      strcpy(ct_task_type, "DM");
#      ct_task_type[2] = '\0';

#      EXEC SQL SELECT LTRIM(RTRIM(TITLE))
#               INTO :ct_svc_pgm_text indicator :nct_svc_pgm_text
#               FROM DBA.T_SERVICE_PROGRAM
#               WHERE SERVICE_PROGRAM_ID = :ct_service_program_id;
#     if(SQLCODE < 0)
#     {
#        fprintf(errfl,"Fatal error while selecting the service program title\n");
#        return(-1);
#     }
#     else if(SQLCODE ==100)
#     {
#        fprintf(errfl,"No record found while selecting the service program title\n");
#        return(-1);
#     }
#     else
#     {
#         strcat(ct_svc_pgm_text, '\0');
#     }

# /* Populate Instructions */

#     strcpy(ct_instructions,file_info.full_name);
#     ct_instructions[23] = '\0';
#     strcat(ct_instructions,file_info.ssn);
#     ct_instructions[32] = '\0';
#     strcat(ct_instructions,"  ");
#     strcat(ct_instructions,ct_svc_pgm_text);
#     strcat(ct_instructions,"  ");
#     strcat(ct_instructions,'\0');

#     if (ct_status_flag ==1)
#     {
#         strncat(ct_instructions,ct_family_id,10);
#     }
#     else if(ct_status_flag == 2)
#     {
#         batch_reg_no = ct_batch_register_no;
#         sprintf(temp_btch_rgtr_no, "%d",batch_reg_no);
#         strcat(ct_instructions,temp_btch_rgtr_no);
#     }

#     strcat(ct_instructions," is deceased ");
#     dod_fmt[0] = file_info.date_of_death[4];
#     dod_fmt[1] = file_info.date_of_death[5];
#     dod_fmt[2] = '-';
#     dod_fmt[3] = file_info.date_of_death[6];
#     dod_fmt[4] = file_info.date_of_death[7];
#     dod_fmt[5] = '-';
#     dod_fmt[6] = file_info.date_of_death[0];
#     dod_fmt[7] = file_info.date_of_death[1];
#     dod_fmt[8] = file_info.date_of_death[2];
#     dod_fmt[9] = file_info.date_of_death[3];
#     dod_fmt[10] = '\0';

#     strncat(ct_instructions,dod_fmt,10);
#     strcat(ct_instructions,". Client Profile tab has been updated. Make necessary eligibility changes for the budget unit.");
#     strcat(ct_instructions,'\0');

# /* Populate Status */

#    strcpy(ct_status,"00");
#    ct_status[2] = '\0';

# /* Populate Assigned By */

#    strcpy(ct_assigned_by, "ANSWER");
#    ct_assigned_by[6] = '\0';

# /* Get Assigned To */

#    if ((strcmp (ct_bu_service_county, "65") == 0) || (strcmp (ct_bu_service_county, "66") == 0) ||
#        (strcmp (ct_bu_service_county, "67") == 0) || (strcmp (ct_bu_service_county, "68") == 0) ||
#        (strcmp (ct_bu_service_county, "69") == 0))
#    {
#        strcpy (ct_assigned_to, ASSIGNED_TO);
#    }
#    else
#    {

#       EXEC SQL SELECT LTRIM(RTRIM(CONV_DOMN_VAL))
#                INTO :ct_assigned_to indicator :nct_assigned_to
#                FROM dba.t_domain_conv
#                WHERE host_sys_domn_val = '07'
#                AND domain_code = '83'
#                AND value = :ct_bu_service_county;

#        if(SQLCODE < 0)
#        {
#           fprintf(errfl,"Fatal error while selecting the conv_domn_val\n");
#           return(-1);
#        }
#        else if(SQLCODE ==100)
#        {
#           fprintf(errfl,"No record found while selecting the conv_domn_val");
#           return(-1);
#        }

#        if(nct_assigned_to == -1)
#           strcpy(ct_assigned_to,"");
#        else
#        {
#           strcat(ct_assigned_to,"G");
#           ct_assigned_to[8] = '\0';
#         }
#    }
# /* Assign Urgency */

#    strcpy(ct_urgency,"05");
#    ct_urgency[2] = '\0';

# /* Assign User Id Update */

#    strcpy(ct_user_id_update,"ANSWER2");
#    ct_user_id_update[8]='\0';

# /* Populate Last Update Date */

#    strcpy(ct_last_update_date,ct_create_date);

#    if(ct_insert_flag == 0)
#    {

# /*Generate the work_order_taskid */

#     EXEC SQL SELECT DOMAIN_VALUE
#              INTO :temp_task_id  indicator :ntemp_task_id
#              FROM DBA.T_SYSTEM_PARM
#              WHERE DOMAIN_ID = 2
#              AND SUB_DOMAIN_ID = 35;

#     if (SQLCODE < 0)
#     {
#         fprintf(errfl,"Error while selecting the task id from T_System_Parm table\n");
#         return(-1);
#     }
#     else if (SQLCODE == 100)
#     {
#        fprintf(errfl,"No record found for work_order_task_id in the T_System_Parm table\n");
#        return(-1);
#     }
#     else if (SQLCODE ==0)
#     {
#        ct_task_id = atof(temp_task_id);
#        ct_task_id ++;
#        sprintf(temp_task_id,"%lf", ct_task_id);

#        EXEC SQL UPDATE DBA.T_SYSTEM_PARM
#                 SET DOMAIN_VALUE = :temp_task_id
#                 WHERE DOMAIN_ID = 2
#                 AND SUB_DOMAIN_ID =35;
#       if (SQLCODE < 0)
#       {
#         fprintf(errfl,"Error while updating the T_System_Parm table, SQLCODE = %d\n",SQLCODE);
#         return(-1);
#       }
#       else if (SQLCODE == 100)
#       {
#         fprintf(errfl,"No record found for updating T_System_Parm table, SQLCODE = %d\n",SQLCODE);
#         return(-1);
#       }

#     }

#    EXEC SQL INSERT
#             INTO DBA.T_WORK_ORDER_TASK
#                    (WORK_ORDER_TASKID,
#                     HOUSEHOLDID,
#                     SERVICE_PROGRAM_ID,
#                     BUDGET_UNIT_ID,
#                     CREATE_DATE,
#                     DUE_DATE,
#                     TASK,
#                     TASK_TYPE,
#                     INSTRUCTIONS,
#                     STATUS,
#                     ASSIGNED_BY,
#                     ASSIGNED_TO,
#                     URGENCY,
#                     USER_ID_UPDATE,
#                     LAST_UPDATE_DATE)
#             VALUES
#                    (:ct_task_id,
#                     :ct_householdid,
#                     :ct_service_program_id,
#                     :ct_budget_unit_id,
#                     :ct_create_date,
#                     :ct_due_date,
#                     :ct_task,
#                     :ct_task_type,
#                     :ct_instructions,
#                     :ct_status,
#                     :ct_assigned_by,
#                     :ct_assigned_to,
#                     :ct_urgency,
#                     :ct_user_id_update,
#                     :ct_last_update_date);

#           if(SQLCODE == 0)
#           {
#             ins_cnt++;
#             printf("Work order task id = %lf\n",ct_task_id);
#           }
#           else if (SQLCODE < 0)
#           {
#             fprintf(errfl,"Fatal error while inserting to dba.t_work_order_task table, SQLCODE = %d\n", SQLCODE);

#           }
#          }
# }

# int update_person_biograph (void)
# {

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#         short ndeath_date = 0;

#         char ideath_date[9] = "\0";
#         char upd_death_date[20] = "\0";
#         char ilast_update[20] = "\0";
#         char rssn [10] = "\0";

#     EXEC SQL END DECLARE SECTION;

#     strncpy (ideath_date, file_info.date_of_death, 8);
#     ideath_date[8] = '\0';
#       upd_death_date[0] = ideath_date[0];
#       upd_death_date[1] = ideath_date[1];
#       upd_death_date[2] = ideath_date[2];
#       upd_death_date[3] = ideath_date[3];
#       upd_death_date[4] = '-';
#       upd_death_date[5] = ideath_date[4];
#       upd_death_date[6] = ideath_date[5];
#       upd_death_date[7] = '-';
#       upd_death_date[8] = ideath_date[6];
#       upd_death_date[9] = ideath_date[7];
#       upd_death_date[10] = '-';
#       upd_death_date[11] = '0';
#       upd_death_date[12] = '0';
#       upd_death_date[13] = '.';
#       upd_death_date[14] = '0';
#       upd_death_date[15] = '0';
#       upd_death_date[16] = '.';
#       upd_death_date[17] = '0';
#       upd_death_date[18] = '0';
#       upd_death_date[19] = '\0';

#     strncpy (rssn, file_info.ssn, 9);
#     rssn[9] = '\0';
#     strcpy (ilast_update, syb_sys_date);

#     EXEC SQL
#     UPDATE dba.t_person_biograph
#     SET    death_date = :upd_death_date indicator :ndeath_date,
#            user_id = 'ANSWER2',
#            last_update = :ilast_update
#     WHERE  ssn = :rssn;

#     if(SQLCODE < 0)
#     {
#        fprintf(errfl,"Fatal error while updating the person biograph table for ssn:%s:, SQLCODE = %d\n",rssn,SQLCODE);
#        return(-1);
#     }
#     else if (SQLCODE == 100)
#     {
#         printf("Record not found in t_person_biograph for SSN = %s\n", rssn);
#         return 0;
#     }
#     else
#     {
#        printf("SSN = %s\n",rssn);
#        return 1;
#     }
# }

