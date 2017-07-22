function js_salary_income_type_show_employment_div()
{

    li_income_type = document.getElementById('income_incometype').value
    if (li_income_type == "2811" || li_income_type == "2854" || li_income_type == "2825" || li_income_type == "2790" || li_income_type == "2796" || li_income_type == "2829")
         { 
         	document.getElementById('other_income_fields').style.display = 'none';
    	    document.getElementById('income_type_salary_employment_navigate').style.display = 'inline';
    	    //document.getElementById('new_income_save_button').disabled  = 'true';
    	    $('#new_income_save_button').hide();

         }
     else
         {
           document.getElementById('other_income_fields').style.display = 'inline';
           document.getElementById('income_type_salary_employment_navigate').style.display = 'none';
            //document.getElementById('new_income_save_button').disabled  = 'false';
            $('#new_income_save_button').show();
          }
}



