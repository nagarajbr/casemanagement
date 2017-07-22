task :death_match_file_creation => :environment do
    batch_user = User.where("uid = '555'").first
    AuditModule.set_current_user=(batch_user)
    extract_filename = "batch_results/monthly/death_match/death_match_send/outbound/death_match_output_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
    extract_path = File.join(Rails.root, extract_filename )
    extract_file = File.new(extract_path,"w+")

    error_filename = "batch_results/monthly/death_match/death_match_send/results/error_death_match_output_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
    error_path = File.join(Rails.root, error_filename )
    error_file = File.new(error_path,"w+")

    log_filename = "batch_results/monthly/death_match/death_match_send/results/log_death_match_output_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
    log_path = File.join(Rails.root, log_filename )
    log_file = File.new(log_path,"w+")

    log_file.puts("Death match batch process start: #{Date.today.strftime("%m-%d-%Y")}"+" "+"#{Time.now.strftime("%H-%M-%S")}")

    success_count = 0
    error_count = 0
    extract_count = 0


    year = Time.now.year.to_s[2..3]
    day = Date.today.yday().to_s
    julian_date = year + day
    active_clients_in_open_PU = Client.get_list_of_active_clients_in_open_program_unit
    active_clients_in_open_PU.each do |client|
        extract_count = extract_count + 1
        error_msg = " "
    	client_record = ''
    	client_record = client_record + julian_date
        name = ''
        if client.last_name?
            name = client.last_name
        else
            error_msg = "Client last name is missing"
        end

        if client.first_name?
            name = name + '  ' +client.first_name
        else
            error_msg =  error_msg + " " + "Client first name is missing"
        end
        name = name.strip[0,23].ljust(23,' ')
        client_record = client_record + name

        if client.ssn?
            client_record = client_record + client.ssn.ljust(9,' ')
        else
            error_msg =  error_msg + " " + "Client SSN is missing"
        end

        if client.dob?
            dob = client.dob.year.to_s
            dob = dob + client.dob.month.to_s.rjust(2,'0')
            dob = dob + client.dob.day.to_s.rjust(2,'0')
            client_record = client_record + dob.ljust(8,' ')
        else
            error_msg =  error_msg + " " + "Client date of birth is missing"
        end

        if client.program_unit_id.present?
            client_record = client_record + client.program_unit_id.to_s.rjust(10,'0')
        else
            error_msg =  error_msg + " " + "Client program unit is missing"
        end

        if client.service_program_id.present?
            client_record = client_record + client.service_program_id.to_s.rjust(2,'0')
        else
            error_msg =  error_msg + " " + "Client service program id is missing"
        end

        client_record = client_record + "  "
        if client_record.length == 59
            client_record = client_record + "\n"
            extract_file.write(client_record)
            success_count = success_count + 1
        else
            error_file.puts(client_record + "  " + error_msg)+ "\n"
            error_count = error_count + 1
        end
        # struct
# {
#     char job_execution_date[6];/*julian date*/
#     char last_name[21];
#     char suffix[5];
#     char first_name[21];
#     char middle_name[2];
#     char ssn[10];
#     char dob[30];
#     char family_id[11];
#     int  service_prog_id;
#     char enumeration[3];
# } file_info;

    end
    log_file.puts("Number of records extracted: #{extract_count}")
    log_file.puts("Number of records processed: #{success_count}")
    log_file.puts("Number of records errored: #{error_count}- look at error file for detailed records and the reason for error")
    log_file.puts("Death match batch process end: #{Date.today.strftime("%m-%d-%Y")}"+" "+"#{Time.now.strftime("%H-%M-%S")}")
    extract_file.close
    error_file.close
    log_file.close
end







# /****************************************************************************
# *****************************************************************************
# *                                                                           *
# *  PROGRAM ID:                    file_creation.sqc                         *
# *                                                                           *
# *  DESCRIPTION:                   This program creates an unduplicated      *
# *                                 extract from ANSWER database to pull all  *
# *                                 the TEA and Food Stamps recipients and    *
# *                                 applicants for all service programs       *
# *                                 without a valid death date. This extract  *
# *                                 will be sent to the Health Department to  *
# *                                 match against their database and send us  *
# *                                 a response file with updates on the death *
# *                                 date.                                     *
# *                                                                           *
# *  ENTRY POINT:                   Main()                                    *
# *                                                                           *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:                                                       *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  file_creation_results.txt                 *
# *                                                                           *
# *  PORTABILITY NEEDS:             ANSI, POSIX                               *
# *                                                                           *
# *****************************************************************************
# *                             MODIFICATION LOG                              *
# *                                                                           *
# * Version   DATE        SE                 DESCRIPTION                      *
# * --------  ---------   -----------------  ---------------------------------*
# *  1.000    01/14/2005  Samatha B         INITIAL RELEASE, PCR # 69938      *
# *  2.000    03/03/2006  Naga Goriparthi   Added code changes for PCR#72699  *
# *                                         to exit out the program with bad  *
# *                                         return code if the program fails. *
# *           07/11/2006  john davis        PCR 73205.  modify code to not    *
# *                                         abend when multiple row are fetched
# *                                         when only 1 should be.            *
# ****************************************************************************/

# /*** INCLUDES ***/
# #include "debug.h"        /* Debug switch                                   */
# #include <stdio.h>        /* UNIX                                           */
# #include <stdlib.h>       /* UNIX                                           */
# #include <malloc.h>       /* UNIX                                           */
# #include <ctype.h>        /* UNIX                                           */
# #include <strings.h>      /* UNIX                                           */
# #include <errno.h>        /* error number for file processing               */
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

# char   sys_date_time[26]= "\0";
# char   syb_sys_date[19]= "\0";
# char   julian_date[6] = "\0";
# time_t timer;

# FILE    *outputf1;
# #define    OUTPUT_FILE            "file_creation_results.txt"


# void initialise_struct ();
# int write_client_to_file (double iclient_idparm,double ibudget_unit_id, int status_flag);
# void create_extract_file(void);
# int get_hsr_id (int b_u_id,int client_idparm,int flag_parm);
# int calc_julian_date (void);

# struct
# {
#     char job_execution_date[6];/*julian date*/
#     char last_name[21];
#     char suffix[5];
#     char first_name[21];
#     char middle_name[2];
#     char ssn[10];
#     char dob[30];
#     char family_id[11];
#     int  service_prog_id;
#     char enumeration[3];
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
#     /*  Declarations */
#     int initializations();
#     int shutdown(void);

#     int return_code = 0;
#     int ret_code_1 = 0;
#     int ret_code_2 = 0;

#     outputf1 = fopen(OUTPUT_FILE, "w+");

#     if ( outputf1 == NULL)
#     {
#         printf ("Error opening the output file, code = %d\n",outputf1);
#         return(-1);
#     }

#     if (( return_code = initializations( ) ) == 0 )
#     {
#         if((ret_code_1 = shutdown() ) !=1)
#         return(-1);
#     }

#     if((ret_code_2 = calc_julian_date())==-1)
#     {
#        printf("Error in calc_julian_date function\n");
#        return(-1);
#     }
#     if( create_file() == 1)
#     {
#         printf( "------------------\n" );
#         printf( "Proper completion of program.\n" );
#     }
#     else
#     {
#         printf(" Program failed with bad return code\n");
#         return (-1);

#     }    /* PCR # 72699 */

#     fclose(outputf1);
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

# version   Comments
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

# int create_file(void)
# {
#     int status_flag = 0;
#     int ret_wtf = 0;

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

#          short ll_count = 0;
#          short icount = 0;

#          double iclientid=0;
#          double curr_clientid=0;
#          double prev_clientid=0;
#          double ibudget_unit_id=0;
#          char icurr_bmem_status[3]="\0";
#          char   iapplication_status[3] = "\0";
#          char iapplication_flag[2] = "\0";

#     EXEC SQL END DECLARE SECTION;

#     EXEC SQL DECLARE clients_crs CURSOR FOR
#     SELECT CLIENTID,
#            BUDGET_UNIT_ID,
#            CURR_BMEM_STATUS,
#            APPLICATION_FLAG
#     FROM DBA.T_BUDGET_UNIT_COMP
#     WHERE (CURR_BMEM_STATUS = '01')
# /*    OR APPLICATION_FLAG = 'R')*/
#     ORDER BY CLIENTID
#     FOR READ ONLY;

#     EXEC SQL OPEN clients_crs;

#     EXEC SQL FETCH clients_crs
#              INTO :iclientid indicator :nclientid,
#                   :ibudget_unit_id indicator :nbudget_unit_id,
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
#      ll_count = 0;
#         EXEC SQL SELECT COUNT (1) INTO :ll_count FROM
#           DBA.T_BUDGET_UNIT_COMP WHERE CLIENTID = :iclientid
#            AND BUDGET_UNIT_ID = :ibudget_unit_id;
#         if ( ll_count > 1)
#         {
#             printf("DUPLICATE CLIENTS IN BUDGET = %f\n",ibudget_unit_id );
#             printf("DUPLICATE CLIENTID = %f\n",iclientid);
#         }
#         else
#         {
#         curr_clientid = iclientid;
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
#         /*else if(strcmp(iapplication_flag,"R")== 0)
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
#          }*/

#         if((curr_clientid != prev_clientid) && (status_flag !=0))
#         {
#            if( (ret_wtf = write_client_to_file(iclientid, ibudget_unit_id,status_flag)) == -1)
#            {
#                printf("Error returned from write_client_to_file function\n");
#                /*return(-1); */
#            }
#            prev_clientid = iclientid;
#         }

#         status_flag =0;
#         icount = 0;
#         iclientid = 0;
#         ibudget_unit_id = 0;
#         icurr_bmem_status[0] = '\0';
#         iapplication_flag[0] = '\0';

#      }
#         EXEC SQL FETCH clients_crs
#              INTO :iclientid indicator :nclientid,
#                   :ibudget_unit_id indicator :nbudget_unit_id,
#                   :icurr_bmem_status indicator :ncurr_bmem_status,
#                   :iapplication_flag  indicator :napplication_flag;
#     }

#     EXEC SQL CLOSE clients_crs;
#     return(1);

# }

# void initialise_struct ()
# {
#     file_info.job_execution_date[0] = '\0';
#     file_info.last_name[0] = '\0';
#     file_info.first_name[0] = '\0';
#     file_info.middle_name[0] = '\0';
#     file_info.ssn[0] = '\0';
#     file_info.dob[0] = '\0';
#     file_info.family_id[0] = '\0';
#     file_info.service_prog_id = 0;
#     file_info.enumeration[0] = '\0';
# }

# int calc_julian_date (void)
# {
#     char temp[4]="\0";
#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#         char ibeginning_year_date[30] = "\0";
#         char icurrent_year_date[19] = "\0";
#         double no_of_days = 0;

#     EXEC SQL END DECLARE SECTION;

#     strcpy (icurrent_year_date, syb_sys_date);

#     ibeginning_year_date[0] = syb_sys_date[0];
#     ibeginning_year_date[1] = syb_sys_date[1];
#     ibeginning_year_date[2] = syb_sys_date[2];
#     ibeginning_year_date[3] = syb_sys_date[3];
#     ibeginning_year_date[4] = '-';
#     ibeginning_year_date[5] = '0';
#     ibeginning_year_date[6] = '1';
#     ibeginning_year_date[7] = '-';
#     ibeginning_year_date[8] = '0';
#     ibeginning_year_date[9] = '1';
#     ibeginning_year_date[10] = '\0';

#     EXEC SQL SELECT days(current date) - days(:ibeginning_year_date)
#              INTO :no_of_days
#              FROM sysibm.sysdummy1;

#     if ((SQLCODE < 0) || (SQLCODE == 100))
#     {
#        printf("Fatal error occured while computing the number of days, SQLCODE = %d\n",SQLCODE);
#        return(-1);

#     }
#     else
#     {
#         no_of_days++;
#         julian_date[0]=ibeginning_year_date[2];
#         julian_date[1]=ibeginning_year_date[3];
#         sprintf(temp,"%.0lf",no_of_days);
#         strcat(julian_date,temp);
#         julian_date[5]='\0';
#     }
# }


# int write_client_to_file (double iclient_idparm,double ibudget_unit_idparm, int status_flagparm)
# {

#     int ret_hsr =0;

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#         short ndeath_date = 0;
#         short nssn = 0;
#         short ndob = 0;
#         short nenumeration = 0;
#         short nlast_name = 0;
#         short nsuffix = 0;
#         short nfirst_name = 0;
#         short nmiddle_name = 0;


#         char ideath_date[30] = "\0";
#         char issn[10] = "\0";
#         char idob[30] = "\0";
#         char ienumeration[3] = "\0";
#         char ilast_name[21] = "\0";
#         char isuffix[5] = "\0";
#         char ifirst_name[21] = "\0";
#         char imiddle_name[2] = "\0";
#         double iclient_id_2 = 0;

#     EXEC SQL END DECLARE SECTION;

#     iclient_id_2 = iclient_idparm;

#     EXEC SQL
#     SELECT a.death_date,
#            a.ssn,a.dob,
#            '  ',
#            ltrim(rtrim(b.last_name)),
#            b.suffix,
#            ltrim(rtrim(b.first_name)),
#            b.middle_name
#     INTO   :ideath_date indicator :ndeath_date,
#            :issn indicator :nssn,
#            :idob indicator :ndob,
#            :ienumeration indicator :nenumeration,
#            :ilast_name   indicator :nlast_name,
#            :isuffix indicator :nsuffix,
#            :ifirst_name  indicator :nfirst_name,
#            :imiddle_name indicator :nmiddle_name
#     FROM   dba.t_person_biograph a, dba.t_person_demograph b
#     WHERE  a.clientid = b.clientid
#     AND    a.clientid = :iclient_id_2;

#     if (SQLCODE < 0)
#     {
#        printf("Fatal error occured while selecting client biograph & demograph info\n");
#        return(-1);
#     }
#     else if (SQLCODE == 100)
#     {
#       /*  printf("Record not in dba.t_person_biograph for clientid %lf \n",iclient_id_2);*/
#     }
#     else if (SQLCODE == 0)
#     {
#         /*if ((ndeath_date == -1) || (strlen(ideath_date) == 0))
#         {*/
#             strcpy (file_info.last_name, ilast_name);
#             strcpy (file_info.suffix, isuffix);
#             strcpy (file_info.first_name, ifirst_name);
#             strcpy (file_info.middle_name, imiddle_name);
#             strcpy (file_info.ssn, issn);
#             strcpy (file_info.dob, idob);
#             strcpy (file_info.enumeration, ienumeration);
#             ret_hsr = get_hsr_id (ibudget_unit_idparm, iclient_idparm,status_flagparm);
#             if(ret_hsr == -1)
#             {
#                 printf("Error from get_hsr_id function for budget unit = %lf\n", ibudget_unit_idparm);
#                 return(-1);
#             }
#             else if(ret_hsr == -2)
#             {
#                 printf("hsr_id or member suffix not found in get_hsr_id function for budget unit = %lf\n", ibudget_unit_idparm);
#             }
#             else
#             {
#                 create_extract_file();
#             }
#         /*}*/
#     }
# }

# void create_extract_file ()
# {
#     char hsr_name[24]="\0";
#     char hsr_dob[9]="\0";
#     char ser_prog_id[3]="\0";

#     strcpy (hsr_name, file_info.last_name);
#    /* strcat (hsr_name, file_info.suffix);*/
#     strcat (hsr_name,"  ");
#     strcat (hsr_name, file_info.first_name);
#  /*   strcat (hsr_name, file_info.middle_name);*/
#     hsr_name[23] = '\0';

#     sprintf (ser_prog_id,"%d",file_info.service_prog_id);
#     hsr_dob[0]=file_info.dob[0];
#     hsr_dob[1]=file_info.dob[1];
#     hsr_dob[2]=file_info.dob[2];
#     hsr_dob[3]=file_info.dob[3];
#     hsr_dob[4]=file_info.dob[5];
#     hsr_dob[5]=file_info.dob[6];
#     hsr_dob[6]=file_info.dob[8];
#     hsr_dob[7]=file_info.dob[9];
#     hsr_dob[8]='\0';

#     fprintf(outputf1,"%5s%-23s%-9s%-8s%-10s%-2s%-2s\n",julian_date, hsr_name,
#             file_info.ssn, hsr_dob, file_info.family_id,
#             ser_prog_id, file_info.enumeration);

# }

# int get_hsr_id (int bu_idparm,int client_idparm,int flag_parm)
# {
#     char ch_temp[4] = "\0";
#     char ch_temp2[11] = "\0";

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#         short nhsr_id_family_id = 0;
#         short nhsr_id_batch_register_id = 0;
#         short nhsr_id_serv_pgm_id = 0;
#         short nhsr_id_member_suffix = 0;

#         double rhsr_id_budget_unit_id = 0;
#         double rhsr_id_clientid = 0;

#         char ihsr_id_family_id [11] = "\0";
#         double ihsr_id_batch_register_id = 0;
#         double ihsr_id_serv_pgm_id = 0;
#         double ihsr_id_member_suffix = 0;

#     EXEC SQL END DECLARE SECTION;

#     rhsr_id_clientid = client_idparm;
#     rhsr_id_budget_unit_id = bu_idparm;

#     EXEC SQL
#     SELECT family_id,
#            batch_register_no,
#            service_program_id
#     INTO   :ihsr_id_family_id indicator :nhsr_id_family_id,
#            :ihsr_id_batch_register_id indicator :nhsr_id_batch_register_id,
#            :ihsr_id_serv_pgm_id indicator :nhsr_id_serv_pgm_id
#     FROM   dba.t_budget_unit
#     WHERE  dba.t_budget_unit.budget_unit_id = :rhsr_id_budget_unit_id;

#     if(SQLCODE < 0)
#     {
#         printf("Fatal error while selecting family id etc, SQLCODE = %d\n",SQLCODE);
#         return(-1);
#     }
#     else if(SQLCODE == 100)
#     {
#         printf("Record not found while selecting family id etc, SQLCODE = %d\n",SQLCODE);
#         return(-2);
#     }

#     else
#     {
#         file_info.service_prog_id = ihsr_id_serv_pgm_id;
#         if (flag_parm == 2)
#         {
#             sprintf(ch_temp2,"%.0lf",ihsr_id_batch_register_id);
#             strcpy(file_info.family_id, ch_temp2);
#         }
#         else if (flag_parm == 1)
#         {
#             if (file_info.service_prog_id == 4)
#                 strcpy (file_info.family_id, ihsr_id_family_id);
#             else
#             {
#                 EXEC SQL
#                 SELECT member_suffix
#                 INTO :ihsr_id_member_suffix indicator :nhsr_id_member_suffix
#                 FROM dba.t_budget_unit_comp
#                 WHERE budget_unit_id = :rhsr_id_budget_unit_id
#                 AND   clientid = :rhsr_id_clientid;

#                 if(SQLCODE < 0)
#                 {
#                    printf("Fatal error while selecting member_suffix, SQLCODE = %d\n",SQLCODE);
#                    return(-1);
#                 }
#                 else if(SQLCODE == 100)
#                 {
#                    printf("Record not found while selecting member suffix, SQLCODE = %d\n",SQLCODE);
#                    return(-2);
#                 }
#                 else
#                 {
#                     if (nhsr_id_member_suffix == -1)
#                     {
#                         strcpy (file_info.family_id, ihsr_id_family_id);
#                     }
#                     else
#                     {
#                         strcpy (file_info.family_id, ihsr_id_family_id);
#                         if(ihsr_id_member_suffix == 1)
#                         {
#                            strcpy(ch_temp,"001");
#                         }
#                         else
#                         {
#                         sprintf (ch_temp,"%.0lf",ihsr_id_member_suffix);
#                         }
#                         ch_temp[3] = '\0';
#                         strcat (file_info.family_id, ch_temp);
#                     }
#                 }
#             }
#         }
#     }
# }
