function  prescreen_assessment_household_conditions()
{
  // Other Label
  // Why do you think you are not currently working? Label
  $('#891_613').hide();
  // Employer Initiated
  $('#caption_892').hide();
  $('#table_892_614').hide();
  // Job Opportunity
  $('#caption_893').hide();
  $('#table_893_615').hide();
// Satisfaction / Motivation
  $('#caption_894').hide();
  $('#table_894_616').hide();
// Compensation
  $('#caption_895').hide();
  $('#table_895_617').hide();
  // Work Site Behavior
  $('#caption_896').hide();
  $('#table_896_618').hide();
// Experience / Skills
  $('#caption_897').hide();
  $('#table_897_619').hide();
// Health
  $('#caption_898').hide();
  $('#table_898_620').hide();
// Household
  $('#caption_899').hide();
  $('#table_899_621').hide();
// Childcare
  $('#caption_900').hide();
  $('#table_900_622').hide();
// Housing / Transportation
  $('#caption_907').hide();
  $('#table_907_629').hide();
  // Other
  $('#901_623').hide();
// Notes Label
  $('#903_625').hide();

// Unemployed for over a year
  $('#table_902').hide();

  // Does the job help you become self-sufficient?
  $('#div_906').hide();
  $('#906_628_1111').hide();
  $('#radio_1111').hide();
  // $('#radio_1111').removeAttr('checked');
  $('#906_628_1112 ').hide();
  $('#radio_1112').hide();
  // $('#radio_1112').removeAttr('checked');


// Does the job offer Health Insurance benefits to cover you and your immediate family?
  $('#div_905').hide();
  $('#905_627_1109').hide();
  // $('#radio_1109').removeAttr('checked');
  $('#radio_1109').hide();
  $('#905_627_1110 ').hide();
  // $('#radio_1110').removeAttr('checked');
  $('#radio_1110').hide();

// Job Type
    $('#904_626').hide();
    $('#table_904_626').hide();
    $('#radio_1107').hide();
    // $('#radio_1107').removeAttr('checked');
    $('#904_626_1108').hide();
    $('#radio_1108').hide();
    $('#903').hide();
    // $('#radio_1108').removeAttr('checked');

  if ($('#radio_1076').is(':checked'))
    {
      // Are you currently working? - Yes

     // Does the job help you become self-sufficient?
      $('#div_906').show();
      $('#906_628_1111').show();
      $('#radio_1111').show();

      $('#906_628_1112').show();
      $('#radio_1112').show();

      // Does the job offer Health Insurance benefits to cover you and your immediate family?

      $('#div_905').show();
      $('#905_627_1109').show();
      $('#radio_1109').show();
      $('#905_627_1110').show();
      $('#radio_1110').show();
       // job type
      $('#904_626').show();
      $('#table_904_626').show();
      $('#904_626_1107').show();
      $('#radio_1107').show();
      $('#904_626_1108').show();
      $('#radio_1108').show();
// other
      // $('#901_623').hide();
  }
  if ($('#radio_1077').is(':checked'))
  {
     // Are you currently working? - No
    // Why do you think you are not currently working?
    $('#891_613').show();
    // Employer Initiated
    $('#caption_892').show();
    $('#table_892_614').show();
    // Job Opportunity
    $('#caption_893').show();
    $('#table_893_615').show();
    // Satisfaction / Motivation
    $('#caption_894').show();
    $('#table_894_616').show();
    // Compensation
    $('#caption_895').show();
    $('#table_895_617').show();
    // Work Site Behavior
    $('#caption_896').show();
    $('#table_896_618').show();
    // Experience / Skills
    $('#caption_897').show();
    $('#table_897_619').show();
    // Health
    $('#caption_898').show();
    $('#table_898_620').show();
    //Household
    $('#caption_899').show();
    $('#table_899_621').show();
    // Childcare
    $('#caption_900').show();
    $('#table_900_622').show();

    // Housing / Transportation
    $('#caption_907').show();
    $('#table_907_629').show();
    // Other
    $('#901_623').show();
    // Unemployed for over a year
    $('#table_902').show();
    // Notes
    $('#903_625').show();
// Notes Text ares
    $('#903 ').show();


    // MNP START -COMMENT
//     if ($('radio_1077').is(":not(:checked)"))
//     {
//        // Why do you think you are not currently working?
//        $('#891_613').hide();
//        // Employer Initiated
//        $('#caption_892').hide();
//        $('#table_892_614').hide();
//        // Job Opportunity
//        $('#caption_893').hide();
//        $('#table_893_615').hide();
//        // Satisfaction / Motivation
//        $('#caption_894').hide();
//        $('#table_894_616').hide();
//        //Compensation

//        $('#caption_895').hide();
//        $('#table_895_617').hide();
// // Work Site Behavior
//        $('#caption_896').hide();
//        $('#table_896_618').hide();
// // Experience / Skills
//        $('#caption_897').hide();
//        $('#table_897_619').hide();
// // Health
//        $('#caption_898').hide();
//        $('#table_898_620').hide();
// // Household
//        $('#caption_899').hide();
//        $('#table_899_621').hide();
// //Childcare
//        $('#caption_900').hide();
//        $('#table_900_622').hide();
// //Housing / Transportation
//        $('#caption_907').hide();
//        $('#table_907_629').hide();

//        // Notes
//        $('#903_625').hide();
//        $('#903').hide();
//        // Unemployed for over a year
//        $('#table_902').hide();

//        // $('#889_661').hide();
//      }
    // MNP END -COMMENT

  // Does the job help you become self-sufficient?
    $('#div_906').hide();
    $('#906_628_1111').hide();
    $('#radio_1111').hide();
    $('#906_628_1112').hide();
    $('#radio_1112').hide();

    // Does the job offer Health Insurance benefits to cover you and your immediate family?
    $('#div_905').hide();
    $('#905_627_1109').hide();
    $('#radio_1109').hide();
    $('#905_627_1110 ').hide();
    $('#radio_1110').hide();

    // Job Type
     $('#904_626').hide();
     $('#table_904_626').hide();
     $('#radio_1107').hide();
     $('#904_626_1108').hide();
     $('#radio_1108').hide();


  }
}

$('#radio_1076').click(function()
{
  // Are you currently working? = Yes is clicked

// Why do you think you are not currently working?
  $('#891_613').hide();
  // Employer Initiated options
  $('#caption_892').hide();
  $('#checkbox_1078').removeAttr('checked');
  $('#checkbox_1079').removeAttr('checked');
  $('#checkbox_1080').removeAttr('checked');
  $('#table_892_614').hide();

  // Job Opportunity options
  $('#caption_893').hide();
  $('#checkbox_1081').removeAttr('checked');
  $('#checkbox_1082').removeAttr('checked');
  $('#checkbox_1083').removeAttr('checked');
  $('#table_893_615').hide();
  //Satisfaction / Motivation

  $('#caption_894').hide();
  $('#checkbox_1084').removeAttr('checked');
  $('#checkbox_1085').removeAttr('checked');
  $('#checkbox_1086').removeAttr('checked');
  $('#checkbox_1087').removeAttr('checked');
  $('#table_894_616').hide();
// Compensation
  $('#caption_895').hide();
  $('#checkbox_1088').removeAttr('checked');
  $('#checkbox_1089').removeAttr('checked');
  $('#checkbox_1090').removeAttr('checked');
  $('#table_895_617').hide();
  //Work Site Behavior
  $('#caption_896').hide();
  $('#checkbox_1091').removeAttr('checked');
  $('#checkbox_1092').removeAttr('checked');
  $('#checkbox_1093').removeAttr('checked');
  $('#table_896_618').hide();
//Experience / Skills
  $('#caption_897').hide();
  $('#checkbox_1094').removeAttr('checked');
  $('#checkbox_1095').removeAttr('checked');
  $('#checkbox_1096').removeAttr('checked');
  $('#table_897_619').hide();
// Health
  $('#caption_898').hide();
  $('#checkbox_1097').removeAttr('checked');
  $('#checkbox_1098').removeAttr('checked');
  $('#checkbox_1099').removeAttr('checked');
  $('#checkbox_1100').removeAttr('checked');
  $('#table_898_620').hide();
//Household
  $('#caption_899').hide();
  $('#checkbox_1101').removeAttr('checked');
  $('#checkbox_1102').removeAttr('checked');
  $('#checkbox_1103').removeAttr('checked');
  $('#table_899_621').hide();
// Childcare
  $('#caption_900').hide();
  $('#checkbox_1104').removeAttr('checked');
  $('#checkbox_1105').removeAttr('checked');
  $('#checkbox_1106').removeAttr('checked');
  $('#table_900_622').hide();
// //Housing / Transportation
//   $('#caption_907').hide();
//   $('#checkbox_1113').removeAttr('checked');
//   $('#checkbox_1114').removeAttr('checked');
//   $('#checkbox_1115').removeAttr('checked');
//   $('#table_907_629').hide();
   // Housing / Transportation
    $('#caption_907').show();
    $('#table_907_629').show();
// Notes
  $('#903_625').hide();
  $('#903').hide();
  $('#903').val('');

// Unemployed for over a year
  $('#902').removeAttr('checked');
  $('#table_902').hide();

  // Does the job help you become self-sufficient?
  $('#div_906').show();
  $('#906_628_1111').show();
  $('#radio_1111').show();
  $('#906_628_1112').show();
  $('#radio_1112').show();


  // job type
   $('#904_626').show();
   $('#table_904_626').show();
   $('#radio_1107').show();
   $('#904_626_1108').show();
   $('#radio_1108').show();


    // Does the job offer Health Insurance benefits to cover you and your immediate family?
     $('#div_905').show();
      $('#905_627_1109').show();
      $('#radio_1109').show();
      $('#905_627_1110').show();
      $('#radio_1110').show();


  // other
   $('#901_623').hide();

}
);

$('#radio_1077').click(function()
{
// Are you currently working? No is clicked
// Why do you think you are not currently working?
 $('#891_613').show();
 // Employer Initiated
  $('#caption_892').show();
  $('#table_892_614').show();
// Job Opportunity
  $('#caption_893').show();
  $('#table_893_615').show();
// Satisfaction / Motivation
  $('#caption_894').show();
  $('#table_894_616').show();
//Compensation
  $('#caption_895').show();
  $('#table_895_617').show();
// Work Site Behavior
  $('#caption_896').show();
  $('#table_896_618').show();
//Experience / Skills
  $('#caption_897').show();
  $('#table_897_619').show();
// Health
  $('#caption_898').show();
  $('#table_898_620').show();
// Household
  $('#caption_899').show();
  $('#table_899_621').show();
//Childcare
  $('#caption_900').show();
  $('#table_900_622').show();
//Housing / Transportation
  $('#caption_907').show();
  $('#table_907_629').show();
// nOTES
  $('#903_625').show();
  $('#903').show();
// Unemployed for over a year
  $('#table_902').show();
// Other
  $('#901_623').show();

  // Does the job help you become self-sufficient?
  $('#div_906').hide();
  $('#906_628_1111').hide();
  $('#radio_1111').hide();
  $('#radio_1111').removeAttr('checked');
  $('#906_628_1112 ').hide();
  $('#radio_1112').hide();
  $('#radio_1112').removeAttr('checked');


// Does the job offer Health Insurance benefits to cover you and your immediate family?
  $('#div_905').hide();
    $('#905_627_1109').hide();
    $('#radio_1109').removeAttr('checked');
    $('#radio_1109').hide();
    $('#905_627_1110 ').hide();
    $('#radio_1110').removeAttr('checked');
    $('#radio_1110').hide();

// Job Type
    $('#904_626').hide();
    $('#table_904_626').hide();
    $('#radio_1107').hide();
    $('#radio_1107').removeAttr('checked');
    $('#904_626_1108').hide();
    $('#radio_1108').hide();
    $('#radio_1108').removeAttr('checked');


}
);