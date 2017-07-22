class PrescreenHousehold < ActiveRecord::Base
# Manoj Patil 10/18/2014
# Description: This Model used to manage Prescreening steps of the household.
# (preScreening Model is no longer used.)

  has_many :prescreen_household_members, dependent: :destroy
  has_many :prescreen_household_q_answers, dependent: :destroy
  has_many :prescreen_household_results, dependent: :destroy

  attr_accessor :first_name,:last_name,:date_of_birth,:citizenship_flag,:residency_flag,:highest_education_grade_completed,:save_prescreen_data_flag,:disabled_flag,:veteran_flag,:pregnancy_flag,:attending_school,:caretaker_flag

       HUMANIZED_ATTRIBUTES = {
      household_earned_income_amount: "Earned Income",
      household_expense_amount: "Expenses",
      household_resource_amount: "Resources",
      child_care_benefit_amount: "Child Care Benefits",
      housing_benefit_amount: "Housing Benefits",
      child_support_benefit_amount: "Child Support Benefits",
      student_sholarship_grant_benefit_amount: "Student Sholarship Grant",
      snap_benefit_amount: "SNAP Benefits",
      ssi_benefit_amount: "SSI Benefits",
      transportation_benefit_amount: "Transportation Benefits",
      veterans_benefit_amount: "Veterans Benefits",
      tanf_benefit_amount: "TANF Benefits",
      receiving_medicaid_flag: "Receiving Medicaid",
      address_line1: "Mailing Address line1",
      address_line2: "Mailing Address line2",
      zip: "Zip Code"
    }

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end




# pre screening Multi step form creation of data. - start
    attr_writer :current_step,:process_object

    def steps

       %w[prescreen_household_first prescreen_household_second prescreen_household_third prescreen_household_fourth prescreen_household_fifth prescreen_household_last]
    end

    def current_step
      @current_step || steps.first
    end

    def next_step
      self.current_step = steps[steps.index(current_step)+1]
    end

    def previous_step
      self.current_step = steps[steps.index(current_step)-1]
    end

    def first_step?
      current_step == steps.first
    end

    def last_step?
      current_step == steps.last
    end


    def get_process_object
      self.process_object = steps[steps.index(current_step)-1]
    end


# pre screening Multi step form creation of data. - - End

end