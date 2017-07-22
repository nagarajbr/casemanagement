// function JS_Alien_Citizenship_Yes_No(rad){
// if (document.getElementById('citizen_yes').checked) ? document.getElementById('alien_div').style.visibility = 'hidden' : document.getElementById('alien_div').style.visibility = 'visible' && (document.getElementById("citizen_no").checked) ? document.getElementById('client_sves_type').disabled = true;

// }

// function JS_Alien_Citizenship_status_Yes_No(rad){

// }
function js_living_arrangement_copy_yes_No(rad){

  if (document.getElementById('copy_address_y').checked){
      set_fields_readonly_flag(true)
      if (document.getElementById('hidden_in_care_of').value != null) {
        document.getElementById('in_care_of').value = document.getElementById('hidden_in_care_of').value;
      }
      if (document.getElementById('hidden_address_line1').value != null) {
        document.getElementById('address_line1').value = document.getElementById('hidden_address_line1').value;
      }
      if (document.getElementById('hidden_address_line2').value != null) {
        document.getElementById('address_line2').value = document.getElementById('hidden_address_line2').value;
      }
      if (document.getElementById('hidden_city').value != null) {
        document.getElementById('city').value = document.getElementById('hidden_city').value;
      }
      if (document.getElementById('hidden_state').value != null) {
        document.getElementById('state').value = document.getElementById('hidden_state').value;
        document.getElementById('address_state').value = document.getElementById('hidden_state').value;
      }
      if (document.getElementById('hidden_zip').value != null) {
        document.getElementById('zip').value = document.getElementById('hidden_zip').value;
      }
      if (document.getElementById('hidden_zip_suffix').value != null) {
        document.getElementById('zip_suffix').value = document.getElementById('hidden_zip_suffix').value;
      }
      if (document.getElementById('hidden_county').value != null) {
        document.getElementById('county').value = document.getElementById('hidden_county').value;
        document.getElementById('address_county').value = document.getElementById('hidden_county').value;
      }


  }else if (document.getElementById('copy_address_n').checked){
      set_fields_readonly_flag(false)
      if (document.getElementById('actual_in_care_of').value != null) {
        document.getElementById('in_care_of').value = document.getElementById('actual_in_care_of').value;
      }
      if (document.getElementById('actual_address_line1').value != null) {
        document.getElementById('address_line1').value = document.getElementById('actual_address_line1').value;
      }
      if (document.getElementById('actual_address_line2').value != null) {
        document.getElementById('address_line2').value = document.getElementById('actual_address_line2').value;
      }
      if (document.getElementById('actual_city').value != null) {
        document.getElementById('city').value = document.getElementById('actual_city').value;
      }
      if (document.getElementById('actual_state').value != null) {
        document.getElementById('state').value = document.getElementById('actual_state').value;
        document.getElementById('address_state').value = document.getElementById('hidden_state').value;
      }
      if (document.getElementById('actual_zip').value != null) {
        document.getElementById('zip').value = document.getElementById('actual_zip').value;
      }
      if (document.getElementById('actual_zip_suffix').value != null) {
        document.getElementById('zip_suffix').value = document.getElementById('actual_zip_suffix').value;
      }
      if (document.getElementById('actual_county').value != null) {
        document.getElementById('county').value = document.getElementById('actual_county').value;
        document.getElementById('address_county').value = document.getElementById('actual_county').value;
      }
  }

function set_fields_readonly_flag(arg_readonly_value){
  document.getElementById('in_care_of').readOnly = arg_readonly_value;
  document.getElementById('address_line1').readOnly = arg_readonly_value;
  document.getElementById('address_line2').readOnly = arg_readonly_value;
  document.getElementById('city').readOnly = arg_readonly_value;
  document.getElementById('state').readOnly = arg_readonly_value;
  document.getElementById('address_state').readOnly = arg_readonly_value;
  document.getElementById('zip').readOnly = arg_readonly_value;
  document.getElementById('zip_suffix').readOnly = arg_readonly_value;
  document.getElementById('county').readOnly = arg_readonly_value;
  document.getElementById('address_county').readOnly = arg_readonly_value;
}

  // alert('called from js_living_arrangement')
if (document.getElementById('citizen_yes').checked){

                document.getElementById('alien_div').style.display = 'none';
                document.getElementById('citizenship_div').style.display = 'inline';
                // document.getElementById('client_sves_type').disabled=false;
  }else if (document.getElementById('citizen_no').checked){
                document.getElementById('alien_div').style.display = 'inline';
                 document.getElementById('citizenship_div').style.display = 'inline';
                // document.getElementById('client_sves_type').disabled=true;
  }else{
                // document.getElementById('client_sves_type').disabled=false;
                 document.getElementById('citizenship_div').style.display = 'none';
                document.getElementById('alien_div').style.display = 'none';
  }
}
