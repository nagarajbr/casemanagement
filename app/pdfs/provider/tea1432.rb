class Tea1432 < FillablePdfForm

  def initialize(provider_agreement)
    @provider_agreement = provider_agreement
    super()
  end

  protected

  def fill_out
    fill :BETWEEN, @provider_agreement.provider_name
    fill("Arkansas Department of Workforce Services the Department does hereby enter into this Memorandum of",@provider_agreement.provider_name)
    fill("transportation services specified herein  The point of contact for the Department for activities related to this",@provider_agreement.local_office_manager_name)
    fill("employment due to transportation barriers  The Transportation Provider shall provide transportation for",@provider_agreement.local_office_name)
    fill("This MOA between the Department and the Transportation Provider to provide transportation",@provider_agreement.served_areas)
    fill("services to current TEA participants residing in",@provider_agreement.agreement_start_date)
  #   [:first_name, :last_name, :address, :address_2, :city, :state, :zip_code].each do |field|
  #     fill field, @user.send(field)
  #   end
  #   fill :age, case @user.age
  #     when nil then nil
  #     when 0..17 then '0_17'
  #     when 18..34 then '18_34'
  #     when 35..54 then '35_54'
  #     else '55_plus'
  #   end
  #   fill :comments, "Hello, World"
  end
end