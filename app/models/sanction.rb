class Sanction < ActiveRecord::Base
has_paper_trail :class_name => 'SanctionVersion',:on => [:update, :destroy]

	include AuditModule

	before_create :set_create_user_fields
	before_update :set_update_user_field, :validate_infraction_begin_date_and_infraction_end_date

	def set_create_user_fields
    	user_id = AuditModule.get_current_user.uid
    	self.created_by = user_id
    	self.updated_by = user_id

    end

    def set_update_user_field
	    user_id = AuditModule.get_current_user.uid
	    self.updated_by = user_id
    end

	belongs_to :client
	has_many :sanction_details, dependent: :destroy
	attr_accessor :expiration_date



  	# Model Validations .
	HUMANIZED_ATTRIBUTES = {
		service_program_id: "Service Program",
		sanction_type: "Sanction Type",
		infraction_begin_date: "Infraction Begin Date",
		description: "Sanction Description",
		mytodolist_indicator: "Add To The To Do List?",
		infraction_end_date: "Infraction End Date"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end


	 validates_presence_of  :service_program_id,:sanction_type,:infraction_begin_date , message: "is required."
	 # client_id,service_program_id,sanction_type,infraction_begin_date combination is unique
	 # validates :sanction_type,:uniqueness => {:scope => [:client_id,:service_program_id]}

	 #validate :valid_infraction_begin_date?
	 validate :valid_infraction_begin_date?
	 validate :begin_date_less_than_infraction_end_date?
	 validate :is_active_sanction_type_present?, :on => :create
	 validate :is_sanction_type_present_update?, :on => :update

	def valid_infraction_begin_date?
		DateService.valid_date_before_today?(self,infraction_begin_date,"Infraction Date")
	end

	def begin_date_less_than_infraction_end_date?
        if infraction_begin_date.present?
	        if infraction_end_date.present?
		        if infraction_begin_date > infraction_end_date
		            errors[:infraction_end_date] << "should be greater than or equal to infraction begin date."
		            return false
		        else
		            return true
		        end
	        else
	        	return true
	        end
        else
        	return false
        end
    end


	def self.get_sanction_detail_by_client(arg_run_id, arg_month_sequence, arg_service_program_id)

		step1 = joins("INNER JOIN program_benefit_members ON sanctions.client_id = program_benefit_members.client_id")
	    step2 = step1.where("program_benefit_members.run_id = ? and program_benefit_members.month_sequence = ?
	    		and sanctions.service_program_id = ? and (sanctions.infraction_end_date is null or sanctions.infraction_end_date >= ?)", arg_run_id, arg_month_sequence, arg_service_program_id,Date.today.beginning_of_month)
	    step3 = step2.select("sanctions.service_program_id, sanctions.sanction_type, sanctions.id, program_benefit_members.member_status,sanctions.client_id")
	end

	def self.get_current_sanction_type_for_client(arg_service_program_id, arg_month_sequence, arg_client_id)
		step1 = joins("INNER JOIN sanction_details ON sanction_details.sanction_id = sanctions.id")
	    step2 = step1.where("sanction_details.sanction_month = ? and sanctions.client_id = ? and sanctions.service_program_id = ?",
	    					 arg_month_sequence, arg_client_id, arg_service_program_id)
	    if step2.present?
			step3 = step2.where("sanctions.sanction_type = 3082 or sanctions.sanction_type = 3070 or
								 sanctions.sanction_type = 3067 or sanctions.sanction_type = 3068 or
								 sanctions.sanction_type = 3064 or sanctions.sanction_type = 3622")
				if step3.present?
					sanction_list = step3.first
					sanction_type = sanction_list.sanction_type
				else
					step4 = step2.where("sanctions.sanction_type = 3062")
					if step4.present?
						sanction_list = step4.first
						sanction_type = sanction_list.sanction_type
					else
						client_sanction = step2.first
						sanction_type = client_sanction.sanction_type
					end
				end
		else
			sanction_type = 0
		end
	    return sanction_type
	end

	  # def self.get_progressive_sanction_details_by_run_id(arg_run_id, arg_month_sequence, arg_service_program_id)
	  #   step1 = joins("INNER JOIN program_benefit_members ON sanctions.client_id = program_benefit_members.client_id")
	  #   step2 = step1.where("program_benefit_members.run_id = ? and program_benefit_members.month_sequence = ? and
	  #   		sanctions.service_program_id = ? ", arg_run_id, arg_month_sequence,arg_service_program_id)
	  #   step3 = step2.select("sanctions.id,sanctions.client_id,sanctions.service_program_id,sanctions.sanction_type,
	  #   				sanctions.infraction_begin_date, sanctions.infraction_end_date, program_benefit_members.member_status")
	  #   step3.order("sanctions.infraction_end_date desc, sanctions.infraction_begin_date asc")
  	# end

  	# def self.get_sanction_records_for_client(arg_service_program, arg_sanction_type, arg_client_id)
  	# 	where("service_program_id = ? and sanction_type  = ? and client_id = ?",arg_service_program, arg_sanction_type, arg_client_id)
  	# end


	def is_active_sanction_type_present?
    lb_return = false
    if infraction_begin_date.present?
        lb_return = Sanction.where("client_id = ? and  service_program_id = ? and sanction_type = ? and infraction_end_date is null",client_id,service_program_id, sanction_type).count>0
          if lb_return
           errors[:base] << "There is an existing sanction for #{CodetableItem.get_short_description(sanction_type)}."
           end

          unless lb_return
            sanction_type_present_item_list = Sanction.where("client_id = ? and  service_program_id = ? and  sanction_type = ?",client_id,service_program_id,sanction_type)
			sanction_type_present_item_list.each do |record|
              start_date = self.infraction_begin_date
              end_date = self.infraction_end_date.present? ? self.infraction_end_date : start_date
              record.infraction_end_date = record.infraction_end_date.present? ? record.infraction_end_date : record.infraction_begin_date
                while start_date < end_date
                  if (record.infraction_begin_date..record.infraction_end_date).cover?(start_date)
                    errors[:base] << "There is an existing sanction for #{CodetableItem.get_short_description(sanction_type)}."
                    lb_return = true
                    break
                  end
                  start_date = start_date + 1
                end
              if lb_return
                break
              end
            end
          end


        end

    return lb_return
  end

   def is_sanction_type_present_update?
        lb_return = false
        if infraction_end_date.present?
            lb_return = Sanction.where("client_id = ? and  service_program_id = ? and sanction_type = ? and id != ? and infraction_end_date is null",client_id,service_program_id, sanction_type,id).count>0
		          if lb_return
		           errors[:base] << "There is an existing sanction for #{CodetableItem.get_short_description(sanction_type)}."
		           end

            unless lb_return
               sanction_type_collection = Sanction.where("client_id = ? and service_program_id = ? and sanction_type = ? and id != ?",client_id,service_program_id, sanction_type,id).order("infraction_end_date DESC")
               sanction_type_collection.each do |record|
                start_date = self.infraction_begin_date
                end_date = self.infraction_end_date.present? ? self.infraction_end_date : start_date
                record.infraction_end_date = record.infraction_end_date.present? ? record.infraction_end_date : record.infraction_begin_date
                  while start_date <= end_date
                    if (record.infraction_begin_date..record.infraction_end_date).cover?(start_date)
                      errors[:base] << "There is an existing sanction for #{CodetableItem.get_short_description(sanction_type)}."
                      lb_return = true
                      break
                    end
                    start_date = start_date + 1
                  end
                if lb_return
                  break
                end
              end
            end
          end

    return lb_return
  end


def validate_infraction_begin_date_before_update

     if self.sanction_details.present?
     	lowest_sanction_detail_date_received = self.sanction_details.order(sanction_month: :asc).first.sanction_month

     	if self.service_program_id == 1 && lowest_sanction_detail_date_received == Date.today.strftime("01/%m/%Y")
     		errors[:base] << "sanction month date."
		        return false
		else
	     	l_date = self.infraction_begin_date

	        lowest_sanction_detail_date_received = self.sanction_details.order(sanction_month: :asc).first.sanction_month
	          self.infraction_begin_date = self.infraction_begin_date.strftime("01/%m/%Y").to_date
	        if self.infraction_begin_date > lowest_sanction_detail_date_received
	        	l_date = self.infraction_begin_date
		        errors[:base] << "Infraction begin date can't be after #{CommonUtil.format_db_date(lowest_sanction_detail_date_received)}."
		        return false
	        else
	        	 self.infraction_begin_date = l_date
	             return true
	        end
	      # else
	      #   return true
	      end
	      self.infraction_begin_date = l_date
	end
end

    def validate_infraction_end_date_before_update
      if self.sanction_details.present?
        lowest_sanction_detail_date_received = self.sanction_details.order(sanction_month: :desc).first.sanction_month
        if self.infraction_end_date.present? && self.infraction_end_date < lowest_sanction_detail_date_received
          errors[:base] << "Infraction end date can't be before #{CommonUtil.format_db_date(lowest_sanction_detail_date_received)}."
          return false
        else
          return true
        end
      else
        return true
      end
    end

  	def validate_infraction_begin_date_and_infraction_end_date

      infraction_begin_date_validation = validate_infraction_begin_date_before_update
      infraction_end_date_validation = validate_infraction_end_date_before_update
      infraction_begin_date_validation && infraction_end_date_validation
    end

    def self.is_sanction_details_present(arg_id)
	    step1 = joins("inner join sanction_details on sanctions.id = sanction_details.sanction_id")
	    step2 = step1.where("sanctions.id = ?", arg_id)
	    if step2.present?
	    	return true
	    else
	    	return false
	    end

  	end

  	def self.did_the_client_receive_sanction_payments_for_work_pays_in_last_6_months(arg_client_id)
  		sanction_details = false
  		step1 = joins("inner join sanction_details on sanctions.id = sanction_details.sanction_id")
        step2= step1.where("sanctions.service_program_id = 4 and sanctions.client_id = ? and  sanction_details.release_indicatior = '0' and sanctions.sanction_type not in (3081,3062) and  sanction_details.sanction_month > CURRENT_DATE - INTERVAL '6 months'",arg_client_id)
        if step2.present?
        	step3 = step2.count
        	if step3 >= 3
        		sanction_details = true
        	return sanction_details
        	end
        end
        return sanction_details
  	end

    def self.check_for_progressive_sanction(arg_sanction_type)
      progressive_santion_collection = SystemParam.where("system_params.system_param_categories_id = 9
                                 and CAST(system_params.value AS integer) = ?
                                 and system_params.key = 'PROGRESSIVE_SANCTIONS'", arg_sanction_type )

      if progressive_santion_collection.present?
         return true
      else
         return false
      end
    end





end


