// function JS_Alien_Citizenship_Yes_No(rad){
// if (document.getElementById('citizen_yes').checked) ? document.getElementById('alien_div').style.visibility = 'hidden' : document.getElementById('alien_div').style.visibility = 'visible' && (document.getElementById("citizen_no").checked) ? document.getElementById('client_sves_type').disabled = true;

// }

// function JS_Alien_Citizenship_status_Yes_No(rad){

// }
function JS_Alien_Citizenship_Yes_No(rad){
if (document.getElementById('citizen_yes').checked){
                document.getElementById('alien_div').style.display = 'none';
                document.getElementById('citizenship_div').style.display = 'inline';
                // document.getElementById('client_sves_type').disabled=false;
  }else if (document.getElementById('citizen_no').checked){
                document.getElementById('alien_div').style.display = 'inline';
                document.getElementById('citizenship_div').style.display = 'none';
                // document.getElementById('client_sves_type').disabled=true;
  }else{
                // document.getElementById('client_sves_type').disabled=false;
                document.getElementById('citizenship_div').style.display = 'none';
                document.getElementById('alien_div').style.display = 'none';
  }
}
