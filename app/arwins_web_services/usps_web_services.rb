
require 'uri'
class UspsWebServices
  include HTTParty
  base_uri ''
  def initialize()
    @auth = {}
  end
  def get_address_from_usps(arg_address_line_1,arg_address_line_2,arg_city,arg_state,arg_zip_code,arg_zip_suffix,options = {})
  	options.merge!({basic_auth: @auth, verify: false})

    url = 'http://production.shippingapis.com/ShippingAPI.dll?API=Verify&XML=<AddressValidateRequest USERID="320ARKAN5862"><IncludeOptionalElements>true</IncludeOptionalElements><ReturnCarrierRoute>true</ReturnCarrierRoute><Address ID="0">'+"<FirmName/><Address1>#{arg_address_line_1}</Address1><Address2>#{arg_address_line_2}</Address2><City>#{arg_city}</City><State>#{arg_state}</State><Zip5>#{arg_zip_code}</Zip5><Zip4>#{arg_zip_suffix}</Zip4></Address></AddressValidateRequest>"

    response = self.class.get(URI.encode(url), options)

    address = {}
    if response.parsed_response["AddressValidateResponse"]["Address"]["Error"].present?
       address["Error"] = response.parsed_response["AddressValidateResponse"]["Address"]["Error"]["Description"]
    else
      address["Address1"] = response.parsed_response["AddressValidateResponse"]["Address"]["Address1"]
      address["Address2"] = response.parsed_response["AddressValidateResponse"]["Address"]["Address2"]
      address["City"] = response.parsed_response["AddressValidateResponse"]["Address"]["City"]
      address["State"] = response.parsed_response["AddressValidateResponse"]["Address"]["State"]
      address["Zip_code"] = response.parsed_response["AddressValidateResponse"]["Address"]["Zip5"]
      address["Zip_suffix"] = response.parsed_response["AddressValidateResponse"]["Address"]["Zip4"]
    end

    return address
  end
end