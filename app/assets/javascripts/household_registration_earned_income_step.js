// Manoj 02/03/2016
// This java script is used in Household registration income step
// Description: New Income record can be added only if Earned income is present or job offer is present

// ONLOAD METHOD BEGIN

function household_registration_earned_income_step()
{
   // alert('onload -earned income step ')
   // Hide New Button
   $('#new_earned_income_button').hide();

   // earned income is NO - hide New button
   if ($('#household_member_earned_income_flag_n').is(':checked'))
   {
      $('#new_earned_income_button').hide();
   }

   // Job offer is NO - hide New button
   // if ($('#household_member_job_offer_flag_n').is(':checked'))
   // {
   //    $('#new_earned_income_button').hide();
   // }

// Hidden field is shown on the view - if income record is present , so that new button is visible to add more income records.
   if ($('#household_member_earned_income_flag').is('Y'))
   {
      $('#new_earned_income_button').show();
   }

   // earned income is Yes - show New button
   if ($('#household_member_earned_income_flag_y').is(':checked'))
   {
      $('#new_earned_income_button').show();
   }

    // job offer is Yes - show New button
   // if ($('#household_member_job_offer_flag_y').is(':checked'))
   // {
   //    $('#new_earned_income_button').show();
   // }

}
// ONLOAD METHOD END

//-----------------------------------------------

// ONCLICK OF earned income  YES START

$('#household_member_earned_income_flag_y').click(function()
{
    // alert('when radio button clicked -earned income Yes ')

// show new button
 $('#new_earned_income_button').show();
 // hide job offer questions
 // $('#earned_income_step_job_offer_flag').hide();

}
);

// ONCLICK OF ARE YOU WORKING YES END

//-----------------------------------------------

// ONCLICK OF earned income NO START

$('#household_member_earned_income_flag_n').click(function()
{
    // alert('when radio button clicked -earned income No ')
    // show job offer radio buttons
 // $('#earned_income_step_job_offer_flag').show();
 // hide new button
  $('#new_earned_income_button').hide();

  // clear radio buttons
  // document.getElementById("household_member_job_offer_flag_y").checked = false;
  // document.getElementById("household_member_job_offer_flag_n").checked = false;

}
);

// ONCLICK OF earned income NO END

//-------------------------------------------

// ONCLICK OF job offer  YES START

// $('#household_member_job_offer_flag_y').click(function()
// {
//     // alert('when radio button clicked -job offer yes ')
//     // show new button
//     $('#new_earned_income_button').show();

// }
// );


// ONCLICK OF DO YOU HAVE JOB OFFER YES END

//-----------------------------------------------

// ONCLICK OF DO YOU HAVE JOB OFFER NO START

// $('#household_member_job_offer_flag_n').click(function()
// {

//    // alert('when radio button clicked -job offer No ')
//    // Hide New button
//  $('#new_earned_income_button').hide();

// }
// );

// ONCLICK OF DO YOU HAVE JOB OFFER? No END

