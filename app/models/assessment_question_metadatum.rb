class AssessmentQuestionMetadatum < ActiveRecord::Base

	def self.get_question_metedata_object(arg_question_id)
		where("assessment_question_id = ?",arg_question_id).first
	end

	def self.is_date_valid(arg_params)
		arg_params.each do |f|
			question = where("assessment_question_id =?",f.first.to_i)
			if question.present?
			type = question.first.response_data_type
				if type == "DATE"
					date = "#{f.second}"
					unless AssessmentQuestionMetadatum.validate_date(date)
						return false
						break
					end
				end
			end
		end
	end

	def self.validate_date(arg_date)
		if arg_date.present?
			if arg_date.to_date < Date.civil(1900,1,1)
                return false
            else
            	return true
            end
		else
			 return true
		end
	end

end