class ApplicationScreening < ActiveRecord::Base
has_paper_trail :class_name => 'ApplicationScreeningVersion',:on => [:view_screening_summary]
  # Author : Manoj Patil
  # Date : 09/27/2014
  #


	#Manoj 09/06/2014
    # Application_screening - Multi step form creation of data. - start
    attr_writer :current_step,:process_object

    def steps
      %w[application_screening_first application_screening_second application_screening_third application_screening_fourth application_screening_last]
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


    # Application_screening - Multi step form creation of data. - End


    def self.manage_application_screening(arg_application_id)
      l_screening_object_collection = ApplicationScreening.where("client_application_id = ?",arg_application_id)
      if l_screening_object_collection.present?
        app_screening_object = l_screening_object_collection.first
      else
        app_screening_object = ApplicationScreening.new
        app_screening_object.client_application_id = arg_application_id
        app_screening_object.save
      end

      return app_screening_object
    end

end
