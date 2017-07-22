# /* PROGRAM DESCRIPTION : This program will read OCSE Sanctions file          *
# *                      and insert records to work order task table.         *
# *                      This program runs on daily basis(Tuesday to Saturday)*
# *                      PCR # 70796 .                                        *
# *                                                                           *
# *                                                                           *
# *  AUTHOR              : Naga S Goriparthi.                                 *
# *  DATE OF WRITTEN     : 10-04-2004.                                        *
# *****************************************************************************
# *                                                                           *
# *  PROGRAM ID:                    ocse_sanction.sqc                         *
# *                                                                           *
# *  DESCRIPTION:                                                             *
# *                                                                           *
# *  ENTRY POINT:                   Main()                                    *
# *                                                                           *
# *  INPUT PARAMETERS:              NONE                                      *
# *                                                                           *
# *  RETURN/EXIT VALUE:                                                       *
# *                                                                           *
# *  INPUT FILES:                   NONE                                      *
# *                                                                           *
# *  OUTPUT FILES:                  ERROR_FILE                                *
# *                                                                           *
# *  PORTABILITY NEEDS:             ANSI, POSIX                               *
# *                                                                           *
# *****************************************************************************
# *                             MODIFICATION LOG                              *
# *                                                                           *
# * Version   DATE        SE                 DESCRIPTION                      *
# * --------  ---------   -----------------  ---------------------------------*
# *  1.000    10/04/2004  Naga Goriparthi    INITIAL RELEASE                  *
# *  2.00     06/20/2005  Naga Goriparthi    Reduce benefits by 25% if the    *
# *                                          is TEA(service prog 20)          *
# *                                          PCR # 71106                      *
# *  3.000    05/15/2006  Naga Goriparthi    Add service program 84 for work  *
# *                                          pays. PCR # 72464.               *
# *  4.000    07/03/2006  Gijun Lee          Fixed known bugs. PCR #          *
# **************************uuuuu*********************************************/

# /*** INCLUDES ***/
# #include <stdio.h>        /* UNIX                                           */
# #include <stdlib.h>       /* UNIX                                           */
# #include <malloc.h>       /* UNIX                                           */
# #include <ctype.h>        /* UNIX                                           */
# #include <strings.h>      /* UNIX                                           */
# #include <errno.h>        /* error number for file processing               */
# #include <unistd.h>       /* for reading flat files                         */
# #include <time.h>         /* DATETIME                                       */
# #include "sqlca.h"        /* UDB ESQL                                       */
# #include "sqlda.h"        /* UDB ESQL                                       */
# #include "ocse_sanction.h"


# /* define default error handling routines for SQL calls */

# EXEC SQL INCLUDE SQLCA;
# EXEC SQL BEGIN declare section;

#     static char id[9]            = "XXXXXXXX";
#     static char pass[9]          = "XXXXXXXX";
#     static char server[9]        = "aransnbt";
#     static char connection[9]    = "xxxxxxxx";


# EXEC SQL END declare section;

# struct budget_sum  /* arrays include null */
# {

#    char host_system_id[19];
#    char service_pgm[11];
#    char action_date[9];
#    char budget_unit_size[3];
#    char tot_earned_inc[9];
#    char tot_unearned_inc[9];
#    char tot_expenses[9];
#    char tot_resources[9];
#    char result[9];
#    char gross_earned[9];
#    char work_deduct[9];
#    char incent_deduct[9];
#    char net_earned[9];
#    char countable_unearned[9];
#    char total_adjusted[9];
#    char bene_amount[9];
#    char earned_inc_deduct[9];
#    char child_care_deduct[9];
#    char net_countable_inc[9];
#    char inc_limit[9];
#    char earned_income[9];
#    char gip_total_unearned_income[9];
#    char gip_farm_loss[9];
#    char gross_income[9];
#    char nir_net_earned[9];
#    char nir_total_unearned_income[9];
#    char nir_farm_loss[9];
#    char standard_deduction[9];
#    char expenses[9];
#    char nir_net_income[9];
#    char rent_mortgage[9];
#    char property_tax[9];
#    char insurance[9];
#    char utilities[9];
#    char total_shelter[9];
#    char fifty_pct_adj_income[9];
#    char excess[9];
#    char allowed_excess[9];
#    char full_benefit[9];
#    char thirty_pct_reduction[9];
#    char benefit_amount[9];
#    char sanction_indicator[2];
#    char action_type[2];
#    char action_reason[4];
#    char filler[18];
#    char eor_marker[2];

# };
# struct budget_sum *budget_sum_p;



# int    svrinit(void);
# int    svrdone(void);

# int     process_budget_teacase(double budget_unit_id,double self_clientid, char *ptr_desc_non_coop,char *member_suffix, double serv_prog_id,char *family_id,double householdid);
# int     get_budget_run_id(double *bwiz_run_id,double *bwiz_mon_id,char *run_date, double budget_unit_id, double serv_prog_id);
# double  get_count_bwiz_mon_id(double bwiz_run_id,double *count_bwiz_mon_id);
# int     determine_mon_id_txn_date(double bwiz_run_id,double *bwiz_mon_id,char *txn_success_date);
# int     determine_mon_id_run_mon(double bwiz_run_id,double *bwiz_mon_id,char *txn_success_date);
# int     process_tea_sanction(double bwiz_run_id,double bwiz_mon_id,double budget_unit_id,
#                              double clientid,char *desc_non_coop,char *member_suffix,
#                              double serv_prog_id,char *family_id,double household_id);
# int     insert_budget_wizard(double bwiz_run_id,double bwiz_mon_id,double new_bwiz_run_id,
#                              double new_bwiz_mon_id);
# int     insert_bu_mo_summary(double bwiz_run_id_pts,double bwiz_mon_id_pts,double new_run_id,
#                              double new_mon_id,double benefit_amt);
# int     update_system_parm(double new_id_value,double domain_id, double sub_dom);

# int     calc_6th_workday(char *date_6wd);
# void    init_budget_sum(struct budget_sum *budget_sum_p);
# void    write_mf_file(struct budget_sum *budget_sum_p);
# int     process_client(char *family_id,char *ptr_desc_non_coop,char *member_suffix);
# int     get_abs_parent_clientid(double budget_unit_id,double *clientid,
#         char *member_suffix);
# int     insert_work_order_taskid(double householdid,double serv_prog_id,double clientid,
#                                  double budget_unit_id,char *ptr_desc_non_coop,char *family_id,
#                                  char *member_suffix,int ret_code);
# int     update_domain_value(double domain_value);
# int     insert_sanction(double budget_unit_id,double clientid,char *ptr_desc_non_coop,
#                     char *member_suffix,double serv_prog_id,int ret_code);
# char    *get_work_order_taskid();
# char    *get_ssn(double clientid);
# int     get_task(double clientid,char *last_name,char *suffix,char *first_name,                                    char *middle_name);
# char    *get_due_date_10();
# void    convert_to_timestamp( char* target, char* source);
# char    *get_county_code(double budget_unit_id);
# char    *get_mf_county_code(char *county_code);
# char    *TRIM(char *String1);
# char    *get_serv_prog_desc(double serv_prog_id);
# int     get_clientid(double budget_unit_id,double *clientid);
# /*Sujeet */
# int     insert_budget_member(double bwiz_run_id_pts,double bwiz_mon_id_pts,double new_run_id,
#                              double new_mon_id);

# void    format_rpts( void );

# char   sys_date_time[26];
# char   syb_sys_date[20];
# int    g_work_order_task;
# time_t timer;
# time_t *timer_p;

# int    record_count      = 0;

# int    g_insert_work_order_taskid = 0;
# int    g_insert_budget_wizard = 0;
# int    g_insert_bu_mo_summary = 0;
# int    g_insert_ans_bwiz_summary  = 0;
# int    g_insert_tea_detail = 0;
# int    g_insert_sanction = 0;
# int    g_insert_budget_member = 0;

# FILE *errorfile;
# #define     ERROR_FILE      "ocse_sanction_res.txt"

# FILE    *mffile;
# #define     MF_FILE       "ocse_mf_ext.txt"


# #define INPUT_SIZE  1024


# #define TRUE                  1
# #define FALSE                 0

# #define SUCCESS               1
# #define FAILURE              -2
# #define NO_TRANSLATION       -3
# #define EDIT_ERROR           -4

# #define EOR_MARKER           '!'
# #define UNKNOWN_PROG         -1.00
# #define NO_PROG               0.00


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
#     int initializations();
#     int shutdown(void);

#     int return_code = 0;
#     char date_6wd1[11] = "\0";

#     char    mn_host_system_id[11] ;
#     char    family_id[8];
#     char    mn_member_suffix[4] ;
#     char    mn_desc_non_coop[101];
#     short   rec_length ;

#     char sz_in_buffer[INPUT_SIZE + 1];



#    FILE *cfptr;
#    struct budget_sum budget_sum_input;
#    budget_sum_p = &budget_sum_input;
#    if (( return_code = initializations( ) ) == 0 )
#    return shutdown();

#    init_budget_sum(budget_sum_p);

#    format_rpts();

#    cfptr = fopen("ocse_sanction_ext.txt", "r");

#    if(cfptr == NULL)
#    {
#       printf("Error opening the input file, code = %d\n", cfptr);
#       exit(-1);
#    }

#    while(fgets(sz_in_buffer,INPUT_SIZE,cfptr) != NULL)
#    {

#         rec_length = strlen(sz_in_buffer);


#         if (strlen(sz_in_buffer) != OCSE_REC_LENGTH)
#         {
#             fprintf(errorfile,"Input file record length is incorrect.\n");
#             printf("record length is: %d\n", rec_length);
#             return(0);
#         }


#         strncpy(mn_host_system_id,&sz_in_buffer[10],10);
#         mn_host_system_id[10] = '\0';
#         strncpy(family_id,mn_host_system_id,7);
#         family_id[7] = '\0';

#         strncpy(mn_member_suffix,&sz_in_buffer[37],3);
#         mn_member_suffix[3] = '\0';

#         strcpy(budget_sum_p->host_system_id,family_id);
#         strcat(budget_sum_p->host_system_id,mn_member_suffix);


#         strncpy(mn_desc_non_coop,&sz_in_buffer[41],100);
#         mn_desc_non_coop[100] = '\0';
#         strcpy(mn_desc_non_coop,TRIM(mn_desc_non_coop));

#         record_count++;

# printf ("Family Id %s \n", budget_sum_p->host_system_id);

#         process_client(family_id,mn_desc_non_coop,mn_member_suffix);
#         init_budget_sum(budget_sum_p);

#    }
#    fprintf(errorfile,"\n");
#    fprintf(errorfile,"Total Number of Records inserted to WORK ORDER TASK TABLE    = %d\n",
#                       g_insert_work_order_taskid);
#    fprintf(errorfile,"Total Number of Records inserted to BUDGET WIZARD TABLE      = %d\n",
#                       g_insert_budget_wizard);
#    fprintf(errorfile,"Total Number of Records inserted to BU MO SUMMARY TABLE      = %d\n",
#                       g_insert_bu_mo_summary);
#    fprintf(errorfile,"Total Number of Records inserted to BUDGET MEMBER      = %d\n",
# 		      g_insert_budget_member);
#    fprintf(errorfile,"Total Number of Records inserted to TEA DETAIL TABLE         = %d\n",
#                       g_insert_tea_detail);
#    fprintf(errorfile,"Total Number of Records inserted to SANCTION   TABLE         = %d\n",
#                       g_insert_sanction);
#    fprintf( errorfile, "Proper completion of program.\n" );
#    fclose(cfptr);
#    return (0);

# }


# /**************************************************************************/
# /*                          svrinit function                              */
# /*                                                                        */
# /*   This function is called to establish a connection to the Sybase      */
# /*   SQL Server.                                                          */
# /*                                                                        */
# /**************************************************************************/

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

# nitial Release
# --------------------------------------------------------------------------------

#     */

#     int return_code = 0;
#     char sys_date_time[26];

#     printf("Starting initializations\n");

#     errorfile = fopen(ERROR_FILE, "w+");
#     if ( errorfile == NULL)
#     {
#         printf ("Error opening the Report file, code = %d\n",errorfile);
#         return(0);
#     }
#     mffile = fopen(MF_FILE, "w+");
#     if ( mffile == NULL)
#     {
#         printf ("Error opening the MMIS file, code = %d\n",mffile);
#         return(0);
#     }

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

#     /* Open database Connect to SYBASE */
#     EXEC SQL CONNECT TO :server;

#     if (SQLCODE < 0)
#     {
#         fprintf(errorfile,"Fatal error %ld encountered when logging on to DB2.\n", SQLCODE );
#         fprintf(errorfile,"Server: %s\nUser: %s\nPassword: %s\n\n", server, id, pass );
#         return(0);
#     }
#     else
#     {
#             if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#             {
#             fprintf(errorfile,"Warning errors encountered when attempting to logon to DB2.\n");
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
#     fclose(errorfile);
#     fclose(mffile);
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

#     /* Close database and then Disconnect from SYBASE */

#     printf ("program about to DISCONNECT\n");

#     EXEC SQL DISCONNECT ALL;
#     printf("finished disconnecting from the database\n");

#     return 1;
# }
# void format_rpts(void)
# {    /*
#     Function         :     format_rpts
#     Description      :     Print out the main header of the
#                            ocse_sanction_res.txt

#     Input Parameters :     none
#     Output Parameters:
#     Return Value     :     none
# --------------------------------------------------------------------------------
#                              Modifications:

# Version   Comments

# --------------------------------------------------------------------------------

# 1.000         Initial Release
# --------------------------------------------------------------------------------

#     */
#     char report_date[30] = "\0";
#     char report_county_name[21] = "\0";
#     strncpy(report_date,syb_sys_date,10);

#     fprintf( errorfile,"%25s  ","\0");
#     fprintf( errorfile,"%-38s\n","OCSE SANCTIONS - NIGHTLY BATCH PROCESSING REPORT ","\0 ");
#     fprintf( errorfile,"Process Date: %-12s\n%",report_date);
#     fprintf( errorfile,"------------------------------------------------\n");

# }
# int process_client(char *family_id,char *ptr_desc_non_coop1,char *member_suffix)
# {


#     int ret_code = 0;
#     int svc_ret_code = 0;

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;


#     short  n_serv_prog_id = 0;
#     short  n_county = 0;
#    short  n_member_sufix = 0;

#     char   pc_family_id[7] = "\0";
#     double pc_householdid = 0;
#     double pc_budget_unit_id = 0;
#     char   pc_county[2] = "\0";
#     char   pc_ssn[9] = "\0";
#     double pc_serv_prog_id = 0;
#     double pc_self_clientid = 0;
#     double pc_member_sufix = 0;

#     EXEC SQL END DECLARE SECTION;

#     strcpy(pc_family_id,family_id);


#    EXEC SQL SELECT  BUDGET_UNIT_ID,
#                     HOUSEHOLDID,
#                     BU_SERVICE_COUNTY,
#                     SERVICE_PROGRAM_ID
#             INTO    :pc_budget_unit_id,
#                     :pc_householdid,
#                     :pc_county             indicator :n_county,
#                     :pc_serv_prog_id       indicator :n_serv_prog_id
#             FROM    dba.t_budget_unit
#             WHERE   family_id = :pc_family_id;

#    if (SQLCODE < 0)
#    {
#         if (SQLCODE == -811)
#         {
#            return 0;
#         }
#         else
#         {
#            fprintf(errorfile,"Failed beceause of SQLCODE in gms %ld\n",SQLCODE);
#            printf("Failed beceause of SQLCODE in gms %ld\n",SQLCODE);
#            EXEC SQL ROLLBACK;
#            svrdone();
#            exit(-1);
#         }
#    }
#    else if (SQLCODE == 100)
#    {
#       fprintf(errorfile,"******** Record not found for the family id :%s\n",
#       pc_family_id);
#       return (0);
#    }
#    else if (SQLCODE == 0)
#    {
#       if(get_clientid(pc_budget_unit_id,&pc_self_clientid))
#       {
#        if ( (pc_serv_prog_id == 20) || (pc_serv_prog_id == 84) ) /* PCR # 72464 */
#        {
#           svc_ret_code = identify_svcpgm(pc_budget_unit_id, pc_serv_prog_id);
#          /* if (svc_ret_code > 0)
#           {
#                insert_work_order_taskid(pc_householdid,pc_serv_prog_id,pc_self_clientid,
#                    pc_budget_unit_id,ptr_desc_non_coop1,pc_family_id,member_suffix,0);
#           }
#           */
#           if (svc_ret_code > 0)
#           {
#             svc_ret_code = 0;
#              ret_code = process_budget_teacase(pc_budget_unit_id,pc_self_clientid,ptr_desc_non_coop1,                                       member_suffix,pc_serv_prog_id,pc_family_id,pc_householdid);
#           }
#           insert_sanction(pc_budget_unit_id,pc_self_clientid,ptr_desc_non_coop1,member_suffix,
#                           pc_serv_prog_id,ret_code);

#           /* if the budget is calcualted,the task should not be inserted also the
#              is sanctioned*/
#           if ((svc_ret_code == 0)  && (ret_code == 0))
#           {
#               insert_work_order_taskid(pc_householdid,pc_serv_prog_id,pc_self_clientid,
#                    pc_budget_unit_id,ptr_desc_non_coop1,pc_family_id,member_suffix,0);
#           }
#           /* A task needs to be written for Family Medicaid programs    */
#        EXEC SQL
#            SELECT a.budget_unit_id,
#                    a.bu_service_county,
#                     a.service_program_id,
#                     a.family_id,
#                     c.clientid,
#                     c.member_suffix
#             INTO    :pc_budget_unit_id,
#                     :pc_county             indicator :n_county,
#                     :pc_serv_prog_id       indicator :n_serv_prog_id,
#                     :pc_family_id,
#                     :pc_self_clientid,
#                     :pc_member_sufix      indicator : n_member_sufix
#             FROM    dba.t_budget_unit a
# inner join dba.t_budget_unit_part b on b.budget_unit_id =a.budget_unit_id
# inner join dba.t_budget_unit_comp c on c.budget_unit_id =a.budget_unit_id and relationship ='00'
#             WHERE   householdid = :pc_householdid
# and a.service_program_id in (01,21,25,26,27,51,52,56,57,61,62,63,64,65,66,67,76,77)
# and b.budget_unit_ph_id = ( select max(budget_unit_ph_id) from dba.t_budget_unit_part
#                      where budget_unit_id = b.budget_unit_id and mf_txn_success_date is not null)
# and participation_stat ='02'
# fetch first row only ;

# if (pc_budget_unit_id > 0)
#         {
#               insert_work_order_taskid(pc_householdid,pc_serv_prog_id,pc_self_clientid,
#                    pc_budget_unit_id,ptr_desc_non_coop1,pc_family_id,member_suffix,ret_code);


#          }
#    }
#        else
#        {

#          insert_work_order_taskid(pc_householdid,pc_serv_prog_id,pc_self_clientid,
#                       pc_budget_unit_id,ptr_desc_non_coop1,pc_family_id,member_suffix,1);
#        }

#        EXEC SQL COMMIT;
#       }

#       return 1;
#    }

# }


# int identify_svcpgm (double budget_unit_id, double serv_prog_id)
# {

# 	 	 EXEC SQL BEGIN DECLARE SECTION;

# 		    double	h_service_program_id_is = 0;
# 		    double	h_budget_unit_id_is = 0;
# 		    double h_count_is = 0;
# 		    short n_count = 0;
#      EXEC SQL END DECLARE SECTION;

# 		 h_budget_unit_id_is = budget_unit_id;
# 		 h_service_program_id_is = serv_prog_id;

#      EXEC SQL SELECT max(BWIZ_RUN_ID) INTO :h_count_is indicator :n_count FROM DBA.T_BUDGET_WIZARD
#      WHERE BWIZ_RUN_ID = (SELECT MAX (BWIZ_RUN_ID) FROM DBA.T_BUDGET_WIZARD
#                               WHERE BUDGET_UNIT_ID = :h_budget_unit_id_is)
#      AND SERVICE_PROGRAM_ID = :h_service_program_id_is;

#      if (SQLCODE < 0)
#      {
#      		fprintf(errorfile,"Failed beceause of SQLCODE in 'identify_svcpgm' SQLCODE %ld\n",SQLCODE);
#         svrdone();
#         exit(-1);
#      }

#      else if (SQLCODE == 100)
#      {
#          return 1;
#      }
#      else if (SQLCODE == 0)
#      {
#         if (n_count = -1)
#         {
# 	   h_count_is= 0;
#         }
#         if( h_count_is > 0 )
#         {
#             EXEC SQL SELECT COUNT(1) INTO :h_count_is FROM DBA.T_BUDGET_WIZARD
#                       WHERE BWIZ_RUN_ID = :h_count_is AND TXN_SUCCESS_DATE IS NOT NULL;
#             if (h_count_is > 0)
#             {
#                 return 1;
#             }
#             return 0;
#         }
#         return 1;
#      }
# }


# int process_budget_teacase(double budget_unit_id,double clientid,char *desc_non_coop,
#                            char *member_suffix, double serv_prog_id,char *family_id,
#                            double household_id)
# {

#     int    ret_code1 = 0;
#     int    ret_code2 = 0;
#     int    cursor_not_empty = 1;
#     double bwiz_run_id_r = 0;
#     double bwiz_mon_id_r = 0;
#     char   bwiz_run_date_r[30] = "\0";
#     double bwiz_run_id_reduct = 0;
#     double bwiz_mon_id_reduct = 0;
#     double bwiz_mon_id1 = 0;
#     double bwiz_mon_id2 = 0;
#     int    ret_code = 0;
#     double benefit_amt = 0;
#     double reduction_amt = 0;
#     double sanction_amt = 0;
#     double count_mon_id = 0;
#     char   txn_date1[30] = "\0";
#     char   txn_date2[30] = "\0";

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     double   budget_unit_id_pbt = 0;
#     double   bwiz_run_id_pbt = 0;
#     double   bwiz_mon_id_pbt = 0;
#     char     retain_ind_pbt[2] = "\0";
#     char     txn_success_date_pbt[30] = "\0";
#     char     bwiz_run_date_pbt[30] = "\0";
#     double   bwiz_mod_id_r = 0;

# 		double	h_service_program_id_pbt= 0;

#     short    n_retain_ind_pbt = 0;
#     short    n_txn_pbt = 0;
#     short    n_run_date_pbt = 0;

#     EXEC SQL END DECLARE SECTION;

# 		h_service_program_id_pbt = serv_prog_id;

#     budget_unit_id_pbt = budget_unit_id;

#    /* Steps for determining run id */
#    /* Determine the run id with greatest Txn_success_date or txn success date with null value*/

#     EXEC SQL DECLARE bccsl_crs CURSOR FOR
#              SELECT A.BWIZ_RUN_ID,
#                     A.BWIZ_MO_ID,
#                     A.RETAIN_IND,
#                     A.TXN_SUCCESS_DATE,
#                     A.BWIZ_RUN_DATE
#              FROM   DBA.T_BUDGET_WIZARD A
#              WHERE  A.BUDGET_UNIT_ID = :budget_unit_id_pbt
#              AND    A.SERVICE_PROGRAM_ID = :h_service_program_id_pbt  /* PCR # 72464 */
#              AND    (A.TXN_SUCCESS_DATE = (SELECT MAX(B.TXN_SUCCESS_DATE)
#                                           FROM   DBA.T_BUDGET_WIZARD B
#                                           WHERE  B.BUDGET_UNIT_ID = :budget_unit_id_pbt
#                                           AND    B.SERVICE_PROGRAM_ID = :h_service_program_id_pbt)
#              OR    (A.TXN_SUCCESS_DATE IS NULL OR LENGTH(TXN_SUCCESS_DATE) = 0))
#              ORDER BY TXN_SUCCESS_DATE ASC,A.BWIZ_RUN_DATE DESC
#              FETCH FIRST ROW ONLY;

#    EXEC SQL OPEN bccsl_crs;

#    while(cursor_not_empty)
#    {

#       EXEC SQL FETCH bccsl_crs
#                INTO :bwiz_run_id_pbt,
#                     :bwiz_mon_id_pbt,
#                     :retain_ind_pbt indicator :n_retain_ind_pbt,
#                     :txn_success_date_pbt indicator :n_txn_pbt,
#                     :bwiz_run_date_pbt indicator :n_run_date_pbt;

#       if (SQLCODE < 0)
#       {
#          fprintf(errorfile,"Failed beceause of SQLCODE in PBT %ld\n",SQLCODE);
#          cursor_not_empty = 0;
#          EXEC SQL CLOSE bccsl_crs;
#          svrdone();
#          exit(-1);
#       }
#       else if (SQLCODE == 100)
#       {
#         /*Need to write this into error file*/
#         fprintf(errorfile,"No RUNID found for the budget_unit_id = %lf\n",budget_unit_id_pbt);
#         printf("family_id1 = %s\n",family_id);
#         printf("Budget Unit Id = %lf\n",budget_unit_id_pbt);
#         cursor_not_empty = 0;
#         EXEC SQL CLOSE bccsl_crs;
#         return 0;
#       }
#       else if (SQLCODE == 0)
#       {
#        /* budget unit id with retain ind R and no txn success date */

#           ret_code1 = get_budget_run_id(&bwiz_run_id_r,&bwiz_mon_id_r,bwiz_run_date_r,
#                                         budget_unit_id_pbt, serv_prog_id);

#          if (ret_code1 == 1)
#          {
#             if (strcmp(bwiz_run_date_r,txn_success_date_pbt) > 0)
#             {
#                bwiz_run_id_reduct = bwiz_run_id_r;
#                bwiz_mon_id_reduct = bwiz_mon_id_r;
#             }
#             else
#             {
#                bwiz_run_id_reduct = bwiz_run_id_pbt;
#                bwiz_mon_id_reduct = bwiz_mon_id_pbt ;
#             }
#        }
#        else if ((n_txn_pbt == 0) || strlen(txn_success_date_pbt) > 0)
#        {
#             bwiz_run_id_reduct = bwiz_run_id_pbt;
#             bwiz_mon_id_reduct = bwiz_mon_id_pbt ;
#        }
#        else
#        {
#            cursor_not_empty = 0;
#            EXEC SQL CLOSE bccsl_crs;
#            return 0;
#        }

#        /* steps for determining budget month id */
#        get_count_bwiz_mon_id(bwiz_run_id_reduct,&count_mon_id);

#        if (count_mon_id > 1)
#        {

#           determine_mon_id_txn_date(bwiz_run_id_reduct,&bwiz_mon_id1,txn_date1);
#           ret_code2 = determine_mon_id_run_mon(bwiz_run_id_reduct,&bwiz_mon_id2,txn_date2);

#          if (ret_code2 == 1)
#          {
#             if (strcmp(txn_date2,txn_date1) > 0)
#             {
#                 bwiz_mon_id_reduct = bwiz_mon_id2;
#             }
#             else
#             {
#                 bwiz_mon_id_reduct = bwiz_mon_id1;

#             }
#          }
#          else
#          {
#             if (strlen(txn_date1) > 0)
#             {
#                 bwiz_mon_id_reduct = bwiz_mon_id1;
#             }
#          }

#        }

#        /* Determine if the benefits have already been reduced - query the t_tea_detail
#           table for the sanction indicator.Reduce benefits only if the sanction indicator
#           has a value of NULL,BLANK OR 'N';
#        */
#        ret_code = process_tea_sanction(bwiz_run_id_reduct,bwiz_mon_id_reduct,budget_unit_id,
#                                        clientid,desc_non_coop,member_suffix,serv_prog_id,
#                                        family_id,household_id);

#        if (ret_code != 1) /* Record not found */
#        {
#         fprintf(errorfile,"Not processed Budget for the Family Id  = %s\n",family_id);
#         printf("family_id = %s\n",family_id);
#         cursor_not_empty = 0;
#         EXEC SQL CLOSE bccsl_crs;
#         return (ret_code);
#        }
#        else
#        {
#           cursor_not_empty = 0;
#           EXEC SQL CLOSE bccsl_crs;
#           return 1;
#        }

#       }
#    }
# }
# int process_tea_sanction(double bwiz_run_id,double bwiz_mon_id,double budget_unit_id,
#                          double clientid,char *desc_non_coop,char *member_suffix,
#                          double serv_prog_id,char *family_id,double household_id)
# {

#     int    ret_code1 = 0;
#     int    ret_code2 = 0;
#     int    ret_code3 = 0;
#     int    ret_code4 = 0;
#     int    ret_code5 = 0;

#     char  chr_benefit_amt[9] = "\0";
#     double benefit_amt = 0;
#     int    int_sanction_amt = 0;
#     double benefit_amt1 = 0;
#     double benefit_amt2 = 0;
#     double dbl_benefit_amt = 0;
#     double dbl_sanction_amt = 0;
#     double reduction_amt = 0;
#     double sanction_amt = 0;
#     double new_run_id = 0;

#     char chr_frac_benefit_amount[3] = "\0";
#     int  int_frac_benefit_amount = 0;
#     char chr_rnd_benefit_amount[9] = "\0";
#     int int_rnd_benefit_amount = 0;

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;


#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     double new_run_id_pts = 0;
#     double new_mon_id_pts = 0;

#     double bwiz_run_id_pts = 0;
#     double bwiz_mon_id_pts = 0;
#     char   sanc_indicator_pts[2] = "\0";

#     double  elig_gross_earned_pts    = 0;
#     short   n_gross_pts              = 0;
#     double  elig_work_deduct_pts     = 0;
#     double  elig_incent_deduct_pts   = 0;
#     double  elig_net_income_pts      = 0;
#     double  elig_tot_unearned_pts    = 0;
#     double  elig_tot_adjusted_pts    = 0;
#     short   n_tot_adjust_pts         = 0;
#     double  ben_gross_earned_pts     = 0;
#     short   n_ben_gross_pts          = 0;
#     double  ben_work_deduction_pts   = 0;
#     short   n_work_deduct_pts        = 0;
#     double  ben_incent_deduct_pts    = 0;
#     short   n_incent_deduct_pts      = 0;
#     double  ben_net_income_pts       = 0;
#     short   n_net_income_pts         = 0;
#     double  ben_total_unearned_pts   = 0;
#     short   n_tot_unearned_pts       = 0;
#     double  ben_total_adjusted_pts   = 0;
#     short   n_tot_adj_pts            = 0;
#     double  full_benefit_pts         = 0;
#     short   n_full_benefit_pts       = 0;
#     double  reduction_pts            = 0;
#     short   n_reduction_pts          = 0;
#     double  sanction_pts             = 0;
#     short   n_sanction_pts           = 0;
#     double  tea_benefit_amount_pts   = 0;
#     short   n_benefit_amount_pts     = 0;
#     double  soc_sec_admin_amt_pts    = 0;
#     short   n_soc_sec_admin_amt_pts  = 0;
#     double  railroad_ret_amt_pts     = 0;
#     short   n_railroad_ret_amt_pts   = 0;
#     double  vet_asst_amt_pts         = 0;
#     short   n_other_unearned_pts     = 0;
#     double  other_unearned_inc_pts   = 0;
#     short   n_other_unearned_inc_pts = 0;
#     double  tea_income_limit_pts     = 0;
#     short   n_tea_income_limit_pts   = 0;
#     short   n_indicator_pts          = 0;



#     EXEC SQL END DECLARE SECTION;

#     bwiz_run_id_pts = bwiz_run_id;
#     bwiz_mon_id_pts = bwiz_mon_id;


#     EXEC SQL SELECT ELIG_GROSS_EARNED,
#                     ELIG_WORK_DEDUCT ,
#                     ELIG_INCENT_DEDUCT,
#                     ELIG_NET_INCOME,
#                     ELIG_TOT_UNEARNED,
#                     ELIG_TOT_ADJUSTED,
#                     BEN_GROSS_EARNED,
#                     BEN_WORK_DEDUCTION,
#                     BEN_INCENT_DEDUCT,
#                     BEN_NET_INCOME,
#                     BEN_TOTAL_UNEARNED,
#                     BEN_TOTAL_ADJUSTED,
#                     FULL_BENEFIT,
#                     REDUCTION,
#                     SANCTION,
#                     TEA_BENEFIT_AMOUNT,
#                     SOC_SEC_ADMIN_AMT,
#                     RAILROAD_RET_AMT,
#                     VET_ASST_AMT,
#                     OTHER_UNEARNED_INC,
#                     TEA_INCOME_LIMIT,
#                     SANCTION_INDICATOR
#              INTO   :elig_gross_earned_pts     indicator :n_gross_pts,
#                     :elig_work_deduct_pts      indicator :n_work_deduct_pts,
#                     :elig_incent_deduct_pts    indicator :n_incent_deduct_pts,
#                     :elig_net_income_pts       indicator :n_net_income_pts,
#                     :elig_tot_unearned_pts     indicator :n_tot_unearned_pts,
#                     :elig_tot_adjusted_pts     indicator :n_tot_adjust_pts,
#                     :ben_gross_earned_pts      indicator :n_ben_gross_pts,
#                     :ben_work_deduction_pts    indicator :n_work_deduct_pts,
#                     :ben_incent_deduct_pts     indicator :n_incent_deduct_pts,
#                     :ben_net_income_pts        indicator :n_net_income_pts,
#                     :ben_total_unearned_pts    indicator :n_tot_unearned_pts,
#                     :ben_total_adjusted_pts    indicator :n_tot_adj_pts,
#                     :full_benefit_pts          indicator :n_full_benefit_pts,
#                     :reduction_pts             indicator :n_reduction_pts,
#                     :sanction_pts              indicator :n_sanction_pts,
#                     :tea_benefit_amount_pts    indicator :n_benefit_amount_pts,
#                     :soc_sec_admin_amt_pts     indicator :n_soc_sec_admin_amt_pts,
#                     :railroad_ret_amt_pts      indicator :n_railroad_ret_amt_pts,
#                     :vet_asst_amt_pts          indicator :n_other_unearned_pts,
#                     :other_unearned_inc_pts    indicator :n_other_unearned_inc_pts,
#                     :tea_income_limit_pts      indicator :n_tea_income_limit_pts,
#                     :sanc_indicator_pts        indicator :n_indicator_pts
#              FROM   DBA.T_TEA_DETAIL
#              where  BWIZ_RUN_ID =  :bwiz_run_id_pts
#              and    BWIZ_MO_ID =  :bwiz_mon_id_pts;


#     if (SQLCODE < 0)
#     {
#         fprintf(errorfile,"Failed beceause of SQLCODE in PTS %ld\n",SQLCODE);
#         svrdone();
#         exit(-1);
#     }
#     else if (SQLCODE == 100)
#     {
#        return 0;
#     }
#     else if (SQLCODE == 0)
#     {
#        n_gross_pts              = 0;
#        n_tot_adjust_pts         = 0;
#        n_ben_gross_pts          = 0;
#        n_work_deduct_pts        = 0;
#        n_incent_deduct_pts      = 0;
#        n_net_income_pts         = 0;
#        n_tot_unearned_pts       = 0;
#        n_tot_adj_pts            = 0;
#        n_full_benefit_pts       = 0;
#        n_reduction_pts          = 0;
#        n_sanction_pts           = 0;
#        n_soc_sec_admin_amt_pts  = 0;
#        n_railroad_ret_amt_pts   = 0;
#        n_other_unearned_pts     = 0;
#        n_other_unearned_inc_pts = 0;
#        n_tea_income_limit_pts   = 0;


#        if ( (n_indicator_pts == -1) || (strlen(sanc_indicator_pts) == 0) ||
#             (strcmp(sanc_indicator_pts,"N") == 0) || (strcmp(sanc_indicator_pts,"n") == 0))
#        {
#           /*Reduce sanction amount by 25% */
#           if (n_benefit_amount_pts == -1)
#               tea_benefit_amount_pts = 0;
#           else
#               n_benefit_amount_pts = 0;

#           /*benefit_amt = tea_benefit_amount_pts;

#           int_sanction_amt = (benefit_amt *  0.25);
#           benefit_amt  = benefit_amt - int_sanction_amt;

#           tea_benefit_amount_pts = benefit_amt;

#           sanction_pts     = int_sanction_amt;
#           n_indicator_pts          = 0;

#           sprintf(budget_sum_p->bene_amount,"%08.00lf",tea_benefit_amount_pts);*/

#           benefit_amt1 = tea_benefit_amount_pts;
#           benefit_amt2 = tea_benefit_amount_pts;


#           dbl_sanction_amt = (benefit_amt1 * 0.25);
#           benefit_amt2 = benefit_amt2 - dbl_sanction_amt ;

#           sprintf(chr_benefit_amt,"%8.2f",benefit_amt2);
#           chr_frac_benefit_amount[0] = chr_benefit_amt[6] ;
#           chr_frac_benefit_amount[1] = chr_benefit_amt[7] ;
#           chr_frac_benefit_amount[2] = '\0';

#           int_frac_benefit_amount = atoi(chr_frac_benefit_amount);

#           if ( int_frac_benefit_amount >= 50)
#           {
#              strncpy(chr_rnd_benefit_amount,chr_benefit_amt,6);
#              chr_rnd_benefit_amount[7] = '\0';
#              int_rnd_benefit_amount = atoi(chr_rnd_benefit_amount);
#              int_rnd_benefit_amount = int_rnd_benefit_amount + 1;
#              tea_benefit_amount_pts = int_rnd_benefit_amount;

#           }
#           else
#           {
#              strncpy(chr_rnd_benefit_amount,chr_benefit_amt,6);
#              chr_rnd_benefit_amount[7] = '\0';
#              int_rnd_benefit_amount = atoi(chr_rnd_benefit_amount);
#              tea_benefit_amount_pts = int_rnd_benefit_amount;

#           }
#             /*tea_benefit_amount_pts = atof(chr_benefit_amt);*/
#              sprintf(budget_sum_p->bene_amount,"%08.00lf",tea_benefit_amount_pts);

#           sanction_pts = benefit_amt1 - tea_benefit_amount_pts ;
#           n_indicator_pts          = 0;



#           get_bwiz_run_id(&new_run_id);
#           new_run_id = new_run_id + 1;

#           new_run_id_pts = new_run_id;
#           new_mon_id_pts = 999999999;

#           ret_code1 = insert_budget_wizard(bwiz_run_id_pts,bwiz_mon_id_pts,new_run_id_pts,
#                                            new_mon_id_pts);


#           if (ret_code1 == 1)
#           {
#             if (!insert_budget_member (bwiz_run_id_pts,bwiz_mon_id_pts,new_run_id_pts, new_mon_id_pts))
#             {
#               fprintf(errorfile,"insert_budget_member Record not inserted for the runid1 = %lf and Family Id %s \n",bwiz_run_id_pts, budget_sum_p->host_system_id);
#              /* EXEC SQL ROLLBACK;
#               svrdone();
#               exit(-1);*/
#             }
#           }
#           else
#           {
#              fprintf(errorfile,"insert_budget_wizard Record not inserted for the runid1 = %lf and Family Id %s \n",bwiz_run_id_pts, budget_sum_p->host_system_id);
#              EXEC SQL ROLLBACK;
#              svrdone();
#              exit(-1);
#           }

#           strcpy(sanc_indicator_pts,"C");

#           if(strlen(sanc_indicator_pts) ==0)
#              n_indicator_pts = -1;
#           else
#              n_indicator_pts = 0;


#           EXEC SQL INSERT INTO DBA.T_TEA_DETAIL(
#                     BWIZ_RUN_ID,
#                     BWIZ_MO_ID,
#                     ELIG_GROSS_EARNED,
#                     ELIG_WORK_DEDUCT ,
#                     ELIG_INCENT_DEDUCT,
#                     ELIG_NET_INCOME,
#                     ELIG_TOT_UNEARNED,
#                     ELIG_TOT_ADJUSTED,
#                     BEN_GROSS_EARNED,
#                     BEN_WORK_DEDUCTION,
#                     BEN_INCENT_DEDUCT,
#                     BEN_NET_INCOME,
#                     BEN_TOTAL_UNEARNED,
#                     BEN_TOTAL_ADJUSTED,
#                     FULL_BENEFIT,
#                     REDUCTION,
#                     SANCTION,
#                     TEA_BENEFIT_AMOUNT,
#                     SOC_SEC_ADMIN_AMT,
#                     RAILROAD_RET_AMT,
#                     VET_ASST_AMT,
#                     OTHER_UNEARNED_INC,
#                     TEA_INCOME_LIMIT,
#                     SANCTION_INDICATOR )
#              VALUES(
#                     :new_run_id_pts,
#                     :new_mon_id_pts,
#                     :elig_gross_earned_pts    indicator :n_gross_pts,
#                     :elig_work_deduct_pts     indicator :n_work_deduct_pts,
#                     :elig_incent_deduct_pts   indicator :n_incent_deduct_pts,
#                     :elig_net_income_pts      indicator :n_net_income_pts,
#                     :elig_tot_unearned_pts    indicator :n_tot_unearned_pts,
#                     :elig_tot_adjusted_pts    indicator :n_tot_adjust_pts,
#                     :ben_gross_earned_pts     indicator :n_ben_gross_pts,
#                     :ben_work_deduction_pts   indicator :n_work_deduct_pts,
#                     :ben_incent_deduct_pts    indicator :n_incent_deduct_pts,
#                     :ben_net_income_pts       indicator :n_net_income_pts,
#                     :ben_total_unearned_pts   indicator :n_tot_unearned_pts,
#                     :ben_total_adjusted_pts   indicator :n_tot_adj_pts,
#                     :full_benefit_pts         indicator :n_full_benefit_pts,
#                     :reduction_pts            indicator :n_reduction_pts,
#                     :sanction_pts             indicator :n_sanction_pts,
#                     :tea_benefit_amount_pts   indicator :n_benefit_amount_pts,
#                     :soc_sec_admin_amt_pts    indicator :n_soc_sec_admin_amt_pts,
#                     :railroad_ret_amt_pts     indicator :n_railroad_ret_amt_pts,
#                     :vet_asst_amt_pts         indicator :n_other_unearned_pts,
#                     :other_unearned_inc_pts   indicator :n_other_unearned_inc_pts,
#                     :tea_income_limit_pts     indicator :n_tea_income_limit_pts,
#                     :sanc_indicator_pts       indicator :n_indicator_pts
#                     );

#           if (SQLCODE < 0)
#           {

#              printf("new_run_id_pts          = %lf\n",new_run_id_pts);
#              printf("new_mon_id_pts          = %lf\n",new_mon_id_pts);
#              printf("elig_gross_earned_pts   = %lf\n",elig_gross_earned_pts);
#              printf("elig_work_deduct_pts    = %lf\n",elig_work_deduct_pts);
#              printf("elig_incent_deduct_pts  = %lf\n",elig_incent_deduct_pts);
#              printf("elig_net_income_pts     = %lf\n",elig_net_income_pts);
#              printf("elig_tot_unearned_pts   = %lf\n",elig_tot_unearned_pts);
#              printf("elig_tot_adjusted_pts   = %lf\n",elig_tot_adjusted_pts);
#              printf("ben_gross_earned_pts    = %lf\n",ben_gross_earned_pts);
#              printf("ben_work_deduction_pts  = %lf\n",ben_work_deduction_pts);
#              printf("ben_incent_deduct_pts   = %lf\n",ben_incent_deduct_pts);
#              printf("ben_net_income_pts      = %lf\n",ben_net_income_pts);
#              printf("ben_total_unearned_pts  = %lf\n",ben_total_unearned_pts);
#              printf("ben_total_adjusted_pts  = %lf\n",ben_total_adjusted_pts);
#              printf("full_benefit_pts        = %lf\n",full_benefit_pts);
#              printf("reduction_pts           = %lf\n",reduction_pts);
#              printf("sanction_pts            = %lf\n",sanction_pts);
#              printf("tea_benefit_amount_pts  = %lf\n",tea_benefit_amount_pts);
#              printf("soc_sec_admin_amt_pts   = %lf\n",soc_sec_admin_amt_pts);
#              printf("railroad_ret_amt_pts    = %lf\n",railroad_ret_amt_pts);
#              printf("vet_asst_amt_pts        = %lf\n",vet_asst_amt_pts);
#              printf("other_unearned_inc_pts  = %lf\n",other_unearned_inc_pts);
#              printf("tea_income_limit_pts    = %lf\n",tea_income_limit_pts);
#              printf("sanc_indicator_pts      = %s\n",sanc_indicator_pts);


#              fprintf(errorfile,"Fatal error encountered when attempting to add to t_tea_detail table %ld\n",SQLCODE);
#              EXEC SQL ROLLBACK;
#              svrdone();
#              exit(-1);
#           }
#           else if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#           {
#                 fprintf(errorfile,"Warning errors encountered when attempting to add to" \
#                                    "t_tea_detail %ld\n",SQLCODE);
#                 EXEC SQL ROLLBACK;
#                 return 0;
#           }
#           else if (SQLCODE == 0)
#           {
#               ++g_insert_tea_detail ;

#               ret_code2 = insert_bu_mo_summary(bwiz_run_id_pts,bwiz_mon_id_pts,new_run_id_pts,
#                                                new_mon_id_pts,tea_benefit_amount_pts);
#               /*if (ret_code2 == 1)
#                  ret_code3 = insert_ans_bwiz_summary(bwiz_run_id_pts,bwiz_mon_id_pts,
#                              new_run_id_pts,new_mon_id_pts,budget_unit_id,clientid);
#               else
#               {
#                  fprintf(errorfile,"Record not inserted for the runid2 = %lf\n",bwiz_run_id_pts);
#                  return 0;
#               }*/
#               if (ret_code2 == 1)
#               {
#                   update_system_parm(new_run_id_pts,2,46);
#                   /*insert_work_order_taskid(household_id,serv_prog_id,clientid,budget_unit_id,
#                                            desc_non_coop,family_id,member_suffix);*/

#                   write_mf_file(budget_sum_p);
#                   return 1;
#               }
#               else
#               {
#                  fprintf(errorfile,"Record not inserted for the runid3 = %lf\n",bwiz_run_id_pts);
#                  EXEC SQL ROLLBACK;
#                  return 0;
#               }
#               /*write_mf_file(budget_sum_p);*/
#           }
#        }
#        else
#        {
#            fprintf(errorfile,"This case already sanctioned - No need to reduce further,RUNID = %lf\n",bwiz_run_id_pts);
#            return 2;
#        }
#     }
# }
# void write_mf_file(struct budget_sum *budget_sum_p)
# {

#     strcpy(budget_sum_p->action_type,"D");

#     strcat(budget_sum_p->host_system_id,"        ");
#     /*strcpy(budget_sum_p->service_pgm,"0000000001");
#     strcpy(budget_sum_p->budget_unit_size,"01");
#     strcpy(budget_sum_p->tot_earned_inc,"00000001");
#     strcpy(budget_sum_p->tot_unearned_inc,"        ");
#     strcpy(budget_sum_p->tot_expenses,"        ");
#     strcpy(budget_sum_p->tot_resources,"        ");
#     strcpy(budget_sum_p->result,"        ");
#     strcpy(budget_sum_p->gross_earned,"        ");
#     strcpy(budget_sum_p->work_deduct,"        ");
#     strcpy(budget_sum_p->incent_deduct,"        ");
#     strcpy(budget_sum_p->net_earned,"        ");
#     strcpy(budget_sum_p->countable_unearned,"        ");
#     strcpy(budget_sum_p->total_adjusted,"        ");
#     strcpy(budget_sum_p->earned_inc_deduct,"        ");
#     strcpy(budget_sum_p->child_care_deduct,"        ");
#     strcpy(budget_sum_p->net_countable_inc,"        ");
#     strcpy(budget_sum_p->inc_limit,"        ");
#     strcpy(budget_sum_p->earned_income,"        ");
#     strcpy(budget_sum_p->gip_total_unearned_income,"        ");
#     strcpy(budget_sum_p->gip_farm_loss,"        ");
#     strcpy(budget_sum_p->gross_income,"        ");
#     strcpy(budget_sum_p->nir_net_earned,"        ");
#     strcpy(budget_sum_p->nir_total_unearned_income,"        ");
#     strcpy(budget_sum_p->nir_farm_loss,"        ");
#     strcpy(budget_sum_p->standard_deduction,"        ");
#     strcpy(budget_sum_p->expenses,"        ");
#     strcpy(budget_sum_p->nir_net_income,"        ");
#     strcpy(budget_sum_p->rent_mortgage,"        ");
#     strcpy(budget_sum_p->property_tax,"        ");
#     strcpy(budget_sum_p->insurance,"        ");
#     strcpy(budget_sum_p->utilities,"        ");
#     strcpy(budget_sum_p->total_shelter,"        ");
#     strcpy(budget_sum_p->fifty_pct_adj_income,"        ");
#     strcpy(budget_sum_p->excess,"        ");
#     strcpy(budget_sum_p->allowed_excess,"        ");
#     strcpy(budget_sum_p->full_benefit,"        ");
#     strcpy(budget_sum_p->thirty_pct_reduction,"        ");
#     strcpy(budget_sum_p->benefit_amount,"        ");
#     strcpy(budget_sum_p->sanction_indicator,"        ");
#     strcpy(budget_sum_p->filler,"                    ");
#     strcpy(budget_sum_p->eor_marker,"!");*/




#     fprintf( mffile,budget_sum_p->host_system_id);

#     strcpy(budget_sum_p->service_pgm,"0000000000");
#     fprintf( mffile,budget_sum_p->service_pgm);

#     fprintf( mffile,budget_sum_p->action_date);

#     strcpy(budget_sum_p->budget_unit_size,"00");
#     fprintf( mffile,budget_sum_p->budget_unit_size);

#     strcpy(budget_sum_p->tot_earned_inc,"00000000");
#     fprintf( mffile,budget_sum_p->tot_earned_inc);

#     strcpy(budget_sum_p->tot_unearned_inc,"00000000");
#     fprintf( mffile,budget_sum_p->tot_unearned_inc);

#     strcpy(budget_sum_p->tot_expenses,"00000000");
#     fprintf( mffile,budget_sum_p->tot_expenses);

#     strcpy(budget_sum_p->tot_resources,"00000000");
#     fprintf( mffile,budget_sum_p->tot_resources);

#     strcpy(budget_sum_p->result,"00000000");
#     fprintf( mffile,budget_sum_p->result);

#     strcpy(budget_sum_p->gross_earned,"00000000");
#     fprintf( mffile,budget_sum_p->gross_earned);

#     strcpy(budget_sum_p->work_deduct,"00000000");
#     fprintf( mffile,budget_sum_p->work_deduct);

#     strcpy(budget_sum_p->incent_deduct,"00000000");
#     fprintf( mffile,budget_sum_p->incent_deduct);

#     strcpy(budget_sum_p->net_earned,"00000000");
#     fprintf( mffile,budget_sum_p->net_earned);

#     strcpy(budget_sum_p->countable_unearned,"00000000");
#     fprintf( mffile,budget_sum_p->countable_unearned);

#     strcpy(budget_sum_p->total_adjusted,"00000000");
#     fprintf( mffile,budget_sum_p->total_adjusted);

#     fprintf( mffile,budget_sum_p->bene_amount);

#     strcpy(budget_sum_p->earned_inc_deduct,"00000000");
#     fprintf( mffile,budget_sum_p->earned_inc_deduct);

#     strcpy(budget_sum_p->child_care_deduct,"00000000");
#     fprintf( mffile,budget_sum_p->child_care_deduct);

#     strcpy(budget_sum_p->net_countable_inc,"00000000");
#     fprintf( mffile,budget_sum_p->net_countable_inc);

#     strcpy(budget_sum_p->inc_limit,"00000000");
#     fprintf( mffile,budget_sum_p->inc_limit);

#     strcpy(budget_sum_p->earned_income,"00000000");
#     fprintf( mffile,budget_sum_p->earned_income);

#     strcpy(budget_sum_p->gip_total_unearned_income,"00000000");
#     fprintf( mffile,budget_sum_p->gip_total_unearned_income);

#     strcpy(budget_sum_p->gip_farm_loss,"00000000");
#     fprintf( mffile,budget_sum_p->gip_farm_loss);

#     strcpy(budget_sum_p->gross_income,"00000000");
#     fprintf( mffile,budget_sum_p->gross_income);

#     strcpy(budget_sum_p->nir_net_earned,"00000000");
#     fprintf( mffile,budget_sum_p->nir_net_earned);

#     strcpy(budget_sum_p->nir_total_unearned_income,"00000000");
#     fprintf( mffile,budget_sum_p->nir_total_unearned_income);

#     strcpy(budget_sum_p->nir_farm_loss,"00000000");
#     fprintf( mffile,budget_sum_p->nir_farm_loss);

#     strcpy(budget_sum_p->standard_deduction,"00000000");
#     fprintf( mffile,budget_sum_p->standard_deduction);

#     strcpy(budget_sum_p->expenses,"00000000");
#     fprintf( mffile,budget_sum_p->expenses);

#     strcpy(budget_sum_p->nir_net_income,"00000000");
#     fprintf( mffile,budget_sum_p->nir_net_income);

#     strcpy(budget_sum_p->rent_mortgage,"00000000");
#     fprintf( mffile,budget_sum_p->rent_mortgage);

#     strcpy(budget_sum_p->property_tax,"00000000");
#     fprintf( mffile,budget_sum_p->property_tax);

#     strcpy(budget_sum_p->insurance,"00000000");
#     fprintf( mffile,budget_sum_p->insurance);

#     /*strcpy(budget_sum_p->property_tax,"00000000");
#     fprintf( mffile,budget_sum_p->property_tax);*/

#     strcpy(budget_sum_p->utilities,"00000000");
#     fprintf( mffile,budget_sum_p->utilities);

#     strcpy(budget_sum_p->total_shelter,"00000000");
#     fprintf( mffile,budget_sum_p->total_shelter);

#     strcpy(budget_sum_p->fifty_pct_adj_income,"00000000");
#     fprintf( mffile,budget_sum_p->fifty_pct_adj_income);

#     strcpy(budget_sum_p->excess,"00000000");
#     fprintf( mffile,budget_sum_p->excess);

#     strcpy(budget_sum_p->allowed_excess,"00000000");
#     fprintf( mffile,budget_sum_p->allowed_excess);

#     strcpy(budget_sum_p->full_benefit,"00000000");
#     fprintf( mffile,budget_sum_p->full_benefit);

#     strcpy(budget_sum_p->thirty_pct_reduction,"00000000");
#     fprintf( mffile,budget_sum_p->thirty_pct_reduction);

#     strcpy(budget_sum_p->benefit_amount,"00000000");
#     fprintf( mffile,budget_sum_p->benefit_amount);

#     strcpy(budget_sum_p->sanction_indicator," ");
#     fprintf( mffile,budget_sum_p->sanction_indicator);

#     strcpy(budget_sum_p->action_type,"D");
#     fprintf(mffile,budget_sum_p->action_type);

#     strcpy(budget_sum_p->action_reason,"226");
#     fprintf( mffile,budget_sum_p->action_reason);

#     strcpy(budget_sum_p->filler,"                 ");
#     fprintf( mffile,budget_sum_p->filler);

#     strcpy(budget_sum_p->eor_marker,"!");
#     fprintf( mffile,budget_sum_p->eor_marker);

#     fprintf( mffile,"\n");

# }
# int update_system_parm(double new_run_id,double domain_id,double sub_domain_id)
# {

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     char   new_run_id_usp[61]  ="\0";
#     double domain_id_usp = 0;
#     double sub_domain_id_usp = 0;

#     EXEC SQL END DECLARE SECTION;

#     domain_id_usp     = domain_id ;
#     sub_domain_id_usp = sub_domain_id;

#     sprintf(new_run_id_usp,"%-10.0f",new_run_id);

#     EXEC SQL UPDATE DBA.T_SYSTEM_PARM
#              SET   DOMAIN_VALUE = :new_run_id_usp
#              WHERE DOMAIN_ID = :domain_id_usp
#              AND   SUB_DOMAIN_ID  = :sub_domain_id_usp;

#     if (SQLCODE < 0)
#     {
#         fprintf(errorfile,"Fatal error encountered when attempting to add to" \
#                 "t_system_parm table %ld\n",SQLCODE);
#         EXEC SQL ROLLBACK;
#         svrdone();
#         exit(-1);
#     }
#     else if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#     {
#          fprintf(errorfile,"Warning errors encountered when attempting to add to" \
#                  "t_system_parm %ld\n",SQLCODE);
#          EXEC SQL ROLLBACK;
#          return 0;
#     }
#     else if (SQLCODE == 0)
#     {
#        return 1;
#     }

# }
# int insert_ans_bwiz_summary(double bwiz_run_id,double bwiz_mon_id,double new_run_id,
#                             double new_mon_id,double budget_unit_id,double clientid)
# {

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     short n_run_id_abs        = 0;
#     short n_work_part_abs     = 0;
#     short n_relation_abs      = 0;
#     short n_satus_abs         = 0;
#     short n_mem_suffix_abs    = 0;
#     short n_user_id_abs       = 0;
#     short n_mo_id_abs         = 0;
#     short n_last_update_abs   = 0;

#     double bwiz_run_id_abs = 0;
#     double bwiz_mon_id_abs = 0;
#     double new_run_id_abs  = 0;
#     double new_mon_id_abs  = 0;
#     double budget_unit_id_abs = 0;
#     double clientid_abs = 0;

#     char   txn_success_date_abs[30] = "\0";
#     char   family_id_abs[10] = "\0";
#     char   run_month_abs[11] = "\0";
#     char   work_part_status_abs[3] = "\0";
#     char   relationship_abs[3] = "\0";
#     char   status_abs[3] = "\0";
#     double member_suffix_abs = 0;
#     char   user_id_abs[9] = "\0";
#     double mo_id_abs = 0;
#     char   last_update_abs[30] = "\0";


#     EXEC SQL END DECLARE SECTION;

#     bwiz_run_id_abs = bwiz_run_id;
#     bwiz_mon_id_abs = bwiz_mon_id;
#     new_run_id_abs  = new_run_id;
#     new_mon_id_abs  = new_mon_id;
#     budget_unit_id_abs = budget_unit_id;
#     clientid_abs = clientid;


#     EXEC SQL SELECT TXN_SUCCESS_DATE,
#                     BWIZ_RUN_ID,
#                     FAMILY_ID,
#                     RUN_MONTH,
#                     WORK_PART_STATUS,
#                     RELATIONSHIP,
#                     STATUS,
#                     MEMBER_SUFFIX,
#                     USER_ID,
#                     MO_ID,
#                     LAST_UPDATE
#              INTO   :txn_success_date_abs,
#                     :bwiz_run_id_abs                  indicator :n_run_id_abs,
#                     :family_id_abs,
#                     :run_month_abs,
#                     :work_part_status_abs             indicator :n_work_part_abs,
#                     :relationship_abs                 indicator :n_relation_abs ,
#                     :status_abs                       indicator :n_satus_abs,
#                     :member_suffix_abs                indicator :n_mem_suffix_abs,
#                     :user_id_abs                      indicator :n_user_id_abs,
#                     :mo_id_abs                        indicator :n_mo_id_abs,
#                     :last_update_abs                  indicator :n_last_update_abs
#              FROM   DBA.T_ANS_BWIZ_SUMMARY
#              WHERE  BUDGET_UNIT_ID = :budget_unit_id_abs
#              AND    CLIENTID       = :clientid_abs
#              AND    TXN_SUCCESS_DATE = (SELECT MAX(A.TXN_SUCCESS_DATE)
#                                         FROM   DBA.T_ANS_BWIZ_SUMMARY A
#                                         WHERE  A.BUDGET_UNIT_ID = :budget_unit_id_abs
#                                         AND    A.CLIENTID       = :clientid_abs) ;

#     if (SQLCODE < 0)
#     {
#         fprintf(errorfile,"Failed beceause of SQLCODE in IBWZ %ld\n",SQLCODE);
#         printf("Clientid = %lf\n",clientid_abs);
#         printf("Budget Unit id = %lf\n",budget_unit_id_abs);
#         svrdone();
#         exit(-1);
#     }
#     else if (SQLCODE == 100)
#     {

#        fprintf(errorfile,"Bypassed beceause of SQLCODE in IBWZ = %ld\n",SQLCODE);
#         printf("Clientid-IBWZ = %lf\n",clientid_abs);
#         printf("Budget Unit id-IBWZ = %lf\n",budget_unit_id_abs);
#        return 0;
#     }
#     else if (SQLCODE == 0)
#     {

#          n_run_id_abs        = 0;
#          n_work_part_abs     = 0;
#          n_relation_abs      = 0;
#          n_satus_abs         = 0;
#          n_mem_suffix_abs    = 0;
#          n_user_id_abs       = 0;
#          n_mo_id_abs         = 0;
#          n_last_update_abs   = 0;

#          strcpy(user_id_abs,"ANSWER2");
#          strcpy(txn_success_date_abs,syb_sys_date);

#          EXEC SQL INSERT INTO DBA.T_ANS_BWIZ_SUMMARY(
#                               BUDGET_UNIT_ID,
#                               CLIENTID,
#                               TXN_SUCCESS_DATE,
#                               BWIZ_RUN_ID,
#                               FAMILY_ID,
#                               RUN_MONTH,
#                               WORK_PART_STATUS,
#                               RELATIONSHIP,
#                               STATUS,
#                               MEMBER_SUFFIX,
#                               USER_ID,
#                               MO_ID,
#                               LAST_UPDATE)
#                         VALUES(
#                               :budget_unit_id_abs,
#                               :clientid_abs,
#                               :txn_success_date_abs,
#                               :bwiz_run_id_abs                   indicator :n_run_id_abs,
#                               :family_id_abs,
#                               :run_month_abs,
#                               :work_part_status_abs              indicator :n_work_part_abs,
#                               :relationship_abs                  indicator :n_relation_abs,
#                               :status_abs                        indicator :n_satus_abs,
#                               :member_suffix_abs                 indicator :n_mem_suffix_abs,
#                               :user_id_abs                       indicator :n_user_id_abs,
#                               :mo_id_abs                         indicator :n_mo_id_abs,
#                               :last_update_abs                   indicator :n_last_update_abs);

#           if (SQLCODE < 0)
#           {
#              fprintf(errorfile,"Fatal error encountered when attempting to add to" \
#                                 " T_ANS_BWIZ_SUMMARY table %ld\n",SQLCODE );

#              printf("budget_unit_id_abs         = %lf\n",budget_unit_id_abs);
#              printf("clientid_abs               = %lf\n",clientid_abs);
#              printf("txn_success_date_abs       = %s\n",txn_success_date_abs);
#              printf("bwiz_run_id_abs            = %lf\n",bwiz_run_id_abs);
#              printf("family_id_abs              = %s\n",family_id_abs);
#              printf("run_month_abs              = %s\n",run_month_abs);
#              printf("work_part_status_abs       = %s\n",work_part_status_abs);
#              printf("relationship_abs           = %s\n",relationship_abs);
#              printf("status_abs                 = %s\n",status_abs);
#              printf("member_suffix_abs          = %lf\n",member_suffix_abs);
#              printf("user_id_abs                = %s\n",user_id_abs);
#              printf("mo_id_abs                  = %s\n",mo_id_abs);
#              printf("last_update_abs            = %s\n",last_update_abs);


#              EXEC SQL ROLLBACK;
#              svrdone();
#              exit(-1);
#           }
#           else if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#           {
#                 fprintf(errorfile,"Warning errors encountered when attempting to add to" \
#                                    "T_ANS_BWIZ_SUMMARY %ld\n",SQLCODE);
#                 EXEC SQL ROLLBACK;
#                 return 0;
#           }
#           else if (SQLCODE == 0)
#           {
#              ++g_insert_ans_bwiz_summary;
#              return 1;
#           }
#     }
# }
# int insert_bu_mo_summary(double bwiz_run_id,double bwiz_mon_id,double new_run_id,
#                          double new_mon_id,double benefit_amt)
# {

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     short  n_budget_unit_size_bms = 0;
#     short  n_tot_earned_inc_bms   = 0;
#     short  n_tot_unearned_inc_bms = 0;
#     short  n_tot_expenses_bms = 0;
#     short  n_tot_resources_bms = 0;
#     short  n_bu_sum_result_bms = 0;
#     short  n_res_pass_fail_ind_bms = 0;

#     double bwiz_run_id_bms = 0;
#     double bwiz_mon_id_bms  = 0;

#     double new_bwiz_run_id_bms = 0;
#     double new_bwiz_mon_id_bms  = 0;
#     double budget_unit_size_bms = 0;
#     double tot_earned_inc_bms = 0;
#     double tot_unearned_inc_bms = 0;
#     double tot_expenses_bms  = 0;
#     double tot_resources_bms = 0;
#     double bu_sum_result_bms = 0;
#     char   res_pass_fail_ind_bms[2]  ="\0" ;


#     EXEC SQL END DECLARE SECTION;

#     bwiz_run_id_bms = bwiz_run_id;
#     bwiz_mon_id_bms =  bwiz_mon_id;
#     new_bwiz_run_id_bms  = new_run_id;
#     new_bwiz_mon_id_bms  = new_mon_id;

#     EXEC SQL SELECT BWIZ_RUN_ID,
#                     BWIZ_MO_ID,
#                     BUDGET_UNIT_SIZE,
#                     TOT_EARNED_INC,
#                     TOT_UNEARNED_INC,
#                     TOT_EXPENSES,
#                     TOT_RESOURCES,
#                     BU_SUM_RESULT,
#                     RES_PASS_FAIL_IND
#              INTO   :bwiz_run_id_bms,
#                     :bwiz_mon_id_bms,
#                     :budget_unit_size_bms             indicator :n_budget_unit_size_bms,
#                     :tot_earned_inc_bms               indicator :n_tot_earned_inc_bms,
#                     :tot_unearned_inc_bms             indicator :n_tot_unearned_inc_bms,
#                     :tot_expenses_bms                 indicator :n_tot_expenses_bms,
#                     :tot_resources_bms                indicator :n_tot_resources_bms,
#                     :bu_sum_result_bms                indicator :n_bu_sum_result_bms,
#                     :res_pass_fail_ind_bms            indicator :n_res_pass_fail_ind_bms
#              FROM   DBA.T_BU_MO_SUMMARY
#              WHERE  BWIZ_RUN_ID = :bwiz_run_id_bms
#              AND    BWIZ_MO_ID = :bwiz_mon_id_bms ;

#    if (SQLCODE < 0)
#     {
#         fprintf(errorfile,"Failed beceause of SQLCODE in IBMS %ld\n",SQLCODE);
#         svrdone();
#         exit(-1);
#     }
#     else if (SQLCODE == 100)
#     {
#        return 0;
#     }
#     else if (SQLCODE == 0)
#     {
#          n_budget_unit_size_bms = 0;
#          n_tot_earned_inc_bms   = 0;
#          n_tot_unearned_inc_bms = 0;
#          n_tot_expenses_bms = 0;
#          n_tot_resources_bms = 0;
#          n_bu_sum_result_bms = 0;
#          n_res_pass_fail_ind_bms = 0;

#          bu_sum_result_bms = benefit_amt;

#          EXEC SQL INSERT INTO DBA.T_BU_MO_SUMMARY(
#                               BWIZ_RUN_ID,
#                               BWIZ_MO_ID,
#                               BUDGET_UNIT_SIZE,
#                               TOT_EARNED_INC,
#                               TOT_UNEARNED_INC,
#                               TOT_EXPENSES,
#                               TOT_RESOURCES,
#                               BU_SUM_RESULT,
#                               RES_PASS_FAIL_IND)
#                        VALUES (
#                               :new_bwiz_run_id_bms,
#                               :new_bwiz_mon_id_bms,
#                               :budget_unit_size_bms       indicator :n_budget_unit_size_bms,
#                               :tot_earned_inc_bms         indicator :n_tot_earned_inc_bms,
#                               :tot_unearned_inc_bms       indicator :n_tot_unearned_inc_bms,
#                               :tot_expenses_bms           indicator :n_tot_expenses_bms,
#                               :tot_resources_bms          indicator :n_tot_resources_bms,
#                               :bu_sum_result_bms          indicator :n_bu_sum_result_bms,
#                               :res_pass_fail_ind_bms      indicator :n_res_pass_fail_ind_bms
#                               );

#           if (SQLCODE < 0)
#           {
#              printf("new_bwiz_run_id_bms    = %lf\n",new_bwiz_run_id_bms);
#              printf("new_bwiz_mon_id_bms    = %lf\n",new_bwiz_mon_id_bms);
#              printf("budget_unit_size_bms   = %lf\n",budget_unit_size_bms);
#              printf("tot_earned_inc_bms     = %lf\n",tot_earned_inc_bms);
#              printf("tot_unearned_inc_bms   = %lf\n",tot_unearned_inc_bms);
#              printf("tot_expenses_bms       = %lf\n",n_tot_expenses_bms);
#              printf("tot_resources_bms      = %lf\n",tot_resources_bms);
#              printf("bu_sum_result_bms      = %lf\n",bu_sum_result_bms);
#              printf("res_pass_fail_ind_bms  = %s\n",res_pass_fail_ind_bms);

#              fprintf(errorfile,"Fatal error encountered when attempting to add to" \
#                                 "T_BU_MO_SUMMARY table %ld\n",SQLCODE );
#              EXEC SQL ROLLBACK;
#              svrdone();
#              exit(-1);
#           }
#           else if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#           {
#                 fprintf(errorfile,"Warning errors encountered when attempting to add to" \
#                                    "T_BU_MO_SUMMARY %ld\n",SQLCODE);
#                 EXEC SQL ROLLBACK;
#                 return 0;
#           }
#           else if (SQLCODE == 0)
#           {
#                ++g_insert_bu_mo_summary ;
#                return 1;

#           }
#     }
# }
# int insert_budget_wizard(double bwiz_run_id,double bwiz_mon_id,double new_bwiz_run_id,
#                          double new_bwiz_mon_id)
# {

#     char  date_6wd_bwz[11] = "\0";
#     char  curr_date_bwz[11] = "\0";

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     double  new_bwiz_run_id_ibwz = 0;
#     double  new_bwiz_mon_id_ibwz = 0;

#     double  bwiz_run_id_ibwz = 0;
#     double  bwiz_mon_id_ibwz = 0;
#     double  budget_unit_id_ibwz = 0;
#     double  service_program_id_ibwz = 0 ;
#     short   n_serv_prog_id_ibwz = 0;
#     char    bwiz_run_month_ibwz[11] = "\0" ;
#     char    user_id_ibwz[9] = "\0";
#     short   n_user_id_ibwz = 0;
#     char    bwiz_run_date_ibwz[30] = "\0";
#     short   n_run_date_ibwz = 0;
#     double  num_budget_months_ibwz = 0;
#     short   n_budget_months_ibwz = 0;
#     char    submit_date_ibwz[30] = "\0";
#     short   n_submit_date_ibwz = 0;
#     char    txn_success_date_ibwz[30] = "\0";
#     short   n_txn_success_date_ibwz = 0;
#     char    bwiz_cat_elig_ind_ibwz[3] = "\0";
#     short   n_cat_elig_ibwz = 0;
#     char    retain_ind_ibwz[2] = "\0";
#     short   n_retain_ind_ibwz = 0;
#     short   n_run_month_ibwz = 0;

#     char    second_foll_date_ibwz[11] = "\0";
#     char    foll_date_ibwz[11] = "\0";

#     EXEC SQL END DECLARE SECTION;

#     bwiz_run_id_ibwz = bwiz_run_id;
#     bwiz_mon_id_ibwz = bwiz_mon_id;


#     new_bwiz_run_id_ibwz = new_bwiz_run_id;
#     new_bwiz_mon_id_ibwz = new_bwiz_mon_id;


#     EXEC SQL SELECT BWIZ_RUN_ID,
#                     BWIZ_MO_ID,
#                     BUDGET_UNIT_ID,
#                     SERVICE_PROGRAM_ID,
#                     BWIZ_RUN_MONTH,
#                     USER_ID,
#                     BWIZ_RUN_DATE,
#                     NUM_BUDGET_MONTHS,
#                     SUBMIT_DATE,
#                     TXN_SUCCESS_DATE,
#                     BWIZ_CAT_ELIG_IND,
#                     RETAIN_IND
#              INTO   :bwiz_run_id_ibwz,
#                     :bwiz_mon_id_ibwz,
#                     :budget_unit_id_ibwz,
#                     :service_program_id_ibwz    indicator :n_serv_prog_id_ibwz,
#                     :bwiz_run_month_ibwz        indicator :n_run_month_ibwz,
#                     :user_id_ibwz               indicator :n_user_id_ibwz,
#                     :bwiz_run_date_ibwz         indicator :n_run_date_ibwz,
#                     :num_budget_months_ibwz     indicator :n_budget_months_ibwz,
#                     :submit_date_ibwz           indicator :n_submit_date_ibwz,
#                     :txn_success_date_ibwz      indicator :n_txn_success_date_ibwz,
#                     :bwiz_cat_elig_ind_ibwz     indicator :n_cat_elig_ibwz,
#                     :retain_ind_ibwz            indicator :n_retain_ind_ibwz
#              FROM   DBA.T_BUDGET_WIZARD
#              WHERE  BWIZ_RUN_ID = :bwiz_run_id_ibwz
#              AND    BWIZ_MO_ID  = :bwiz_mon_id_ibwz ;

#     if (SQLCODE < 0)
#     {
#         fprintf(errorfile,"Failed beceause of SQLCODE in IBWZ %ld\n",SQLCODE);
#         svrdone();
#         exit(-1);
#     }
#     else if (SQLCODE == 100)
#     {
#        return 0;
#     }
#     else if (SQLCODE == 0)
#     {
#          n_serv_prog_id_ibwz       = 0;
#          n_run_month_ibwz          = 0;
#          n_user_id_ibwz            = 0;
#          n_run_date_ibwz           = 0;
#          n_budget_months_ibwz      = 0;
#          n_submit_date_ibwz        = 0;
#          n_txn_success_date_ibwz   = 0;
#          n_cat_elig_ibwz           = 0;
#          n_retain_ind_ibwz         = 0;

#          strncpy(curr_date_bwz,syb_sys_date,10);
#          calc_6th_workday(date_6wd_bwz);

#          if (strcmp(curr_date_bwz,date_6wd_bwz) > 0)
#          {
#            /* process the bwiz_run_month for the second following month */

#              EXEC SQL SELECT ((current date) + 2 months)
#                       INTO :foll_date_ibwz
#                       FROM SYSIBM.SYSDUMMY1 ;

#          }
#          else
#          {
#            /* process the bwiz_run_month for the following month */

#              EXEC SQL SELECT ((current date ) + 1 months)
#                       INTO :foll_date_ibwz
#                       FROM SYSIBM.SYSDUMMY1 ;

#          }

#          strcpy(bwiz_run_month_ibwz,foll_date_ibwz);
#          bwiz_run_month_ibwz[3] = '0';
#          bwiz_run_month_ibwz[4] = '1';

#          budget_sum_p->action_date[0] = bwiz_run_month_ibwz[0];
#          budget_sum_p->action_date[1] = bwiz_run_month_ibwz[1];
#          budget_sum_p->action_date[2] = bwiz_run_month_ibwz[3];
#          budget_sum_p->action_date[3] = bwiz_run_month_ibwz[4];
#          budget_sum_p->action_date[4] = bwiz_run_month_ibwz[6];
#          budget_sum_p->action_date[5] = bwiz_run_month_ibwz[7];
#          budget_sum_p->action_date[6] = bwiz_run_month_ibwz[8];
#          budget_sum_p->action_date[7] = bwiz_run_month_ibwz[9];
#          budget_sum_p->action_date[8] = '\0';

#          strcpy(bwiz_run_date_ibwz,syb_sys_date);
#          submit_date_ibwz[0] = '\0';
#          n_submit_date_ibwz = -1;
#          strcpy(txn_success_date_ibwz,syb_sys_date);
#          strcpy(user_id_ibwz,"ANSWER2");
#          retain_ind_ibwz[0] = '\0';

#          /* indicator values need to be reset before insert - NOTE */
#          EXEC SQL INSERT INTO DBA.T_BUDGET_WIZARD(
#                               BWIZ_RUN_ID,
#                               BWIZ_MO_ID,
#                               BUDGET_UNIT_ID,
#                               SERVICE_PROGRAM_ID,
#                               BWIZ_RUN_MONTH,
#                               USER_ID,
#                               BWIZ_RUN_DATE,
#                               NUM_BUDGET_MONTHS,
#                               SUBMIT_DATE,
#                               TXN_SUCCESS_DATE,
#                               BWIZ_CAT_ELIG_IND,
#                               RETAIN_IND)
#                        VALUES(
#                               :new_bwiz_run_id_ibwz,
#                               :new_bwiz_mon_id_ibwz,
#                               :budget_unit_id_ibwz,
#                               :service_program_id_ibwz  indicator :n_serv_prog_id_ibwz,
#                               :bwiz_run_month_ibwz      indicator :n_run_month_ibwz,
#                               :user_id_ibwz             indicator :n_user_id_ibwz,
#                               :bwiz_run_date_ibwz       indicator :n_run_date_ibwz,
#                               :num_budget_months_ibwz   indicator :n_budget_months_ibwz,
#                               :submit_date_ibwz         indicator :n_submit_date_ibwz,
#                               :txn_success_date_ibwz    indicator :n_txn_success_date_ibwz,
#                               :bwiz_cat_elig_ind_ibwz   indicator :n_cat_elig_ibwz,
#                               :retain_ind_ibwz          indicator :n_retain_ind_ibwz
#                              );
#           if (SQLCODE < 0)
#           {
#              fprintf(errorfile,"Fatal error encountered when attempting to add to" \
#                                 "DBA.T_BUDGET_WIZARD table %ld\n",SQLCODE );

#              printf("new_bwiz_run_id_ibwz    = %lf\n",new_bwiz_run_id_ibwz);
#              printf("new_bwiz_mon_id_ibwz    = %lf\n",new_bwiz_mon_id_ibwz);
#              printf("budget_unit_id_ibwz     = %lf\n",budget_unit_id_ibwz);
#              printf("service_program_id_ibwz = %lf\n",service_program_id_ibwz);
#              printf("bwiz_run_month_ibwz     = %s\n",bwiz_run_month_ibwz);
#              printf("user_id_ibwz            = %s\n",user_id_ibwz);
#              printf("bwiz_run_date_ibwz      = %s\n",bwiz_run_date_ibwz);
#              printf("num_budget_months_ibwz  = %lf\n",num_budget_months_ibwz);
#              printf("submit_date_ibwz        = %s\n",submit_date_ibwz);
#              printf("txn_success_date_ibwz   = %s\n",txn_success_date_ibwz);
#              printf("bwiz_cat_elig_ind_ibwz  = %s\n",bwiz_cat_elig_ind_ibwz);
#              printf("retain_ind_ibwz         = %s\n",retain_ind_ibwz);

#              EXEC SQL ROLLBACK;
#              svrdone();
#              exit(-1);
#           }
#           else if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#           {
#                 fprintf(errorfile,"Warning errors encountered when attempting to add to" \
#                                    "DBA.T_BUDGET_WIZARD %ld\n",SQLCODE);
#                 EXEC SQL ROLLBACK;
#                 return 0;
#           }
#           else if (SQLCODE == 0)
#           {
#              ++g_insert_budget_wizard ;
#              return 1;
#           }
#     }

# }
# /*sujeet*/
# int insert_budget_member(double bwiz_run_id,double bwiz_mon_id,double new_run_id,
#                          double new_mon_id)
# {
#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     short b_count = 0;
#     double bwiz_run_id_bm = 0;
#     double bwiz_mon_id_bm  = 0;

#     double new_bwiz_run_id_bm = 0;
#     double new_bwiz_mon_id_bm  = 0;

#     EXEC SQL END DECLARE SECTION;

#     bwiz_run_id_bm = bwiz_run_id;
#     bwiz_mon_id_bm =  bwiz_mon_id;
#     new_bwiz_run_id_bm  = new_run_id;
#     new_bwiz_mon_id_bm  = new_mon_id;

#     EXEC SQL SELECT COUNT (*)
#              INTO   :b_count
#              FROM   DBA.T_BUDGET_MEMBER
#              WHERE  BWIZ_RUN_ID = :bwiz_run_id_bm
#              AND    BWIZ_MO_ID = :bwiz_mon_id_bm ;

#    if (SQLCODE < 0)
#     {
#         fprintf(errorfile,"Failed beceause of SQLCODE in IBMS %ld\n",SQLCODE);
#         svrdone();
#         exit(-1);
#     }
#     else if (SQLCODE == 100)
#     {
#        return 0;
#     }
#     else if (b_count <= 0)
#     {
#        return 0;
#     }
#     else if (SQLCODE == 0)
#     {
#       if (b_count > 0)
#       {
# 	   EXEC SQL INSERT INTO DBA.T_BUDGET_MEMBER
# 		SELECT :new_bwiz_run_id_bm,
#                        :new_bwiz_mon_id_bm,
# 		       BMEMBER_ID,
# 		       CLIENT_ID,
# 		       B_MEMBER_STATUS
# 		FROM DBA.T_BUDGET_MEMBER
# 			WHERE BWIZ_RUN_ID = :bwiz_run_id_bm
# 			AND BWIZ_MO_ID = :bwiz_mon_id_bm;
#           if (SQLCODE < 0)
#           {
#              printf("new_bwiz_run_id_bm    = %lf\n",new_bwiz_run_id_bm);
#              printf("new_bwiz_mon_id_bm    = %lf\n",new_bwiz_mon_id_bm);

#              fprintf(errorfile,"Fatal error encountered when attempting to add to" \
#                                 "T_BUDGET_MEMBER table %ld\n",SQLCODE );
#              EXEC SQL ROLLBACK;
#              svrdone();
#              exit(-1);
#           }
#           else if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#           {
#                 fprintf(errorfile,"Warning errors encountered when attempting to add to" \
#                                    "T_BUDGET_MEMBER %ld\n",SQLCODE);
#                 EXEC SQL ROLLBACK;
#                 return 0;
#           }
#           else if (SQLCODE == 0)
#           {
#                ++g_insert_budget_member;
#                return 1;

#           }
# 	}
# 	else
# 	{
# 		return 0;
# 	}
#     }

# }
# /*sujeet*/
# int get_bwiz_run_id(double *run_id)
# {

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     short nrun_id;
#     char  i_run_id[61];

#     EXEC SQL END DECLARE SECTION;

#     EXEC SQL SELECT DOMAIN_VALUE
#     INTO  :i_run_id  INDICATOR :nrun_id
#     FROM  DBA.T_SYSTEM_PARM
#     WHERE DOMAIN_ID = 2
#     AND   SUB_DOMAIN_ID = 46;

#     if (SQLCODE < 0)
#     {
#         fprintf(errorfile,"Failed beceause of SQLCODE in GRID %ld\n",SQLCODE);
#         svrdone();
#         exit(-1);
#     }
#     else if (SQLCODE == 100)
#     {
#        *run_id = 0;
#        return 0;
#     }
#     else if (SQLCODE == 0)
#     {

#       *run_id = atof(i_run_id);
#     }
# }
# int determine_mon_id_txn_date(double bwiz_run_id,double *bwiz_mon_id,char *txn_success_date)
# {

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     double bwiz_run_id_dmt = 0;
#     double bwiz_mon_id_dmt = 0;
#     char   txn_success_date_dmt[30] = "\0";
#     short  n_txn_date_dmt = 0;

#     EXEC SQL END DECLARE SECTION;

#     bwiz_run_id_dmt = bwiz_run_id;

#     EXEC SQL SELECT BWIZ_MO_ID,TXN_SUCCESS_DATE
#              INTO   :bwiz_mon_id_dmt,
#                     :txn_success_date_dmt  indicator :n_txn_date_dmt
#              FROM   DBA.T_BUDGET_WIZARD
#              WHERE  BWIZ_RUN_ID = :bwiz_run_id_dmt
#              AND    TXN_SUCCESS_DATE = (SELECT MAX(TXN_SUCCESS_DATE)
#                                         FROM   DBA.T_BUDGET_WIZARD
#                                         WHERE  BWIZ_RUN_ID = :bwiz_run_id_dmt);

#      if (SQLCODE < 0)
#      {
#          fprintf(errorfile,"Failed beceause of SQLCODE in PBT %ld\n",SQLCODE);
#          svrdone();
#          exit(-1);
#      }
#      else if (SQLCODE == 100)
#      {
#         *bwiz_mon_id = 0;
#         txn_success_date[0] = '\0';
#         return 0;
#      }
#      else if (SQLCODE == 0)
#      {
#         *bwiz_mon_id = bwiz_mon_id_dmt;
#          if (n_txn_date_dmt == -1)
#             txn_success_date_dmt[0] = '\0';
#          strcpy(txn_success_date,txn_success_date_dmt);
#          return 1;

#      }

# }
# int  determine_mon_id_run_mon(double bwiz_run_id,double *bwiz_mon_id,char *txn_success_date)
# {

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     double bwiz_run_id_dmi = 0;
#     double bwiz_mon_id_dmi = 0;
#     char   txn_success_date_dmi[30] = "\0";
#     short  n_txn_date_dmi = 0;

#     EXEC SQL END DECLARE SECTION;

#     bwiz_run_id_dmi = bwiz_run_id;

#     EXEC SQL SELECT BWIZ_MO_ID,TXN_SUCCESS_DATE
#              INTO   :bwiz_mon_id_dmi,
#                     :txn_success_date_dmi  indicator :n_txn_date_dmi
#              FROM   DBA.T_BUDGET_WIZARD
#              WHERE  BWIZ_RUN_ID = :bwiz_run_id_dmi
#              AND    RETAIN_IND = 'R'
#              AND    BWIZ_RUN_MONTH = (SELECT MAX(BWIZ_RUN_MONTH)
#                                       FROM   DBA.T_BUDGET_WIZARD
#                                       WHERE  BWIZ_RUN_ID = :bwiz_run_id_dmi
#                                       AND    RETAIN_IND = 'R');

#       if (SQLCODE < 0)
#       {
#          fprintf(errorfile,"Failed beceause of SQLCODE in PBT %ld\n",SQLCODE);
#          svrdone();
#          exit(-1);
#       }
#       else if (SQLCODE == 100)
#       {
#          *bwiz_mon_id = 0;
#           txn_success_date[0] = '\0';
#           return 0;
#       }
#       else if (SQLCODE == 0)
#       {
#          *bwiz_mon_id = bwiz_mon_id_dmi;
#          if (n_txn_date_dmi == -1)
#             txn_success_date_dmi[0] = '\0';
#          strcpy(txn_success_date,txn_success_date_dmi);
#           return 1;
#       }

# }
# double get_count_bwiz_mon_id(double bwiz_run_id,double *count_bwiz_mon_id)
# {


#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;

#     EXEC SQL BEGIN DECLARE SECTION;

#     double bwiz_run_id_gcw = 0;
#     double count_mon_id_gcw = 0;

#     EXEC SQL END DECLARE SECTION;

#     bwiz_run_id_gcw = bwiz_run_id ;

#     EXEC SQL SELECT COUNT(BWIZ_MO_ID)
#              INTO   :count_mon_id_gcw
#              FROM   DBA.T_BUDGET_WIZARD
#              WHERE  BWIZ_RUN_ID = :bwiz_run_id_gcw ;

#     if (SQLCODE < 0)
#     {
#        fprintf(errorfile,"Failed beceause of SQLCODE in GCW %ld\n",SQLCODE);
#        svrdone();
#        exit(-1);
#     }
#     else if (SQLCODE == 100)
#     {
#          *count_bwiz_mon_id = 0;
#     }
#     else if (SQLCODE == 0)
#     {
#          *count_bwiz_mon_id = count_mon_id_gcw;
#     }

#     return 1;
# }
# int get_budget_run_id(double *bwiz_run_id,double *bwiz_mon_id,char *run_date,double budget_unit_id, double serv_prog_id)
# {

#     int  cursor_not_empty = 1;
#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     double   budget_unit_id_pbr = 0;
#     double   bwiz_run_id_pbr = 0;
#     double   bwiz_mo_id_pbr = 0;
#     char     retain_ind_pbr[2] = "\0";
#     char     txn_success_date_pbr[30] = "\0";
#     char     bwiz_run_date_pbr[30] = "\0";

#     short    n_retain_ind_pbr = 0;
#     short    n_txn_pbr = 0;
#     short    n_run_date_pbr = 0;

# 		double   h_service_program_id_gbri = 0;
#     EXEC SQL END DECLARE SECTION;

# 	  h_service_program_id_gbri = serv_prog_id;

#     budget_unit_id_pbr = budget_unit_id;

#     EXEC SQL DECLARE bwiz_crs CURSOR FOR
#              SELECT BWIZ_RUN_ID,
#                     BWIZ_MO_ID,
#                     RETAIN_IND,
#                     TXN_SUCCESS_DATE,
#                     BWIZ_RUN_DATE
#              FROM   DBA.T_BUDGET_WIZARD
#              WHERE  SERVICE_PROGRAM_ID IN (20,84)  /* 72464 */
#              AND    RETAIN_IND = 'R'
#              AND    BUDGET_UNIT_ID = :budget_unit_id_pbr
#              AND    SERVICE_PROGRAM_ID = :h_service_program_id_gbri
#              AND    (TXN_SUCCESS_DATE IS NULL OR LENGTH(TXN_SUCCESS_DATE) = 0)
#              ORDER BY BWIZ_RUN_DATE DESC
#              FETCH FIRST ROW ONLY;

#    EXEC SQL OPEN bwiz_crs;

#    while(cursor_not_empty)
#    {
#       EXEC SQL FETCH bwiz_crs
#                INTO :bwiz_run_id_pbr,
#                     :bwiz_mo_id_pbr,
#                     :retain_ind_pbr       indicator :n_retain_ind_pbr,
#                     :txn_success_date_pbr indicator :n_txn_pbr,
#                     :bwiz_run_date_pbr    indicator :n_run_date_pbr;

#       if (SQLCODE < 0)
#       {
#          fprintf(errorfile,"Failed beceause of SQLCODE in PBT %ld\n",SQLCODE);
#          svrdone();
#          exit(-1);
#       }
#       else if (SQLCODE == 100)
#       {
#           *bwiz_run_id = 0.0;
#           *bwiz_mon_id = 0.0;
#           run_date[0] = '\0';
#           cursor_not_empty = 0;
#           EXEC SQL CLOSE bwiz_crs;
#           return 0;

#       }
#       else if (SQLCODE == 0)
#       {

#           *bwiz_run_id = bwiz_run_id_pbr;
#           *bwiz_mon_id = bwiz_mo_id_pbr;
#           if (n_run_date_pbr == -1)
#              bwiz_run_date_pbr[0] = '\0';
#           strcpy(run_date,bwiz_run_date_pbr);
#           cursor_not_empty = 0;
#           EXEC SQL CLOSE bwiz_crs;
#           return 1;
#       }
#    }
# }
# int get_abs_parent_clientid(double budget_unit_id,double *clientid,char *mem_suffix)
# {


#     char gc_member_suffix[1] = "\0";

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     double gc_budget_unit_id = 0;
#     double i_gc_clientid = 0;
#     double gc_parent_suffix = 0;

#     EXEC SQL END DECLARE SECTION;

#     gc_budget_unit_id = budget_unit_id;
#     gc_member_suffix[0] = mem_suffix[2];

#     gc_parent_suffix = atol(gc_member_suffix);


#    EXEC SQL SELECT ABS_PARENT_ID
#             INTO   :i_gc_clientid
#             FROM   dba.t_abs_parent_hdr
#             WHERE  budget_unit_id = :gc_budget_unit_id
#             AND    abs_parent_suffix = :gc_parent_suffix;



#    if (SQLCODE < 0)
#    {
#        if (SQLCODE = -811)
#        {
#           clientid = 0;
#           return 0;
#        }
#        else
#        {
#          fprintf(errorfile,"Failed beceause of SQLCODE in GC %ld\n",SQLCODE);
#          svrdone();
#          exit(-1);
#        }
#    }
#    else if (SQLCODE == 0)
#    {
#       *clientid = i_gc_clientid;
#       return (1);
#    }

# }
# int insert_work_order_taskid(double householdid,double serv_prog_id,double clientid,double budget_unit_id,char *ptr_desc_non_coop,char *family_id,char *member_suffix,int ret_code)
# {


#     double iwo_abs_clientid = 0;

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     short  n_budget_unit_id = 0;
#     short  n_create_date = 0;
#     short  n_due_date = 0;
#     short  n_task = 0;
#     short  n_task_type = 0;
#     short  n_instructions = 0;
#     short  n_status = 0;
#     short  n_assigned_by = 0;
#     short  n_assigned_to = 0;
#     short  n_urgency = 0;
#     short  n_user_id_update = 0;
#     short  n_last_update = 0;
#     short  n_work_orderid = 0;
#     short  ni_serv_prog_id = 0;

#     double iwo_clientid = 0;
#     double iwo_d_work_order_taskid = 0;
#     char   iwo_ch_work_order_taskid[61] = "\0";
#     double iwo_householdid = 0;
#     double iwo_budget_unit_id = 0;
#     char   iwo_create_date[30] = "\0";
#     char   iwo_ts_due_date[30] = "\0";
#     char   iwo_due_date[11] = "\0";
#     char   iwo_task[36] = "\0";
#     char   iwo_ssn[10] = "\0";
#     char   iwo_family_id[10] = "\0";
#     double iwo_serv_prog_id = 0;
#     char   iwo_task_type[3] = "\0";
#     char   iwo_instructions[251] = "\0";
#     char   iwo_status[3] = "\0";
#     char   iwo_assigned_by[9] = "\0";
#     char   iwo_assigned_to[9] = "\0";
#     char   iwo_urgency[3] = "\0";
#     char   iwo_user_id_update[9] = "\0";
#     char   iwo_last_update_date[30] = "\0";
#     char   iwo_ch_serv_prog_id[21] = "\0";
#     double iwo_work_orderid = 0;

#     char   iwo_first_name[21] = "\0";
#     char   iwo_suffix[5] = "\0";
#     char   iwo_middle_name[21] = "\0";
#     char   iwo_middle_initial[2] = "\0";
#     char   iwo_last_name[21] = "\0";
#     char   iwo_client_name[61] = "\0";
#     char   iwo_county_code[3] = "\0";
#     char   iwo_mf_county_code[4] = "\0";
#     char   iwo_generic_worker[5] = "\0";

#     EXEC SQL END DECLARE SECTION;

#     iwo_householdid = householdid;

#     iwo_serv_prog_id = serv_prog_id;


#     iwo_clientid = clientid;
#     iwo_budget_unit_id = budget_unit_id;
#     strcpy(iwo_family_id,family_id);

#     strcpy(iwo_create_date,syb_sys_date);
#     strcpy(iwo_due_date,get_due_date_10());
#     convert_to_timestamp(iwo_ts_due_date,iwo_due_date);



#     strcpy(iwo_ssn,get_ssn(iwo_clientid));
#     strcpy(iwo_ch_work_order_taskid,get_work_order_taskid());
#     iwo_d_work_order_taskid = atof(iwo_ch_work_order_taskid);
#     iwo_d_work_order_taskid++;

#     get_task(iwo_clientid,iwo_last_name,iwo_suffix,iwo_first_name,
#                                                   iwo_middle_name);
#     strcpy(iwo_task,iwo_last_name);
#     if ( strcmp(iwo_suffix,"    ") != 0)
#     {
#        strcat(iwo_task,iwo_suffix);
#     }
#     strcat(iwo_task," ");
#     strcat(iwo_task,iwo_first_name);

#     strcpy(iwo_instructions,iwo_task);
#     strcat(iwo_instructions," ");
#     strcat(iwo_instructions,iwo_ssn);

# /* rao for PCR# 77866 change desc */
# /*
#     strncpy(iwo_ch_serv_prog_id,get_serv_prog_desc(serv_prog_id),20);
#     iwo_ch_serv_prog_id[20] = '\0';


#     strcat(iwo_instructions," ");
#     strcat(iwo_instructions,iwo_ch_serv_prog_id);
#     strcat(iwo_instructions," ");
#     strcat(iwo_instructions,iwo_family_id);*/

#     strcat(iwo_instructions," ");
#     strcat(iwo_instructions,ptr_desc_non_coop);
#     strcat(iwo_instructions," ");

# /*
#     get_abs_parent_clientid(budget_unit_id,&iwo_abs_clientid,member_suffix);
#     if (get_task(iwo_abs_clientid,iwo_last_name,iwo_suffix,iwo_first_name,
#                                                   iwo_middle_name))
#     {
#         strcat(iwo_instructions,"ABSENT PARENT-");
#     }

#     strcat(iwo_instructions,iwo_last_name);
#     strcat(iwo_instructions," ");
#     strcat(iwo_instructions,iwo_first_name);*/
#    strcat(iwo_instructions,".   Please review all Medicaid cases and determine if a sanction is required. ");

#     strcpy(iwo_task_type,"NC");
#     strcpy(iwo_status,"00");
#     strcpy(iwo_assigned_by,"ANSWER");
#     strcpy(iwo_county_code,get_county_code(iwo_budget_unit_id));
#     strcpy(iwo_mf_county_code,get_mf_county_code(iwo_county_code));
#     strcpy(iwo_generic_worker,iwo_mf_county_code);
#     strcat(iwo_generic_worker,"G");
#     strcpy(iwo_assigned_to,iwo_generic_worker);

#     strcpy(iwo_urgency,"05");
#     strcpy(iwo_user_id_update,"ANSWER2");
#     strcpy(iwo_last_update_date,syb_sys_date);

#     if (ret_code == 0) /* Budget not calcualted */
#     {
#        strcpy(iwo_task_type,"CE");
#        strcat(iwo_instructions,"- Manual budget calculation required");

#     }

#     EXEC SQL INSERT
#              INTO   dba.t_work_order_task
#                     ( work_order_taskid,
#                       householdid,
#                       work_orderid,
#                       service_program_id,
#                       budget_unit_id,
#                       create_date,
#                       due_date,
#                       task,
#                       task_type,
#                       instructions,
#                       status,
#                       assigned_by,
#                       assigned_to,
#                       urgency,
#                       user_id_update,
#                       last_update_date)
#              VALUES
#                     ( :iwo_d_work_order_taskid,
#                       :iwo_householdid,
#                       :iwo_work_orderid                 indicator :n_work_orderid,
#                       :iwo_serv_prog_id                 indicator :ni_serv_prog_id,
#                       :iwo_budget_unit_id               indicator :n_budget_unit_id,
#                       :iwo_create_date                  indicator :n_create_date,
#                       :iwo_ts_due_date                  indicator :n_due_date,
#                       :iwo_task                         indicator :n_task,
#                       :iwo_task_type                    indicator :n_task_type,
#                       :iwo_instructions                 indicator :n_instructions,
#                       :iwo_status                       indicator :n_status,
#                       :iwo_assigned_by                  indicator :n_assigned_by,
#                       :iwo_assigned_to                  indicator :n_assigned_to,
#                       :iwo_urgency                      indicator :n_urgency,
#                       :iwo_user_id_update               indicator :n_user_id_update,
#                       :iwo_last_update_date             indicator :n_last_update   );

#     if (SQLCODE < 0)
#     {
#         fprintf( errorfile,"Fatal error %ld occured when attempting to insert work_order_task table\n",SQLCODE);


#         printf("iwo_d_work_order_taskid = %lf\n",iwo_d_work_order_taskid);
#         printf("iwo_householdid         = %lf\n",iwo_householdid);
#         printf("iwo_work_orderid        = %lf\n",iwo_work_orderid);
#         printf("iwo_serv_prog_id        = %lf\n",iwo_serv_prog_id);
#         printf("iwo_budget_unit_id      = %lf\n",iwo_budget_unit_id);
#         printf("iwo_create_date         = %s\n",iwo_create_date);
#         printf("iwo_due_date            = %s\n",iwo_due_date);
#         printf("iwo_task                = %s\n",iwo_task );
#         printf("iwo_task_type           = %s\n",iwo_task_type);
#         printf("iwo_instructions        = %s\n",iwo_instructions);
#         printf("iwo_status              = %s\n",iwo_status);
#         printf("iwo_assigned_by         = %s\n",iwo_assigned_by);
#         printf("iwo_assigned_to         = %s\n",iwo_assigned_to);
#         printf("iwo_urgency             = %s\n",iwo_urgency);
#         printf("iwo_user_id_update      = %s\n",iwo_user_id_update);
#         printf("iwo_last_update_date    = %s\n",iwo_last_update_date);


#         EXEC SQL ROLLBACK;
#         svrdone();
#         exit(-1);
#     }
#     else
#     {
#         if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#         {
#         }
#         else if(SQLCODE == 0)
#         {
#             ++g_work_order_task;
#             ++g_insert_work_order_taskid;
#             update_domain_value(iwo_d_work_order_taskid);
#             return 1;
#         }
#     }
# }
# int update_domain_value(double domain_value)
# {

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     static char idv_domain_value[61] = "\0";


#     EXEC SQL END DECLARE SECTION;

#     sprintf(idv_domain_value,"%-10.0f",domain_value);

#     EXEC SQL UPDATE dba.t_system_parm
#              SET    domain_value = :idv_domain_value
#              WHERE  domain_id = 2
#              AND    sub_domain_id = 35;


#     if (SQLCODE < 0)
#     {
#         fprintf( errorfile,"Fatal error %ld occured when attempting to update system_parm table\n"
# ,SQLCODE);

#         EXEC SQL ROLLBACK;
#         svrdone();
#         exit(-1);
#     }
#     else
#     {
#         if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#         {
#         }
#         else if(SQLCODE == 0)
#         {
#           return 1;
#         }
#     }
# }
# char *get_work_order_taskid()
# {

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     short n_domain_value = 0;
#     char  gwt_domain_value[61] = "\0";

#     EXEC SQL END DECLARE SECTION;


#      EXEC SQL SELECT domain_value
#               INTO   :gwt_domain_value indicator :n_domain_value
#               FROM   dba.t_system_parm
#               WHERE  domain_id = 2
#               AND    sub_domain_id = 35;

#     if (SQLCODE < 0)
#     {
#         fprintf( errorfile,"Fatal error %ld occured when attempting to get work_order_task table\n",SQLCODE);
#         gwt_domain_value[0] = '\0';
#         return gwt_domain_value;
#     }
#     else if (SQLCODE == 100)
#     {
#         fprintf( errorfile,"No Records found for work_order_taskid \n");
#         return gwt_domain_value;
#     }
#     else if (SQLCODE == 0)
#     {
#         return gwt_domain_value;

#     }
# }
# char *get_sanction_id()
# {

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     short n_domain_value_sid = 0;
#     char  domain_value_sid[61] = "\0";

#     EXEC SQL END DECLARE SECTION;


#      EXEC SQL SELECT DOMAIN_VALUE
#               INTO   :domain_value_sid indicator :n_domain_value_sid
#               FROM   DBA.T_SYSTEM_PARM
#               WHERE  DOMAIN_ID = 2
#               AND    SUB_DOMAIN_ID = 32;

#     if (SQLCODE < 0)
#     {
#         fprintf( errorfile,"Fatal error %ld occured when attempting to get SANCTIONID\n",SQLCODE);
#         svrdone();
#         exit(-1);

#     }
#     else if (SQLCODE == 100)
#     {
#         fprintf( errorfile,"No Records found for SANCTION ID \n");
#         return domain_value_sid;
#     }
#     else if (SQLCODE == 0)
#     {
#         return domain_value_sid;

#     }
# }
# char *get_ssn(double clientid)
# {

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     short  n_ssn = 0;

#     double gs_clientid = 0;
#     char   gs_ssn[10] = "\0";


#     EXEC SQL END DECLARE SECTION;

#     gs_clientid = clientid;

#     EXEC SQL SELECT ssn
#              INTO   :gs_ssn  indicator :n_ssn
#              FROM   dba.t_person_biograph
#              WHERE  clientid = :gs_clientid;

#     if (SQLCODE < 0)
#     {
#         fprintf( errorfile,"Fatal error %ld occured when attempting to get SSN \n",SQLCODE);
#         gs_ssn[0] = '\0';
#         return gs_ssn;
#     }
#     else if (SQLCODE == 100)
#     {
#         gs_ssn[0] = '\0';
#         return gs_ssn;
#     }
#     else if (SQLCODE == 0)
#     {
#         return gs_ssn;

#     }
# }
# int get_task(double clientid,char *last_name,char *suffix,char *first_name,
#                                                             char *middle_name)
# {

#     char   gt_task[36] = "\0";

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     short  n_last_name = 0;
#     short  ngt_suffix = 0;
#     short  n_first_name = 0;
#     short  n_middle_name = 0;

#     double gt_clientid = 0;
#     char   gt_last_name[21] = "\0";
#     char   gt_suffix[5] = "\0";
#     char   gt_first_name[21] = "\0";
#     char   gt_middle_name[21] = "\0";


#     EXEC SQL END DECLARE SECTION;

#     gt_clientid = clientid;
#     EXEC SQL SELECT LTRIM(RTRIM(last_name)),
#                     suffix,
#                     LTRIM(RTRIM(first_name)),
#                     LTRIM(RTRIM(middle_name))
#              INTO   :gt_last_name    indicator :n_last_name,
#                     :gt_suffix       indicator :ngt_suffix,
#                     :gt_first_name   indicator :n_first_name,
#                     :gt_middle_name  indicator :n_middle_name
#              FROM   dba.t_person_demograph
#              WHERE  clientid = :gt_clientid;

#     if (SQLCODE < 0)
#     {
#         fprintf( errorfile,"Fatal error %ld occured when attempting to get Demograph info\n",SQLCODE);
#         strcpy(last_name,"");
#         strcpy(suffix,"");
#         strcpy(first_name,"");
#         strcpy(middle_name,"");

#         return(0);
#     }
#     else if (SQLCODE == 100)
#     {

#         strcpy(last_name,"");
#         strcpy(suffix,"");
#         strcpy(first_name,"");
#         strcpy(middle_name,"");
#         return(0);

#     }
#     else if (SQLCODE == 0)
#     {
#         strcpy(last_name,gt_last_name);
#         strcpy(suffix,gt_suffix);
#         strcpy(first_name,gt_first_name);
#         strcpy(middle_name,gt_middle_name);
#         return(1);

#     }
# }
# void convert_to_timestamp( char* target, char* source)
# {    /*
#     Function:       convert_to_timstamp
#     Description:    Function takes a standard mm/dd/ccyy date and converts
#             it into a standard UDB timestamp format.

#     Input Parameters:

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

#     /* ccyy */
#     target[0]  = source[6];
#     target[1]  = source[7];
#     target[2]  = source[8];
#     target[3]  = source[9];
#     target[4]  = '-';
#           /* mm */
#     target[5]  = source[0];
#     target[6]  = source[1];
#     target[7]  = '-';
#         /* dd */
#     target[8]  = source[3];
#     target[9]  = source[4];
#     target[10] = '-';
#         /* hh */
#     target[11] = '0';
#     target[12] = '0';
#     target[13] = '.';
#     /* mm */
#     target[14] = '0';
#     target[15] = '0';
#     target[16] = '.';
#     /* ss */
#     target[17] = '0';
#     target[18] = '0';
#     target[19] = '\0';
# }
# char *get_due_date_10()
# {
#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     char gdd_due_date[20] = "\0";
#     char   gdd_curr_date[11] = "\0";
#     char gdd_cvrt_date[11] = "\0";


#     EXEC SQL END DECLARE SECTION;

#     strncpy(gdd_curr_date,syb_sys_date,10);
#     gdd_curr_date[10] = '\0';


#     EXEC SQL SELECT DISTINCT(date(:gdd_curr_date) + 10 days)
#              INTO   :gdd_due_date
#              FROM   sysibm.sysdummy1;

#     if (SQLCODE < 0)
#     {
#         fprintf(errorfile,"Failed from SQLCODE in FUNC GDD %ld \n",SQLCODE);
#         return(0);
#     }
#     else if (SQLCODE == 0)
#     {
#         return (gdd_due_date);
#     }
#     else if (SQLCODE == 100)
#     {
#        return 0;
#     }
# }
# char *get_mf_county_code(char *county)
# {

#        EXEC SQL WHENEVER SQLERROR continue;
#        EXEC SQL WHENEVER SQLWARNING continue;
#        EXEC SQL WHENEVER NOT FOUND continue;

#        EXEC SQL INCLUDE SQLCA;
#        EXEC SQL BEGIN DECLARE SECTION;

#        short  n_mf_county = 0;
#        char   gmc_county_code[3] = "\0";
#        char   gmc_mf_county_code[9] = "\0";

#        EXEC SQL END DECLARE SECTION;

#        strcpy(gmc_county_code,county);

#        EXEC SQL SELECT CONV_DOMN_VAL
#                 INTO   :gmc_mf_county_code indicator :n_mf_county
#                 FROM   dba.t_domain_conv
#                 WHERE  host_sys_domn_val = '07'
#                 AND    domain_code = '83'
#                 AND    value = :gmc_county_code;

#        if (SQLCODE == 0)
#        {
#           if (n_mf_county == -1)
#               strcpy(gmc_mf_county_code,"");
#           return gmc_mf_county_code;
#        }
#        else if (SQLCODE == 100)
#        {
#           strcpy(gmc_mf_county_code,"");
#           return gmc_mf_county_code;
#        }
#        else
#        {
#           strcpy(gmc_mf_county_code,"");
#           return gmc_mf_county_code;
#        }

# }
# char *get_county_code(double budget_unit_id)
# {
#        EXEC SQL WHENEVER SQLERROR continue;
#        EXEC SQL WHENEVER SQLWARNING continue;
#        EXEC SQL WHENEVER NOT FOUND continue;

#        EXEC SQL INCLUDE SQLCA;
#        EXEC SQL BEGIN DECLARE SECTION;

#        short  ncounty = 0;
#        double gcc_budget_unit_id = 0;
#        char   gcc_county_code[3] = "\0";

#        EXEC SQL END DECLARE SECTION;

#        gcc_budget_unit_id = budget_unit_id;


#        EXEC SQL SELECT BU_SERVICE_COUNTY
#                 INTO   :gcc_county_code indicator :ncounty
#                 FROM   dba.t_budget_unit
#                 WHERE  budget_unit_id = :gcc_budget_unit_id;


#        if (SQLCODE == 0)
#        {
#           if (ncounty == -1)
#              strcpy(gcc_county_code,"");
#           return gcc_county_code;
#        }
#        else if (SQLCODE == 100)
#        {
#           strcpy(gcc_county_code,"");
#           return gcc_county_code;
#        }
#        else if (SQLCODE < 0)
#        {
#           fprintf(errorfile,"Failed from SQLCODE in FUNC GCC %ld \n",SQLCODE);
#           strcpy(gcc_county_code,"");
#           return gcc_county_code;
#        }

# }
# char *get_serv_prog_desc(double serv_prog_id)
# {

#        EXEC SQL WHENEVER SQLERROR continue;
#        EXEC SQL WHENEVER SQLWARNING continue;
#        EXEC SQL WHENEVER NOT FOUND continue;

#        EXEC SQL INCLUDE SQLCA;
#        EXEC SQL BEGIN DECLARE SECTION;

#        short  nserv_desc = 0;
#        double gsp_serv_prog_id = 0;
#        char   gsp_serv_prog_desc[251] = "\0";

#        EXEC SQL END DECLARE SECTION;

#        gsp_serv_prog_id = serv_prog_id;


#        EXEC SQL SELECT LTRIM(RTRIM(DESCRIPTION))
#                 INTO   :gsp_serv_prog_desc  indicator :nserv_desc
#                 FROM   dba.t_service_program
#                 WHERE  service_program_id = :gsp_serv_prog_id;

#       if (SQLCODE == 0)
#        {
#           if (nserv_desc == -1)
#              strcpy(gsp_serv_prog_desc,"");
#           return gsp_serv_prog_desc;
#        }
#        else if (SQLCODE == 100)
#        {
#           strcpy(gsp_serv_prog_desc,"");
#           return gsp_serv_prog_desc;
#        }
#        else if (SQLCODE < 0)
#        {
#           fprintf(errorfile,"Failed from SQLCODE in FUNC GSP %ld \n",SQLCODE);

#           strcpy(gsp_serv_prog_desc,"");
#           return gsp_serv_prog_desc;
#        }
# }
# char *TRIM(char *as_String1)
# {
#         int     li_StrLen;
#         char    *ptr_Beg, *ptr_End, *ptr_Cur;
#         char    lc_Space = ' ';

#    /* Keep track of the length, begin and end of string1 */
#         li_StrLen       = strlen(as_String1);
#         ptr_Beg         = as_String1;
#         ptr_End         = ptr_Beg + li_StrLen;

#         /* Trim leading spaces */
#         for (ptr_Cur = ptr_Beg; ptr_Cur <= ptr_End;)
#         {
#                 if (*ptr_Cur == lc_Space)
#                 {  /* Shift left to remove leading space */
#                         for (;ptr_Cur <= ptr_End; ptr_Cur++)
#                                 *ptr_Cur = *(ptr_Cur + 1);
#                         ptr_End--;
#                         ptr_Cur = ptr_Beg;
#                 }
#                 else
#                         break;
#         }
#         /* Trim trailing spaces */
#         for (ptr_Cur = ptr_End - 1; ptr_Cur >= ptr_Beg;)
#         {
#                 if (*ptr_Cur == lc_Space)
#                 {  /* Replace trailing spaces with NULL */
#                         *ptr_Cur = '\0';
#                         ptr_End--;
#                         ptr_Cur = ptr_End;
#                         ptr_Cur--;
#                 }
#                 else
#                         break;
#         }

#         return as_String1;
# }
# int get_clientid(double budget_unit_id,double *clientid)
# {


#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     double gcid_budget_unit_id = 0;
#     double i_gcid_clientid = 0;

#     EXEC SQL END DECLARE SECTION;

#     gcid_budget_unit_id = budget_unit_id;


#    EXEC SQL SELECT CLIENTID
#             INTO   :i_gcid_clientid
#             FROM   dba.t_budget_unit_comp
#             WHERE  budget_unit_id = :gcid_budget_unit_id
#             AND    relationship = '00';

#    if (SQLCODE < 0)
#    {
#        if (SQLCODE = -811)
#        {
#           clientid = 0;
#           return 0;
#        }
#        else
#        {
#          fprintf(errorfile,"Failed beceause of SQLCODE in GCID %ld\n",SQLCODE);
#          svrdone();
#          exit(-1);
#        }
#    }
#    else if (SQLCODE == 100)
#    {
#         clientid = 0;
#         return 0;
#    }
#    else if (SQLCODE == 0)
#    {
#       *clientid = i_gcid_clientid;
#       return (1);
#    }

# }
# int insert_sanction(double budget_unit_id,double clientid,char *ptr_desc_non_coop,
#                     char *member_suffix,double serv_prog_id,int ret_code)
# {


#     char    sixth_wd_eom_ist[11] = "\0";
#     char    curr_date_ist[11] = "\0";
#     double  abs_clientid_ist = 0;
#     char    member_suffix_ist[5] = "\0";
#     char    first_name_ist[21] = "\0";
#     char    middle_name_ist[21] = "\0";
#     char    middle_initial_ist[2] = "\0";
#     char    last_name_ist[21] = "\0";
#     char    sanction_id_ist[61] = "\0";


#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     double  sanctionid_ist = 0;
#     double  clientid_ist   = 0;
#     double  service_program_id_ist  =0;
#     double  provider_id_ist = 0;
#     char    type_ist[3]     = "\0";
#     char    description_ist[256] = "\0";
#     char    infraction_date_ist[30] = "\0";
#     char    effective_beg_date_ist[30] = "\0";
#     char    duration_ist[3] = "\0";
#     char    not_serviced_ind_ist[3] = "\0";
#     char    user_id_ist[9] = "\0";
#     char    last_update_ist[30] = "\0";
#     char    mytodolist_ind_ist[2] = "\0";
#     char    eff_date_ist[11] = "\0";

#     short  n_provider_id_ist = 0;
#     short  n_type_ist = 0;
#     short  n_description_ist = 0;
#     short  n_infraction_date_ist = 0;
#     short  n_effective_beg_date_ist = 0;
#     short  n_duration_ist = 0;
#     short  n_not_serviced_ind_ist = 0;
#     short  n_last_update_ist = 0;
#     short  n_mytodolist_ind_ist = 0;
#     short  n_user_id_ist = 0;

#     EXEC SQL END DECLARE SECTION;

#     clientid_ist = clientid;
#     strcpy(description_ist,"System applied sanction. ");
#     strcat(description_ist,ptr_desc_non_coop);

#     get_abs_parent_clientid(budget_unit_id,&abs_clientid_ist,member_suffix);
#     if (get_task(abs_clientid_ist,last_name_ist,member_suffix_ist,first_name_ist,
#                                                   middle_name_ist))
#     {
#         strcat(description_ist," ABSENT PARENT-");
#     }

#     strcat(description_ist,last_name_ist);
#     strcat(description_ist," ");
#     strcat(description_ist,first_name_ist);

#     service_program_id_ist = serv_prog_id ;

#     /* This sixth workday calculation is applicable to tea, but not for workpays. PCR#72464*/
#     if (service_program_id_ist == 20)
#         calc_6th_workday(sixth_wd_eom_ist);

#     strncpy(curr_date_ist,syb_sys_date,10);
#     curr_date_ist[10] = '\0';

#     /* PCR #72464 - Unlike Tea, for work pays case, the effective date is following month
#        if the curent date is 6th work day of the month. */

#     if ( (strcmp(curr_date_ist,sixth_wd_eom_ist) > 0) && (service_program_id_ist == 20) )
#     {
#         /* process the bwiz_run_month for the second following month */

#            EXEC SQL SELECT ((current date) + 2 months)
#                     INTO :eff_date_ist
#                     FROM SYSIBM.SYSDUMMY1 ;
#     }
#     else
#     {
#            /* process the bwiz_run_month for the following month */

#              EXEC SQL SELECT ((current date ) + 1 months)
#                       INTO :eff_date_ist
#                       FROM SYSIBM.SYSDUMMY1 ;
#     }

#     effective_beg_date_ist[0] = eff_date_ist[6];
#     effective_beg_date_ist[1] = eff_date_ist[7];
#     effective_beg_date_ist[2] = eff_date_ist[8];
#     effective_beg_date_ist[3] = eff_date_ist[9];
#     effective_beg_date_ist[4] = '-';
#     effective_beg_date_ist[5] = eff_date_ist[0];
#     effective_beg_date_ist[6] = eff_date_ist[1];
#     effective_beg_date_ist[7] = '-';
#     effective_beg_date_ist[8] = '0';
#     effective_beg_date_ist[9] = '1';
#     effective_beg_date_ist[10] = '-';
#     effective_beg_date_ist[11] = '0';
#     effective_beg_date_ist[12] = '0';
#     effective_beg_date_ist[13] = '.';
#     effective_beg_date_ist[14] = '0';
#     effective_beg_date_ist[15] = '0';
#     effective_beg_date_ist[16] = '.';
#     effective_beg_date_ist[17] = '0';
#     effective_beg_date_ist[18] = '0';


#     /*
#     if (ret_code != 1)
#     {
#        effective_beg_date_ist[0] = '\0';
#        n_effective_beg_date_ist = -1;
#     }
#     */

#     strcpy(infraction_date_ist,syb_sys_date);

#     strcpy(last_update_ist,syb_sys_date);

#     strcpy(mytodolist_ind_ist,"N");

#     strcpy(not_serviced_ind_ist,"NN");

#     strcpy(infraction_date_ist,syb_sys_date);

#     strcpy(last_update_ist,syb_sys_date);

#     strcpy(mytodolist_ind_ist,"N");

#     strcpy(not_serviced_ind_ist,"NN");

#     strcpy(type_ist,"26");

#     strcpy(duration_ist,"05");

#     strcpy(user_id_ist,"ANSWER");

#     strcpy(sanction_id_ist,get_sanction_id());
#     sanctionid_ist = atof(sanction_id_ist);
#     sanctionid_ist++;


#     EXEC SQL INSERT INTO DBA.T_SANCTION(
#              SANCTIONID,
#              CLIENTID,
#              SERVICE_PROGRAM_ID,
#              PROVIDER_ID,
#              TYPE,
#              DESCRIPTION,
#              INFRACTION_DATE,
#              EFFECTIVE_BEG_DATE,
#              DURATION,
#              NOT_SERVICED_IND,
#              USER_ID,
#              LAST_UPDATE,
#              MYTODOLIST_IND)
#      VALUES(:sanctionid_ist,
#             :clientid_ist,
#             :service_program_id_ist,
#             :provider_id_ist                 indicator :n_provider_id_ist,
#             :type_ist                        indicator :n_type_ist ,
#             :description_ist                 indicator :n_description_ist,
#             :infraction_date_ist             indicator :n_infraction_date_ist,
#             :effective_beg_date_ist          indicator :n_effective_beg_date_ist,
#             :duration_ist                    indicator :n_duration_ist,
#             :not_serviced_ind_ist            indicator :n_not_serviced_ind_ist,
#             :user_id_ist                     indicator :n_user_id_ist,
#             :last_update_ist                 indicator :n_last_update_ist,
#             :mytodolist_ind_ist              indicator :n_mytodolist_ind_ist);


#    if (SQLCODE < 0)
#    {
#        fprintf(errorfile,"Failed when attempting to add T_SANCTION table  %ld\n",SQLCODE);
#        printf("sanctionid_ist = %lf\n",sanctionid_ist);
#        printf("clientid_ist = %lf\n",clientid_ist);
#        printf("service_program_id_ist = %lf\n",service_program_id_ist);
#        printf("provider_id_ist        = %lf\n",provider_id_ist);
#        printf("type_ist               = %s\n",type_ist);
#        printf("description_ist        = %s\n",description_ist);
#        printf("infraction_date_ist    = %s\n",infraction_date_ist);
#        printf("effective_beg_date_ist = %s\n",effective_beg_date_ist);
#        printf("duration_ist           = %s\n",duration_ist);
#        printf("not_serviced_ind_ist   = %s\n",not_serviced_ind_ist);
#        printf("user_id_ist            = %s\n",user_id_ist);
#        printf("last_update_ist        = %s\n",last_update_ist);
#        printf("mytodolist_ind_ist     = %s\n",mytodolist_ind_ist);

#        EXEC SQL ROLLBACK;
#        svrdone();
#        exit(-1);
#    }
#    else if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
#    {
#         fprintf(errorfile,"Warning errors encountered when attempting to add to" \
#                            "T_SANCTION %ld\n",SQLCODE);
#         EXEC SQL ROLLBACK;
#         return 0;
#    }
#    else if (SQLCODE == 0)
#    {
#       ++g_insert_sanction;

#       update_system_parm(sanctionid_ist,2,32);

#    }

# }
# calc_6th_workday(char *date_6wd)
# {

#     char ch_curr_month_wd[3] = "\0";
#     int  int_curr_month_wd = 0;
#     char curr_year_wd[5] = "\0";
#     int  int_curr_year_wd = 0;
#     int  day_wd = 0;
#     char ch_day_wd[3] = "\0";

#     EXEC SQL WHENEVER SQLERROR continue;
#     EXEC SQL WHENEVER SQLWARNING continue;
#     EXEC SQL WHENEVER NOT FOUND continue;

#     EXEC SQL INCLUDE SQLCA;
#     EXEC SQL BEGIN DECLARE SECTION;

#     char  curr_date_eom_wd[11] = "\0";
#     double  day_of_week_wd = 0;


#     EXEC SQL END DECLARE SECTION;

#     curr_year_wd[0] = syb_sys_date[0];
#     curr_year_wd[1] = syb_sys_date[1];
#     curr_year_wd[2] = syb_sys_date[2];
#     curr_year_wd[3] = syb_sys_date[3];
#     curr_year_wd[4] = '\0';

#     ch_curr_month_wd[0] = syb_sys_date[5];
#     ch_curr_month_wd[1] = syb_sys_date[6];
#     ch_curr_month_wd[2] = '\0';

#     strncpy(curr_date_eom_wd,syb_sys_date,4);
#     curr_date_eom_wd[4] = '-';
#     curr_date_eom_wd[5] = syb_sys_date[5];
#     curr_date_eom_wd[6] = syb_sys_date[6];
#     curr_date_eom_wd[7] = '-';
#     curr_date_eom_wd[8] = '3';
#     curr_date_eom_wd[9] = '0';
#     curr_date_eom_wd[10] = '\0';

#     int_curr_year_wd = atoi(curr_year_wd);

#     int_curr_month_wd = atoi(ch_curr_month_wd);

#    /* This latter should be removed */

#     /*int_curr_month_wd = 12;
#     curr_date_eom_wd[0] = '2';
#     curr_date_eom_wd[1] = '0';
#     curr_date_eom_wd[2] = '0';
#     curr_date_eom_wd[3] = '6';
#     curr_date_eom_wd[4] = '-';
#     curr_date_eom_wd[5] = '1';
#     curr_date_eom_wd[6] = '2';
#     curr_date_eom_wd[7] = '-';
#     curr_date_eom_wd[8] = '3';
#     curr_date_eom_wd[9] = '1';
#     curr_date_eom_wd[10] = '\0';*/


#     switch( int_curr_month_wd )       {
#     case 1:
#     case 3:
#     case 5:
#     case 7:
#     case 8:
#     case 10:
#     case 12:

#               curr_date_eom_wd[9] = '1';

#               EXEC SQL SELECT (DAYOFWEEK(:curr_date_eom_wd))
#                        INTO :day_of_week_wd
#                        FROM SYSIBM.SYSDUMMY1 ;

#               if (day_of_week_wd == 1) /* Sunday */
#               {
#                  day_wd =  (31 - 9) ; /* 6 the work day from the end of month */
#                  if (int_curr_month_wd == 5)
#                      day_wd = (31 - 10) ;
#                  if (int_curr_month_wd == 12)
#                     day_wd = (31 - 11) ;
#               }
#               else if (day_of_week_wd == 2) /* Monday */
#               {
#                  day_wd =  (31 - 7) ; /* 6 the work day from the end of month */
#                  if (int_curr_month_wd == 5)
#                     day_wd = (31 - 8) ;
#                  if (int_curr_month_wd == 12)
#                     day_wd = (31 - 9) ;
#               }
#               else if (day_of_week_wd == 3) /* Tuesday */
#               {
#                  day_wd =  (31 - 7) ; /* 6 the work day from the end of month */
#                  if (int_curr_month_wd == 5)
#                     day_wd = (31 - 8) ;
#                  if (int_curr_month_wd == 12)
#                     day_wd = (31 - 9) ;
#               }
#               else if (day_of_week_wd == 4) /* Wednesday */
#               {
#                  day_wd =  (31 - 7) ; /* 6 the work day from the end of month */

#                  if (int_curr_month_wd == 5)
#                     day_wd = (31 - 8) ;
#                  if (int_curr_month_wd == 12)
#                     day_wd = (31 - 9) ;
#               }
#               else if (day_of_week_wd == 5) /* Thursday */
#               {
#                  day_wd =  (31 - 7) ; /* 6 the work day from the end of month */

#                  if (int_curr_month_wd == 5)
#                     day_wd = (31 - 8) ;
#                  if (int_curr_month_wd == 12)
#                     day_wd = (31 - 9) ;
#               }
#               else if (day_of_week_wd == 6) /* Friday */
#               {
#                  day_wd =  (31 - 8) ; /* 6 the work day from the end of month */
#                  if (int_curr_month_wd == 5)
#                     day_wd = (31 - 9) ;
#                  if (int_curr_month_wd == 12)
#                     day_wd = (31 - 10) ;
#               }
#               else if (day_of_week_wd == 7) /* Saturday */
#               {
#                  day_wd =  (31 - 8) ; /* 6 the work day from the end of month */
#                  if (int_curr_month_wd == 5)
#                     day_wd = (31 - 9) ;
#                  if (int_curr_month_wd == 15)
#                     day_wd = (31 - 10) ;
#               }
#               sprintf(ch_day_wd,"%2d",day_wd);
#               curr_date_eom_wd[8] = ch_day_wd[0];
#               curr_date_eom_wd[9] = ch_day_wd[1];
#               strcpy(date_6wd,curr_date_eom_wd);
#               return 1;

#        case 4:
#        case 6:
#        case 9:
#        case 11:

#                   curr_date_eom_wd[9] = '0';

#                   EXEC SQL SELECT (DAYOFWEEK(:curr_date_eom_wd))
#                            INTO :day_of_week_wd
#                            FROM SYSIBM.SYSDUMMY1 ;

#                    if (day_of_week_wd == 1) /* Sunday */
#                    {
#                       day_wd =  (30 - 9) ; /* 6 the work day from the end of month */
#                       if (int_curr_month_wd == 11)
#                          day_wd = (30 - 11) ;
#                    }
#                    else if (day_of_week_wd == 2) /* Monday */
#                    {
#                       day_wd =  (30 - 7) ; /* 6 the work day from the end of month */
#                       if (int_curr_month_wd == 11)
#                          day_wd = (30 - 11) ;
#                    }
#                    else if (day_of_week_wd == 3) /* Tuesday */
#                    {
#                       day_wd =  (30 - 7) ; /* 6 the work day from the end of month */
#                       if (int_curr_month_wd == 11)
#                          day_wd = (30 - 11) ;
#                    }
#                    else if (day_of_week_wd == 4) /* Wednesday */
#                    {
#                       day_wd =  (30 - 7) ; /* 6 the work day from the end of month */
#                       if (int_curr_month_wd == 11)
#                          day_wd = (30 - 9) ;
#                    }
#                    else if (day_of_week_wd == 5) /* Thursday */
#                    {
#                       day_wd =  (30 - 7) ; /* 6 the work day from the end of month */
#                       if (int_curr_month_wd == 11)
#                          day_wd = (30 - 9) ;
#                    }
#                    else if (day_of_week_wd == 6) /* Friday */
#                    {
#                       day_wd =  (30 - 7) ; /* 6 the work day from the end of month */
#                       if (int_curr_month_wd == 11)
#                          day_wd = (30 - 9) ;
#                    }
#                    else if (day_of_week_wd == 7) /* Saturday */
#                    {
#                       day_wd =  (30 - 8) ; /* 6 the work day from the end of month */
#                       if (int_curr_month_wd == 11)
#                          day_wd = (30 - 10) ;
#                    }
#                    sprintf(ch_day_wd,"%2d",day_wd);
#                    curr_date_eom_wd[8] = ch_day_wd[0];
#                    curr_date_eom_wd[9] = ch_day_wd[1];
#                    strcpy(date_6wd,curr_date_eom_wd);
#                    return 1;

#        case 2:

#                if((int_curr_year_wd % 4 == 0) && (int_curr_year_wd % 100 != 0) ||
#                   (int_curr_year_wd % 400 == 0))
#                {

#                   /* 29 days */
#                    curr_date_eom_wd[8] = '2';
#                    curr_date_eom_wd[9] = '9';

#                    EXEC SQL SELECT (DAYOFWEEK(:curr_date_eom_wd))
#                             INTO :day_of_week_wd
#                             FROM SYSIBM.SYSDUMMY1;

#                    if (day_of_week_wd == 1) /* Sunday */
#                    {
#                        day_wd = 29 - 10 ;
#                    }
#                    else if (day_of_week_wd == 2) /* Monday */
#                    {
#                        day_wd = 29 - 7 ;
#                    }
#                    else if (day_of_week_wd == 3) /* Tuesday */
#                    {
#                        day_wd = 29 - 7 ;
#                    }
#                    else if (day_of_week_wd == 4) /* Wednesday */
#                    {
#                        day_wd = 29 - 7 ;
#                    }
#                    else if (day_of_week_wd == 5) /* Thursday */
#                    {
#                        day_wd = 29 - 7 ;
#                    }
#                    else if (day_of_week_wd == 6) /* Friday */
#                    {
#                        day_wd = 29 - 7 ;
#                    }
#                    else if (day_of_week_wd == 7) /* Saturday */
#                    {
#                        day_wd = 29 - 8 ;
#                    }
#                    sprintf(ch_day_wd,"%2d",day_wd);
#                    curr_date_eom_wd[8] = ch_day_wd[0];
#                    curr_date_eom_wd[9] = ch_day_wd[1];
#                    strcpy(date_6wd,curr_date_eom_wd);
#                    return 1;
#                }
#                else
#                {
#                    /* 28 days */
#                     curr_date_eom_wd[8] = '2';
#                     curr_date_eom_wd[9] = '8';

#                     EXEC SQL SELECT (DAYOFWEEK(:curr_date_eom_wd))
#                              INTO :day_of_week_wd
#                              FROM SYSIBM.SYSDUMMY1;

#                    if (day_of_week_wd == 1) /* Sunday */
#                    {
#                        day_wd = 28 - 9 ;
#                    }
#                    else if (day_of_week_wd == 2) /* Monday */
#                    {
#                        day_wd = 28 - 7 ;
#                    }
#                    else if (day_of_week_wd == 3) /* Tuesday */
#                    {
#                        day_wd = 28 - 7 ;
#                    }
#                    else if (day_of_week_wd == 4) /* Wednesday */
#                    {
#                        day_wd = 28 - 7 ;
#                    }
#                    else if (day_of_week_wd == 5) /* Thursday */
#                    {
#                        day_wd = 28 - 7 ;
#                    }
#                    else if (day_of_week_wd == 6) /* Friday */
#                    {
#                        day_wd = 28 - 7 ;
#                    }
#                    else if (day_of_week_wd == 7) /* Saturday */
#                    {
#                        day_wd = 28 - 8 ;
#                    }
#                    /*sprintf(due_date1,"%4d-%02d-%02d-00.00.00", yr_num, mon_num, dd_num);*/
#                    sprintf(ch_day_wd,"%2d",day_wd);
#                    curr_date_eom_wd[8] = ch_day_wd[0];
#                    curr_date_eom_wd[9] = ch_day_wd[1];
#                    strcpy(date_6wd,curr_date_eom_wd);
#                    return 1;

#                }

#     }
# }
# void init_budget_sum(struct budget_sum *budget_sum_p)
# {/*
#     Function:    Initialize the Struct

#     Description:    This function initializes the structure
# --------------------------------------------------------------------------------
#                              Modifications:

# Version  Comments
# --------------------------------------------------------------------------------
# 1.000     Initial Release
# --------------------------------------------------------------------------------
# */
#     budget_sum_p->host_system_id[0]                = '\0';
#     budget_sum_p->service_pgm[0]                   = '\0';
#     budget_sum_p->action_date[0]                   = '\0';
#     budget_sum_p->budget_unit_size[0]              = '\0';
#     budget_sum_p->tot_earned_inc[0]                = '\0';
#     budget_sum_p->tot_unearned_inc[0]              = '\0';
#     budget_sum_p->tot_expenses[0]                  = '\0';
#     budget_sum_p->tot_resources[0]                 = '\0';
#     budget_sum_p->result[0]                        = '\0';
#     budget_sum_p->gross_earned[0]                  = '\0';
#     budget_sum_p->work_deduct[0]                   = '\0';
#     budget_sum_p->incent_deduct[0]                 = '\0';
#     budget_sum_p->net_earned[0]                    = '\0';
#     budget_sum_p->countable_unearned[0]            = '\0';
#     budget_sum_p->total_adjusted[0]                = '\0';
#     budget_sum_p->bene_amount[0]                  = '\0';
#     budget_sum_p->earned_inc_deduct[0]             = '\0';
#     budget_sum_p->child_care_deduct[0]             = '\0';
#     budget_sum_p->net_countable_inc[0]             = '\0';
#     budget_sum_p->inc_limit[0]                      = '\0';
#     budget_sum_p->earned_income[0]                 = '\0';
#     budget_sum_p->gip_total_unearned_income[0]     = '\0';
#     budget_sum_p->gip_farm_loss[0]                 = '\0';
#     budget_sum_p->gross_income[0]                  = '\0';
#     budget_sum_p->nir_net_earned[0]                = '\0';
#     budget_sum_p->nir_total_unearned_income[0]     = '\0';
#     budget_sum_p->nir_farm_loss[0]                 = '\0';
#     budget_sum_p->standard_deduction[0]            = '\0';
#     budget_sum_p->expenses[0]                      = '\0';
#     budget_sum_p->nir_net_income[0]                = '\0';
#     budget_sum_p->rent_mortgage[0]                 = '\0';
#     budget_sum_p->property_tax[0]                  = '\0';
#     budget_sum_p->insurance[0]                     = '\0';
#     budget_sum_p->utilities[0]                     = '\0';
#     budget_sum_p->total_shelter[0]                 = '\0';
#     budget_sum_p->fifty_pct_adj_income[0]          = '\0';
#     budget_sum_p->excess[0]                        = '\0';
#     budget_sum_p->allowed_excess[0]                = '\0';
#     budget_sum_p->full_benefit[0]                  = '\0';
#     budget_sum_p->thirty_pct_reduction[0]          = '\0';
#     budget_sum_p->benefit_amount[0]                = '\0';
#     budget_sum_p->sanction_indicator[0]            = '\0';
#     budget_sum_p->action_reason[0]                 = '\0';
#     budget_sum_p->filler[0]                        = '\0';
#     budget_sum_p->eor_marker[0]                    = '\0';
# }

