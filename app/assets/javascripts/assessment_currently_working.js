// ONLOAD METHOD BEGIN

function currently_working()
{


      // alert('on load - first line')
      // step1

      // show only are you currently working question
      hide_all_controls_except_are_you_working_question()

// Are you currently working? is yes' START
      if ($('#radio_117').is(':checked'))
      {
          // alert('on load - Are you currently working? is yes')

          // show challenge to retain income
          // show facorts -health,household,cild care,housing/transportation
          // show tea diversion one time financial amount

          currently_working_yes_on_show();

      }

    // Are you currently working? is yes' END

      if ($('#radio_118').is(':checked'))
      {
           // alert('on load -Are you currently working? is NO')
           // show do you have job offer next month
           $('#div_3').show();
           $('#3_81_119').show();
           $('#radio_119').show();

          $('#3_81_120').show();
           $('#radio_120').show();

           // Have you ever held a paying job ?

           $('#div_904').show();
           $('#904_626_1115').show();
           $('#radio_1115').show();

           $('#904_626_1116').show();
           $('#radio_1116').show();

           //  on load when are you currently working NO - then do you have job offer yes/NO on load functionality.

           if ($('#radio_119').is(':checked'))
          {
              // alert('on load - JOB OFFER ? is yes') also same as currently working YES
               currently_working_yes_on_show();

          }


          if ($('#radio_120').is(':checked'))
          {
               // alert('on load -JOB OFFER ?? is NO')
                currently_working_yes_on_show();
                  $('#903_625_903').hide();
                  $('#dropdown_903').hide();
                show_additional_factors_for_not_working()
          }

      }



}
// ONLOAD METHOD END

//-----------------------------------------------

// ONCLICK OF ARE YOU WORKING YES START

$('#radio_117').click(function()
{
  // alert('when radio button clicked -Are you currently working? Yes ')


   // CLEAR ALL VALUES.
   clear_additional_factors_for_not_working();
   clear_main_factors_working_or_non_working();

    hide_all_controls_except_are_you_working_question();

   currently_working_yes_on_show();


}
);


// ONCLICK OF ARE YOU WORKING YES END

//-----------------------------------------------

// ONCLICK OF ARE YOU WORKING NO START

$('#radio_118').click(function()
{

// alert('when radio button clicked -Are you currently working? No ')
// CLEAR ALL VALUES.


           // CLEAR ALL VALUES.
   clear_additional_factors_for_not_working()
   clear_main_factors_working_or_non_working()

    hide_all_controls_except_are_you_working_question()

     // show do you have job offer next month
           $('#div_3').show();
            $('#3_81_119').show();
           $('#radio_119').show();

          $('#3_81_120').show();
           $('#radio_120').show();

          // Have you ever held a paying job ?
           $('#div_904').show();
           $('#904_626_1115').show();
           $('#radio_1115').show();

           $('#904_626_1116').show();
           $('#radio_1116').show();

            if ($('#radio_119').is(':checked'))
          {
              // alert('on load - JOB OFFER ? is yes') also same as currently working YES
               currently_working_yes_on_show();

          }


          if ($('#radio_120').is(':checked'))
          {
               // alert('on load -JOB OFFER ?? is NO')
                currently_working_yes_on_show();
                show_additional_factors_for_not_working()
          }


}
);

// ONCLICK OF ARE YOU WORKING NO END

//-------------------------------------------

// ONCLICK OF DO YOU HAVE JOB OFFER YES START

$('#radio_119').click(function()
{
   // alert('when radio button clicked -DO YOU HAVE JOB OFFER? Yes ')

  // CLEAR ALL VALUES
  // CLEAR ALL VALUES.
   clear_additional_factors_for_not_working();
   clear_main_factors_working_or_non_working();

    hide_additional_factors();
    currently_working_yes_on_show();


}
);


// ONCLICK OF DO YOU HAVE JOB OFFER YES END

//-----------------------------------------------

// ONCLICK OF DO YOU HAVE JOB OFFER NO START

$('#radio_120').click(function()
{

// alert('when radio button clicked -DO YOU HAVE JOB OFFER? No ')
  // CLEAR VALUES


    // CLEAR ALL VALUES.
   clear_additional_factors_for_not_working()
   clear_main_factors_working_or_non_working()

    // hide_all_controls_except_are_you_working_question();

    currently_working_yes_on_show();
    $('#903_625_903').hide();
    $('#dropdown_903').hide();
    show_additional_factors_for_not_working();


}
);

// ONCLICK OF DO YOU HAVE JOB OFFER? No END




function clear_additional_factors_for_not_working()
{


    $('#checkbox_145').removeAttr('checked');
    $('#checkbox_146').removeAttr('checked');
    $('#checkbox_147').removeAttr('checked');

    // <li>
    //   <fieldset><div  id= caption_7> <caption class='fontc'>Job Opportunity</caption></div> <div><table id = table_7_88> <label id= 7_88_148  for='148'><tr><td width='10%'><input id='checkbox_148' name='7[]' type='checkbox' value='Quit' /></td><td>Quit</td></tr></label> <label id= 7_88_149  for='149'><tr><td width='10%'><input id='checkbox_149' name='7[]' type='checkbox' value='No jobs available' /></td><td>No jobs available</td></tr></label> </table></div></fieldset>
    // </li>

    $('#checkbox_148').removeAttr('checked');
    $('#checkbox_149').removeAttr('checked');

    // <li>
    //   <fieldset><div  id= caption_8> <caption class='fontc'>Satisfaction / Motivation</caption></div> <div><table id = table_8_89> <label id= 8_89_150  for='150'><tr><td width='10%'><input id='checkbox_150' name='8[]' type='checkbox' value='Did not like the work involved' /></td><td>Did not like the work involved</td></tr></label> <label id= 8_89_151  for='151'><tr><td width='10%'><input id='checkbox_151' name='8[]' type='checkbox' value='Do not want to work' /></td><td>Do not want to work</td></tr></label> <label id= 8_89_152  for='152'><tr><td width='10%'><input id='checkbox_152' name='8[]' type='checkbox' value='Schedule/shift issue' /></td><td>Schedule/shift issue</td></tr></label> <label id= 8_89_153  for='153'><tr><td width='10%'><input id='checkbox_153' name='8[]' type='checkbox' value='Too busy to work' /></td><td>Too busy to work</td></tr></label> </table></div></fieldset>
    // </li>

     $('#checkbox_150').removeAttr('checked');
     $('#checkbox_151').removeAttr('checked');
    $('#checkbox_152').removeAttr('checked');
     $('#checkbox_153').removeAttr('checked');

    //  <li>
    //   <fieldset><div  id= caption_9> <caption class='fontc'>Compensation</caption></div> <div><table id = table_9_90> <label id= 9_90_154  for='154'><tr><td width='10%'><input id='checkbox_154' name='9[]' type='checkbox' value='Low wages/hours' /></td><td>Low wages/hours</td></tr></label> <label id= 9_90_155  for='155'><tr><td width='10%'><input id='checkbox_155' name='9[]' type='checkbox' value='No benefits' /></td><td>No benefits</td></tr></label> <label id= 9_90_156  for='156'><tr><td width='10%'><input id='checkbox_156' name='9[]' type='checkbox' value='Poor benefits' /></td><td>Poor benefits</td></tr></label> </table></div></fieldset>
    // </li>


    $('#checkbox_154').removeAttr('checked');

    $('#checkbox_155').removeAttr('checked');

    $('#checkbox_156').removeAttr('checked');

    // <li>
    //   <fieldset><div  id= caption_10> <caption class='fontc'>Work Site Behavior</caption></div> <div><table id = table_10_91> <label id= 10_91_157  for='157'><tr><td width='10%'><input id='checkbox_157' name='10[]' type='checkbox' value='Insubordination' /></td><td>Insubordination</td></tr></label> <label id= 10_91_158  for='158'><tr><td width='10%'><input id='checkbox_158' name='10[]' type='checkbox' value='Interpersonal conflicts' /></td><td>Interpersonal conflicts</td></tr></label> <label id= 10_91_159  for='159'><tr><td width='10%'><input id='checkbox_159' name='10[]' type='checkbox' value='Tardiness/Absence' /></td><td>Tardiness/Absence</td></tr></label> </table></div></fieldset>
    // </li>

     $('#checkbox_157').removeAttr('checked');

     $('#checkbox_158').removeAttr('checked');

     $('#checkbox_159').removeAttr('checked');

    // <li>
    //   <fieldset><div  id= caption_11> <caption class='fontc'>Experience / Skills</caption></div> <div><table id = table_11_92> <label id= 11_92_160  for='160'><tr><td width='10%'><input id='checkbox_160' name='11[]' type='checkbox' value='Inadequate education, experience, or skills' /></td><td>Inadequate education, experience, or skills</td></tr></label> <label id= 11_92_161  for='161'><tr><td width='10%'><input id='checkbox_161' name='11[]' type='checkbox' value='Language barrier' /></td><td>Language barrier</td></tr></label> <label id= 11_92_162  for='162'><tr><td width='10%'><input id='checkbox_162' name='11[]' type='checkbox' value='Returned to school' /></td><td>Returned to school</td></tr></label> </table></div></fieldset>
    // </li>


    $('#checkbox_160').removeAttr('checked');

    $('#checkbox_161').removeAttr('checked');

    $('#checkbox_162').removeAttr('checked');

    // <li>
    //    <label id= 89_98>If other, please explain</label> <div class = 'row' ><div class='large-5 columns'><textarea id= 89 name= 89 maxlength = 250 /></textarea></div></div>
    // </li>


    $('#89').val('');

    // <li>
    //    <table id = table_495><tr><td width='10%'><input id= 495 name= 495 type='checkbox'/></td> <td> Did not provide specific reason</td></tr></table>
    // </li>


    $('#495').removeAttr('checked');

}

function clear_main_factors_working_or_non_working()
{




      $('#checkbox_163').removeAttr('checked');

      $('#checkbox_164').removeAttr('checked');

      $('#checkbox_165').removeAttr('checked');

      $('#checkbox_166').removeAttr('checked');

    //   <li>
    //   <fieldset><div  id= caption_13> <caption class='fontc'>Household</caption></div> <div><table id = table_13_94> <label id= 13_94_167  for='167'><tr><td width='10%'><input id='checkbox_167' name='13[]' type='checkbox' value='Issue with child' /></td><td>Issue with child</td></tr></label> <label id= 13_94_168  for='168'><tr><td width='10%'><input id='checkbox_168' name='13[]' type='checkbox' value='Issue with household member' /></td><td>Issue with household member</td></tr></label> <label id= 13_94_169  for='169'><tr><td width='10%'><input id='checkbox_169' name='13[]' type='checkbox' value='Need to work close to home' /></td><td>Need to work close to home</td></tr></label> </table></div></fieldset>
    // </li>

     $('#checkbox_167').removeAttr('checked');

     $('#checkbox_168').removeAttr('checked');

     $('#checkbox_169').removeAttr('checked');



    //  <li>
    //   <fieldset><div  id= caption_14> <caption class='fontc'>Childcare</caption></div> <div><table id = table_14_95> <label id= 14_95_170  for='170'><tr><td width='10%'><input id='checkbox_170' name='14[]' type='checkbox' value='Can not find childcare' /></td><td>Can not find childcare</td></tr></label> <label id= 14_95_171  for='171'><tr><td width='10%'><input id='checkbox_171' name='14[]' type='checkbox' value='Location of available child care' /></td><td>Location of available child care</td></tr></label> <label id= 14_95_172  for='172'><tr><td width='10%'><input id='checkbox_172' name='14[]' type='checkbox' value='Can not afford' /></td><td>Can not afford</td></tr></label> </table></div></fieldset>
    // </li>



        $('#checkbox_170').removeAttr('checked');
        $('#checkbox_171').removeAttr('checked');
        $('#checkbox_172').removeAttr('checked');

    //      <li>
    //   <fieldset><div  id= caption_15> <caption class='fontc'>Housing / Transportation</caption></div> <div><table id = table_15_96> <label id= 15_96_173  for='173'><tr><td width='10%'><input id='checkbox_173' name='15[]' type='checkbox' value='No transportation' /></td><td>No transportation</td></tr></label> <label id= 15_96_174  for='174'><tr><td width='10%'><input id='checkbox_174' name='15[]' type='checkbox' value='Vehicle needs repair' /></td><td>Vehicle needs repair</td></tr></label> <label id= 15_96_175  for='175'><tr><td width='10%'><input id='checkbox_175' name='15[]' type='checkbox' value='No permanent housing' /></td><td>No permanent housing</td></tr></label> </table></div></fieldset>
    // </li>


    $('#checkbox_173').removeAttr('checked');


    $('#checkbox_174').removeAttr('checked');


    $('#checkbox_175').removeAttr('checked');

    // $('#dropdown_903').selected.val('');
    $('#dropdown_903').val('');
    $('#4').val('');


}




function hide_all_controls_except_are_you_working_question()
{

   // hide all the other controls other than are you currently working question
      // <label id= 4_82> Other reasons, please explain
      //  </label>
      $('#4_82').hide();
      // <textarea id= 4 name= 4 maxlength = 250 />
      //  </textarea>
       $('#4').hide();
       // <div id = div_3>
       //    <legend class='radiolegend'>
       //      <b class = 'fi-alert' style= 'color: red'></b>
       //      (If not currently working)
       //      <br> Do you have job offer to start working within a month or next month?
       //    </legend>
       //  </div>
        $('#div_3').hide();
      //   <div class='button-group'>
      // <label id= 3_81_119 class='radio-button' for='119'>
      //   <input id='radio_119' name='3' type='radio' value='Y' />Yes
      // </label>
      // <label id= 3_81_120 class='radio-button' for='120'>
      //   <input id='radio_120' name='3' type='radio' value='N' />No
      // </label>
      // </div>
      $('#3_81_119').hide();
       $('#radio_119').hide();

      $('#3_81_120').hide();
       $('#radio_120').hide();

       // Have you ever held a paying job ?

       $('#div_904').hide();
       $('#904_626_1115').hide();
       $('#radio_1115').hide();

       $('#904_626_1116').hide();
       $('#radio_1116').hide();

      // <label id= 88_86>
      //   <b class = 'fi-alert' style= 'color: red'></b>
      //   <b>Do you have any challenges in retaining your income or
      //   why do you think you are not currently working?
      //   </b>
      // </label>
      $('#88_86').hide();
      // <label id= 903_625_903 for = 903>Could a one-time benefit payment get you through so that you are able to take care of yourself and your family?
      // </label>
       $('#903_625_903').hide();
      //  <div class = 'row' >
      //   <div class='large-5 columns'>
      //     <select  id = dropdown_903 name = 903 >
      //       <option value=  >Select a Value</option>
      //       <option value= 150>$1-$150</option>
      //       <option value= 300>$151-$300</option>
      //       <option value= 450>$301-$450</option>
      //       <option value= 600>$451-$600</option>
      //       <option value= 750>$601-$750</option>
      //       <option value= 900>$751-$900</option>
      //       <option value= 1000> More than $900</option>
      //     </select>
      //   </div>
      // </div>
       $('#dropdown_903').hide();

    //    <li>
    //   <fieldset>
    //     <div  id= caption_12>
    //       <caption class='fontc'>Health</caption>
    //     </div>
    //     <div>
    //       <table id = table_12_93>
    //         <label id= 12_93_163  for='163'>
    //           <tr>
    //             <td width='10%'>
    //               <input id='checkbox_163' name='12[]' type='checkbox' value='Physical health' />
    //             </td>
    //             <td>Physical health</td>
    //           </tr>
    //         </label>
    //         <label id= 12_93_164  for='164'>
    //           <tr>
    //             <td width='10%'><input id='checkbox_164' name='12[]' type='checkbox' value='Mental health/stress' />
    //             </td>
    //             <td>Mental health/stress</td>
    //           </tr>
    //         </label>
    //         <label id= 12_93_165  for='165'>
    //           <tr>
    //             <td width='10%'>
    //               <input id='checkbox_165' name='12[]' type='checkbox' value='Pregnancy' />
    //             </td>
    //             <td>Pregnancy</td>
    //           </tr>
    //         </label>
    //         <label id= 12_93_166  for='166'>
    //           <tr>
    //             <td width='10%'><input id='checkbox_166' name='12[]' type='checkbox' value='Alcohol/drugs' />
    //             </td>
    //             <td>Alcohol/drugs</td>
    //           </tr>
    //         </label>
    //         </table>
    //         </div>
    //         </fieldset>
    // </li>

      $('#caption_12').hide();
      $('#table_12_93').hide();
      $('#12_93_163').hide();
      $('#checkbox_163').hide();
      $('#12_93_164').hide();
      $('#checkbox_164').hide();
      $('#12_93_165').hide();
      $('#checkbox_165').hide();
      $('#12_93_166').hide();
      $('#checkbox_166').hide();

    //   <li>
    //   <fieldset><div  id= caption_13> <caption class='fontc'>Household</caption></div> <div><table id = table_13_94> <label id= 13_94_167  for='167'><tr><td width='10%'><input id='checkbox_167' name='13[]' type='checkbox' value='Issue with child' /></td><td>Issue with child</td></tr></label> <label id= 13_94_168  for='168'><tr><td width='10%'><input id='checkbox_168' name='13[]' type='checkbox' value='Issue with household member' /></td><td>Issue with household member</td></tr></label> <label id= 13_94_169  for='169'><tr><td width='10%'><input id='checkbox_169' name='13[]' type='checkbox' value='Need to work close to home' /></td><td>Need to work close to home</td></tr></label> </table></div></fieldset>
    // </li>
     $('#caption_13').hide();
     $('#table_13_94').hide();
     $('#13_94_167').hide();
     $('#checkbox_167').hide();
     $('#13_94_168').hide();
     $('#checkbox_168').hide();
     $('#13_94_169').hide();
     $('#checkbox_169').hide();



    //  <li>
    //   <fieldset><div  id= caption_14> <caption class='fontc'>Childcare</caption></div> <div><table id = table_14_95> <label id= 14_95_170  for='170'><tr><td width='10%'><input id='checkbox_170' name='14[]' type='checkbox' value='Can not find childcare' /></td><td>Can not find childcare</td></tr></label> <label id= 14_95_171  for='171'><tr><td width='10%'><input id='checkbox_171' name='14[]' type='checkbox' value='Location of available child care' /></td><td>Location of available child care</td></tr></label> <label id= 14_95_172  for='172'><tr><td width='10%'><input id='checkbox_172' name='14[]' type='checkbox' value='Can not afford' /></td><td>Can not afford</td></tr></label> </table></div></fieldset>
    // </li>

        $('#caption_14').hide();

        $('#table_14_95').hide();
        $('#14_95_170').hide();

        $('#checkbox_170').hide();

        $('#14_95_171').hide();

        $('#14_95_170').hide();
        $('#checkbox_170').hide();
        $('#14_95_171').hide();

        $('#checkbox_171').hide();
        $('#14_95_172').hide();
         $('#checkbox_172').hide();

    //      <li>
    //   <fieldset><div  id= caption_15> <caption class='fontc'>Housing / Transportation</caption></div> <div><table id = table_15_96> <label id= 15_96_173  for='173'><tr><td width='10%'><input id='checkbox_173' name='15[]' type='checkbox' value='No transportation' /></td><td>No transportation</td></tr></label> <label id= 15_96_174  for='174'><tr><td width='10%'><input id='checkbox_174' name='15[]' type='checkbox' value='Vehicle needs repair' /></td><td>Vehicle needs repair</td></tr></label> <label id= 15_96_175  for='175'><tr><td width='10%'><input id='checkbox_175' name='15[]' type='checkbox' value='No permanent housing' /></td><td>No permanent housing</td></tr></label> </table></div></fieldset>
    // </li>
    $('#caption_15').hide();


    $('#table_15_96').hide();

    $('#15_96_173').hide();

    $('#checkbox_173').hide();

    $('#15_96_174').hide();

    $('#checkbox_174').hide();

    $('#15_96_175').hide();

    $('#checkbox_175').hide();


    // <li>
    //   <label id= 16_97><b> Additional reasons for not working</b></label></br>
    // </li>
     $('#16_97').hide();

    //  <li>
    //   <fieldset><div  id= caption_6> <caption class='fontc'>Employer Initiated</caption></div> <div><table id = table_6_87> <label id= 6_87_145  for='145'><tr><td width='10%'><input id='checkbox_145' name='6[]' type='checkbox' value='Laid off due to company downsizing or poor job performance' /></td><td>Laid off due to company downsizing or poor job performance</td></tr></label> <label id= 6_87_146  for='146'><tr><td width='10%'><input id='checkbox_146' name='6[]' type='checkbox' value='Did not pass drug test' /></td><td>Did not pass drug test</td></tr></label> <label id= 6_87_147  for='147'><tr><td width='10%'><input id='checkbox_147' name='6[]' type='checkbox' value='Criminal record' /></td><td>Criminal record</td></tr></label> </table></div></fieldset>
    // </li>


    $('#caption_6').hide();

    $('#table_6_87').hide();

    $('#6_87_145').hide();

    $('#checkbox_145').hide();

    $('#6_87_146').hide();

    $('#checkbox_146').hide();

     $('#6_87_147').hide();

     $('#checkbox_147').hide();

    // <li>
    //   <fieldset><div  id= caption_7> <caption class='fontc'>Job Opportunity</caption></div> <div><table id = table_7_88> <label id= 7_88_148  for='148'><tr><td width='10%'><input id='checkbox_148' name='7[]' type='checkbox' value='Quit' /></td><td>Quit</td></tr></label> <label id= 7_88_149  for='149'><tr><td width='10%'><input id='checkbox_149' name='7[]' type='checkbox' value='No jobs available' /></td><td>No jobs available</td></tr></label> </table></div></fieldset>
    // </li>


     $('#caption_7').hide();

    $('#table_7_88').hide();

    $('#7_88_148').hide();

    $('#checkbox_148').hide();

    $('#7_88_149').hide();

    $('#checkbox_149').hide();

    // <li>
    //   <fieldset><div  id= caption_8> <caption class='fontc'>Satisfaction / Motivation</caption></div> <div><table id = table_8_89> <label id= 8_89_150  for='150'><tr><td width='10%'><input id='checkbox_150' name='8[]' type='checkbox' value='Did not like the work involved' /></td><td>Did not like the work involved</td></tr></label> <label id= 8_89_151  for='151'><tr><td width='10%'><input id='checkbox_151' name='8[]' type='checkbox' value='Do not want to work' /></td><td>Do not want to work</td></tr></label> <label id= 8_89_152  for='152'><tr><td width='10%'><input id='checkbox_152' name='8[]' type='checkbox' value='Schedule/shift issue' /></td><td>Schedule/shift issue</td></tr></label> <label id= 8_89_153  for='153'><tr><td width='10%'><input id='checkbox_153' name='8[]' type='checkbox' value='Too busy to work' /></td><td>Too busy to work</td></tr></label> </table></div></fieldset>
    // </li>


    $('#caption_8').hide();

     $('#table_8_89').hide();

    $('#8_89_150').hide();

     $('#checkbox_150').hide();

     $('#8_89_151').hide();

     $('#checkbox_151').hide();

     $('#8_89_152').hide();

    $('#checkbox_152').hide();

     $('#8_89_153').hide();

     $('#checkbox_153').hide();

    //  <li>
    //   <fieldset><div  id= caption_9> <caption class='fontc'>Compensation</caption></div> <div><table id = table_9_90> <label id= 9_90_154  for='154'><tr><td width='10%'><input id='checkbox_154' name='9[]' type='checkbox' value='Low wages/hours' /></td><td>Low wages/hours</td></tr></label> <label id= 9_90_155  for='155'><tr><td width='10%'><input id='checkbox_155' name='9[]' type='checkbox' value='No benefits' /></td><td>No benefits</td></tr></label> <label id= 9_90_156  for='156'><tr><td width='10%'><input id='checkbox_156' name='9[]' type='checkbox' value='Poor benefits' /></td><td>Poor benefits</td></tr></label> </table></div></fieldset>
    // </li>

    $('#caption_9').hide();
    $('#table_9_90').hide();
    $('#9_90_154').hide();
    $('#checkbox_154').hide();
    $('#9_90_155').hide();
    $('#checkbox_155').hide();
    $('#9_90_156').hide();
    $('#checkbox_156').hide();

    // <li>
    //   <fieldset><div  id= caption_10> <caption class='fontc'>Work Site Behavior</caption></div> <div><table id = table_10_91> <label id= 10_91_157  for='157'><tr><td width='10%'><input id='checkbox_157' name='10[]' type='checkbox' value='Insubordination' /></td><td>Insubordination</td></tr></label> <label id= 10_91_158  for='158'><tr><td width='10%'><input id='checkbox_158' name='10[]' type='checkbox' value='Interpersonal conflicts' /></td><td>Interpersonal conflicts</td></tr></label> <label id= 10_91_159  for='159'><tr><td width='10%'><input id='checkbox_159' name='10[]' type='checkbox' value='Tardiness/Absence' /></td><td>Tardiness/Absence</td></tr></label> </table></div></fieldset>
    // </li>
     $('#caption_10').hide();
     $('#table_10_91').hide();
     $('#10_91_157').hide();
     $('#checkbox_157').hide();
     $('#10_91_158').hide();
     $('#checkbox_158').hide();
     $('#10_91_159').hide();
     $('#checkbox_159').hide();

    // <li>
    //   <fieldset><div  id= caption_11> <caption class='fontc'>Experience / Skills</caption></div> <div><table id = table_11_92> <label id= 11_92_160  for='160'><tr><td width='10%'><input id='checkbox_160' name='11[]' type='checkbox' value='Inadequate education, experience, or skills' /></td><td>Inadequate education, experience, or skills</td></tr></label> <label id= 11_92_161  for='161'><tr><td width='10%'><input id='checkbox_161' name='11[]' type='checkbox' value='Language barrier' /></td><td>Language barrier</td></tr></label> <label id= 11_92_162  for='162'><tr><td width='10%'><input id='checkbox_162' name='11[]' type='checkbox' value='Returned to school' /></td><td>Returned to school</td></tr></label> </table></div></fieldset>
    // </li>

    $('#caption_11').hide();
    $('#table_11_92').hide();
    $('#11_92_160').hide();
    $('#checkbox_160').hide();
    $('#11_92_161').hide();
    $('#checkbox_161').hide();
    $('#11_92_162').hide();
    $('#checkbox_162').hide();

    // <li>
    //    <label id= 89_98>If other, please explain</label> <div class = 'row' ><div class='large-5 columns'><textarea id= 89 name= 89 maxlength = 250 /></textarea></div></div>
    // </li>

    $('#89_98').hide();
    $('#89').hide();

    // <li>
    //    <table id = table_495><tr><td width='10%'><input id= 495 name= 495 type='checkbox'/></td> <td> Did not provide specific reason</td></tr></table>
    // </li>

    $('#table_495').hide();
    $('#495').hide();



}


function currently_working_yes_on_show()
{

    // <label id= 88_86>
      //   <b class = 'fi-alert' style= 'color: red'></b>
      //   <b>Do you have any challenges in retaining your income or
      //   why do you think you are not currently working?
      //   </b>
      // </label>
      $('#88_86').show();
       // document.getElementById('88_86').innerHTML = 'Do you have any challenges in retaining your income? ';
       document.getElementById('88_86').innerHTML = "<b class = 'fi-alert' style= 'color: red'></b> <b>Do you have challenges in retaining current employment?</b>"

    //   <li>
    //    <label id= 4_82>Other reasons, please explain</label> <div class = 'row' ><div class='large-5 columns'><textarea id= 4 name= 4 maxlength = 250 /></textarea></div></div>
    // </li>
       $('#4_82').show();
       $('#4').show();
      // <label id= 903_625_903 for = 903>Could a one-time benefit payment get you through so that you are able to take care of yourself and your family?
      // </label>
       $('#903_625_903').show();
      //  <div class = 'row' >
      //   <div class='large-5 columns'>
      //     <select  id = dropdown_903 name = 903 >
      //       <option value=  >Select a Value</option>
      //       <option value= 150>$1-$150</option>
      //       <option value= 300>$151-$300</option>
      //       <option value= 450>$301-$450</option>
      //       <option value= 600>$451-$600</option>
      //       <option value= 750>$601-$750</option>
      //       <option value= 900>$751-$900</option>
      //       <option value= 1000> More than $900</option>
      //     </select>
      //   </div>
      // </div>
       $('#dropdown_903').show();

    //    <li>
    //   <fieldset>
    //     <div  id= caption_12>
    //       <caption class='fontc'>Health</caption>
    //     </div>
    //     <div>
    //       <table id = table_12_93>
    //         <label id= 12_93_163  for='163'>
    //           <tr>
    //             <td width='10%'>
    //               <input id='checkbox_163' name='12[]' type='checkbox' value='Physical health' />
    //             </td>
    //             <td>Physical health</td>
    //           </tr>
    //         </label>
    //         <label id= 12_93_164  for='164'>
    //           <tr>
    //             <td width='10%'><input id='checkbox_164' name='12[]' type='checkbox' value='Mental health/stress' />
    //             </td>
    //             <td>Mental health/stress</td>
    //           </tr>
    //         </label>
    //         <label id= 12_93_165  for='165'>
    //           <tr>
    //             <td width='10%'>
    //               <input id='checkbox_165' name='12[]' type='checkbox' value='Pregnancy' />
    //             </td>
    //             <td>Pregnancy</td>
    //           </tr>
    //         </label>
    //         <label id= 12_93_166  for='166'>
    //           <tr>
    //             <td width='10%'><input id='checkbox_166' name='12[]' type='checkbox' value='Alcohol/drugs' />
    //             </td>
    //             <td>Alcohol/drugs</td>
    //           </tr>
    //         </label>
    //         </table>
    //         </div>
    //         </fieldset>
    // </li>

      $('#caption_12').show();
      $('#table_12_93').show();
      $('#12_93_163').show();
      $('#checkbox_163').show();
      $('#12_93_164').show();
      $('#checkbox_164').show();
      $('#12_93_165').show();
      $('#checkbox_165').show();
      $('#12_93_166').show();
      $('#checkbox_166').show();

    //   <li>
    //   <fieldset><div  id= caption_13> <caption class='fontc'>Household</caption></div> <div><table id = table_13_94> <label id= 13_94_167  for='167'><tr><td width='10%'><input id='checkbox_167' name='13[]' type='checkbox' value='Issue with child' /></td><td>Issue with child</td></tr></label> <label id= 13_94_168  for='168'><tr><td width='10%'><input id='checkbox_168' name='13[]' type='checkbox' value='Issue with household member' /></td><td>Issue with household member</td></tr></label> <label id= 13_94_169  for='169'><tr><td width='10%'><input id='checkbox_169' name='13[]' type='checkbox' value='Need to work close to home' /></td><td>Need to work close to home</td></tr></label> </table></div></fieldset>
    // </li>
     $('#caption_13').show();
     $('#table_13_94').show();
     $('#13_94_167').show();
     $('#checkbox_167').show();
     $('#13_94_168').show();
     $('#checkbox_168').show();
     $('#13_94_169').show();
     $('#checkbox_169').show();



    //  <li>
    //   <fieldset><div  id= caption_14> <caption class='fontc'>Childcare</caption></div> <div><table id = table_14_95> <label id= 14_95_170  for='170'><tr><td width='10%'><input id='checkbox_170' name='14[]' type='checkbox' value='Can not find childcare' /></td><td>Can not find childcare</td></tr></label> <label id= 14_95_171  for='171'><tr><td width='10%'><input id='checkbox_171' name='14[]' type='checkbox' value='Location of available child care' /></td><td>Location of available child care</td></tr></label> <label id= 14_95_172  for='172'><tr><td width='10%'><input id='checkbox_172' name='14[]' type='checkbox' value='Can not afford' /></td><td>Can not afford</td></tr></label> </table></div></fieldset>
    // </li>

        $('#caption_14').show();

        $('#table_14_95').show();
        $('#14_95_170').show();

        $('#checkbox_170').show();

        $('#14_95_171').show();

        $('#14_95_170').show();
        $('#checkbox_170').show();
        $('#14_95_171').show();

        $('#checkbox_171').show();
        $('#14_95_172').show();
         $('#checkbox_172').show();

    //      <li>
    //   <fieldset><div  id= caption_15> <caption class='fontc'>Housing / Transportation</caption></div> <div><table id = table_15_96> <label id= 15_96_173  for='173'><tr><td width='10%'><input id='checkbox_173' name='15[]' type='checkbox' value='No transportation' /></td><td>No transportation</td></tr></label> <label id= 15_96_174  for='174'><tr><td width='10%'><input id='checkbox_174' name='15[]' type='checkbox' value='Vehicle needs repair' /></td><td>Vehicle needs repair</td></tr></label> <label id= 15_96_175  for='175'><tr><td width='10%'><input id='checkbox_175' name='15[]' type='checkbox' value='No permanent housing' /></td><td>No permanent housing</td></tr></label> </table></div></fieldset>
    // </li>
    $('#caption_15').show();


    $('#table_15_96').show();

    $('#15_96_173').show();

    $('#checkbox_173').show();

    $('#15_96_174').show();

    $('#checkbox_174').show();

    $('#15_96_175').show();

    $('#checkbox_175').show();

}


function show_additional_factors_for_not_working()
{


    // <li>
    //   <label id= 16_97><b> Additional reasons for not working</b></label></br>
    // </li>
     $('#16_97').show();
      // document.getElementById('88_86').innerHTML = 'Why do you think you are not currently working?';
      document.getElementById('88_86').innerHTML = "<b class = 'fi-alert' style= 'color: red'></b>  <b> why do you think you are not currently working?</b>"

    //  <li>
    //   <fieldset><div  id= caption_6> <caption class='fontc'>Employer Initiated</caption></div> <div><table id = table_6_87> <label id= 6_87_145  for='145'><tr><td width='10%'><input id='checkbox_145' name='6[]' type='checkbox' value='Laid off due to company downsizing or poor job performance' /></td><td>Laid off due to company downsizing or poor job performance</td></tr></label> <label id= 6_87_146  for='146'><tr><td width='10%'><input id='checkbox_146' name='6[]' type='checkbox' value='Did not pass drug test' /></td><td>Did not pass drug test</td></tr></label> <label id= 6_87_147  for='147'><tr><td width='10%'><input id='checkbox_147' name='6[]' type='checkbox' value='Criminal record' /></td><td>Criminal record</td></tr></label> </table></div></fieldset>
    // </li>


    $('#caption_6').show();

    $('#table_6_87').show();

    $('#6_87_145').show();

    $('#checkbox_145').show();

    $('#6_87_146').show();

    $('#checkbox_146').show();

     $('#6_87_147').show();

     $('#checkbox_147').show();

    // <li>
    //   <fieldset><div  id= caption_7> <caption class='fontc'>Job Opportunity</caption></div> <div><table id = table_7_88> <label id= 7_88_148  for='148'><tr><td width='10%'><input id='checkbox_148' name='7[]' type='checkbox' value='Quit' /></td><td>Quit</td></tr></label> <label id= 7_88_149  for='149'><tr><td width='10%'><input id='checkbox_149' name='7[]' type='checkbox' value='No jobs available' /></td><td>No jobs available</td></tr></label> </table></div></fieldset>
    // </li>


     $('#caption_7').show();

    $('#table_7_88').show();

    $('#7_88_148').show();

    $('#checkbox_148').show();

    $('#7_88_149').show();

    $('#checkbox_149').show();

    // <li>
    //   <fieldset><div  id= caption_8> <caption class='fontc'>Satisfaction / Motivation</caption></div> <div><table id = table_8_89> <label id= 8_89_150  for='150'><tr><td width='10%'><input id='checkbox_150' name='8[]' type='checkbox' value='Did not like the work involved' /></td><td>Did not like the work involved</td></tr></label> <label id= 8_89_151  for='151'><tr><td width='10%'><input id='checkbox_151' name='8[]' type='checkbox' value='Do not want to work' /></td><td>Do not want to work</td></tr></label> <label id= 8_89_152  for='152'><tr><td width='10%'><input id='checkbox_152' name='8[]' type='checkbox' value='Schedule/shift issue' /></td><td>Schedule/shift issue</td></tr></label> <label id= 8_89_153  for='153'><tr><td width='10%'><input id='checkbox_153' name='8[]' type='checkbox' value='Too busy to work' /></td><td>Too busy to work</td></tr></label> </table></div></fieldset>
    // </li>


    $('#caption_8').show();

     $('#table_8_89').show();

    $('#8_89_150').show();

     $('#checkbox_150').show();

     $('#8_89_151').show();

     $('#checkbox_151').show();

     $('#8_89_152').show();

    $('#checkbox_152').show();

     $('#8_89_153').show();

     $('#checkbox_153').show();

    //  <li>
    //   <fieldset><div  id= caption_9> <caption class='fontc'>Compensation</caption></div> <div><table id = table_9_90> <label id= 9_90_154  for='154'><tr><td width='10%'><input id='checkbox_154' name='9[]' type='checkbox' value='Low wages/hours' /></td><td>Low wages/hours</td></tr></label> <label id= 9_90_155  for='155'><tr><td width='10%'><input id='checkbox_155' name='9[]' type='checkbox' value='No benefits' /></td><td>No benefits</td></tr></label> <label id= 9_90_156  for='156'><tr><td width='10%'><input id='checkbox_156' name='9[]' type='checkbox' value='Poor benefits' /></td><td>Poor benefits</td></tr></label> </table></div></fieldset>
    // </li>

    $('#caption_9').show();
    $('#table_9_90').show();
    $('#9_90_154').show();
    $('#checkbox_154').show();
    $('#9_90_155').show();
    $('#checkbox_155').show();
    $('#9_90_156').show();
    $('#checkbox_156').show();

    // <li>
    //   <fieldset><div  id= caption_10> <caption class='fontc'>Work Site Behavior</caption></div> <div><table id = table_10_91> <label id= 10_91_157  for='157'><tr><td width='10%'><input id='checkbox_157' name='10[]' type='checkbox' value='Insubordination' /></td><td>Insubordination</td></tr></label> <label id= 10_91_158  for='158'><tr><td width='10%'><input id='checkbox_158' name='10[]' type='checkbox' value='Interpersonal conflicts' /></td><td>Interpersonal conflicts</td></tr></label> <label id= 10_91_159  for='159'><tr><td width='10%'><input id='checkbox_159' name='10[]' type='checkbox' value='Tardiness/Absence' /></td><td>Tardiness/Absence</td></tr></label> </table></div></fieldset>
    // </li>
     $('#caption_10').show();
     $('#table_10_91').show();
     $('#10_91_157').show();
     $('#checkbox_157').show();
     $('#10_91_158').show();
     $('#checkbox_158').show();
     $('#10_91_159').show();
     $('#checkbox_159').show();

    // <li>
    //   <fieldset><div  id= caption_11> <caption class='fontc'>Experience / Skills</caption></div> <div><table id = table_11_92> <label id= 11_92_160  for='160'><tr><td width='10%'><input id='checkbox_160' name='11[]' type='checkbox' value='Inadequate education, experience, or skills' /></td><td>Inadequate education, experience, or skills</td></tr></label> <label id= 11_92_161  for='161'><tr><td width='10%'><input id='checkbox_161' name='11[]' type='checkbox' value='Language barrier' /></td><td>Language barrier</td></tr></label> <label id= 11_92_162  for='162'><tr><td width='10%'><input id='checkbox_162' name='11[]' type='checkbox' value='Returned to school' /></td><td>Returned to school</td></tr></label> </table></div></fieldset>
    // </li>

    $('#caption_11').show();
    $('#table_11_92').show();
    $('#11_92_160').show();
    $('#checkbox_160').show();
    $('#11_92_161').show();
    $('#checkbox_161').show();
    $('#11_92_162').show();
    $('#checkbox_162').show();

    // <li>
    //    <label id= 89_98>If other, please explain</label> <div class = 'row' ><div class='large-5 columns'><textarea id= 89 name= 89 maxlength = 250 /></textarea></div></div>
    // </li>

    $('#89_98').show();
    $('#89').show();

    // <li>
    //    <table id = table_495><tr><td width='10%'><input id= 495 name= 495 type='checkbox'/></td> <td> Did not provide specific reason</td></tr></table>
    // </li>

    $('#table_495').show();
    $('#495').show();

}

function hide_additional_factors()
{

   // <li>
    //   <label id= 16_97><b> Additional reasons for not working</b></label></br>
    // </li>
     $('#16_97').hide();

    //  <li>
    //   <fieldset><div  id= caption_6> <caption class='fontc'>Employer Initiated</caption></div> <div><table id = table_6_87> <label id= 6_87_145  for='145'><tr><td width='10%'><input id='checkbox_145' name='6[]' type='checkbox' value='Laid off due to company downsizing or poor job performance' /></td><td>Laid off due to company downsizing or poor job performance</td></tr></label> <label id= 6_87_146  for='146'><tr><td width='10%'><input id='checkbox_146' name='6[]' type='checkbox' value='Did not pass drug test' /></td><td>Did not pass drug test</td></tr></label> <label id= 6_87_147  for='147'><tr><td width='10%'><input id='checkbox_147' name='6[]' type='checkbox' value='Criminal record' /></td><td>Criminal record</td></tr></label> </table></div></fieldset>
    // </li>


    $('#caption_6').hide();

    $('#table_6_87').hide();

    $('#6_87_145').hide();

    $('#checkbox_145').hide();

    $('#6_87_146').hide();

    $('#checkbox_146').hide();

     $('#6_87_147').hide();

     $('#checkbox_147').hide();

    // <li>
    //   <fieldset><div  id= caption_7> <caption class='fontc'>Job Opportunity</caption></div> <div><table id = table_7_88> <label id= 7_88_148  for='148'><tr><td width='10%'><input id='checkbox_148' name='7[]' type='checkbox' value='Quit' /></td><td>Quit</td></tr></label> <label id= 7_88_149  for='149'><tr><td width='10%'><input id='checkbox_149' name='7[]' type='checkbox' value='No jobs available' /></td><td>No jobs available</td></tr></label> </table></div></fieldset>
    // </li>


     $('#caption_7').hide();

    $('#table_7_88').hide();

    $('#7_88_148').hide();

    $('#checkbox_148').hide();

    $('#7_88_149').hide();

    $('#checkbox_149').hide();

    // <li>
    //   <fieldset><div  id= caption_8> <caption class='fontc'>Satisfaction / Motivation</caption></div> <div><table id = table_8_89> <label id= 8_89_150  for='150'><tr><td width='10%'><input id='checkbox_150' name='8[]' type='checkbox' value='Did not like the work involved' /></td><td>Did not like the work involved</td></tr></label> <label id= 8_89_151  for='151'><tr><td width='10%'><input id='checkbox_151' name='8[]' type='checkbox' value='Do not want to work' /></td><td>Do not want to work</td></tr></label> <label id= 8_89_152  for='152'><tr><td width='10%'><input id='checkbox_152' name='8[]' type='checkbox' value='Schedule/shift issue' /></td><td>Schedule/shift issue</td></tr></label> <label id= 8_89_153  for='153'><tr><td width='10%'><input id='checkbox_153' name='8[]' type='checkbox' value='Too busy to work' /></td><td>Too busy to work</td></tr></label> </table></div></fieldset>
    // </li>


    $('#caption_8').hide();

     $('#table_8_89').hide();

    $('#8_89_150').hide();

     $('#checkbox_150').hide();

     $('#8_89_151').hide();

     $('#checkbox_151').hide();

     $('#8_89_152').hide();

    $('#checkbox_152').hide();

     $('#8_89_153').hide();

     $('#checkbox_153').hide();

    //  <li>
    //   <fieldset><div  id= caption_9> <caption class='fontc'>Compensation</caption></div> <div><table id = table_9_90> <label id= 9_90_154  for='154'><tr><td width='10%'><input id='checkbox_154' name='9[]' type='checkbox' value='Low wages/hours' /></td><td>Low wages/hours</td></tr></label> <label id= 9_90_155  for='155'><tr><td width='10%'><input id='checkbox_155' name='9[]' type='checkbox' value='No benefits' /></td><td>No benefits</td></tr></label> <label id= 9_90_156  for='156'><tr><td width='10%'><input id='checkbox_156' name='9[]' type='checkbox' value='Poor benefits' /></td><td>Poor benefits</td></tr></label> </table></div></fieldset>
    // </li>

    $('#caption_9').hide();
    $('#table_9_90').hide();
    $('#9_90_154').hide();
    $('#checkbox_154').hide();
    $('#9_90_155').hide();
    $('#checkbox_155').hide();
    $('#9_90_156').hide();
    $('#checkbox_156').hide();

    // <li>
    //   <fieldset><div  id= caption_10> <caption class='fontc'>Work Site Behavior</caption></div> <div><table id = table_10_91> <label id= 10_91_157  for='157'><tr><td width='10%'><input id='checkbox_157' name='10[]' type='checkbox' value='Insubordination' /></td><td>Insubordination</td></tr></label> <label id= 10_91_158  for='158'><tr><td width='10%'><input id='checkbox_158' name='10[]' type='checkbox' value='Interpersonal conflicts' /></td><td>Interpersonal conflicts</td></tr></label> <label id= 10_91_159  for='159'><tr><td width='10%'><input id='checkbox_159' name='10[]' type='checkbox' value='Tardiness/Absence' /></td><td>Tardiness/Absence</td></tr></label> </table></div></fieldset>
    // </li>
     $('#caption_10').hide();
     $('#table_10_91').hide();
     $('#10_91_157').hide();
     $('#checkbox_157').hide();
     $('#10_91_158').hide();
     $('#checkbox_158').hide();
     $('#10_91_159').hide();
     $('#checkbox_159').hide();

    // <li>
    //   <fieldset><div  id= caption_11> <caption class='fontc'>Experience / Skills</caption></div> <div><table id = table_11_92> <label id= 11_92_160  for='160'><tr><td width='10%'><input id='checkbox_160' name='11[]' type='checkbox' value='Inadequate education, experience, or skills' /></td><td>Inadequate education, experience, or skills</td></tr></label> <label id= 11_92_161  for='161'><tr><td width='10%'><input id='checkbox_161' name='11[]' type='checkbox' value='Language barrier' /></td><td>Language barrier</td></tr></label> <label id= 11_92_162  for='162'><tr><td width='10%'><input id='checkbox_162' name='11[]' type='checkbox' value='Returned to school' /></td><td>Returned to school</td></tr></label> </table></div></fieldset>
    // </li>

    $('#caption_11').hide();
    $('#table_11_92').hide();
    $('#11_92_160').hide();
    $('#checkbox_160').hide();
    $('#11_92_161').hide();
    $('#checkbox_161').hide();
    $('#11_92_162').hide();
    $('#checkbox_162').hide();

    // <li>
    //    <label id= 89_98>If other, please explain</label> <div class = 'row' ><div class='large-5 columns'><textarea id= 89 name= 89 maxlength = 250 /></textarea></div></div>
    // </li>

    $('#89_98').hide();
    $('#89').hide();

    // <li>
    //    <table id = table_495><tr><td width='10%'><input id= 495 name= 495 type='checkbox'/></td> <td> Did not provide specific reason</td></tr></table>
    // </li>

    $('#table_495').hide();
    $('#495').hide();



}











