class SanctionDetail < ActiveRecord::Base
has_paper_trail :class_name => 'SanctionDetailVersion',:on => [:update, :destroy]
 attr_accessor :warning_count

  include AuditModule

  before_create :set_create_user_fields
  before_update :set_update_user_field
  belongs_to :sanction


  HUMANIZED_ATTRIBUTES = {
    effective_begin_date: "Effective Begin Date",
    sanction_month: "Sanction Month",
    duration: "Duration",
    modified_month: "Modified Month",
    sanction_indicator: "Sanction Implication",
    release_indicatior: "Release Indicator",
    sanction_served: "Sanction Served"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end

    validates_uniqueness_of :sanction_month, :scope => [:sanction_id]
    validates_presence_of  :sanction_month, :sanction_indicator,message: "is required."
    validate :sanction_month_should_be_greater_than_or_equal_to_infraction_start_date?
    validate :sanction_month_should_be_less_than_or_equal_to_infraction_end_date?
    # validate :If_release_indicatior_yes_infraction_end_date_should_be_present?
    validate :sanction_month_should_not_be_added_if_there_is_any_in_state_payment_for_that_month?,:on => [:create]

    def sanction_month_should_be_greater_than_or_equal_to_infraction_start_date?

          if self.sanction.infraction_begin_date.present?
            l_date = self.sanction.infraction_begin_date
            sanction.infraction_begin_date = self.sanction.infraction_begin_date.strftime("01/%m/%Y").to_date
                if (sanction_month.present?) && (sanction_month < sanction.infraction_begin_date)

                  self.sanction.infraction_begin_date = l_date
                  local_message = "Sanction month can't be before infraction begin date."

                  errors[:base] = local_message
                  return false
                end
            self.sanction.infraction_begin_date = l_date
          end

        end



     def sanction_month_should_not_be_added_if_there_is_any_in_state_payment_for_that_month?
           payment_collection = InStatePayment.get_payments_for_the_client(self.sanction.client_id)
           payment_collection.each do |payment|
             if payment.payment_month.present?
            l_date = payment.payment_month
           state_payments= payment.payment_month.strftime("01/%m/%Y").to_date
                if (sanction_month.present?) && (sanction_month == state_payments) && (payment.action_type != 6054 )
                  # payment.payment_month = l_date
                  local_message = "Sanction cannot be applied as a regular payment has been issued for this month."

                  errors[:base] = local_message
                  return false
                end
            payment.payment_month = l_date
          end

        end

      end

    # end




def sanction_month_should_be_less_than_or_equal_to_infraction_end_date?


    if (sanction_month.present?) && (self.sanction.infraction_end_date.present?)&& (sanction_month > self.sanction.infraction_end_date)
      # errors.add(:expense_due_date, "can't be before Expense Begin date")
      local_message = "Sanction month can't be after infraction end date."

      errors[:base] = local_message
      return false
    end
  end

  # def If_release_indicatior_yes_infraction_end_date_should_be_present?
  #   if self.sanction.infraction_end_date.present?
  #     return true
  #   else
  #     if release_indicatior == "1"
  #       local_message = "Infraction end date should be present."
  #       errors[:base] = local_message
  #       return false
  #     end
  #     return true
  #   end
  # end

    def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
      self.release_indicatior = "0"
    end

    def set_update_user_field
      user_id = AuditModule.get_current_user.uid
      self.updated_by = user_id
    end



     def self.get_sanction_details_by_sanction_id(arg_sanction_id)
      where("sanction_id = ?",arg_sanction_id).order(sanction_month: :desc)
    end

    def self.get_sanction_details_by_sanction_id_and_sanction_month(arg_sanction_id,arg_sanction_month)
      where("sanction_id = ? and sanction_month = ? and release_indicatior = '0'",arg_sanction_id,arg_sanction_month).order(sanction_month: :desc)
    end


    def self.is_there_santion_detail_already_for_a_given_month_and_type(arg_sanction_id, arg_sanction_type,arg_sanction_month)
      step1 = joins("INNER JOIN sanctions ON sanctions.id = sanction_details.sanction_id")
      step2 = step1.where("sanction_details.sanction_id = ? and sanctions.sanction_type=? and sanction_details.sanction_month=?", arg_sanction_id,arg_sanction_type,arg_sanction_month)
      result = step2.count > 0
      return result
    end

  def self.save_sanction_details(arg_sanction_id,arg_sanction_indicator,arg_next_month)
    sanction_detail_object = SanctionDetail.new
    sanction_detail_object.sanction_id = arg_sanction_id
    sanction_detail_object.sanction_month = arg_next_month
    sanction_detail_object.sanction_indicator = arg_sanction_indicator
    if sanction_detail_object.save
      ls_sanction_detail = SanctionDetail.find(sanction_detail_object.id)
      @inserted_from_batch = ls_sanction_detail
    else
      @inserted_from_batch = "FAILED"
    end
    return  @inserted_from_batch
  end



  def self.is_payment_month_present_for_sanction_details(arg_sanction_month,arg_sanction_id)
        step1 = joins("inner join sanctions on sanctions.id = sanction_details.sanction_id
                       inner join in_state_payments on sanctions.client_id = in_state_payments.client_id")
        step2 = step1.where("sanctions.id = ? and in_state_payments.payment_type = 5760 and in_state_payments.payment_month = ? ", arg_sanction_id,arg_sanction_month)
      if step2.present?
          return true
       else
          return false
       end
  end

  def self.get_sanction_release_warning_message(arg_client_id,arg_sanction_month)
      program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
      program_wizard_collection = ProgramWizard.get_program_wizard_from_pgu_id_and_run_month(program_unit_id,arg_sanction_month)
      if program_wizard_collection.blank?
         message = "sanctioned payment was never applied for this month."
      else
         message = "SUCCESS"

      end
    return message
  end

  def self.process_supplement_payments_for_sanction_release(arg_client_id,arg_sanction_month)
    msg = nil
     if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_id)
        program_unit_id = ProgramUnit.get_open_program_unit_for_client(arg_client_id)
        program_unit_object = ProgramUnit.find(program_unit_id)
        application_date = ClientApplication.get_application_date(program_unit_object.client_application_id)
        program_wizard_collection = ProgramWizard.get_program_wizard_from_pgu_id_and_run_month(program_unit_id,arg_sanction_month)
        if program_wizard_collection.present?
           program_wizard = program_wizard_collection.first
           program_benfit_detail_object = ProgramBenefitDetail.get_program_benefit_detail_collection_by_run_id(program_wizard.run_id).first
           # service_program_id = program_unit_object.service_program_id
           # client_id = arg_client_id
           # program_unit_id = program_unit_id
           # payment_month = arg_sanction_month
           # determination_id = program_wizard.run_id
           # payment_status = 6191
           # payment_type = 6228
           # payment_amount = program_benfit_detail_object.sanction
          if program_benfit_detail_object.present? and program_benfit_detail_object.sanction > 0
             payment_return_object = PaymentLineItem.save_sup_bonus_retro_payment_line_item(program_unit_object.service_program_id,
                                                                                          6228,
                                                                                          arg_client_id,
                                                                                          program_unit_id,
                                                                                          program_benfit_detail_object.sanction,
                                                                                          arg_sanction_month,
                                                                                          program_wizard.run_id,
                                                                                          6191
                                                                                          )
          if (payment_return_object.class.name != "String")
            begin
                  ActiveRecord::Base.transaction do
                    payment_return_object.save!
                      supl_retro_bns_payment_object = SuplRetroBnsPayment.save_sup_bonus_retro_record(program_unit_id,6228,arg_sanction_month,program_benfit_detail_object.sanction,6191)
                       unless supl_retro_bns_payment_object == 'record_present'
                        supl_retro_bns_payment_object.save!
                      end# unless
                  end#ActiveRecord::Base.transaction do
              msg = "SUCCESS"
              rescue Exception => err
              error_object = CommonUtil.write_to_attop_error_log_table("SanctionDetailsmodel","process_supplement_payments_for_sanction_release",err,AuditModule.get_current_user.uid)
              msg = "Error processing supplement payment - for more details refer to error ID: #{error_object.id}."
            end#begin
          end# if (payment_return_object.class.name == "String")
          end# if program_benfit_detail_object.present? and program_benfit_detail_object.sanction > 0
        end #if program_wizard_collection.present?
     end #if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(arg_client_id)
    return msg
  end

    def add_sanction_after_checking_validations
      warnings = []
      if (self.sanction.sanction_type.to_i == 3062 || self.sanction.sanction_type.to_i == 3081)
        if ((self.sanction.sanction_type.to_i == 3081 && self.new_record?) || self.sanction.sanction_type.to_i == 3062)
           warnings = nil
        else
           client_age = Client.get_age(self.sanction.client_id)
            if client_age < 5
              client_exempt_from_immunization = Client.is_exempted_from_immunization(self.sanction.client_id)
              if client_exempt_from_immunization.blank?
               client_immunization = ClientImmunization.get_client_immunization(self.sanction.client_id)
                if client_immunization.blank?
                 warnings <<  "Sanction is required as immunization information is not present"
                elsif client_immunization.immunizations_record != "Y"
                 warnings <<  "Sanction is required as he/she is not exempt from immunization"
                end
              end
            end
        end
      else
         if ProgramUnitParticipation.is_the_client_present_in_open_program_unit_and_active?(self.sanction.client_id)
            work_charateristic_id = ClientCharacteristic.get_current_work_characteristics(self.sanction.client_id,self.sanction_month)
            if (work_charateristic_id == 5667 || work_charateristic_id.blank?)
              # only mandatory charateristic present or work
              start_date = DateService.date_of_previous("Sunday", Date.today) - 14
              end_date = DateService.date_of_previous("Saturday", Date.today)
              activity_hours = ActivityHour.get_client_activities_for_reporting_month(start_date,end_date,self.sanction.client_id)
               if activity_hours.present?
                  if activity_hours.sum(:assigned_hours) <= activity_hours.sum(:completed_hours)
                      warnings <<  "Client has met work participation rate for prior two weeks."
                  elsif activity_hours.map{|each| each.absent_reason.to_i}.include? 6297
                    #6297 - "Do not attend - Not Excused"
                  elsif (activity_hours.sum(:completed_hours) == 0 || activity_hours.sum(:completed_hours) < activity_hours.sum(:assigned_hours))
                    # no hours entered
                  else
                    warnings <<  "Client has allowable excused/holiday hours."
                  end
               else
                 warnings <<  "No client activities present."
               end
            else
                warnings <<  "Client has deffered charateristic for given month."
            end
         else
          warnings <<  "Client does not have an open program unit."
         end
      end
       return warnings
    end

end
