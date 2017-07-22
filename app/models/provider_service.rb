class ProviderService < ActiveRecord::Base
has_paper_trail :class_name => 'ProviderServiceVersion',:on => [:update, :destroy]

	include AuditModule

	belongs_to :provider
 	before_create :set_create_user_fields
  	before_update :set_update_user_field

    has_many :provider_service_areas, dependent: :destroy



  	 HUMANIZED_ATTRIBUTES = {
    :service_type => "Service",
    :service_units => "Service units",
    :start_date => "Start date",
    :end_date => "End date"
    }

    validates_presence_of :service_type, :start_date,message: "is required"
    validate :valid_start_date?,:valid_end_date?,:start_date_less_than_end_date?
    validate :validate_only_one_active_service?, :on => :create
    validate :validate_only_one_active_service_update?, :on => :update
    validate :validate_no_overlapping_dates, :on => :create
    validate :validate_no_overlapping_dates_update, :on => :update
    #validate :validate_date_greater_than_current_agreement, :on => :update


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

    def valid_start_date?
      DateService.valid_date?(self,start_date,"Start date")
    end

    def valid_end_date?
      DateService.valid_date?(self,end_date,"End date")
    end

    def start_date_less_than_end_date?
      DateService.begin_date_cannot_be_greater_than_end_date?(self,start_date,end_date,"Start date","End date")
    end



   # provider service - date & unique validations start Manoj 01/08/2014
     def validate_only_one_active_service?
      if Provider.is_service_present(self.provider_id,self.service_type)
        local_message = "The provider is currently providing this service"
        self.errors[:base] << local_message
        return false
      else
        return true
      end
    end


    def validate_only_one_active_service_update?
      if self.end_date.blank?
        if Provider.is_service_present_update(self.provider_id,self.service_type,self.id)
          local_message = "The provider is currently providing this service"
          self.errors[:base] << local_message
          return false
        else
          return true
        end
      else
        return true
      end
    end

     def validate_no_overlapping_dates
      if Provider.check_service_overlapping_dates(self.provider_id,self.service_type,self.start_date,self.end_date)
        local_message = "Service dates overlap for the given service"
        self.errors[:base] << local_message
        return false
      else
        return true
      end
    end

     def validate_no_overlapping_dates_update
      if Provider.check_service_overlapping_dates_update(self.provider_id,self.service_type,self.start_date,self.end_date,self.id)
        local_message = "Service dates overlap for the given service"
        self.errors[:base] << local_message
        return false
      else
        return true
      end
    end

    # provider service - date & unique validations end Manoj 01/08/2014

    def self.item_list(arg_provider_id)
      where("provider_id = ? and (end_date is null or end_date > current_date)", arg_provider_id)
    end


    # provider service - for all occupations

    def self.provider_occupations_lits()
      step1 = where("occupation is not null and (end_date is null or end_date > current_date)")
      step2 = step1.select("distinct occupation")
    end


    #
    def self.can_provider_service_be_closed?(arg_id,arg_start_date,arg_end_date)

      msg = "CLOSE"
      provider_service_object = ProviderService.find(arg_id)
      program_agreement_collection = ProviderAgreement.where("provider_service_id = ?",arg_id)
      program_agreement_collection.each do |arg_agreement_object|
        if arg_end_date.present?
          if arg_agreement_object.state !=6266
            if arg_agreement_object.agreement_end_date > arg_end_date
              # you cannot close this service - there is an agreement still available.
              msg = "Currently there is an open agreement associated with this service, you cannot close this service"
              break
            end
          end
        end

        if arg_agreement_object.agreement_start_date < arg_start_date
          if arg_agreement_object.state !=6266
            msg = "Currently there is an open agreement associated with this service, you cannot change the start date of this service"
            break
          end
        end
      end
      return msg
    end


    # Provider Agreement date validations - start - Manoj 01/12/2014


     def self.check_agreement_overlapping_dates(arg_provider_id,arg_service_id,arg_start_date,arg_end_date)
     #    Testing the range "start1 to end1" against the range "start2 to end2" is done by testing if...
     # ( start1 <= end2 and start2 <= end1 )
     #    If TRUE, then the ranges overlap.
        lb_return = false
        provider_agreement_collection = ProviderAgreement.where("provider_id = ? and provider_service_id = ?",arg_provider_id,arg_service_id).order("agreement_end_date DESC")
        if provider_agreement_collection.present?
            latest_provider_agreement_object = provider_agreement_collection.first
          if ( (arg_start_date <= latest_provider_agreement_object.agreement_end_date) and (latest_provider_agreement_object.agreement_start_date <= arg_end_date) and
            (latest_provider_agreement_object.state != 6266) )
                        lb_return = true
          end
        end
        return lb_return
    end

    def self.check_agreement_overlapping_dates_update(arg_provider_id,arg_service_id,arg_start_date,arg_end_date,arg_agreement_id,arg_served_area)
         # other than current record search other record.
              #    Testing the range "start1 to end1" against the range "start2 to end2" is done by testing if...
     # ( start1 <= end2 and start2 <= end1 )
     #    If TRUE, then the ranges overlap.
        lb_return = false
        provider_agreement_collection = ProviderAgreement.where("provider_id = ? and provider_service_id = ? and id != ? and dws_local_office_id = ?",arg_provider_id,arg_service_id,arg_agreement_id,arg_served_area).order("agreement_end_date DESC")
        if provider_agreement_collection.present?
            latest_provider_agreement_object = provider_agreement_collection.first
            if ( (arg_start_date <= latest_provider_agreement_object.agreement_end_date) and (latest_provider_agreement_object.agreement_start_date <= arg_end_date) and
              (latest_provider_agreement_object.state != 6266))
                lb_return = true
            end
        # else
        #   lb_return = true
        end
        return lb_return
    end


    #  Provider agreement date  Validations end - Manoj 01/12/2014





end
