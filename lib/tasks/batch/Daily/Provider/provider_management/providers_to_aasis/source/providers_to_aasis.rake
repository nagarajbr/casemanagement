task :generate_provider_file_to_aasis_for_verification => :environment do


filename = "lib/tasks/batch/Daily/Provider/provider_management/providers_to_aasis/outbound/TANFVEND0810_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"
log_filename = "lib/tasks/batch/Daily/Provider/provider_management/providers_to_aasis/results/vend_log_" + "#{Date.today.strftime("%m%d%Y")}"+"#{Time.now.strftime("%H%M%S")}" + ".txt"

path = File.join(Rails.root, filename )
log_path = File.join(Rails.root, log_filename )


# # Create new file called 'filename.txt' at a specified path.
file = File.new(path,"w+")
log_file = File.new(log_path,"w+")
log_file.puts("Begin provider extract to AASIS")
ls_extract_date = Date.today.strftime("%Y-%m-%d")
log_file.puts("Extract date: " + ls_extract_date.to_s)
ls_write = 0
ls_count = 0
ls_error_cnt = 0
#providers = Provider.where("(date(created_at) = current_date or date(updated_at) = current_date) and status = 6540 ")
providers_verify = NightlyBatchProcess.where("process_type = 6592")
 if providers_verify.present?
  ls_count = providers_verify.size
  providers_verify.each do |verify|
    provider = Provider.get_provider_information_from_id(verify.entity_id).first
    address = Address.get_provider_address(provider.id)
    if address.present?
      address = address.first
    end
    # tax = Provider.get_tax_id_ssn_for_provider(provider.id)
    # if tax.present?
    #   tax = tax.first
    # end
    # Rails.logger.debug("********tax = #{tax.inspect}")


#VTR-ACT-CODE
    if verify.reason == 6651
       provider_record = ' ADD'
    else
      provider_record = ' CHG'
    end

#VTR-RANGE
    provider_record = provider_record + '00100000'

#VTR-CO + VTR-PROV
    provider_record = provider_record + provider.id.to_s.strip[0,2].rjust(2,'0')

 #VTR-VND-NAME
   provider_record = provider_record + provider.provider_name.strip[0,35].ljust(35,' ')

#VTR-VND-NAME
   # provider_record = provider_record + provider.provider_type.to_s.strip[0,5].ljust(5,' ')

#VTR-VND-NAME2
    provider_record = provider_record +  provider.contact_person.to_s.strip[0,35].ljust(35,' ')

#VTR-STREET
    if address.present?
      #Address line 1
      provider_record = provider_record + address.address_line1.to_s.strip[0,35].ljust(35,' ')
      #Address line 2
      if address.address_line2?
          provider_record = provider_record + address.address_line2.to_s.strip[0,35].ljust(35,' ')
        else
          provider_record = provider_record + ' '.ljust(35,' ')
      end
      #City
      provider_record = provider_record + address.city.to_s.strip[0,35].ljust(35,' ')
      #Zip
      provider_record = provider_record + address.zip.to_s.strip[0,5].rjust(5,' ')
      #Zip suffix
      if address.zip_suffix?
        provider_record = provider_record + '-'
        provider_record = provider_record + address.zip_suffix.to_s.strip[0,4].ljust(4,'0')
      else
        provider_record = provider_record + ' '.ljust(5,' ')
      end
      #Country
      if provider.provider_country_code.present?
        if provider.provider_country_code == 383
           provider_record = provider_record +'US'
        else
           provider_record = provider_record + '  '
        end
      else
        provider_record = provider_record + '  '
      end
      provider_record = provider_record + ' '
      #State
      provider_record = provider_record + CodetableItem.get_long_description(address.state).strip[0,2].ljust(3,' ')
    else
      log_file.write("Address not found for : " + provider.provider_name.to_s + "\n")
      ls_error_cnt = ls_error_cnt + 1
    end
# VTR-POBOX    X(10)     Defaulted to spaces
   provider_record = provider_record + ' '.ljust(10,' ')
# VTR-POBOX-ZIP            X(10)     Defaulted to spaces
   provider_record = provider_record + ' '.ljust(10,' ')


# VTR-TAX-ID  9(9). Provider EIN
tax= Provider.get_tax_id_ssn_for_provider(provider.id)
provider_record = provider_record + tax.to_s.strip[0,16].rjust(16,' ')

# FILLER                XX.         NA
# provider_record = provider_record + '  '

# VTR-SSN           X(16)     Defaulted to spaces
# No banking information
provider_record = provider_record + ' '.ljust(49,' ')
                # BANK-INFO                     Defaulted to spaces
    #provider_record = provider_record + ' '.ljust(10,' ')
                # VTR-BCOUNTRY            XXX.       Defaulted to spaces
    #provider_record = provider_record + ' '.ljust(3,' ')
                # VTR-BROUT-NO            X(15)     Defaulted to spaces
    #provider_record = provider_record + ' '.ljust(15,' ')
                # VTR-BROUT-ACCT        X(18)     Defaulted to spaces
    #provider_record = provider_record + ' '.ljust(7,' ')

# VTR-WH-TAX-CODE 99  If reportable vendor value is '07' else '00'

#VTR-classification
if provider.classification.present?
  if provider.classification == 6136 || provider.classification == 6135
     provider_record = provider_record + '00'
  else
      if provider.classification == 6133 || provider.classification == 6134 || provider.classification == 6137
        provider_record = provider_record + '07'
      end
  end
else
    provider_record = provider_record + '  '
end

# VTR-SORT-FIELD  X(10) If tax-id is for a county or city value is 'WSCC' else 'WISE'
  if provider.classification.present?
    if provider.classification == 6136
       provider_record = provider_record + 'WSCC'
    else
      if provider.classification == 6133 || provider.classification == 6134 || provider.classification == 6135 || provider.classification == 6137
          provider_record = provider_record + 'WISE'
      end
    end
  else
    provider_record = provider_record + '    '
  end
# VTR-BAACT-TYPE          XX.         Defaulted to spaces
  provider_record = provider_record + ' '.ljust(5,' ') + "\n"
  if provider_record.length != 302
       log_file.write("incorrect length: " + provider_record.length.to_s)
       log_file.write(provider_record)
       ls_error_cnt = ls_error_cnt + 1
    else
       file.write(provider_record)
       ls_write = ls_write + 1
    end
end
end
log_file.puts("Records read : " + ls_count.to_s)
log_file.puts("Records erred : " + ls_error_cnt.to_s)
log_file.puts("Records written : " + ls_write.to_s)
#Close the file.
file.close
log_file.puts("End provider extract to AASIS")
log_file.close

end
