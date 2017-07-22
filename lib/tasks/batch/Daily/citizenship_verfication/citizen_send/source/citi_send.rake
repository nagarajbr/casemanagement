task :generate_citizenship_verification_send => :environment do

	batch_user = User.where("uid = '555'").first
	AuditModule.set_current_user=(batch_user)


	extract_filename = "batch_results/daily/citizenship_verfication/citizen_send/outbound/citi_to_ssa_results" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
 #  	# result_filename = "lib/tasks/batch/daily/citizenship_verification/citizen_send/citi_to_ssa_results" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
  	error_filename = "batch_results/daily/citizenship_verfication/citizen_send/results/errors_citi_to_ssa_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
  	log_filename = "batch_results/daily/citizenship_verfication/citizen_send/results/log_citi_to_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"


  	extract_path = File.join(Rails.root, extract_filename )
 # #  	result_path = File.join(Rails.root, result_filename )
	error_path = File.join(Rails.root, error_filename )
	log_path = File.join(Rails.root, log_filename )

	extract_file = File.new(extract_path,"w+")
	# result_file = File.new(result_path,"w+")
	error_file = File.new(error_path,"w+")
	log_file = File.new(log_path,"w+")

	log_file.puts("Citizenship verification batch process start")

	clients_citizenship_verification_collection = NightlyBatchProcess.where("process_type = 6513 and processed is null ").select("distinct entity_id")
	if clients_citizenship_verification_collection.present?
		number_of_clients = clients_citizenship_verification_collection.size

		log_file.puts("Number of clients extracted: ", + number_of_clients)
		error_count = 0
		# error_msg = " "
		clients_citizenship_verification_collection.each do |each_client|
			error_msg = " "
			client = Client.find(each_client.entity_id)
			if client.ssn?
				citizenship_verification = client.ssn.strip[0,9].ljust(9,' ')
			else
				error_msg = "SSN is missing"
			end

			citizenship_verification = citizenship_verification + "000000000   ".to_s.ljust(12,' ')
			if client.last_name?
				citizenship_verification = citizenship_verification + client.last_name.strip[0,19].ljust(19,' ')
			else
				error_msg = error_msg + " " + "Last name is missing"
			end

			if client.middle_name?
				citizenship_verification = citizenship_verification + client.middle_name.strip[0,1].ljust(1,' ')
			else
				citizenship_verification = citizenship_verification + ' '.to_s.ljust(1,' ')
			end

			if client.first_name?
				citizenship_verification = citizenship_verification + client.first_name.strip[0,12].ljust(12,' ')
			else
				error_msg = error_msg +  " " + "First name is missing"
			end

			if client.dob?
				l_dob = client.dob.to_s[0,4]
				l_dob = l_dob + client.dob.to_s[5,2]
				l_dob = l_dob + client.dob.to_s[8,2]
				citizenship_verification = citizenship_verification + l_dob.strip[0,8].ljust(8,' ')
			else
				error_msg = error_msg +  " " + "DOB is missing"
			end

			if client.gender.present?
				if client.gender == 4478
					ls_gender = "F"
				elsif client.gender == 4479
					ls_gender = "M"
				elsif client.gender == 4480
					ls_gender = "U"
				end
				citizenship_verification = citizenship_verification + ls_gender.strip[0,1].ljust(1,' ')
			else
				if client.gender.blank?
					ls_gender = "U"
				end
				citizenship_verification = citizenship_verification + ls_gender.strip[0,1].ljust(1,' ')
			end


			citizenship_verification = citizenship_verification + "  004Z".ljust(75,' ')

			if citizenship_verification.length == 137
				citizenship_verification = citizenship_verification + "\n"
				extract_file.write(citizenship_verification)
				client.update(:sves_status => 'W')
			else
				error_file.puts(citizenship_verification + "  " + error_msg)
				error_count = error_count + 1
			end
			record_collection = NightlyBatchProcess.where("entity_id = #{each_client.entity_id} and process_type = 6513 ").update_all(processed: 'Y')
		end
	else
		log_file.puts("No records for Citizenship verification batch process")
	end
	log_file.puts("Number of clients errored due to insufficient data: ", + error_count)
	log_file.puts("Citizenship verification batch process end")
	extract_file.close
	log_file.close
	error_file.close
end

# /*******************************************************
# *  PROGRAM ID          :  citizenship_verfication_send.sqc                       *
# *  TRACKER ID          :                                                     *
# *  PROGRAM DESCRIPTION :                                                     *
# *                                                                            *
# * The program extracts all clients marked for sending to SSA for citizenship *
# *  verification                                                              *
# *                                                                            *
# *  AUTHOR                :Thirumal Rao                                       *
# *  DATE OF WRITTEN       : 02/26/2010.                                       *
# ***********xxxxxxxx**********************************************************/

# /*#define DEBUG
# */

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

# #define 	 	TRUE 		1
# #define 	 	FALSE		0

# /* define default error handling routines for SQL calls */
# EXEC SQL INCLUDE SQLCA;
# EXEC SQL BEGIN DECLARE SECTION;
#     static char id[9]            = "XXXXXXXX";
#     static char pass[9]          = "XXXXXXXX";
#     static char server[9]     = "aranssit";
#     /*static char server[9]     = "aransqap";  */
#     static char connection[9]    = "xxxxxxxx";
# EXEC SQL END DECLARE SECTION;


# #define    EXTRACT_FILE_NAME  "citi_to_ssa_extract.txt"
# #define    REPORT_FILE_NAME  "citi_to_ssa_results.txt"
# #define    ERROR_BUFFER_SIZE      2048

# FILE 	*EXTRACT_FILE_HANDLE = NULL;
# FILE 	*REPORT_FILE_HANDLE = NULL;

# /* REPORT FILE FUNCTION PROTOTYPES */
# int open_files(void);  /* wrapper function for opening all files */
# void close_files(void); /* wrapper function for closing all files */

# void print_log_message(char * message);

# void format_mmddyyyy(char * datetime);
# int database_connect(void);
# void database_disconnect(void);
# void print_log_message(char * message);
# int open_files(void);
# void close_files(void);

# int do_citizen_to_ssa_extract();
# void remDash(char *s);

# EXEC SQL WHENEVER SQLERROR continue;
# EXEC SQL WHENEVER SQLWARNING continue;
# EXEC SQL WHENEVER NOT FOUND continue;
# EXEC SQL INCLUDE SQLCA;


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

# 	/* declarations */
# 	int return_code = 0 ;
# 	char error_message[ERROR_BUFFER_SIZE] = "\0";

# 	return_code = open_files();
# 	if (return_code == 0){
# 		printf("error opening files.");
# 		return 1;
# 	}

# 	print_log_message("started the batch program.");

# 	return_code = database_connect();
# 	if (return_code == 0)
# 	{
# 		print_log_message("database connection error.");
# 		close_files();
# 		return 1;
# 	}

# 	return_code = do_citizen_to_ssa_extract();
# 	if (return_code == 0)
# 	{
#           print_log_message("'do_ssn_to_ssa_extract' failed. 1");
#           database_disconnect();
#           close_files();
#           return 1;
# 	}

# 	database_disconnect();
# 	print_log_message("successfully completed the batch program.");
# 	close_files();
#          EXEC SQL COMMIT;

# 	return (0);
# }


# /*==========================================================================

#                            database_connect

# This function is called to establish connection to database server.

# INPUT         : See function prototype
# RETURN Values : 1 (SUCCESSFUL), 0 (FAILURE)

# ===========================================================================*/

# int database_connect(void)
# {
# 	char error_message[ERROR_BUFFER_SIZE];
# 	char db2_server[512] = "\0";

# 	strcpy(db2_server, getenv("DB2INSTANCE"));
# 	if (strlen(db2_server) > 0){
# 		strcpy(server, db2_server);
# 	}

# 	sprintf(error_message, "connecting to database server '%s'.", server);
# 	print_log_message(error_message);

# 	/* connect to database server */
# 	EXEC SQL CONNECT TO :server;
# 	if (SQLCODE < 0)
# 	{
# 		sprintf(error_message, "fatal error %ld encountered when connecting to database server '%s'.", SQLCODE, server );
# 		print_log_message(error_message);

# 		sprintf(error_message, "database server:'%s'  user:'%s' password:'%s'.", server, id, pass );
# 		print_log_message(error_message);

# 		return (0);
# 	}
# 	else
# 	{
# 		if ((SQLCODE == 0) && (sqlca.sqlwarn[0] == 'w'))
# 		{
# 			sprintf(error_message, "warning errors encountered when attempting to logon to database server '%s'", server);
# 			print_log_message(error_message);
# 		}
# 	}

# 	EXEC SQL COMMIT;
# 	sprintf(error_message, "successfully connected to database server '%s'.", server);
# 	print_log_message(error_message);

# 	return 1;
# }


# /*==========================================================================
#                        database_disconnect

# This function is called to disconnect from IBM DB2 server.

# INPUT         : See function prototype
# RETURN Values : 1 (SUCCESSFUL)

# ===========================================================================*/

# void database_disconnect(void)
# {
# 	char error_message[ERROR_BUFFER_SIZE];

# 	/* close database and then disconnect from database server*/
# 	sprintf(error_message, "disconnecting from database server '%s'.", server);
# 	print_log_message(error_message);

# 	EXEC SQL DISCONNECT ALL;

# 	sprintf(error_message, "successfully disconnected from database server '%s'.", server);
# 	print_log_message(error_message);
# }


# /*==========================================================================
#                        print_log_message

# This function is called to write message into log file.

# INPUT         : See function prototype
# RETURN Values : NONE

# ===========================================================================*/

# void print_log_message(char * message)
# {
# 	char system_date_time[256];

# 	time_t timer;
# 	timer = time(NULL);

# 	/* obtain local time */
# 	strftime(system_date_time, sizeof(system_date_time), "%m/%d/%Y %X", localtime(&timer));

# 	printf("%s   %s\n", system_date_time, message);
# }


# /*==========================================================================
#                        open_files
# ===========================================================================*/

# int open_files(void)
# {

# 	REPORT_FILE_HANDLE = fopen(REPORT_FILE_NAME, "w+");
# 	if (REPORT_FILE_HANDLE == NULL)
# 	{
# 		printf("error opening '%s'. code:%d error:%s\n", REPORT_FILE_NAME, REPORT_FILE_HANDLE, strerror(errno));
# 		return 0;
# 	}
# 	EXTRACT_FILE_HANDLE = fopen(EXTRACT_FILE_NAME, "w+");
# 	if (EXTRACT_FILE_HANDLE == NULL)
# 	{
# 		printf("error opening '%s'. code:%d error:%s\n", EXTRACT_FILE_NAME, EXTRACT_FILE_HANDLE, strerror(errno));
# 		return 0;
# 	}

# 	return 1;
# }


# /*==========================================================================
#                        close_files
# ===========================================================================*/

# void close_files(void)
# {
# 	int return_code = 0;
# 	return_code = fclose(EXTRACT_FILE_HANDLE);
# 	if (return_code != 0)
# 	{
# 		printf("error closing '%s' error:'%s'\n", EXTRACT_FILE_NAME, strerror(errno));
# 	}
# 	return_code = fclose(REPORT_FILE_HANDLE);
# 	if (return_code != 0)
# 	{
# 		printf("error closing '%s' error:'%s'\n", EXTRACT_FILE_NAME, strerror(errno));
# 	}
# }




# /*******************************************************************************************
# 			CITIZENSHIP EXTRACT routines
# *******************************************************************************************/

# int do_citizen_to_ssa_extract()
# {
#   int  return_code = 0;
#   char error_message[ERROR_BUFFER_SIZE];
#   int counter = 0;
# /* variables for CITIZENSHIP  routines */
# EXEC SQL BEGIN DECLARE SECTION;
#   char	h_ssn[9+1] = "";
#   char  h_last_name[20] = "";
#   char  h_first_name[13] = "";
#   char  h_middla_name[2] = "";
#   char  h_dob[30] = "";
#   char  h_dob1[30] ="";
#   short  n_dob = 0;
#   char  h_sex[2] = "";
#   char  h_family_id[10] = "";
#   char  h_suf[10] = "";
#   char  h_fil1[13] = "";
#   char  h_fil2[35] = "";
#   char  h_file_type[6] = "";
#   char  h_family_id2[10] = "";
#   char  h_fil3[40] = "";
#   char  h_fil4[26] = "";
#   char  h_requestor[5] = "";
#   char  h_mult_req_id[4] = "";
#   short nssn;
#   short nlast;
#   short nfirst;
#   short nmiddle;
#   short ndob;

# EXEC SQL END DECLARE SECTION;

#   EXEC SQL DECLARE SSN_REC CURSOR WITH HOLD FOR
#   SELECT d.ssn ,
#          e.last_name,
#           e.first_name,
#           substr(e.middle_name,1,1),
#           d.dob,
#           e.sex,'  004', 'Z', '000000000   '
#   FROM dba.t_person_biograph d
#        inner join dba.t_person_demograph e on d.clientid =e.clientid
#   WHERE d.SVES_STATUS ='S'

#   union

#   SELECT d.ssn ,
#          e.last_name,
#           e.first_name,
#           substr(e.middle_name,1,1),
#           d.dob,
#           e.sex,'  004', 'Z', '000000000   '
#   FROM dba.t_person_biograph d
#        inner join dba.t_person_demograph e on d.clientid =e.clientid
#         where sves_type ='RS' and sves_status is null;




#   EXEC SQL OPEN SSN_REC;

#   do {
#     h_ssn[0] = '\0';
#     h_last_name[0] = '\0';
#     h_first_name[0] = '\0';
#     h_middla_name[0] = '\0';
#     h_dob[0] = '\0';
#     n_dob = 0;
#     h_sex[0] = '\0';
#     h_family_id[0] = '\0';
#     h_suf[0] = '\0';
#     h_fil1[0] = '\0';
#     h_fil2[0] = '\0';
#     h_file_type[0] = '\0';
#     h_family_id2[0] = '\0';
#     h_fil3[0] = '\0';
#     h_fil4[0] = '\0';
#     h_requestor[0] = '\0';
#     h_mult_req_id[0] = '\0';

#     EXEC SQL FETCH SSN_REC
#     INTO
#       :h_ssn indicator :nssn,
#       :h_last_name indicator :nlast,
#       :h_first_name indicator :nfirst,
#       :h_middla_name indicator :nmiddle,
#       :h_dob indicator :n_dob ,
#       :h_sex,
#       :h_file_type,
#       :h_requestor,
#       :h_fil1;

#   if (SQLCODE < 0)
#   {
#       printf("do_ssn_to_ssa_extract()....SSN %s\n", h_ssn);
#       sprintf(error_message, "do_ssn_to_ssa_extract 1 failed beceause of SQLCODE %ld.",SQLCODE);
#       print_log_message(error_message);
#       EXEC SQL CLOSE SSN_REC;
#       return 0;
#   }
#   else if (SQLCODE == 100)
#   {
#       EXEC SQL CLOSE SSN_REC;
#       return 1;
#   }
#   else if (SQLCODE == 0)
#   {
#     if (n_dob == -1)
#     {
#       h_dob[0] = '0';
#       h_dob[1] = '0';
#       h_dob[2] = '0';
#       h_dob[3] = '0';
#       h_dob[4] = '0';
#       h_dob[5] = '0';
#       h_dob[6] = '0';
#       h_dob[7] = '0';
#       h_dob[8] = '\0';
#     }
#     else
#     {
#      strcpy(h_dob1,h_dob);
#       h_dob[0] = h_dob1[5];
#       h_dob[1] = h_dob1[6];
#       h_dob[2] = h_dob1[8];
#       h_dob[3] = h_dob1[9];
#       h_dob[4] = h_dob1[0];
#       h_dob[5] = h_dob1[1];
#       h_dob[6] = h_dob1[2];
#       h_dob[7] = h_dob1[3];
#       h_dob[8] = '\0';
#     }
#     h_ssn[9] = '\0';
#     h_last_name[19] = '\0';
#     h_first_name[12] = '\0';
#     h_middla_name[1] = '\0';
#     h_sex[1] = '\0';
#     h_family_id[7] = '\0';
#     h_suf[3] = '\0';
#     h_fil1[12] = '\0';
#     h_fil2[34] = '\0';
#     h_file_type[5] = '\0';
#     h_fil4[20] = '\0';
#     h_requestor[4] = '\0';
#     h_mult_req_id[3] = '\0';


#     fprintf(REPORT_FILE_HANDLE,"%-9s%-12s%-19s%-1s%-12s%-8s%-1s%-5s%-1s%-69s\n",h_ssn,h_fil1,h_last_name,h_middla_name,h_first_name,h_dob,h_sex,h_file_type,h_requestor,h_fil3);


#   EXEC SQL
#   UPDATE
#    dba.t_person_biograph
#   set
#   SVES_STATUS ='W',
#   SVES_SEND_DATE = date(current timestamp)
#   WHERE SSN = :h_ssn ;
#   if (SQLCODE < 0)
#   {
#   printf("updaet failed of SQLCODE %ld.",SQLCODE);
#   }

#     }
#   } while(1);


#   fprintf(REPORT_FILE_HANDLE,"Record count:%d  \n",counter);
#   return 1;
# }



