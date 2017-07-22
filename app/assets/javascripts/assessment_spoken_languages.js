function spoken_languages(){
	if ($('#radio_278').is(':checked')){
      $('#div_40').show(); // If yes, have you ever used a foreign language in a work setting?
	    $('#40_163_280').show(); // Yes
      $('#40_163_281').show(); // No
      $('#498_164').show(); // How fluent are you?

      $('#645_165').show(); //Spoken Language 1
      $('#645').show(); //input

	    $('#646_166').show(); //Language 1 fluency
      $('#table_646_166').show();

      $('#647_167').show(); // Spoken Language 2
      $('#647').show();

      $('#648_168').show(); // Language 2 fluency
      $('#table_648_168').show();

      $('#649_169').show(); // Spoken Language 3
      $('#649').show();

      $('#650_170').show(); // Language 3 fluency
      $('#table_650_170').show();

  }else {
    $('#div_40').hide();
    $('#40_163_280').hide();
    $('#40_163_281').hide();
    $('#498_164').hide();

    $('#645_165').hide();
    $('#645').hide();

    $('#646_166').hide();
    $('#table_646_166').hide();


    $('#647_167').hide();
    $('#647').hide();

    $('#648_168').hide();
    $('#table_648_168').hide();

    $('#649_169').hide();
    $('#649').hide();

    $('#650_170').hide();
    $('#table_650_170').hide();


  }
}

$('#radio_278').change(function() {
  if ($('#radio_278').is(':checked')){
    $('#div_40').show();
    $('#40_163_280').show();
    $('#40_163_281').show();
    $('#498_164').show();

    $('#645_165').show();
    $('#645').show();

    $('#646_166').show();
    $('#table_646_166').show();

    $('#647_167').show();
    $('#647').show();

    $('#648_168').show();
    $('#table_648_168').show();

    $('#649_169').show();
    $('#649').show();

    $('#650_170').show();
    $('#table_650_170').show();


  }
});

$('#radio_279').change(function() {
  if ($('#radio_279').is(':checked')){
    $('#div_40').hide();
    $('#radio_280').removeAttr('checked');
    $('#radio_281').removeAttr('checked');
    $('#40_163_280').hide();
    $('#40_163_281').hide();
    $('#498_164').hide();

    $('#645_165').hide();
    $('#645').hide();

    $('#646_166').hide();
    $('#table_646_166').hide();

    $('#647_167').hide();
    $('#647').hide();

    $('#648_168').hide();
    $('#table_648_168').hide();

    $('#649_169').hide();
    $('#649').hide();

    $('#650_170').hide();
    $('#table_650_170').hide();
  }
});