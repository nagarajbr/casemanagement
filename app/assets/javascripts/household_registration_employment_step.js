// Manoj 02/03/2016
// This java script is used in Household registration income step
// Description: New Income record can be added only if Earned income is present or job offer is present

// ONLOAD METHOD BEGIN

function household_registration_employment_step()
{
   $('#new_employment_button').hide();
   $('#employment_earned_income_step_job_offer_flag').hide();
   // alert('onload -earned income step ')
   // Hide New Button


   // are you currently working is NO - hide New button
   if ($('#household_member_currently_working_flag_n').is(':checked'))
   {
      $('#new_employment_button').hide();
      $('#employment_earned_income_step_job_offer_flag').show();
   }

   // Job offer is NO - hide New button
   if ($('#household_member_job_offer_flag_n').is(':checked'))
   {
      $('#new_employment_button').hide();
   }



   // earned income is Yes - show New button
   if ($('#household_member_currently_working_flag_y').is(':checked'))
   {
      $('#new_employment_button').show();
   }

    // job offer is Yes - show New button
   if ($('#household_member_job_offer_flag_y').is(':checked'))
   {
      $('#new_employment_button').show();
   }

}
// ONLOAD METHOD END

//-----------------------------------------------

// ONCLICK OF are you currently working  YES START

$('#household_member_currently_working_flag_y').click(function()
{
    // alert('when radio button clicked -earned income Yes ')

// show new button
 $('#new_employment_button').show();
 // hide job offer questions
 $('#employment_earned_income_step_job_offer_flag').hide();

}
);

// ONCLICK OF ARE YOU WORKING YES END

//-----------------------------------------------

// ONCLICK OF are you currently working NO START

$('#household_member_currently_working_flag_n').click(function()
{
    // alert('when radio button clicked -earned income No ')
    // show job offer radio buttons
 $('#employment_earned_income_step_job_offer_flag').show();
 // hide new button
  $('#new_employment_button').hide();

  // clear radio buttons
  document.getElementById("household_member_job_offer_flag_y").checked = false;
  document.getElementById("household_member_job_offer_flag_n").checked = false;

}
);

// ONCLICK OF you currently working NO END

//-------------------------------------------

// ONCLICK OF job offer  YES START

$('#household_member_job_offer_flag_y').click(function()
{
    // alert('when radio button clicked -job offer yes ')
    // show new button
    $('#new_employment_button').show();

}
);


// ONCLICK OF DO YOU HAVE JOB OFFER YES END

//-----------------------------------------------

// ONCLICK OF DO YOU HAVE JOB OFFER NO START

$('#household_member_job_offer_flag_n').click(function()
{

   // alert('when radio button clicked -job offer No ')
   // Hide New button
 $('#new_employment_button').hide();

}
);

// ONCLICK OF DO YOU HAVE JOB OFFER? No END

