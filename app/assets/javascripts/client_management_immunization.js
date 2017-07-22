    function js_exempt_from_immunization_div()
    {

        // onload start

         $('#cm_exempt_from_immunization_div').hide();

         // if Provided Immunization record is NO then it should visible.
         if ($('#provided_immunization_n').is(':checked'))
         {
            $('#cm_exempt_from_immunization_div').show();
         }

         if ($('#provided_immunization_y').is(':checked'))
         {
            $('#cm_exempt_from_immunization_div').hide();
         }
    }
    // onload end

    // ONCLICK OF provided immunization information  YES START
    $('#provided_immunization_y').click(function()
    {
         $('#cm_exempt_from_immunization_div').hide();
          // clear
          document.getElementById("excempt_immunization_y").checked = false;
          document.getElementById("excempt_immunization_n").checked = false;
    }
    );
     // ONCLICK OF provided immunization information  YES end

    // ONCLICK OF provided immunization information  NO START
    $('#provided_immunization_n').click(function()
    {
         $('#cm_exempt_from_immunization_div').show();
          // clear
          document.getElementById("excempt_immunization_y").checked = false;
          document.getElementById("excempt_immunization_n").checked = false;
    }
    );
     // ONCLICK OF provided immunization information  NO end







