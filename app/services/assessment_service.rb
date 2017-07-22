class AssessmentService
# Manoj Patil
# 01/22/2014
# Common functions of Client Assessment methods - which will be used in Assessment controls.
# Assessment REcommendation report functions

	def self.any_question_answered?(arg_params,arg_questions_collection)
		qstn_answered = false
		arg_questions_collection.each do |each_qstn|
			if arg_params["#{each_qstn.id}"].present?
				qstn_answered = true
				break
			end
		end
		return qstn_answered
	end

	def self.save_assessment_answer(arg_assessment_id,arg_params,arg_questions_collection)
		object_changed = false
		# Rails.logger.debug("MNP1 - arg_params= #{arg_params.inspect}")
		# Rails.logger.debug("MNP2 - arg_questions_collection= #{arg_questions_collection.inspect}")

		msg = "FAILED"
		arg_questions_collection.each do |each_qstn|
			# Rails.logger.debug("each_qstn = #{each_qstn.inspect}")
			# Rails.logger.debug("MNP3 - each_qstn = #{each_qstn.inspect}")

			if (each_qstn.id == 2 || each_qstn.id == 3)
				# Dont change /delete answers for question 2 & 3 , they are managed by only employment step/screen
			else




					if arg_params["#{each_qstn.id}"].present?

						# Rails.logger.debug("question id present = #{each_qstn.inspect}")
						# Rails.logger.debug("answer for question #{each_qstn.inspect} =   arg_params['#{each_qstn.id}']")
						# Rails.logger.debug("arg_params class = #{ arg_params["#{each_qstn.id}"].class}")
						if  "#{ arg_params["#{each_qstn.id}"].class}" == "Array"
							# if class is array - it is multi select - checkbox group - so Delete & Insert operation
							# answer_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn.id)
							# answer_collection.destroy_all

							# check if any answer really changed to set client assessment status to Incomplete.
							array_answer_collection_multi_select = arg_params["#{each_qstn.id}"]
							array_answer_collection_multi_select.each do |each_answer|
								# Rails.logger.debug("each_answer class = #{each_answer.class}")
								# Rails.logger.debug("each_answer = #{each_answer}")
								assessment_answer_object_collection = ClientAssessmentAnswer.where("client_assessment_id = ? and assessment_question_id = ? and answer_value = ?",arg_assessment_id,each_qstn.id,each_answer)
								if assessment_answer_object_collection.blank?
									object_changed = true
								else
									object_changed = false
								end	 # end of assessment_answer_object_collection.blank?
							end
							if object_changed == true
								 client_assessment_object = ClientAssessment.find(arg_assessment_id)
								 client_assessment_object.assessment_status = 6265 #status changed to incomplete
								 client_assessment_object.save
							end

							# if class is array - it is multi select - checkbox group - so Delete & Insert operation
							answer_collection_multi_select = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn.id)
							answer_collection_multi_select.destroy_all
							array_answer_collection_multi_select = arg_params["#{each_qstn.id}"]
							array_answer_collection_multi_select.each do |each_answer|
								assessment_answer_object = ClientAssessmentAnswer.new
								assessment_answer_object.client_assessment_id = arg_assessment_id
								assessment_answer_object.assessment_question_id = each_qstn.id
								assessment_answer_object.answer_value = each_answer.to_s
								assessment_answer_object.save
							end

							msg = "SUCCESS"
						else
							# save if any data populated. (Non Multi select)
							answer_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn.id)
							if answer_collection.present?

								assessment_answer_object = answer_collection.first
							else

								assessment_answer_object = ClientAssessmentAnswer.new
							end

							assessment_answer_object.client_assessment_id = arg_assessment_id
							assessment_answer_object.assessment_question_id = each_qstn.id
							# Rails.logger.debug("test= #{arg_params["#{each_qstn.id}"]}")
							assessment_answer_object.answer_value = arg_params["#{each_qstn.id}"]
							object_value_changed = assessment_answer_object.changed?
							Rails.logger.debug("object_value_changed1 = #{object_value_changed}")
							if object_value_changed == true

								if assessment_answer_object.save
									client_assessment_object = ClientAssessment.find(arg_assessment_id)
									client_assessment_object.assessment_status = 6265 #status changed to incomplete
									client_assessment_object.save
									msg = "SUCCESS"
								else
									msg = "assessment_answer_object.errors.full_messages.last"
								end
							else

								msg = "SUCCESS"
							end

						end


					else
						# Rails.logger.debug("This question id is not answered ? = #{each_qstn.inspect}")
						answer_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn.id)
						if answer_collection.present?
								answer_collection.destroy_all
								# assessment_answer_object = answer_collection.first
								# assessment_answer_object.destroy # since user put empty string in the user -
						end
						# check if th answer was present previously
						# answer_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn.id)
						# 	if answer_collection.present?
						# 		assessment_answer_object = answer_collection.first

					end # end of arg_params["#{each_qstn.id}"].present?
			end # end of (each_qstn.id == 2 || each_qstn.id == 3)
		end # end of arg_questions_collection.each do
		if arg_params[:sub_section_id].to_i == 13
			l_difficulty_score = populate_ld_assessment_and_client_score(arg_assessment_id)

			if l_difficulty_score >= 0

				client_id = ClientAssessment.find(arg_assessment_id).client_id
				assessment_history_id = ClientAssessmentHistory.where("parent_primary_key_id = ? and client_id = ? ",arg_assessment_id,client_id).order("id DESC").first
				client_score_object = ClientScore.where("client_id = ? and test_type = 3109 and client_assessment_id is null ",client_id).order("id DESC").first
				if assessment_history_id.present?
					if client_score_object.present?
						client_score_object.scores =  l_difficulty_score
		                client_score_object.date_referred = Date.today
						client_score_object.date_test_taken_on = Date.today
					    client_score_object.save
					else
					   client_scores = ClientScore.new
						client_scores.client_id = client_id
						client_scores.test_type = 3109
						client_scores.scores =  l_difficulty_score
		                client_scores.date_referred = Date.today
						client_scores.date_test_taken_on = Date.today
						client_scores.save
					end
				else
					#first assessment
					if client_score_object.present?
						client_score_object.scores =  l_difficulty_score
		                client_score_object.date_referred = Date.today
						client_score_object.date_test_taken_on = Date.today
	                    client_score_object.save
					else
					    client_scores = ClientScore.new
						client_scores.client_id = client_id
						client_scores.test_type = 3109
						client_scores.scores =  l_difficulty_score
		                client_scores.date_referred = Date.today
						client_scores.date_test_taken_on = Date.today
						client_scores.save
					end
				end
			end
		end
		return msg
	end












 	def self.return_years_of_school_attended(arg_assessment_id)
 		ls_years_of_school_attended = ""
 		# question - 142 = Elementary. Middle, or Junior High School (1-8)
 		school_years_1_to_8_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,142)
 		# question - 143 = "High School (9-12)"
 		school_years_9_to_12_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,143)
 		# question - 144 = "College or Vocational School (after High School) (13-16)"
 		school_years_13_to_16_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,144)
 		# question - 145 = "Post College/Graduate School (17-20)"
 		school_years_17_to_20_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,145)

 		# Since checking is done from in sequence ls_years_of_school_attended will give highest school years attended.
 		if school_years_1_to_8_collection.present?
 			ls_years_of_school_attended = school_years_1_to_8_collection.first.answer_value
 		end

 		if school_years_9_to_12_collection.present?
 			ls_years_of_school_attended = school_years_9_to_12_collection.first.answer_value
 		end

 		if school_years_13_to_16_collection.present?
 			ls_years_of_school_attended = school_years_13_to_16_collection.first.answer_value
 		end

 		if school_years_17_to_20_collection.present?
 			ls_years_of_school_attended = school_years_17_to_20_collection.first.answer_value
 		end

 		return ls_years_of_school_attended
 	end

 	def self.return_initial_barrier_comments(arg_sub_sction_id)
 		assessment_sub_section_object = AssessmentSubSection.find(arg_sub_sction_id)
		ls_comments = "Comments:"
 		ls_comments = "(#{assessment_sub_section_object.title})"
 		return ls_comments
 	end





 	def self.process_assessment_education_barriers(arg_assessment_id,arg_client_id)
 			AssessmentService.process_edu_school_barrier(arg_assessment_id,arg_client_id)
 			AssessmentService.process_edu_learning_barrier(arg_assessment_id)
 			AssessmentService.process_edu_language_barrier(arg_assessment_id)
 	end


 	def self.process_edu_school_barrier(arg_assessment_id,arg_client_id)
 		ls_comments = ""
 		ls_detail_comments = ""
 		lb_barrier_exists = false
 		education_collection = Education.client_higher_educations_collections(arg_client_id)
 		if education_collection.blank?
 			ls_detail_comments = "No high school diploma"
 			ls_comments = AssessmentSubSection.find(10).title
 			lb_barrier_exists = true
 		end
 		if lb_barrier_exists == true
 			#                 save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,3,7,ls_comments)
	 		#                 save_assessment_recommendation(arg_assessment_id,arg_barrier_id)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,7)
	 		#                 save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
	 		AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,7,10,ls_detail_comments,1)
	 	end
 	end

 	def self.process_edu_learning_barrier(arg_assessment_id)
 		# Barrier = 8 = "	May have learning disabilities	"
        l_difficulty_score = populate_ld_assessment_and_client_score(arg_assessment_id)
 		if l_difficulty_score >= 12
 			ls_sub_section_name = AssessmentSubSection.find(13).title
 			ls_comments = ls_sub_section_name
 			# barriers exist
 			# 1.assessment_barriers
 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,3,8,ls_comments)
	 		# 2. assessment_barrier_recommendations
	 		# save_assessment_recommendation(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,8)
			# 3.assessment_barrier_details
			ls_detail_comments = "(#{ls_sub_section_name}) Score: #{l_difficulty_score} out of 30"
			# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
			  AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,8,13,ls_detail_comments,2)
		end
 	end


 	def self.process_edu_language_barrier(arg_assessment_id)
 		#Barrier = 9 "	May lack English language proficiency	"
		ls_sub_section_name = AssessmentSubSection.find(14).title
 		ls_comments = ls_sub_section_name
 		ls_detail_comments = "(#{ls_sub_section_name})"
 		language_related_questions = [44,45,47,48]
 		lb_barrier_exists = false

 		language_related_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
 			if answer_for_question_collection.present?
 				if answer_for_question_collection.first.answer_value == "Y"
 					lb_barrier_exists = true
 					if each_qstn == 44
 						ls_detail_comments = "#{ls_detail_comments} Reading,"
 					end
 					if each_qstn == 45
 						ls_detail_comments = "#{ls_detail_comments} Writing,"
 					end
 					if each_qstn == 47
 						ls_detail_comments = "#{ls_detail_comments} Speaking,"
 					end
 					if each_qstn == 48
 						ls_detail_comments = "#{ls_detail_comments} Understanding,"
 					end

 				end
 			end
 		end

 		if lb_barrier_exists == true
 			# 1.assessment_barriers
 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,3,9,ls_comments)
	 		# 2. assessment_barrier_recommendations
	 		# save_assessment_recommendation(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,9)
			# 3.assessment_barrier_details
			li_length = ls_detail_comments.length
			li_length = li_length - 2
			ls_detail_comments = ls_detail_comments[0..li_length]
			# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
			  AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,9,14,ls_detail_comments,3)
 		end

 	end


 	def self.process_assessment_employment_barriers(arg_assessment_id)
 			AssessmentService.process_employment_never_held_paying_job_currently_not_working_barrier(arg_assessment_id)
 			AssessmentService.process_employment_currently_working_and_needs_assistanc_barrier(arg_assessment_id)
 			# AssessmentService.process_employment_criminal_record_barrier(arg_assessment_id)
 			# AssessmentService.process_employment_upcoming_court_date_barrier(arg_assessment_id)
 	end

 	def self.process_employment_never_held_paying_job_currently_not_working_barrier(arg_assessment_id)
 			ls_sub_section_name =  AssessmentSection.find(2).title
 			ls_comments = ls_sub_section_name

 			# Barrier 2 = "	Never held a paying job	"
 			# Question = 3 = "Have you ever held a paying job?"
 			li_barrier_id = []
 			lb_barrier_exists = false
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,904)
	 		if answer_for_question_collection.present?
	 			if answer_for_question_collection.first.answer_value == "N"
	 				lb_barrier_exists = true
	 				li_barrier_id << 2
	 			end
	 		end

	 		# if lb_barrier_exists == false
	 			# Question = 2 = "Are you currently working?"
		 		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,2)
		 		if answer_for_question_collection.present?
		 			if answer_for_question_collection.first.answer_value == "N"
		 				lb_barrier_exists = true
		 				li_barrier_id << 6
		 			end
		 		end
	 		# end

	 		if lb_barrier_exists == true
	 			li_barrier_id.each do |barrier|
	 			# 1.assessment_barriers
	 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
		 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,2,barrier,ls_comments)
		 		# 2. assessment_barrier_recommendations
		 		# save_assessment_recommendation(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
		 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,barrier)
				# 3.assessment_barrier_details
				# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
				AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,barrier,2,"",1)
	 			end

	 		end
 	end

 	def self.process_employment_currently_working_and_needs_assistanc_barrier(arg_assessment_id)
 		# Barrier = 3 = "	Currently working and needs assistance	"
 		ls_sub_section_name =  AssessmentSection.find(2).title
 		ls_comments = ls_sub_section_name
 		ls_detail_comments = "#{ls_sub_section_name}"

 		lb_proceed = false
 		# Rule 1 Never held paying job should be No
 		# answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,3)
 		# if answer_for_question_collection.present?
 		# 	if answer_for_question_collection.first.answer_value == "N"
 		# 		lb_proceed = true
 		# 	end
 		# end

 		# Rule 2 Currently working should be Yes
 		# if lb_proceed == true
	 		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,2)
	 		if answer_for_question_collection.present?
	 			if answer_for_question_collection.first.answer_value == "Y"
	 				lb_proceed = true
	 			end
	 		end
	 	# end

 		if lb_proceed == true
	 		# Question = 4 = "Since you currently have a job, why is it not meeting your needs?"
	 		answer_for_question_collection = ClientAssessmentAnswer.challenges_in_retaining_job_collection(arg_assessment_id)
	 		if answer_for_question_collection.present?
	 			# ls_detail_comments_for_client = ""

				ls_detail_comments_for_client =  "Client has following challenges in retaining his job - #{answer_for_question_collection.gsub(/\,$/, '.')}"
					# 1.assessment_barriers
	 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
		 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,2,3,ls_comments)
		 		# 2. assessment_barrier_recommendations
		 		# save_assessment_recommendation(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
		 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,3)
				# 3.assessment_barrier_details
				# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
				AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,3,2,ls_detail_comments_for_client,2)
	 		end
	 	end

 	end

 	def self.process_employment_criminal_record_barrier(arg_assessment_id)
 		# Barrier = 5 "	Criminal record and/or on parole or probation	"
 		ls_sub_section_name = AssessmentSubSection.find(5).title
 		ls_comments = ls_sub_section_name
 		ls_detail_comments = "(#{ls_sub_section_name})"
 		lb_barrier_exists = false
 		# Question = 33 = "Sometimes having a criminal record can hinder someone's ability to get a job. <b> Have you ever been convicted of any criminal offense other than a minor traffic violation?"
 		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,33)
 		if answer_for_question_collection.present?
 			if answer_for_question_collection.first.answer_value == "Y"
 				lb_barrier_exists = true
 				# 36 = "If yes, are you on parole or probation now?"
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,36)
 				if answer_for_question_collection.present?
 					if answer_for_question_collection.first.answer_value == "Y"
 						ls_detail_comments = "#{ls_detail_comments} currently on probation and/or parole."
 					else
 						ls_detail_comments = "#{ls_detail_comments} not on probation and/or parole."
 					end
 				end
 			end
 		end

 		if lb_barrier_exists == true
 			# 1.assessment_barriers
 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,2,5,ls_comments)
	 		# 2. assessment_barrier_recommendations
	 		# save_assessment_recommendation(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,5)
			# 3.assessment_barrier_details
			# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
			  AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,5,5,ls_detail_comments,3)
 		end
 	end

 	def self.process_employment_upcoming_court_date_barrier(arg_assessment_id)
 		# Barrier = 4 "	Upcoming court date	"
 		ls_sub_section_name = AssessmentSubSection.find(5).title
 		ls_comments = ls_sub_section_name
 		ls_detail_comments = "(#{ls_sub_section_name})"

 		# Question = 37 = "Do you have any upcoming court dates?"
 		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,37)
 		if answer_for_question_collection.present?
 			if answer_for_question_collection.first.answer_value == "Y"
 				# 1.assessment_barriers
	 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
		 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,2,4,ls_comments)
		 		# 2. assessment_barrier_recommendations
		 		# save_assessment_recommendation(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
		 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,4)
 				# 595;5;"Date?"
				# 596;5;"Reason?"
				# 597;5;"Date?"
				# 598;5;"Reason?"
				# 599;5;"Date?"
				# 600;5;"Reason?"
				# 601;5;"Date?"
				# 602;5;"Reason?"
				ls_detail_comment1 = ls_detail_comments
				ls_detail_comment2 = ls_detail_comments
				ls_detail_comment3 = ls_detail_comments
				ls_detail_comment4 = ls_detail_comments
 				court_date_reason_questions = [596,595,598,597,600,599,602,601]
		 		court_date_reason_questions.each do |each_qstn|
		 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
		 			if answer_for_question_collection.present?
		 				if answer_for_question_collection.first.answer_value.present?
		 					if each_qstn == 596
		 						ls_detail_comment1 = "#{ls_detail_comment1} reason: #{answer_for_question_collection.first.answer_value}."
		 					end
		 					if each_qstn == 595
		 						ls_detail_comment1 = "#{ls_detail_comment1} court date: #{answer_for_question_collection.first.answer_value}."
		 					end
		 					if ls_detail_comment1.present?
		 						# 3.assessment_barrier_details
								# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
			  					  AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,4,5,ls_detail_comment1,4)
		 					end
		 					if each_qstn == 598
		 						ls_detail_comment2 = "#{ls_detail_comment2} reason: #{answer_for_question_collection.first.answer_value}."
		 					end
		 					if each_qstn == 597
		 						ls_detail_comment2 = "#{ls_detail_comment2} court date: #{answer_for_question_collection.first.answer_value}."
		 					end
		 					if ls_detail_comment2.present?
		 						# 3.assessment_barrier_details
								# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
			  					  AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,4,5,ls_detail_comment2,5)
		 					end
		 					if each_qstn == 600
		 						ls_detail_comment3 = "#{ls_detail_comment3} reason: #{answer_for_question_collection.first.answer_value}."
		 					end
		 					if each_qstn == 599
		 						ls_detail_comment3 = "#{ls_detail_comment3} court date: #{answer_for_question_collection.first.answer_value}."
		 					end
		 					if ls_detail_comment3.present?
		 						# 3.assessment_barrier_details
								# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
			  					  AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,4,5,ls_detail_comment3,6)
		 					end
		 					if each_qstn == 602
		 						ls_detail_comment4 = "#{ls_detail_comment4} reason: #{answer_for_question_collection.first.answer_value}."
		 					end
		 					if each_qstn == 601
		 						ls_detail_comment4 = "#{ls_detail_comment4} court date: #{answer_for_question_collection.first.answer_value}."
		 					end
		 					if ls_detail_comment4.present?
		 						# 3.assessment_barrier_details
								# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
			  					  AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,4,5,ls_detail_comment4,7)
		 					end

		 				end
		 			end
		 		end
		 	end
		end
 	end


 	def self.process_assessment_housing_barriers(arg_assessment_id)
 		   # Barrier 10 = "	Unstable housing	"

 			ls_sub_section_name = AssessmentSubSection.find(15).title
 			ls_comments = ls_sub_section_name
 			ls_detail_comments = "(#{ls_sub_section_name})"
 			lb_barrier_exists = false
 			# lb_current_housing_barrier_exists = false
 			# lb_other_housing_barrier_exists = false

 			# Question 49 = "1. Is there anything about your housing situation that is unstable or presents a challenge for you to work? For example, have you moved a lot in recent months?"
	 		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,49)
	 		if answer_for_question_collection.present?
	 			if answer_for_question_collection.first.answer_value == "Y"
	 				# lb_current_housing_barrier_exists = true
	 				# Manoj 05/08/2015
	 				lb_barrier_exists = true
	 				# 1.assessment_barriers
		 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
			 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,4,10,ls_comments)
			 		# 2. assessment_barrier_recommendations
			 		# save_assessment_recommendation(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
			 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,10)
	 				# Question = 803 = "What is your current housing situation?"
	 				# Question = 50 = "If other, please specify:"

	 				housing_related_questions = [803,50]
			 		housing_related_questions.each do |each_qstn|
			 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			 			if answer_for_question_collection.present?
			 				if answer_for_question_collection.first.answer_value.present?
			 					if each_qstn == 803
			 						ls_detail_comments = "(#{ls_sub_section_name})  #{answer_for_question_collection.first.answer_value}"
			 						# 3.assessment_barrier_details
									# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
			  					  	AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,10,15,ls_detail_comments,1)
			 					end
			 					if each_qstn == 50
			 						ls_detail_comments = "(#{ls_sub_section_name}) other: #{answer_for_question_collection.first.answer_value}."
			 						# 3.assessment_barrier_details
									# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
			  					  	AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,10,15,ls_detail_comments,2)
			 					end
			 				end
			 			end
			 		end
			 	end
			end

			# 53 = "Is there anything else about your housing situation that is unstable or that you would like to discuss?"
			ls_sub_section_name = AssessmentSubSection.find(17).title
 			ls_comments = ls_sub_section_name
 			ls_detail_comments = "(#{ls_sub_section_name})"

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,53)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value == "Y"

					if lb_barrier_exists == true
						ls_comments = "#{AssessmentSubSection.find(15).title},#{AssessmentSubSection.find(17).title}"
						AssessmentBarrier.update_assessment_barrier_comments(arg_assessment_id,10,ls_comments)
					else
						# 1.assessment_barriers
			 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
				 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,4,10,ls_comments)
				 		# 2. assessment_barrier_recommendations
				 		# save_assessment_recommendation(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
				 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,10)
					end
					# lb_other_housing_barrier_exists = true
					lb_barrier_exists = true


					# "If yes, please explain."
					answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,54)
					if answer_for_question_collection.present?
						if answer_for_question_collection.first.answer_value.present?
							ls_detail_comments = "#{ls_detail_comments} #{ answer_for_question_collection.first.answer_value}"
							# 3.assessment_barrier_details
							# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
							AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,10,17,ls_detail_comments,3)
						end
					end
				end
			end

			# 51 = "How many times have you moved in the last 12 months, including temporary or short moves."
			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,231)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value.present?
					moved_count = answer_for_question_collection.first.answer_value.to_i
					if  moved_count > 3
						# Barrier Exists - if barrier record is not inserted before then insert
						if lb_barrier_exists == true
							ls_comments = "#{AssessmentSubSection.find(15).title},#{AssessmentSubSection.find(17).title}"
							AssessmentBarrier.update_assessment_barrier_comments(arg_assessment_id,10,ls_comments)
						else
							# if lb_other_housing_barrier_exists == false
								# 1.assessment_barriers
					 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
						 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,4,10,ls_comments)
						 		# 2. assessment_barrier_recommendations
						 		# save_assessment_recommendation(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
						 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,10)
							# end
						end
						ls_detail_comments = "(#{AssessmentSubSection.find(17).title})"
						ls_detail_comments = "#{ls_detail_comments} moved #{moved_count} times in past year."
						# 3.assessment_barrier_details
						# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
						AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,10,17,ls_detail_comments,4)

					end
				end
			end
 	end

 	def self.process_assessment_transportation_barriers(arg_assessment_id)
 		# Barrier = 27 "	Transportation challenge	"
 		ls_sub_section_name = AssessmentSubSection.find(43).title
 		ls_comments = ls_sub_section_name
 		ls_detail_comments = "(#{ls_sub_section_name})"
 		lb_barrier_exists = false

 		# 805 :"Is there anything about your transportation method that presents a challenge for you to work? For example, do you need a car? Is your car unreliable? Is public transportation reliable?"
	 	answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,805)
		if answer_for_question_collection.present?
			if answer_for_question_collection.first.answer_value == "Y"
				lb_barrier_exists = true
				# 1.assessment_barriers
	 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
		 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,13,27,ls_comments)
		 		# 2. assessment_barrier_recommendations
		 		# save_assessment_recommendation(arg_assessment_id,arg_section_id,arg_barrier_id)
		 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,27)
			end
		end

		if lb_barrier_exists == true
			# 62 :"Is there anything else about your transportation situation that you would like to discuss?"
	 	# 	answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,62)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value == "Y"
			 		# question 63: Transportaion challenge - Yes explanation.
			 		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,63)
					if answer_for_question_collection.present?
						if answer_for_question_collection.first.answer_value.present?
							ls_detail_comments = "#{ls_detail_comments} #{ answer_for_question_collection.first.answer_value}"
							# 3.assessment_barrier_details
							# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
							AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,27,43,ls_detail_comments,1)
						end
					end

				end
			end

			#Driving license validity
			# 57 = "Do you have a valid driving license?"
			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,57)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value == "N"
					ls_detail_comments = "(#{AssessmentSubSection.find(42).title}) No driver's license"
					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,27,42,ls_detail_comments,2)
					ls_comments = "#{ls_comments},#{AssessmentSubSection.find(42).title}"
					AssessmentBarrier.update_assessment_barrier_comments(arg_assessment_id,27,ls_comments)
				else
					# Question :61 = "If you own a vehicle, is it reliable?"
					answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,61)
					if answer_for_question_collection.present?
						if answer_for_question_collection.first.answer_value == "N"
							ls_detail_comments = "(#{AssessmentSubSection.find(42).title}) no access to reliable vehicle."
							# 3.assessment_barrier_details
							# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
							AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,27,42,ls_detail_comments,5)
						end
					end
				end
			end

			# 512 = "If no, do you have a suspended license?"
			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,512)
			if answer_for_question_collection.present?

				if answer_for_question_collection.first.answer_value == "Y"
					ls_detail_comments = "(#{AssessmentSubSection.find(42).title}) suspended driver's license."
					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,27,42,ls_detail_comments,3)
					# ls_comments = "#{ls_comments},#{AssessmentSubSection.find(42).title}"
					# AssessmentBarrier.update_assessment_barrier_comments(arg_assessment_id,27,ls_comments)
					# 514;"When will it be reinstated?"
					answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,514)
					if answer_for_question_collection.present?
						if answer_for_question_collection.first.answer_value.present?
							ls_detail_comments = "(#{AssessmentSubSection.find(42).title}) reinstate date: #{answer_for_question_collection.first.answer_value}."
							# 3.assessment_barrier_details
							# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
							AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,27,42,ls_detail_comments,4)
						end
					end

				end
			end

			# question 55 :"How do you usually get to the places you need to go?"
			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,55)
			if answer_for_question_collection.present?
				ls_comments = "#{ls_comments},#{AssessmentSubSection.find(41).title}"
				AssessmentBarrier.update_assessment_barrier_comments(arg_assessment_id,27,ls_comments)

				ls_sub_section_name = "(#{AssessmentSubSection.find(41).title})"
				li_sort_order = 5
				answer_for_question_collection.each do |each_answer|
					ls_detail_comments = "#{ls_sub_section_name} #{each_answer.answer_value}"
					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,27,41,ls_detail_comments,li_sort_order)
					li_sort_order = li_sort_order + 1

					if each_answer.answer_value == "Other"
						# 56 "If other, please specify:"
						answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,56)
						if answer_for_question_collection.present?
							if answer_for_question_collection.first.answer_value.present?
								ls_detail_comments = "#{ls_sub_section_name} #{answer_for_question_collection.first.answer_value}"
								# 3.assessment_barrier_details
								# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
								AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,27,41,ls_detail_comments,li_sort_order)
							end
						end
					end
				end
			end

		end

 	end

 	def self.process_assessment_general_health_barriers(arg_assessment_id)
 		# 1
			AssessmentService.process_general_health_challenge_to_work_condition_barrier(arg_assessment_id)
 	end


 	def self.process_general_health_challenge_to_work_condition_barrier(arg_assessment_id)
 		# # Barrier = 18 = 		Health challenge to work
		# Question ID =66 ="Is there anything about your health that presents a challenge to you to work?"
		lb_barriers_found = false
		ls_sub_section_name = AssessmentSubSection.find(29).title
 		ls_comments = ls_sub_section_name

 		assessment_object = ClientAssessment.find(arg_assessment_id)
 		disability_char_collection = ClientCharacteristic.open_characteristics_for_client("DisabilityCharacteristic",assessment_object.client_id)
 		# start
 		# 1.
 		if disability_char_collection.present?
 			lb_barriers_found = true
 		end
 		# 2.
 		answer_for_question_collection_66 = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,66)
		if answer_for_question_collection_66.present?
			if answer_for_question_collection_66.first.answer_value == "Y"
				lb_barriers_found = true
			end
		end
		# 3.
		answer_for_question_collection_64 = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,64)
		if answer_for_question_collection_64.present?
			if answer_for_question_collection_64.first.answer_value == "Poor"
				lb_barriers_found = true
			end
		end

		if lb_barriers_found == true
			# fail
			# 1.assessment_barriers
 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,8,18,ls_comments)
	 		# 2. assessment_barrier_recommendations
	 		# save_assessment_recommendation(arg_assessment_id,arg_section_id,arg_barrier_id)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,18)

	 		# 3. _assessment_barrier_detail will have all entries of disability characteristic/intyerview mode answers details
	 		# disability characteristics
	 		if disability_char_collection.present?
	 			disability_char_collection.each do |disability|
		 			disability_char_type = CodetableItem.get_short_description(disability.characteristic_id.to_i)
		 			ls_detail_comments = "#{ls_sub_section_name}: Participant is having #{disability_char_type}."
		 			#            self.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
		 			AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,18,29,ls_detail_comments,1)
	 			end
	 		end

	 		# 2.
	 		answer_for_question_collection_66 = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,66)
			if answer_for_question_collection_66.present?
				if answer_for_question_collection_66.first.answer_value == "Y"
					ls_detail_comments = "#{ls_sub_section_name}: client answered Yes for question Is there anything about your health that presents a challenge to you to work? or do you have any serious medical conditions?"
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,18,29,ls_detail_comments,2)
				end
			end
			# 3.
			answer_for_question_collection_64 = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,64)
			if answer_for_question_collection_64.present?
				if answer_for_question_collection_64.first.answer_value == "Poor"
					ls_detail_comments = "#{ls_sub_section_name}: client answered his overall health condition is poor"
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,18,29,ls_detail_comments,3)
				end
			end
		end
		# fail

 	end


 	def self.process_assessment_mental_health_barriers(arg_assessment_id)
 		# 1
 			AssessmentService.process_mental_health_barrier(arg_assessment_id)

 	end

 	# Mental Health emotional health start
 	def self.process_mental_health_barrier(arg_assessment_id)
 		# Barrier = 22 = 	Mental health challenge
 		ls_sub_section_name = AssessmentSubSection.find(35).title
 		ls_comments = ls_sub_section_name
 		ls_detail_comments = ""

 		lb_barrier_found = false
 		assessment_object = ClientAssessment.find(arg_assessment_id)
 		mentalhealth_char_collection = ClientCharacteristic.open_characteristics_for_client("MentalCharacteristic",assessment_object.client_id)
 		# Manoj 04/14/2016 -start
 		if mentalhealth_char_collection.present?
 			lb_barrier_found = true
 		end

 		# Barrier = 22 = 	Mental health challenge
 		 		# 173;35;"1. Have you ever felt like you have had or diagnosed or treated for a mental health condition, such as depression or ADD?"
 		answer_for_mental_health_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,173)
		if answer_for_mental_health_question_collection.present?
			if answer_for_mental_health_question_collection.first.answer_value == "Y"
				lb_barrier_found = true
			end
		end

 		li_score = 0
 		li_count = 0
 		li_each_score = 0
 		lb_depressed = false
 		# Question ID - 176 to 184
 		(176..184).each do |question_id|
 			li_each_score = AssessmentService.return_mental_health_score(arg_assessment_id,question_id)
 			if li_each_score > 0
 				li_score = li_score + li_each_score
	 			if li_each_score == 5 # All of the time radio button is checked on emotional health question
					lb_depressed = true
				end
				if li_each_score == 4 # "Most of the time"
					li_count = li_count + 1
				end
 			end
 		end # end of loop.

 		if li_count >= 2
 			lb_depressed = true
 		end

 		if li_score >= 16
 			lb_depressed = true
 		end

 		# 534 = "Have you ever experienced or witnessed a frightening or violent event?"
 		answer_for_question_collection_534 = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,534)
		if answer_for_question_collection_534.present?
			if answer_for_question_collection_534.first.answer_value == "Y"
				lb_depressed = true
			end
		end

		# 535 = "Have you ever wanted or thought of huring yourself or others?"
		answer_for_question_collection_535 = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,535)
		if answer_for_question_collection_535.present?
			if answer_for_question_collection_535.first.answer_value == "Y"
				lb_depressed = true
			end
		end

		# 536 = "Do you have trouble sleeping even if you are tired?"
		answer_for_question_collection_536 = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,536)
		if answer_for_question_collection_536.present?
			if answer_for_question_collection_536.first.answer_value == "Y"
				lb_depressed = true
			end
		end

		if lb_depressed == true
 			lb_barrier_found = true
 		end

 		if lb_barrier_found == true
 			# 1.assessment_barriers
 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,10,22,ls_comments)
	 		# 2. assessment_barrier_recommendations
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,22)
 		end

 		# assessment_barrier_details

 		if lb_barrier_found == true
		 		if mentalhealth_char_collection.present?
		 			if mentalhealth_char_collection.length == 1
		 				case mentalhealth_char_collection.first.characteristic_id
		 				when 5755
		 					ls_detail_comments = "#{ls_sub_section_name}: Participant has mentioned that he/she is suffering from an unstable mental health."
		 				when 5756
		 					ls_detail_comments = "#{ls_sub_section_name}: Participant has mentioned that he/she is suffering from ADD(Attention deficit disorder)."
		 				end
		 			elsif mentalhealth_char_collection.length == 2
		 				ls_detail_comments = "#{ls_sub_section_name}: Participant has mentioned that he/she is suffering from ADD(Attention deficit disorder) and has an unstable mental health."
		 			end
		 			# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,22,35,ls_detail_comments,1)
		 		end


		 		if answer_for_mental_health_question_collection.present?
		 			if answer_for_mental_health_question_collection.first.answer_value == "Y"
		 				ls_detail_comments = "#{ls_sub_section_name}: Participant has answered Yes for question:Have you ever felt like you have had or diagnosed or treated for a mental health condition, such as depression or ADD? "
		 				AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,22,35,ls_detail_comments,2)
		 			end
		 		end

		 		if lb_depressed == true
		 				if li_score > 0
							ls_detail_comments = "#{ls_detail_comments} Score: #{li_score} out of 45"
							# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
							AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,22,35,ls_detail_comments,3)
						end


						if answer_for_question_collection_534.present? && answer_for_question_collection_534.first.answer_value == "Y"
							ls_detail_comments = "#{ls_sub_section_name}: Experienced or witnessed a violent event."
							AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,22,35,ls_detail_comments,4)
						end

						if answer_for_question_collection_535.present? && answer_for_question_collection_535.first.answer_value == "Y"
							ls_detail_comments = "#{ls_sub_section_name}: Thought of huring self or others."
							AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,22,35,ls_detail_comments,5)
						end

						if answer_for_question_collection_536.present? && answer_for_question_collection_536.first.answer_value == "Y"
							ls_detail_comments = "#{ls_sub_section_name}: Trouble Sleeping."
							AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,22,35,ls_detail_comments,6)
						end
		 		end
		end

 	end





 	def self.return_mental_health_score(arg_assessment_id,arg_question_id)
 		li_return_value = 0
 		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,arg_question_id)
		if answer_for_question_collection.present?
			ans_value = answer_for_question_collection.first.answer_value
			li_return_value = AssessmentService.menatl_health_radio_group_answer_value(ans_value)
		end
		return li_return_value
 	end


 	def self.menatl_health_radio_group_answer_value(arg_answer)
 		li_return = 0
 		case arg_answer
 			when "All of the time"
 				li_return =  5
 			when "Most of the time"
 				li_return =  4
 			when "Some of the time"
 				li_return =  3
 			when "A little of the time"
 				li_return =  2
 			when "None of the time"
 				li_return =  1
 		end
 		return 	li_return

 	end

 	# Mental Health emotional health end

 	def self.process_assessment_substance_abuse_barriers(arg_assessment_id)
 		# Barrier = 21 "	May have an alcohol or drug addiction	"
 		lb_barrier_found = false
 		ls_sub_section_name = AssessmentSubSection.find(32).title
 		ls_comments = ls_sub_section_name

 		assessment_object = ClientAssessment.find(arg_assessment_id)
 		substance_abuse_char_collection = ClientCharacteristic.open_characteristics_for_client("SubstanceAbuseCharacteristic",assessment_object.client_id)
 		if substance_abuse_char_collection.present?
 			lb_barrier_found = true
 		end

 		count = 0
 		substance_abuse_relatied_questions  = [834,607,608,609,610,611,612,614,613,619,620,621,622,623,624,625,626,615,628,617,627,616,618,543,544,545,546,547,548,549,550,551,553,554,555,556]
		# [811,186,187,188,189,190,191,518,519,543,544,545,546,547,548,549,550,551,552,553,554,555,556]
 		substance_abuse_relatied_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					if (each_qstn == 543 || each_qstn == 544 || each_qstn == 545 || each_qstn == 546 ||
						each_qstn == 547 || each_qstn == 548 || each_qstn == 549 || each_qstn == 550 ||
						each_qstn == 551 || each_qstn == 553 || each_qstn == 554 || each_qstn == 555 ||
						each_qstn == 556
						)

						lb_barrier_found = true
					else
						count = count + 1
					end
				end
			end
 		end

 		if count > 3
 			lb_barrier_found = true
 		end

 		if lb_barrier_found == true
 			# 1.assessment_barriers
 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,9,21,ls_comments)
	 		# 2. assessment_barrier_recommendations
	 		# save_assessment_recommendation(arg_assessment_id,arg_barrier_id)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,21)
 		end

 		if lb_barrier_found == true
 			# 3.assessment_barrier_details
			# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)

 			if substance_abuse_char_collection.present?
 				ls_detail_comments = "#{ls_sub_section_name}: Participant has mentioned that he/she is suffering from substance abuse."
 				AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,1)
 			end

 			# 1. question 834
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,834)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Tried to cut down or quit drinking or using drugs"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,1)
				end
			end
			# 2.
			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,607)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Problem stopping drinking or using drugs?"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,2)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,608)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Have more to drink or use more drugs than you intended to, or did you drink or use longer than you intended to?"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,3)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,609)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Times you had to drink or use drugs much more than you used to in order to get the same effect you wanted?"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,4)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,610)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Relative, close friend, or partner ever worried or complained about your drinking or drug use?"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,5)
				end
			end


			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,611)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Felt bad or guilty about your drinking or drug use?"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,6)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,612)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Spent a lot of time thinking about or trying to get alcohol or other drugs?"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,7)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,614)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Participated in high risk activities or been injured while under the influence of alcohol or other substances?"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,8)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,613)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Drinking or drug use interfered with your work at a job, school, or at home"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,9)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,619)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Blackouts or other periods of memory loss"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,10)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,620)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Injury to your head"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,11)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,621)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Convulsions or delirium tremens(DTs)"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,12)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,622)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Hepatitis or other liver problems"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,13)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,623)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Feeling sick, shaky, or depressed"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,14)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,624)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Feeling coke bugs or a crawling feeling under the skin"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,15)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,625)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Injury to yourself or others"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,16)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,626)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Using needles to shoot drugs"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,17)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,615)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Had emotional or psychological problems from drinking or using drugs?"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,18)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,628)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Ask for help because of drinking or drug use"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,19)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,617)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Hospitalized because of drinking or drug use"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,20)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,627)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Alcohol dependent"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,21)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,616)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: Drug dependent"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,22)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,618)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: In the past month, abused prescription or non-prescription drugs or any other substance"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,32,ls_detail_comments,23)
				end
			end

			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,75)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					ls_detail_comments = "#{ls_sub_section_name}: People living with you or closely involved in your life have a problem or a history of problems with illegal drugs, prescription drugs, and/or alcohol"
 					# 3.assessment_barrier_details
					# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
					AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,21,33,ls_detail_comments,24)
				end
			end

 		end

 	end


 	def self.process_assessment_domestic_voilence_barriers(arg_assessment_id)

 		# 1
 			# AssessmentService.process_domestic_voilence_barrier_victim(arg_assessment_id)

 		# 2.
 			AssessmentService.process_domestic_voilence_barrier(arg_assessment_id)

    end

    def self.process_domestic_voilence_barrier(arg_assessment_id)
    	lb_barrier_found = false
    	ls_sub_section_name = AssessmentSubSection.find(38).title
		ls_comments = ls_sub_section_name
   		# Barrier = 26 "Domestic violence-related conflicts"
   		assessment_object = ClientAssessment.find(arg_assessment_id)
 		substance_abuse_char_collection = ClientCharacteristic.open_characteristics_for_client("DomesticViolenceCharacteristic",assessment_object.client_id)

		if substance_abuse_char_collection.present?
			lb_barrier_found = true
		end

		# Victim
		# 1.
		# 710;38;"Have you ever been abused, physically or emotionally, by a partner?"
		# 780;38;"Have you ever applied for a restraining order?"
		# 774;38;"Have you ever felt that your partner was trying to control your life, behavior or finances?"
		# 857 Do you have concerns for your safety or the safety of your family?
		# Has there ever been anything going on at home that made you feel afraid?
		# 206 - IS THIS ISSUE NOW
		#Have the police ever been called to your house to settle a dispute or because of violence?
		# 207 -IS THIS ISSUE NOW
		#  Have you ever been in a relationship in which you have been threatened or physically hurt?
		# 208-IS THIS ISSUE NOW
		# Has another person ever destroyed your clothing, objects, or something you especially cared about?
		# 209 - IS THIS ISSUE NOW
		# Has your partner or others ever tried to control the money you earn or spend?
		# 712 - IS THIS ISSUE NOW
		# Has another person ever prevented you from leaving the house, seeing friends, getting a job, or attending school?
		# 210 -IS THIS ISSUE NOW
		# Have you ever been in a relationship in which jealousy plays a major role?
		# 211 - IS THIS ISSUE NOW
		#Have you ever been in a relationship with someone who checked up on what you were doing?
		# 538 - IS THIS ISSUE NOW
		#  Have you ever been watchful of what you were doing in order to avoid making another person angry or upset?
		# 213 - IS THIS ISSUE NOW
		# Have you ever been in a relationship with someone who criticized you or embarrassed you in front of others?
		# 214 - IS THIS ISSUE NOW
		# Have you ever been in a relationship with someone who said that if you left him or her, you would never see your children again?
		# 215 - IS THIS ISSUE NOW
		#Have you ever been in a relationship with someone who has harassed you at work, training, or school?
		# 217 - IS THIS ISSUE NOW
		# Have you ever been in a relationship with someone who interfered with your attempts to go to work, training, or school?
		# 218 - IS THIS ISSUE NOW
		# Have you ever felt forced by a partner or others to engage in sexual activities?
		# 212 - IS THIS ISSUE NOW

		domestic_voilence_victim_relatied_questions  = [710,780,774,206,207,208,209,712,210,211,538,213,214,215,217,218,212,857]
 		domestic_voilence_victim_relatied_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					lb_barrier_found = true
					break
				end
			end
 		end

 		# 3.


		# Perpetrator
		# 775 - Have you ever felt that your words or actions have ever caused your partner to feel afraid, unsafe or controlled?
 		# 781 - Have you ever witnessed domestic abuse as a child?
 		# 782 - Do you have a temper?
 		# 783 - Do you have any restraining orders against you?
 		# Have the police ever been called to your house to settle a dispute or because of violence?
 		# 718 - IS THIS ISSUE NOW
 		# Have you ever been in a relationship in which you have threatened or physically hurt someone?
 		# 778- IS THIS ISSUE NOW
 		#  Have you ever destroyed your partner's clothing, objects, or something they especially cared about?
 		# 779 - IS THIS ISSUE NOW
 		# Have you ever tried to control the money your partner earns or spends?
 		# 769 - IS THIS ISSUE NOW
 		# Have you ever prevented another person from leaving the house, seeing friends, getting a job, or attending school?
 		# 771
 		#  f. Have you ever been in a relationship in which jealousy plays a major role?
 		# 773
 		# g. Have you ever been in a relationship where you checked up on what your partner was doing?
 		# 790
 		# h. Have you ever criticized or embarrased your partner in front of others?
 		# 869
 		# i. Have you ever threatened your partner?
 		#794
 		#  j. Have you ever harassed yoru partner at work, training, or school, or interfered with your partner's attempts to go to work, training, or school?
 		# 796
 		#  k. Have you ever forced your partner or others to engage in sexual activities?
 		# 800



 		domestic_voilence_perpetrator_relatied_questions  = [775,781,782,783,718,778,779,769,771,773,790,869,794,796,800]
 		domestic_voilence_perpetrator_relatied_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					lb_barrier_found = true
					break
				end
			end
 		end

		if lb_barrier_found == true
			# 1.assessment_barriers
			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,11,26,ls_comments)
	 		# 2. assessment_barrier_recommendations
	 		# save_assessment_recommendation(arg_assessment_id,arg_barrier_id)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,26)
		end

		if lb_barrier_found == true
			if substance_abuse_char_collection.present?
				ls_detail_comments = "(#{ls_sub_section_name}) Participant has mentioned that he/she is having domestic voilence problem."
		 		# 3.assessment_barrier_details
				# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
				AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,26,38,ls_detail_comments,1)
 			end

 			domestic_voilence_victim_relatied_questions  = [710,780,774,206,207,208,209,712,210,211,538,213,214,215,217,218,212,857]
 			li_display_order = 1
 			domestic_voilence_victim_relatied_questions.each do |each_qstn|
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
				if answer_for_question_collection.present?
					if answer_for_question_collection.first.answer_value =="Y"
						case each_qstn
							when 710
							# Have you ever been abused, physically or emotionally, by a partner?
								ls_detail_comments = "#{ls_sub_section_name}: client is Physically or emotially abused by partner."
							when 780
							# 780;38;"Have you ever applied for a restraining order?"
								ls_detail_comments = "#{ls_sub_section_name}: client applied for restraining order from perpetrator."
							when 774
							# 774;38;"Have you ever felt that your partner was trying to control your life, behavior or finances?"
								ls_detail_comments = "#{ls_sub_section_name}: client Felt his/her partner was trying to control your life, behavior or finances."
							when 206
								ls_detail_comments = "#{ls_sub_section_name}: client is Afraid about something going on at home"
							when 207
								ls_detail_comments = "#{ls_sub_section_name}: client called police to house to resolve domestic issue"
							when 208
								ls_detail_comments = "#{ls_sub_section_name}: Been in a relationship in which you have been threatened or physically hurt"
							when 209
								ls_detail_comments = "#{ls_sub_section_name}: Client's clothing, objects, or something you especially cared about have been destroyed"
							when 712
								ls_detail_comments = "#{ls_sub_section_name}: Your partner or others tried to control the money you earn or spend"
							when 210
								ls_detail_comments = "#{ls_sub_section_name}: Another person prevented you from leaving the house, seeing friends, getting a job, or attending school"
							when 211
								ls_detail_comments = "#{ls_sub_section_name}: client is in a relationship in which jealousy played a major role"
							when 538
								ls_detail_comments = "#{ls_sub_section_name}: client is in a relationship with someone who checked up on what you were doing"
							when 213
								ls_detail_comments = "#{ls_sub_section_name}: client is in a relationship with someone who checked up on what you were doing"
							when 214
								ls_detail_comments = "#{ls_sub_section_name}: client is in a relationship with someone who criticized you or embarrassed you in front of others"
							when 215
								ls_detail_comments = "#{ls_sub_section_name}: client is in a relationship with someone who thretened that you would never see your children again"
							when 217
								ls_detail_comments = "#{ls_sub_section_name}: client is in a relationship with someone who has harassed you at work, training, or school"
							when 218
								ls_detail_comments = "#{ls_sub_section_name}: client is in a relationship with someone who interfered with your attempts to go to work, training, or school"
							when 212
								ls_detail_comments = "#{ls_sub_section_name}: client is forced by a partner or others to engage in sexual activities"
							when 857
								# " Do you have any concerns about your safety or the safety of your family?"
								ls_detail_comments = "#{ls_sub_section_name}: client has concerns about his/her safety or the safety of his/her family"
						end
						# 3.assessment_barrier_details
						# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
						AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,26,38,ls_detail_comments,li_display_order)
						li_display_order = li_display_order + 1

					end # end of answer_for_question_collection.first.answer_value =="Y"
				end # end of  answer_for_question_collection.present?
 			end # end of question loop

 			domestic_voilence_perpetrator_relatied_questions  = [775,781,782,783,718,778,779,769,771,773,790,869,794,796,800]
 			domestic_voilence_perpetrator_relatied_questions.each do |each_qstn|
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
				if answer_for_question_collection.present?
					if answer_for_question_collection.first.answer_value =="Y"
						ls_sub_section_name = AssessmentSubSection.find(39).title
						case each_qstn
							when 775
								# 775 - Have you ever felt that your words or actions have ever caused your partner to feel afraid, unsafe or controlled?
								ls_detail_comments = "#{ls_sub_section_name}: client's words or actions have caused his/her partner to feel afraid, unsafe or controlled."

							when 781
								# 781 - Have you ever witnessed domestic abuse as a child?
								ls_detail_comments = "#{ls_sub_section_name}: client witnessed domestic abuse as a child."

							when 782
								# Do you have a temper?
								ls_detail_comments = "#{ls_sub_section_name}: client has temper issues."

							when 783
								# 783 - Do you have any restraining orders against you?
								ls_detail_comments = "#{ls_sub_section_name}: client has restraining orders against him/her."

							when 718
								#  Have the police ever been called to your house to settle a dispute or because of violence?
								ls_detail_comments = "#{ls_sub_section_name}: client is calling police to resolve domestic issue."

							when 778
								# Have you ever been in a relationship in which you have threatened or physically hurt someone?
								ls_detail_comments = "#{ls_sub_section_name}: client is in a relationship in which he/she have threatened or physically hurt someone."

							when 779
								# Have you ever destroyed your partner's clothing, objects, or something they especially cared about?
								ls_detail_comments = "#{ls_sub_section_name}: client destroyed his/her partner's clothing, objects, or something they especially cared about."

							when 769
								# Have you ever tried to control the money your partner earns or spends?
								ls_detail_comments = "#{ls_sub_section_name}: client tried to control the money his/her partner earns or spends."

							when 771
								# # Have you ever prevented another person from leaving the house, seeing friends, getting a job, or attending school?
								ls_detail_comments = "#{ls_sub_section_name}: client prevented another person from leaving the house, seeing friends, getting a job, or attending school"

							when 773
								# f. Have you ever been in a relationship in which jealousy plays a major role?
								ls_detail_comments = "#{ls_sub_section_name}: client is in a relationship in which jealousy plays a major role."

							when 790
								# g. Have you ever been in a relationship where you checked up on what your partner was doing?
								ls_detail_comments = "#{ls_sub_section_name}: client is in a relationship where he/she checked up on what his/her partner was doing."

							when 869
								# Have you ever criticized or embarrased your partner in front of others?
								ls_detail_comments = "#{ls_sub_section_name}: client criticized or embarrased his/her partner in front of others."

							when 794
								# Have you ever threatened your partner?
								ls_detail_comments = "#{ls_sub_section_name}: client threatened his/her partner."

							when 796
								# Have you ever harassed yoru partner at work, training, or school, or interfered with your partner's attempts to go to work, training, or school?
								ls_detail_comments = "#{ls_sub_section_name}: client harassed his/her partner at work, training, or school, or interfered with his/her partner's attempts to go to work, training, or school."
							when 800
								# Have you ever forced your partner or others to engage in sexual activities?
								ls_detail_comments = "#{ls_sub_section_name}: client forced his/her partner or others to engage in sexual activities"
						end
						# 3.assessment_barrier_details
						# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
						AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,26,38,ls_detail_comments,li_display_order)
						li_display_order = li_display_order + 1

					end # end of answer_for_question_collection.first.answer_value =="Y"
				end # end of  answer_for_question_collection.present?
 			end # end of question loop


		end


	end


 	def self.process_assessment_finance_barriers(arg_assessment_id)
 		ls_sub_section_name = AssessmentSubSection.find(46).title
 		ls_comments = ls_sub_section_name
 		ls_detail_comments = "(#{ls_sub_section_name})"
 		lb_barrier_found = false

 		finance_related_questions = [878,879,880]
 		finance_related_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.assessment_question_id == 880
					if answer_for_question_collection.first.answer_value =="Bad"
						lb_barrier_found = true
						break
					end
				else
					if answer_for_question_collection.first.answer_value =="Y"
						lb_barrier_found = true
						break
					end
				end
			end
 		end
 		if lb_barrier_found == true
 			# 1.assessment_barriers
			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,15,30,ls_comments)
	 		# 2. assessment_barrier_recommendations
	 		# save_assessment_recommendation(arg_assessment_id,arg_barrier_id)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,30)
 		end
 		if lb_barrier_found == true
 			finance_related_questions = [878,879,880]
 			li_display_order = 1
 			finance_related_questions.each do |each_qstn|
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
				if answer_for_question_collection.present?
					if answer_for_question_collection.first.assessment_question_id == 880
						if answer_for_question_collection.first.answer_value =="Bad"
							case each_qstn
								when 880
									ls_detail_comments = "(#{ls_sub_section_name}) Employer thinks that your personal finances handling is bad"
							end
							# 3.assessment_barrier_details
							# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
							AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,30,46,ls_detail_comments,li_display_order)
							li_display_order = li_display_order + 1
						end
					else
						if answer_for_question_collection.first.answer_value =="Y"
							case each_qstn
								when 878
									ls_detail_comments = "(#{ls_sub_section_name}) Not able to pay bills"
								when 879
									ls_detail_comments = "(#{ls_sub_section_name}) Has taken PayDay type loan"
							end
							# 3.assessment_barrier_details
							# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
							AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,30,46,ls_detail_comments,li_display_order)
							li_display_order = li_display_order + 1

						end # end of answer_for_question_collection.first.answer_value =="Y"
					end
				end # end of  answer_for_question_collection.present?
 			end # end of loop
 		end

 	end


 	def self.process_assessment_pregnancy_barriers(arg_assessment_id)
 		AssessmentService.process_client_or_household_member_may_be_pregnant_assistanc_barrier(arg_assessment_id)

 	end

 	def self.process_assessment_child_care(arg_assessment_id)
 		# 1
 			AssessmentService.process_childcare_barrier_no_childcare_provider(arg_assessment_id)
		# 2.
			AssessmentService.process_childcare_barrier_child_disability(arg_assessment_id)
		#3
			AssessmentService.process_childcare_barrier_providing_caregiving_services(arg_assessment_id)
 	end

 	def self.process_childcare_barrier_no_childcare_provider(arg_assessment_id)
 		# Barrier = 12 ""Child(ren) not in child care""
 		lb_barrier_found = false
 		ls_sub_section_name = AssessmentSubSection.find(25).title
		ls_comments = ls_sub_section_name
		ls_detail_comments = ""

 		child_not_in_child_care_relatied_questions  = [244,389,395,401,407,413,419,425,431,437,443,449]
 		# [242,387,393,399,405,411,417,423,429,435,441,447]
 		child_not_in_child_care_relatied_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="N"
					lb_barrier_found = true
					break
				end
			end
 		end

 		if lb_barrier_found == true
 			# 1.assessment_barriers
			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,6,12,ls_comments)
	 		# 2. assessment_barrier_recommendations
	 		# save_assessment_recommendation(arg_assessment_id,arg_barrier_id)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,12)
 		end

 		if lb_barrier_found == true
 			child_not_in_child_care_relatied_questions  = [244,389,395,401,407,413,419,425,431,437,443,449]
 			li_display_order = 1
 			child_not_in_child_care_relatied_questions.each do |each_qstn|
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
				if answer_for_question_collection.present?
					if answer_for_question_collection.first.answer_value =="N"
						case each_qstn
							when 244
								ls_detail_comments = "(#{ls_sub_section_name}) Child 1 has no provider"

							when 389
								ls_detail_comments = "(#{ls_sub_section_name}) Child 2 has no provider"

							when 395
								ls_detail_comments = "(#{ls_sub_section_name}) Child 3 has no provider"

							when 401
								ls_detail_comments = "(#{ls_sub_section_name}) Child 4 has no provider"

							when 407
								ls_detail_comments = "(#{ls_sub_section_name}) Child 5 has no provider"

							when 413
								ls_detail_comments = "(#{ls_sub_section_name}) Child 6 has no provider"

							when 419
								ls_detail_comments = "(#{ls_sub_section_name}) Child 7 has no provider"

							when 425
								ls_detail_comments = "(#{ls_sub_section_name}) Child 8 has no provider"

							when 431
								ls_detail_comments = "(#{ls_sub_section_name}) Child 9 has no provider"

							when 437
								ls_detail_comments = "(#{ls_sub_section_name}) Child 10 has no provider"

							when 443
								ls_detail_comments = "(#{ls_sub_section_name}) Child 11 has no provider"

							when 449
								ls_detail_comments = "(#{ls_sub_section_name}) Child 12 has no provider"
						end
						# 3.assessment_barrier_details
						# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
						AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,12,25,ls_detail_comments,li_display_order)
						li_display_order = li_display_order + 1

					end # end of answer_for_question_collection.first.answer_value =="Y"
				end # end of  answer_for_question_collection.present?
 			end # end of loop
 		end # end of lb_barrier_found == true

 	end

 	def self.process_childcare_barrier_child_disability(arg_assessment_id)
 		# Barrier = 16 "Child disability, health or other need"
 		lb_barrier_found = false
 		ls_sub_section_name = AssessmentSubSection.find(21).title
		ls_comments = ls_sub_section_name
		ls_detail_comments = ""

 		child_disability_relatied_questions  = [234,630,235,236,237,238,239,241]
 		child_disability_relatied_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					lb_barrier_found = true
					break
				end
			end
 		end

 		if lb_barrier_found == true
 			# 1.assessment_barriers
			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,6,16,ls_comments)
	 		# 2. assessment_barrier_recommendations
	 		# save_assessment_recommendation(arg_assessment_id,arg_barrier_id)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,16)
 		end

 		if lb_barrier_found == true
 			child_disability_relatied_questions  = [234,630,235,236,237,238,239,241]
 			li_display_order = 1
 			child_disability_relatied_questions.each do |each_qstn|
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
				if answer_for_question_collection.present?
					if answer_for_question_collection.first.answer_value =="Y"
						case each_qstn
							when 234
								ls_detail_comments = "(#{ls_sub_section_name}) Has Health problems"

							when 630
								ls_detail_comments = "(#{ls_sub_section_name}) Has mental health problems"

							when 235
								ls_detail_comments = "(#{ls_sub_section_name}) Has behavioral problems"

							when 236
								ls_detail_comments = "(#{ls_sub_section_name}) Special needs"

							when 237
								ls_detail_comments = "(#{ls_sub_section_name}) Had frequent disciplinary problems at school or child care"

							when 238
								ls_detail_comments = "(#{ls_sub_section_name}) Missed school or child care frequently"

							when 239
								ls_detail_comments = "(#{ls_sub_section_name}) Faced suspension or expulsion from school or child care"

							when 241
								ls_detail_comments = "(#{ls_sub_section_name}) Faced charges, involvement with the juvenile justice system, detention or on probation"
						end
						# 3.assessment_barrier_details
						# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
						AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,16,21,ls_detail_comments,li_display_order)
						li_display_order = li_display_order + 1

					end # end of answer_for_question_collection.first.answer_value =="Y"
				end # end of  answer_for_question_collection.present?
 			end # end of loop
 		end # end of lb_barrier_found == true

 	end

 	def self.process_childcare_barrier_providing_caregiving_services(arg_assessment_id)
 		# Barrier = 14 "	Providing care giving services	"
 		lb_barrier_found = false
 		ls_sub_section_name = AssessmentSubSection.find(22).title
		ls_comments = ls_sub_section_name
		ls_detail_comments = ""

 		providing_care_giving_relatied_questions  = [723]
 		providing_care_giving_relatied_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value == "Y"
					lb_barrier_found = true
					break
				end
			end
 		end

 		if lb_barrier_found == true
 			# 1.assessment_barriers
			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,6,14,ls_comments)
	 		# 2. assessment_barrier_recommendations
	 		# save_assessment_recommendation(arg_assessment_id,arg_barrier_id)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,14)
 		end

 		if lb_barrier_found == true
 			domestic_voilence_relatied_questions  = [723]
 			li_display_order = 1
 			domestic_voilence_relatied_questions.each do |each_qstn|
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
				if answer_for_question_collection.present?
					if answer_for_question_collection.first.answer_value =="Y"
						case each_qstn
							when 723
								ls_detail_comments = "(#{ls_sub_section_name}) No primary caregiver for an elderly, disabled, or sick family member and no other caregivers available."

						end
						# 3.assessment_barrier_details
						# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_barrier_id,arg_sub_section_id,arg_comments,arg_display_order)
						AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,14,22,ls_detail_comments,li_display_order)
						li_display_order = li_display_order + 1

					end # end of answer_for_question_collection.first.answer_value =="Y"
				end # end of  answer_for_question_collection.present?
 			end # end of loop
 		end # end of lb_barrier_found == true

 	end



	def self.process_assessment_strengths(arg_assessment_id,arg_client_id)
 		# 1
 			AssessmentService.process_employment_experience_strengths(arg_assessment_id)

 		#2
			AssessmentService.process_employment_work_interest_strengths(arg_assessment_id)
		#3
			AssessmentService.process_employment_career_interest_strengths(arg_assessment_id)
		#4
			AssessmentService.process_education_highest_grade_strengths(arg_assessment_id,arg_client_id)
		#5
			AssessmentService.process_education_other_education_strengths(arg_assessment_id)

	end

	def self.process_employment_experience_strengths(arg_assessment_id)
		lb_strength_found = false
 		ls_sub_section_name = AssessmentSubSection.find(6).title
		ls_comments = ls_sub_section_name
		ls_detail_comments = ""

		strengths_relatied_questions  = [105,107,111,133,113,123,127,139,578,580,582,574,576,584,590]
 		strengths_relatied_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			if answer_for_question_collection.present?
				if answer_for_question_collection.first.answer_value =="Y"
					lb_strength_found = true
					break
				end
			end
 		end

 		if lb_strength_found == true
 			strengths_relatied_questions  = [105,107,111,133,113,123,127,139,578,580,582,574,576,584,590,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,122,124,126,128,130,132,134,136,138,140,106,575,577,579,581,681]
 			li_display_order = 1
 			strengths_relatied_questions.each do |each_qstn|
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
				if answer_for_question_collection.present?
					if answer_for_question_collection.first.answer_value =="Y"
						case each_qstn
							when 105
								ls_detail_comments = "Experience in customer service positions"
							when 107
								ls_detail_comments = "Experience in food service positions"
							when 111
								ls_detail_comments = "Experience in using math and electronic machines like cash register"
							when 133
								ls_detail_comments = "Experience in using computers"
							when 113
								ls_detail_comments = "Experience in housekeeping"
							when 123
								ls_detail_comments = "Have experience in assisting children or handicapped or elderly people"
							when 127
								ls_detail_comments = "Experience in barber or in cosmetology"
							when 139
								ls_detail_comments = "Supervised other people"
							when 578
								ls_detail_comments = "Experience with government agencies"
							when 580
								ls_detail_comments = "Contributed to a local community events"
							when 582
								ls_detail_comments = "Experience in local tourism or served as a guide for visitors"
							when 574
								ls_detail_comments = "Experience in harvesting local commodities"
							when 576
								ls_detail_comments = "Experience in cultural activities"
							when 584
								ls_detail_comments = "Experience in local subsistence hunting, fishing, and gathering"
							when 590
								ls_detail_comments = "Experience in preserving, protecting, or conserving natural resources"

								# -- are you proficient 653,654,655,656,657,658,659,660,661,662,663,664,665,666,667
							when 653
								ls_detail_comments = "Proficient in customer service positions"
							when 654
								ls_detail_comments = "Proficient in food service positions"
							when 655
								ls_detail_comments = "Proficient in math skill and electronic machines like cash register"
							when 656
								ls_detail_comments = "Proficient in computers"
							when 657
								ls_detail_comments = "Proficient as housekeeping person"
							when 658
								ls_detail_comments = "Proficient in children or assisted handicapped or elderly people"
							when 659
								ls_detail_comments = "Proficient as a barber or in cosmetology"
							when 660
								ls_detail_comments = "Proficient in supervising other people"
							when 661
								ls_detail_comments = "Proficient in government agencies"
							when 662
								ls_detail_comments = "Proficient in contribution to a local community events"
							when 663
								ls_detail_comments = "Proficient in local tourism or served as a guide for visitors"
							when 664
								ls_detail_comments = "Proficient in harvesting local commodities"
							when 665
								ls_detail_comments = "Proficient in skills required for cultural activities"
							when 666
								ls_detail_comments = "Proficient in local subsistence hunting, fishing, and gathering"
							when 667
								ls_detail_comments = "Proficient in preserving, protecting, or conserving natural resources"

								# -- Does this type of work intreset you 122,124,126,128,130,132,134,136,138,140,106,575,577,579,581

							when 122
								ls_detail_comments = "Interested in customer service positions"
							when 124
								ls_detail_comments = "Interested in food service positions"
							when 126
								ls_detail_comments = "Interested in math and electronic machines like cash register"
							when 128
								ls_detail_comments = "Interested in computers"
							when 130
								ls_detail_comments = "Interested in housekeeping person"
							when 132
								ls_detail_comments = "Interested in assisting children or handicapped or elderly people"
							when 134
								ls_detail_comments = "Interested in beeing a barber or in cosmetology"
							when 136
								ls_detail_comments = "Interested in supervising other people"
							when 138
								ls_detail_comments = "Interested in government agencies"
							when 140
								ls_detail_comments = "Interested in contribution to a local community events"
							when 106
								ls_detail_comments = "Interested in local tourism or served as a guide for visitors"
							when 575
								ls_detail_comments = "Interested in harvesting local commodities"
							when 577
								ls_detail_comments = "Interested in skills required for cultural activities"
							when 579
								ls_detail_comments = "Interested in local subsistence hunting, fishing, and gathering"
							when 581
								ls_detail_comments = "Interested in preserving, protecting, or conserving natural resources"
							when 681
								ls_detail_comments = "Military experience"


						end
						# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_sub_section_id,arg_comments,arg_display_order)
						AssessmentStrength.save_assessment_strength_detail(arg_assessment_id,6,ls_detail_comments,li_display_order)
						li_display_order = li_display_order + 1

					end # end of answer_for_question_collection.first.answer_value =="Y"
				end # end of  answer_for_question_collection.present?
 			end # end of loop
 		end # end of lb_barrier_found == true

	end

	def self.process_employment_work_interest_strengths(arg_assessment_id)
		lb_strength_found = false
 		ls_sub_section_name = AssessmentSubSection.find(8).title
		ls_comments = ls_sub_section_name
		ls_detail_comments = ""

		strengths_relatied_questions  = [41]
 		strengths_relatied_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			if answer_for_question_collection.present?
				lb_strength_found = true
				break
			end
 		end

 		if lb_strength_found == true
 			strengths_relatied_questions  = [41]
 			li_display_order = 1
 			strengths_relatied_questions.each do |each_qstn|
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
 				if answer_for_question_collection.present?
 					answer_for_question_collection.each do |each_answer|
 						ls_detail_comments = each_answer.answer_value
 						# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_sub_section_id,arg_comments,arg_display_order)
						AssessmentStrength.save_assessment_strength_detail(arg_assessment_id,8,ls_detail_comments,li_display_order)
						li_display_order = li_display_order + 1
 					end
 				end
 			end
 		end
	end

	def self.process_employment_career_interest_strengths(arg_assessment_id)
		lb_strength_found = false
 		ls_sub_section_name = AssessmentSubSection.find(9).title
		ls_comments = ls_sub_section_name
		ls_detail_comments = ""

		strengths_relatied_questions  = [559,560]
 		strengths_relatied_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			if answer_for_question_collection.present?
				lb_strength_found = true
				break
			end
 		end

 		if lb_strength_found == true
 			strengths_relatied_questions  = [559,560]
 			li_display_order = 1
 			strengths_relatied_questions.each do |each_qstn|
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
 				if answer_for_question_collection.present?
 					answer_for_question_collection.each do |each_answer|
 						ls_detail_comments = each_answer.answer_value
 						# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_sub_section_id,arg_comments,arg_display_order)
						AssessmentStrength.save_assessment_strength_detail(arg_assessment_id,9,ls_detail_comments,li_display_order)
						li_display_order = li_display_order + 1
 					end
 				end
 			end
 		end
	end

	def self.process_education_highest_grade_strengths(arg_assessment_id,arg_client_id)
		lb_strength_found = false
 		ls_sub_section_name = AssessmentSubSection.find(10).title
		ls_comments = ls_sub_section_name
		ls_detail_comments = ""
		li_display_order = 1
		education_collection = Education.client_higher_educations_collections(arg_client_id)
		if education_collection.present?
			education_collection.each do |eduaction|
				if eduaction.high_grade_level == 2232
					ls_detail_comments = "Have a PhD Degree"
				elsif eduaction.high_grade_level == 2231
					ls_detail_comments = "Have a Masters Degree"
				elsif eduaction.high_grade_level == 2230
					ls_detail_comments = "Graduated from college"
				elsif eduaction.high_grade_level == 2234
					ls_detail_comments = "Have a Associate's Degree"
				elsif eduaction.high_grade_level == 2229
					ls_detail_comments = "Completed 4 years of College or TECH."
				elsif eduaction.high_grade_level == 2228
					ls_detail_comments = "Completed 3 years of College or TECH."
				elsif eduaction.high_grade_level == 2227
					ls_detail_comments = "Completed 2 years of College or TECH."
				elsif eduaction.high_grade_level == 2235
					ls_detail_comments = "Completed 1 years of College or TECH."
				elsif eduaction.high_grade_level == 2238
					ls_detail_comments = "Completed GED"
				end
				# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_sub_section_id,arg_comments,arg_display_order)
				AssessmentStrength.save_assessment_strength_detail(arg_assessment_id,10,ls_detail_comments,li_display_order)
				li_display_order = li_display_order + 1
			end
		end
	end

	def self.process_education_other_education_strengths(arg_assessment_id)
		lb_strength_found = false
 		ls_sub_section_name = AssessmentSubSection.find(12).title
		ls_comments = ls_sub_section_name
		ls_detail_comments = ""
# -----221,223,225,227,229
		strengths_relatied_questions  = [220,222,224,226,228,230]
 		strengths_relatied_questions.each do |each_qstn|
 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
			if answer_for_question_collection.present?
				lb_strength_found = true
				break
			end
 		end

 		if lb_strength_found == true
 			strengths_relatied_questions  = [220,222,224,226,228,230]
 			li_display_order = 1
 			strengths_relatied_questions.each do |each_qstn|
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
				if answer_for_question_collection.present?
					if answer_for_question_collection.first.answer_value =="Y"
						case each_qstn
							when 220
								training_collection_data = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,221)
								if training_collection_data.present?
									training_object = training_collection_data.first
									ls_detail_comments = "Training: #{training_object.answer_value}"
								end
							when 222
								college_collection_data = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,223)
								if college_collection_data.present?
									college_object = college_collection_data.first
									ls_detail_comments = "College classes: #{college_object.answer_value}"
								end
							when 224
								job_readiness_collection_data = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,225)
								if job_readiness_collection_data.present?
									job_readiness_object = job_readiness_collection_data.first
									ls_detail_comments = "Job readiness programs: #{job_readiness_object.answer_value}"
								end
							when 226
								work_experience_collection_data = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,227)
								if work_experience_collection_data.present?
									work_experience_object = work_experience_collection_data.first
									ls_detail_comments = "Work experience: #{work_experience_object.answer_value}"
								end
							when 228
								military_service_collection_data = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,229)
								if military_service_collection_data.present?
									military_service_object = military_service_collection_data.first
									ls_detail_comments = "Military Service: #{military_service_object.answer_value}"
								end
							when 230
								other_training_collection_data = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,471)
								if other_training_collection_data.present?
									other_training_object = other_training_collection_data.first
									ls_detail_comments = "Other Training: #{other_training_object.answer_value}"
								end
						end
						# AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,arg_sub_section_id,arg_comments,arg_display_order)
						AssessmentStrength.save_assessment_strength_detail(arg_assessment_id,12,ls_detail_comments,li_display_order)
						li_display_order = li_display_order + 1

					end # end of answer_for_question_collection.first.answer_value =="Y"
				end # end of  answer_for_question_collection.present?
 			end # end of loop
 		end # end of lb_barrier_found == true

	end

	def self.process_client_or_household_member_may_be_pregnant_assistanc_barrier(arg_assessment_id)
 		# Barrier = 11 = "	Customer or household member may be pregnant	"
 		lb_barrier_found = false
 		ls_sub_section_name = AssessmentSubSection.find(19).title
 		ls_comments = ls_sub_section_name

 		assessment_object = ClientAssessment.find(arg_assessment_id)
 		pregnancy_char_collection = Pregnancy.current_pregnancy_for_client(assessment_object.client_id)
 		if pregnancy_char_collection.present?
 			lb_barrier_found = true
 		end

 		# Pregnancy Interview mode
 		 # 735 = Are you pregnant? or Is someone in your household pregnant? or Is someone currently pregnant with your child? should be "yes"
		# get_answer_collection(arg_assessment_id,arg_qstn_id)
 		answer_for_question_collection_735= ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,735)
	 		if answer_for_question_collection_735.present?
	 			if answer_for_question_collection_735.first.answer_value == "Y"
	 				lb_barrier_found = true

	 			end
	 		end

	 		# 738 = "Are you currently pregnant?"-for female client
		answer_for_question_collection_738 = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,738)
		if answer_for_question_collection_738.present?
			if answer_for_question_collection_738.first.answer_value == "Y"
				lb_barrier_found = true
			end
		end

           # 741 = "Are any other females in your household currently pregnant?"- for female client
	 		answer_for_question_collection_741 = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,741)
		if answer_for_question_collection_741.present?
			if answer_for_question_collection_741.first.answer_value == "Y"
				lb_barrier_found = true
			end
		end

		# 748 = "Is your female partner or are any other females in your household currently pregnant?" - male client
		# answer_for_question_collection_748 = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,748)
		# if answer_for_question_collection_748.present?
		# 	if answer_for_question_collection_748.first.answer_value == "Y"
		# 		lb_barrier_found = true
		# 	end
		# end




 		if lb_barrier_found == true
 			# assessment_barriers
 			# AssessmentBarrier.save_assessment_barrier(arg_assessment_id,arg_section_id,arg_barrier_id,arg_comments)
	 		AssessmentBarrier.save_assessment_barrier(arg_assessment_id,5,11,ls_comments)
	 		# assessment_barrier_recommendations
	 		# save_assessment_recommendation(arg_assessment_id,arg_barrier_id)
	 		AssessmentBarrier.save_assessment_recommendation(arg_assessment_id,11)
 		end



 		if lb_barrier_found == true
 			if pregnancy_char_collection.present?
	 		    ls_detail_comments = "#{ls_sub_section_name}: client is currently pregnant."
	 		    # 3.
			   	AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,11,19,ls_detail_comments,1)
	 		end

	 		if answer_for_question_collection_735.present?
	 			# 735;19;"Is someone in your household pregnant? or Is someone currently pregnant with your child?"
			    if answer_for_question_collection_735.first.answer_value == "Y"
				  ls_detail_comments = "#{ls_sub_section_name}: someone in the household is currently pregnant or someone currently pregnant with your child"
				  AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,11,19,ls_detail_comments,3)
			    end
		    end

	 		if answer_for_question_collection_738.present?
	 			# 738;19;"Are you currently pregnant?"
				if answer_for_question_collection_738.first.answer_value == "Y"
				   ls_detail_comments = "#{ls_sub_section_name}: client is currently pregnant. "
				   AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,11,19,ls_detail_comments,1)
			    end
		    end

            if answer_for_question_collection_741.present?
            	# 741;19;"Are any other females in your household currently pregnant?"
			    if answer_for_question_collection_741.first.answer_value == "Y"
				  ls_detail_comments = "#{ls_sub_section_name}:	Someone in the household is currently pregnant ."
				  AssessmentBarrier.save_assessment_barrier_detail(arg_assessment_id,11,19,ls_detail_comments,2)
			    end
		    end
 		end


	end





	def self.save_prescreen_assessment_answer(arg_prescreen_household_id,arg_params,arg_questions_collection)
		object_changed = false
		 # Rails.logger.debug("MNP1 - arg_params= #{arg_params.inspect}")
		 # Rails.logger.debug("MNP2 - arg_params[#{each_qstn.id}]= #{arg_params["#{each_qstn.id}"]}")

		msg = "FAILED"
		arg_questions_collection.each do |each_qstn|
			# Rails.logger.debug("each_qstn = #{each_qstn.inspect}")
			if arg_params["#{each_qstn.id}"].present?
				# Rails.logger.debug("question id present = #{each_qstn.inspect}")
				# Rails.logger.debug("answer for question #{each_qstn.inspect} =   arg_params['#{each_qstn.id}']")
				# Rails.logger.debug("arg_params class = #{ arg_params["#{each_qstn.id}"].class}")
				if  "#{ arg_params["#{each_qstn.id}"].class}" == "Array"
					# if class is array - it is multi select - checkbox group - so Delete & Insert operation
					# answer_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn.id)
					# answer_collection.destroy_all

					# check if any answer really changed to set client assessment status to Incomplete.
					array_answer_collection_multi_select = arg_params["#{each_qstn.id}"]

					# if class is array - it is multi select - checkbox group - so Delete & Insert operation
					answer_collection_multi_select = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,each_qstn.id)
					answer_collection_multi_select.destroy_all
					array_answer_collection_multi_select = arg_params["#{each_qstn.id}"]
					array_answer_collection_multi_select.each do |each_answer|
						assessment_answer_object = PrescreenAssessmentAnswer.new
						assessment_answer_object.prescreen_household_id = arg_prescreen_household_id
						assessment_answer_object.assessment_question_id = each_qstn.id
						assessment_answer_object.answer_value = each_answer.to_s
						assessment_answer_object.save
					end

					msg = "SUCCESS"
				else
					# save if any data populated. (Non Multi select)
					answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,each_qstn.id)
					if answer_collection.present?
						assessment_answer_object = answer_collection.first
					else
						assessment_answer_object = PrescreenAssessmentAnswer.new
					end
					assessment_answer_object.prescreen_household_id = arg_prescreen_household_id
					assessment_answer_object.assessment_question_id = each_qstn.id
					# Rails.logger.debug("test= #{arg_params["#{each_qstn.id}"]}")
					assessment_answer_object.answer_value = arg_params["#{each_qstn.id}"]
					object_value_changed = assessment_answer_object.changed?
					Rails.logger.debug("object_value_changed1 = #{object_value_changed}")
					if object_value_changed == true
						if assessment_answer_object.save
							msg = "SUCCESS"
						else
							msg = "assessment_answer_object.errors.full_messages.last"
						end
					end

				end
			else
				# Rails.logger.debug("This question id is not answered ? = #{each_qstn.inspect}")
				answer_collection = PrescreenAssessmentAnswer.get_answer_collection(arg_prescreen_household_id,each_qstn.id)
				if answer_collection.present?
						answer_collection.destroy_all
				end
			end # end of arg_params["#{each_qstn.id}"].present?
		end # end of arg_questions_collection.each do
		return msg
	end

	def self.populate_ld_assessment_and_client_score(arg_assessment_id)
		l_difficulty_score = 0
			learning_related_questions = [159,160,161,162,163,164,165,166,167,168,169,170,171]
	 		learning_related_questions.each do |each_qstn|
	 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
	 			if answer_for_question_collection.present?
	 				if answer_for_question_collection.first.answer_value == "Y"

	 					if (each_qstn == 159 || each_qstn == 160 || each_qstn == 161 || each_qstn == 162 || each_qstn == 163)
	                       	l_difficulty_score = l_difficulty_score + 1
	                    end
	                    if (each_qstn == 164 || each_qstn == 165)
	                        l_difficulty_score = l_difficulty_score + 2
	                    end
	                    if (each_qstn == 166 || each_qstn == 167 || each_qstn == 168)
	                        l_difficulty_score = l_difficulty_score + 3
	                    end
	                    if (each_qstn == 169 || each_qstn == 170 || each_qstn == 171)
	                        l_difficulty_score = l_difficulty_score + 4
	                    end
	 				end
	 			end
	 		end
		return l_difficulty_score
	end

	def self.get_barrier_id_for_the_client(arg_client_id)
		barrier_id = nil
		assessments = ClientAssessment.get_client_assessments(arg_client_id)
		if assessments.present?
			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(assessments.first.id,2) # "Are you currently working?"
			if answer_for_question_collection.present? && answer_for_question_collection.first.answer_value == "Y"
 				barrier_id = 3 # "Currently working and needs assistance"
 			else
 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(assessments.first.id,904) # "Have you ever held a paying job?"
 				if answer_for_question_collection.present? && answer_for_question_collection.first.answer_value == "N"
 					barrier_id = 2 # "Never held a paying job"
 				else
 					barrier_id = 6 # "Currently not working"
 				end
	 		end
			# ClientAssessmentAnswer.get_answer_collection(assessments.first.id,3) # "(If not currently working) <br> Do you have job offer to start working within a month or next month?"
		end
		return barrier_id
	end


end




# def self.any_current_housing_barrier_exists?(arg_assessment_id)
#  		l_hash = {}
#  		l_hash["BARRIER_EXISTS"] = false


#  		# 49 = "1. Is there anything about your housing situation that is unstable or presents a challenge for you to work? For example, have you moved a lot in recent months?"

#  		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,49)
#  		if answer_for_question_collection.present?
#  			if answer_for_question_collection.first.answer_value == "Y"
#  				l_hash["BARRIER_EXISTS"] = true
#  				ls_comments = AssessmentService.return_initial_barrier_comments(15)
#  				# Question = 803 = "What is your current housing situation?"
#  				# Question = 50 = "If other, please specify:"

#  				housing_related_questions = [803,50]
# 		 		housing_related_questions.each do |each_qstn|
# 		 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
# 		 			if answer_for_question_collection.present?
# 		 				if answer_for_question_collection.first.answer_value.present?

# 		 					if each_qstn == 803
# 		 						ls_comments = "#{ls_comments}  #{answer_for_question_collection.first.answer_value}"
# 		 					end
# 		 					if each_qstn == 50
# 		 						ls_comments = "#{ls_comments} #{answer_for_question_collection.first.answer_value}"
# 		 					end
# 		 				end
# 		 			end
# 		 		end
# 		 	end
# 		end

# 		# 53 = "Is there anything else about your housing situation that is unstable or that you would like to discuss?"
# 		assessment_sub_section_object = AssessmentSubSection.find(17)
# 		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,53)
# 		if answer_for_question_collection.present?
# 			if answer_for_question_collection.first.answer_value == "Y"
# 				l_hash["BARRIER_EXISTS"] = true
# 				ls_comments = "#{ls_comments} (#{assessment_sub_section_object.title})"
# 				# "If yes, please explain."
# 				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,54)
# 				if answer_for_question_collection.present?
# 					if answer_for_question_collection.first.answer_value.present?
# 						ls_comments = "#{ls_comments} #{ answer_for_question_collection.first.answer_value}"
# 					end
# 				end
# 			end
# 		end

#  		# 51 = "How many times have you moved in the last 12 months, including temporary or short moves."
# 		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,231)
# 		if answer_for_question_collection.present?
# 			if answer_for_question_collection.first.answer_value.present?
# 				moved_count = answer_for_question_collection.first.answer_value.to_i
# 				Rails.logger.debug("moved_count = #{moved_count}")
# 				if  moved_count > 3
# 					l_hash["BARRIER_EXISTS"] = true
# 					ls_comments = "#{ls_comments} (#{assessment_sub_section_object.title})"
# 					ls_comments = "#{ls_comments} Moved #{moved_count} times in past year"
# 				end
# 			end
# 		end


#  		l_hash["BARRIER_COMMENTS"] = ls_comments
#  		return l_hash
#  	end


# def self.any_employment_upcoming_court_date_barrier_exists?(arg_assessment_id)
#  		l_hash = {}
#  		l_hash["BARRIER_EXISTS"] = false
#  		ls_comments = AssessmentService.return_initial_barrier_comments(5)
#  		# Question = 37 = "Do you have any upcoming court dates?"
#  		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,37)
#  		if answer_for_question_collection.present?
#  			if answer_for_question_collection.first.answer_value == "Y"
#  				l_hash["BARRIER_EXISTS"] = true
#  				# 595;5;"Date?"
# 				# 596;5;"Reason?"
# 				# 597;5;"Date?"
# 				# 598;5;"Reason?"
# 				# 599;5;"Date?"
# 				# 600;5;"Reason?"
# 				# 601;5;"Date?"
# 				# 602;5;"Reason?"
#  				court_date_reason_questions = [596,595,598,597,600,599,602,601]
# 		 		court_date_reason_questions.each do |each_qstn|
# 		 			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
# 		 			if answer_for_question_collection.present?
# 		 				if answer_for_question_collection.first.answer_value.present?
# 		 					if (each_qstn == 596 || each_qstn == 598 || each_qstn == 600 || each_qstn == 602)
# 		 						ls_comments = "#{ls_comments}  Reason: #{answer_for_question_collection.first.answer_value}"
# 		 					end
# 		 					if (each_qstn == 595 || each_qstn == 597 || each_qstn == 599 || each_qstn == 601)
# 		 						ls_comments = "#{ls_comments} Court Date: #{answer_for_question_collection.first.answer_value}"
# 		 					end

# 		 				end
# 		 			end
# 		 		end
# 		 	end
# 		end
# 		Rails.logger.debug("any_employment_upcoming_court_date_barrier_exists-ls_comments = #{ls_comments}")
#  		l_hash["BARRIER_COMMENTS"] = ls_comments
#  		return l_hash
#  	end




# def self.any_employment_criminal_record_exists?(arg_assessment_id)
#  		l_hash = {}
#  		l_hash["BARRIER_EXISTS"] = false
#  		ls_comments = AssessmentService.return_initial_barrier_comments(5)
#  		# Question = 33 = "Sometimes having a criminal record can hinder someone's ability to get a job. <b> Have you ever been convicted of any criminal offense other than a minor traffic violation?"
#  		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,33)
#  		if answer_for_question_collection.present?
#  			if answer_for_question_collection.first.answer_value == "Y"
#  				l_hash["BARRIER_EXISTS"] = true
#  				# 36 = "If yes, are you on parole or probation now?"
#  				answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,36)
#  				if answer_for_question_collection.present?
#  					if answer_for_question_collection.first.answer_value == "Y"
#  						ls_comments = "#{ls_comments} Currently On Probation and/or Parole"
#  					else
#  						ls_comments = "#{ls_comments} Not On Probation and/or Parole"
#  					end
#  				end
#  			end
#  		end
#  		Rails.logger.debug("any_employment_criminal_record_exists-ls_comments = #{ls_comments}")
#  		l_hash["BARRIER_COMMENTS"] = ls_comments
#  		return l_hash
# end



	# def self.any_employment_currently_working_and_needs_assistanc_barrier_exists?(arg_assessment_id)
 # 		l_hash = {}
 # 		l_hash["BARRIER_EXISTS"] = false
 # 		ls_comments = AssessmentService.return_initial_barrier_comments(2)
 # 		# Question = 4 = "Since you currently have a job, why is it not meeting your needs?"
 # 		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,4)
 # 		if answer_for_question_collection.present?
 # 			if answer_for_question_collection.first.answer_value.present?
 # 				l_hash["BARRIER_EXISTS"] = true
 # 				ls_comments = "#{ls_comments}- #{answer_for_question_collection.first.answer_value}"
 # 			end
 # 		end
 # 		l_hash["BARRIER_COMMENTS"] = ls_comments
 # 		return l_hash
 # 	end



# def self.any_employment_currently_not_working_barrier_exists?(arg_assessment_id)
#  		l_hash = {}
#  		l_hash["BARRIER_EXISTS"] = false
#  		ls_comments = ""
#  		# Question = 2 = "Are you currently working?"
#  		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,2)
#  		if answer_for_question_collection.present?
#  			if answer_for_question_collection.first.answer_value == "Y"
#  				l_hash["BARRIER_EXISTS"] = true
#  			end
#  		end
#  		l_hash["BARRIER_COMMENTS"] = ls_comments
#  		return l_hash
#  	end


# def self.any_employment_never_held_paying_job_barrier_exists?(arg_assessment_id)
#  		l_hash = {}
#  		l_hash["BARRIER_EXISTS"] = false
#  		ls_comments = ""
#  		# Question = 3 = "Have you ever held a paying job?"
#  		answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,3)
#  		if answer_for_question_collection.present?
#  			if answer_for_question_collection.first.answer_value == "Y"
#  				l_hash["BARRIER_EXISTS"] = true
#  			end
#  		end
#  		l_hash["BARRIER_COMMENTS"] = ls_comments
#  		return l_hash
#  	end




# def self.any_edu_language_barrier_exists?(arg_assessment_id)
#  		l_hash = {}
#  		l_hash["BARRIER_EXISTS"] = false

#  		ls_comments = AssessmentService.return_initial_barrier_comments(14) # English Language


#  		language_related_questions = [44,45,47,48]
#  		language_related_questions.each do |each_qstn|
#  			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
#  			if answer_for_question_collection.present?
#  				if answer_for_question_collection.first.answer_value == "Y"
#  					l_hash["BARRIER_EXISTS"] = true
#  					if each_qstn == 44
#  						ls_comments = "#{ls_comments} Reading"
#  					end
#  					if each_qstn == 45
#  						ls_comments = "#{ls_comments} Writing"
#  					end
#  					if each_qstn == 47
#  						ls_comments = "#{ls_comments} Speaking"
#  					end
#  					if each_qstn == 48
#  						ls_comments = "#{ls_comments} Understanding"
#  					end
#  					# ls_comments = comments.concat(this.getBullitinFormat(barrier[i]));
#  				end
#  			end
#  		end
#  		l_hash["BARRIER_COMMENTS"] = ls_comments
#  		return l_hash

#  	end



# def self.any_edu_learning_barrier_exists?(arg_assessment_id)
#  		l_hash = {}
#  		l_hash["BARRIER_EXISTS"] = false
#  		l_difficulty_score = 0
#  		l_hash["DIFFICULTY_SCORE"] = l_difficulty_score
#  		ls_comments = AssessmentService.return_initial_barrier_comments(13) # Learning Difficulties

#  		learning_related_questions = [159,160,161,162,163,164,165,166,167,168,169,170,171]
#  		learning_related_questions.each do |each_qstn|
#  			answer_for_question_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,each_qstn)
#  			if answer_for_question_collection.present?
#  				if answer_for_question_collection.first.answer_value == "Y"

#  					if (each_qstn == 159 || each_qstn == 160 || each_qstn == 161 || each_qstn == 162 || each_qstn == 163)
#                        	l_difficulty_score = l_difficulty_score + 1
#                     end
#                     if (each_qstn == 164 || each_qstn == 165)
#                         l_difficulty_score = l_difficulty_score + 2
#                     end
#                     if (each_qstn == 166 || each_qstn == 167 || each_qstn == 168)
#                         l_difficulty_score = l_difficulty_score + 3
#                     end
#                     if (each_qstn == 169 || each_qstn == 170 || each_qstn == 171)
#                         l_difficulty_score = l_difficulty_score + 4
#                     end
#  				end
#  			end
#  		end
#  		if l_difficulty_score >= 12
#  			ls_comments = "#{ls_comments} Score: #{l_difficulty_score} out of 30"
#  			l_hash["BARRIER_EXISTS"] = true
#  		else
#  			ls_comments = ""
#  		end
#  		l_hash["BARRIER_COMMENTS"] = ls_comments

#  		return l_hash

#  	end

# def self.any_edu_school_barrier_exists?(arg_assessment_id)
		# l_hash = {}
		# lb_barrier_exists = false
		# l_hash["BARRIER_EXISTS"] = lb_barrier_exists
		# ls_comments = AssessmentService.return_initial_barrier_comments(10)
 	# 	# 	select * from assessment_questions where id = 147 is  "High School Diploma"
 	# 	highSchool_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,147)
 	# 	# question - 148 = 'GED / Equivalency'
 	# 	ged_collection  = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,148)
 	# 	# question - 474 = 'None'
 	# 	education_none_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,474)
 	# 	education__highest_grade_none_collection = ClientAssessmentAnswer.get_answer_collection(arg_assessment_id,141)
 	# 	ls_years_of_school_attended = AssessmentService.return_years_of_school_attended(arg_assessment_id)

 	# 	if education_none_collection.present? || education__highest_grade_none_collection.present?
 	# 		# client answered highest grade None - so education barrier exists

 	# 		if education_none_collection.present?
 	# 			lb_barrier_exists =  true
 	# 		end
 	# 		if education__highest_grade_none_collection.first.answer_value == "Y"
 	# 			lb_barrier_exists =  true
 	# 		end
 	# 	else
 	# 		if (highSchool_collection.blank? && ged_collection.blank? )
 	# 			# No Highschool AND No GED AND no years of school attendance - so education barrier exists
 	# 			lb_barrier_exists =  true
 	# 		end
 	# 	end

 	# 	if ls_years_of_school_attended.present?
 	# 		ls_comments = "#{ls_comments} #{ls_years_of_school_attended} years of school"
 	# 	else
 	# 		ls_comments = ""
 	# 	end

		# l_hash["BARRIER_EXISTS"] = lb_barrier_exists
 	# 	l_hash["YEARS_OF_SCHOOL_ATTENDED"] = ls_years_of_school_attended
 	# 	l_hash["BARRIER_COMMENTS"] = ls_comments
 	# 	return l_hash
 	# end
