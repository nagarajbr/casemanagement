# /********************************************************************
# *                             MODIFICATION LOG                              *
# *                                                                           *
# * PCR       DATE        SE                 DESCRIPTION                      *
# * --------  ---------   -----------------  ---------------------------------*
# * 71090     12/21/04    Naga Goriparthi   Added SQL COMMIT                  *
# * 74562     02/06/08    John Davis        adde enum_counter calculation     *
# ****************************************************************************/

# #include <stdio.h>
# #include <strings.h>
# #include <fcntl.h>
# #include <stdlib.h>
# #include <ctype.h>
# #include "sqlca.h"
# #include "sqlda.h"

#    EXEC SQL INCLUDE 'commbat1.h';
#    EXEC SQL INCLUDE 'comm_err22.h';
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
#      char ssn_enum[3]="\0";
#      char county[3]="\0";
#      FILE *inp_fp;
#      FILE *err_fp;

#      int update_person_biograph(char *, char *,char *);
#      int svrinit();
#      int svrdone();
# main()
# {
#     typedef struct
#     {
#       char ssn[9];
#       char lname[13];
#       char fname[10];
#       char mname[7];
#       char dob[8];
#       char sex;
#       char filler1[49];
#       char ssn_enum;
#       char filler2[13];
#       char mssn[50];
#     } facts_part;

#     facts_part facts_input;
#     inp_fp=fopen("ssn_enum_ext.txt","r");
#     err_fp=fopen("enum_res.txt","w+");
#     svrinit();
#     fprintf(err_fp,"Proccessing ssn enumeration...\n\n");

#     while(!feof(inp_fp))
#     {
#         fread(&facts_input,sizeof(facts_part),1,inp_fp);
#         if(feof(inp_fp))
#           break;
#         rec_prc++;
#         strncpy(ssn,facts_input.ssn,9);
#         ssn[9]='\0';
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
# printf(" ssn %s \n", ssn);
# printf(" ssn_enum %s \n", ssn_enum);
#         strcpy (county,"\0");
#         if(update_person_biograph(ssn,ssn_enum,county))
#         {
#             printf("Record updated for : ssn = %s ssn_enum = %s \n", \
#                     ssn,ssn_enum);
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


# int update_person_biograph(char*  ssn,char* ssn_enum,char* county)
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
#     char h_county[3]="\0";
#     char   syb_sys_date[20];
#     double h_enum_counter;


#     EXEC SQL END DECLARE SECTION;

#         strncpy(social,ssn,9);
#         social[9]='\0';
#         strncpy(enumeration,ssn_enum,2);
#         enumeration[2]='\0';
#         strncpy(h_county,county,2);
#         h_county[2]='\0';

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

#         EXEC SQL SELECT enum_counter
#              INTO   :h_enum_counter
#              FROM   dba.t_person_biograph
#              WHERE  ssn = :social;

#     if (SQLCODE < 0)
#     {
#         fprintf( err_fp,"Fatal error %ld occured when attempting to get enum counter \
# n",SQLCODE);
#         return(0);
#     }
#     else
#     {
#         if (SQLCODE == 100)
#         {
#     fprintf(err_fp,"No record found for ssn = %s enum = %s County is %s\n", social,
#     enumeration,h_county);
#            rec_erd++;
#            return(0);
#         }
#     }
#     if ((strcmp(enumeration,"SS") != 0) && (strcmp(enumeration,"CC") != 0))
#     {
#         h_enum_counter += 1;
#     }

#         EXEC SQL UPDATE dba.t_person_biograph
#         SET enumeration = :enumeration,
#             user_id = 'ANSWER2',
#             enum_counter = :h_enum_counter,
#             last_update = :syb_sys_date
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
#            fprintf(err_fp,"No record found for ssn = %s enum = %s County is %s\n", social, enumeration,h_county);
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
#     return(1);
# }
