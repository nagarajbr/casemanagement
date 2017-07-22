// Manoj 02/03/2016
// This java script is used in Household registration income step
// Description: New Income record can be added only if unearned income is yes.

// ONLOAD METHOD BEGIN

function household_registration_unearned_income_step()
{
    // alert('onload -earned income step ')

   if ($('#household_member_unearned_income_flag_n').is(':checked'))
   {
      $('#new_unearned_income_button').hide();
   }

// Hidden field is shown on the view - if income record is present , so that new button is visible to add more income records.
   if ($('#household_member_unearned_income_flag').is('Y'))
   {
      $('#new_unearned_income_button').show();
   } 


}
// ONLOAD METHOD END

//-----------------------------------------------

// ONCLICK OF unearned income  YES START

$('#household_member_unearned_income_flag_y').click(function()
{
     // alert('when radio button clicked -earned income Yes ')

// show new button
 $('#new_unearned_income_button').show();

}
);

// ONCLICK OFunearned income YES END

//-----------------------------------------------

// ONCLICK OF unearned income NO START

$('#household_member_unearned_income_flag_n').click(function()
{
     // alert('when radio button clicked -earned income No ')
 // hide new button
  $('#new_unearned_income_button').hide();

}
);

// ONCLICK OF unearned income NO END



