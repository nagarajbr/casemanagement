class ClientScore < ActiveRecord::Base
has_paper_trail :class_name => 'ClientScoreVersion',:on => [:update, :destroy]


	before_create :set_create_user_fields, :date_referred_and_date_test_taken_on_presence?
   	before_update :set_update_user_field, :date_referred_and_date_test_taken_on_presence?

   	 HUMANIZED_ATTRIBUTES = {
      test_type: "Test Type",
      date_referred: "Referred Date"  ,
  	  date_test_taken_on: "Test Taken Date",
      scores: "Scores"
    }

    validates_presence_of  :test_type, :date_referred,:date_test_taken_on,:scores,message: "is required."
    validate :date_referred_less_than_date_test_taken_on?
    validate :date_test_taken_on_should_not_future_date
    validate :date_referred_should_not_future_date
    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end


   	def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end

    def self.get_client_scores(arg_client_id)
    	where("client_id = ?", arg_client_id)
    end

    def date_referred_and_date_test_taken_on_presence?
      if date_test_taken_on.present? && scores.present?
        return true
      else
        if date_test_taken_on.present? && scores.blank?
          errors[:base] << "Score is required"
          return false
        end
        if date_test_taken_on.blank? && scores.present?
          errors[:base] << "Test taken date is required"
          return false
        end
        return true
      end
    end



      def date_referred_less_than_date_test_taken_on?
      if date_referred.present?
        if date_test_taken_on.present?
          if date_referred >  date_test_taken_on
            errors[:base] << "Test date should be greater than or equal to referred date."
            return false
          else
            return true
          end
        else
          return true
        end
      else
        return true
      end
    end


    def date_test_taken_on_should_not_future_date
      ls_return = true
       if date_test_taken_on.present?
          if date_test_taken_on <= Date.today
             ls_return = true
         else
             errors[:base] << "Test taken date should be less than or equal to the current date."
             ls_return = false
         end
        end
       return ls_return

    end



    def date_referred_should_not_future_date
      ls_return = true
       if date_referred.present?
          if date_referred <= Date.today
             ls_return = true
         else
             errors[:base] << "Referred date should be less than or equal to the current date."
             ls_return = false
         end
        end
       return ls_return

    end


    def self.check_if_TABE_scores_are_present(arg_client_id)
      msg = "SUCCESS"
      tabe_score_object = ClientScore.where("client_id = ? and test_type in (3105,3106,3107)",arg_client_id).order("date_test_taken_on desc")
      if (tabe_score_object.present? && (tabe_score_object.first.date_test_taken_on >= (Date.today - 30.days)))
        msg = "SUCCESS"
      else
        msg = "FAIL"
      end
      return msg
    end

    def self.check_if_LD_scores_are_present(arg_client_id)
      msg = "SUCCESS"
      ld_score_object = ClientScore.where("client_id = ? and test_type = 3109",arg_client_id).order("date_test_taken_on desc")
      if (ld_score_object.present? && (ld_score_object.first.date_test_taken_on >= (Date.today - 30.days)))
        msg = "SUCCESS"
      else
        msg = "FAIL"
      end
      return msg
    end

end
