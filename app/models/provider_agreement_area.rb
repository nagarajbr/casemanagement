class ProviderAgreementArea < ActiveRecord::Base
has_paper_trail :class_name => 'ProviderAgreementAreaVersion',:on => [:update, :destroy]

	include AuditModule

  	before_create :set_create_user_fields
  	before_update :set_update_user_field

	belongs_to :provider_agreements

	 HUMANIZED_ATTRIBUTES = {
      served_county: "County",
      served_area_zip: "Zip code",
      served_local_office_id: "Served Area",
    }

  def self.human_attribute_name(attr,options={})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

   validates_presence_of :served_local_office_id,message: "is required"
   validates_uniqueness_of :served_local_office_id, :scope => [:provider_agreement_id],message: "is already assigned"


  def set_create_user_fields
      user_id = AuditModule.get_current_user.uid
      self.created_by = user_id
      self.updated_by = user_id
  end

  def set_update_user_field
    user_id = AuditModule.get_current_user.uid
    self.updated_by = user_id
  end

  # def self.get_distinct_counties_for_agreement_id(arg_agreement_id)
  #   step1 = ProviderAgreementArea.where("provider_agreement_id = ?",arg_agreement_id).select("distinct provider_agreement_id,served_county")
  # end

  #  def self.get_distinct_local_offices_for_agreement_id(arg_agreement_id)
  #   step1 = ProviderAgreementArea.where("provider_agreement_id = ?",arg_agreement_id).select("distinct provider_agreement_id,served_local_office_id")
  # end

  # def self.get_counties_and_zip_for_agreement_id(arg_agreement_id)
  #   ProviderAgreementArea.where("provider_agreement_id = ?",arg_agreement_id)
  # end

  # def self.delete_provider_agreement_id_served_local_office_id(arg_provider_agreement_id,arg_served_local_office_id)
  #   where("provider_agreement_id = ? and served_local_office_id = ?",arg_provider_agreement_id,arg_served_local_office_id).destroy_all
  # end

  def self.get_local_offices_already_used(arg_provider_agreement_id)
    step1 = ProviderAgreementArea.where("provider_agreement_id = ?",arg_provider_agreement_id).select("distinct served_local_office_id")
  end

  # def self.get_provider_agreement_areas(arg_provider_agreement_id,arg_provider_agreement_local_office)
  #   ProviderAgreementArea.where("provider_agreement_id = ? and served_local_office_id =?",arg_provider_agreement_id,arg_provider_agreement_local_office)
  # end

  def self.get_distinct_local_offices(arg_agreement_id)
    step1 = ProviderAgreementArea.where("provider_agreement_id = ?",arg_agreement_id).select("distinct served_local_office_id")
  end

  def self.find_if_this_area_in_approved_agreement(arg_provider_id,arg_provider_service_id,arg_local_office_id)
    step1 = ProviderAgreement.joins("INNER JOIN provider_agreement_areas ON provider_agreements.id = provider_agreement_areas.provider_agreement_id")
    step2 = step1.where("provider_agreements.provider_id = ? and provider_agreements.provider_service_id = ? and provider_agreement_areas.served_local_office_id = ? and provider_agreements.state = 6166",arg_provider_id,arg_provider_service_id,arg_local_office_id)
    lb_area_associated_with_approved_agreement =   step2.count > 0
    return lb_area_associated_with_approved_agreement
  end

  def self.save_provider_agreement_area(arg_provider_agreement_id,served_local_office_id)
    provider_agrmnt_area_collection = ProviderAgreementArea.where("provider_agreement_id = ? and served_local_office_id = ?",arg_provider_agreement_id,served_local_office_id)
    if  provider_agrmnt_area_collection.present?
    else
      provider_agreement_area_object = ProviderAgreementArea.new
      provider_agreement_area_object.provider_agreement_id = arg_provider_agreement_id
      provider_agreement_area_object.served_local_office_id = served_local_office_id
      provider_agreement_area_object.save
    end

  end


end