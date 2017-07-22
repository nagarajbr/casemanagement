class PguAction < ActiveRecord::Base
has_paper_trail :class_name => 'PguActionVersion',:on => [:update, :destroy]


	  attr_accessor :pgu_action,:pgu_action_reason,:pgu_action_date,:pgu_deny_notice_generation_flag

    HUMANIZED_ATTRIBUTES = {
      pgu_action: "Action",
      pgu_action_reason: "Action Reason",
      pgu_action_date: "Action Date",
      pgu_deny_notice_generation_flag: "Notice Generation"
    }

    def self.human_attribute_name(attr, options = {})
      HUMANIZED_ATTRIBUTES[attr.to_sym] || super
    end
    # validates_presence_of :pgu_action,:pgu_action_reason,:pgu_action_date, message: "is required"

	#Manoj 11/09/2014
    # Program unit action- Multi step form creation of data. - start
    attr_writer :current_step,:process_object

    def steps

       %w[pgu_action_first pgu_action_last]
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


    # Program unit action- - Multi step form creation of data. - End
end
