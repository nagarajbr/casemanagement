// Manoj 02/03/2016
// This java script is used in Household registration expense step
// Description: New expense record can be added only if expense question is yes

// ONLOAD METHOD BEGIN

function household_registration_expense_step()
{
     // alert('onload -expense step ')
      $('#new_expense_button').hide();

   if ($('#household_member_expense_add_flag_n').is(':checked'))
   {
      $('#new_expense_button').hide();
   }

   if ($('#household_member_expense_add_flag_s').is(':checked'))
   {
      $('#new_expense_button').hide();
   }

   if ($('#household_member_expense_add_flag_y').is(':checked'))
   {
      $('#new_expense_button').show();
   }

// Hidden field is shown on the view - if income record is present , so that new button is visible to add more income records.
   if ($('#household_member_expense_add_flag').is('Y'))
   {
      $('#new_expense_button').show();
   }


}
// ONLOAD METHOD END

//-----------------------------------------------

// ONCLICK OF expense  YES START

$('#household_member_expense_add_flag_y').click(function()
{
     // alert('when radio button clicked -expense Yes ')

// show new button
 $('#new_expense_button').show();

}
);

// ONCLICK Of expense YES END

//-----------------------------------------------

// ONCLICK OF expense NO START

$('#household_member_expense_add_flag_n').click(function()
{
     // alert('when radio button clicked -expense No ')
 // hide new button
  $('#new_expense_button').hide();

}
);

// ONCLICK OF expensee NO END

// ONCLICK OF expense skip START

$('#household_member_expense_add_flag_s').click(function()
{
     // alert('when radio button clicked -expense skip ')
 // hide new button
  $('#new_expense_button').hide();

}
);

// ONCLICK OF expensee skip END


