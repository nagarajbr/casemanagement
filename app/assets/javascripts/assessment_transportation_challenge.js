function transportation_challenge(){
  if ($('#radio_301').is(':checked')){
      $('#table_55_183').show();
      $('#caption_55').show();
      //$('#div_805').show();
      $('#61_185_311').show();
      $('#61_185_312').show();

      $('#510_188').show();
      $('#510').show();
      $('#510').attr('onkeypress','return isNaturalNumber(event)');

      $('#511_189').show();
      $('#511').show();
      $('#511').attr('onkeypress','return isNaturalNumber(event)');

      $('#701_190').show();
      $('#table_701_190').show();

      if ($('#checkbox_310').is(':checked')){
          $('#56_184').show();
          $('#56').show();
      }else{
          $('#56_184').hide();
          $('#56').hide();
      }

      if ($('#radio_313').is(':checked')){
          $('#509_187').show();
          $('#509').show();
      }else{
          $('#509_187').hide();
          $('#509').hide();
      }

      $('#div_62').show();
      $('#62_200_379').show();
      $('#62_200_380').show();

      if ($('#radio_379').is(':checked')){
          $('#63_201').show();
          $('#63').show();
      }else{
          $('#63_201').hide();
          $('#63').hide();
      }

      if ($('#radio_311').is(':checked')){
          $('#div_508').show();
          $('#508_186_313').show();
          $('#508_186_314').show();
      }else {
          $('#div_508').hide();
          $('#508_186_313').hide();
          $('#508_186_314').hide();
      }

  }else {
    $('#table_55_183').hide();
    $('#caption_55').hide();
    //$('#div_805').hide();
    $('#61_185_311').hide();
    $('#61_185_312').hide();

    $('#510_188').hide();
    $('#510').hide();

    $('#511_189').hide();
    $('#511').hide();

    $('#701_190').hide();
    $('#table_701_190').hide();

    $('#div_508').hide();
    $('#508_186_313').hide();
    $('#508_186_314').hide();

    $('#56_184').hide();
    $('#56').hide();

	$('#div_61').hide();
    $('#509_187').hide();
    $('#509').hide();

    $('#div_62').hide();
    $('#62_200_379').hide();
    $('#62_200_380').hide();

    $('#63_201').hide();
    $('#63').hide();
  }
}

$('#radio_301').change(function() {
  if ($('#radio_301').is(':checked')){
      $('#table_55_183').show();
      $('#caption_55').show();
      //$('#div_805').show();
      $('#61_185_311').show();
      $('#61_185_312').show();

      $('#510_188').show();
      $('#510').show();
      $('#510').attr('onkeypress','return isNaturalNumber(event)');

      $('#511_189').show();
      $('#511').show();
      $('#511').attr('onkeypress','return isNaturalNumber(event)');

      $('#701_190').show();
      $('#table_701_190').show();

      if ($('#radio_311').is(':checked')){
          $('#div_508').show();
          $('#508_186_313').show();
          $('#508_186_314').show();
          if ($('#radio_313').is(':checked')){
            $('#509_187').show();
            $('#509').show();
          }
      }else {
          $('#div_508').hide();
          $('#508_186_313').hide();
          $('#508_186_314').hide();
          $('#509_187').hide();
          $('#509').hide();
      }

      if ($('#checkbox_310').is(':checked')){
          $('#56_184').show();
          $('#56').show();
      }
	  $('#div_61').show();

      if ($('#radio_379').is(':checked')){
          $('#63_201').show();
          $('#63').show();
      }

      $('#div_62').show();
      $('#62_200_379').show();
      $('#62_200_380').show();
  }
});

$('#radio_302').change(function() {
  if ($('#radio_302').is(':checked')){
      $('#checkbox_303').removeAttr('checked');
      $('#checkbox_304').removeAttr('checked');
      $('#checkbox_305').removeAttr('checked');
      $('#checkbox_306').removeAttr('checked');
      $('#checkbox_307').removeAttr('checked');
      $('#checkbox_308').removeAttr('checked');
      $('#checkbox_309').removeAttr('checked');
      $('#checkbox_310').removeAttr('checked');
      $('#table_55_183').hide();
      $('#caption_55').hide();
      //$('#div_805').hide();
      $('#radio_311').removeAttr('checked');
      $('#radio_312').removeAttr('checked');
      $('#61_185_311').hide();
      $('#61_185_312').hide();

      $('#510_188').hide();
      $('#510').val('');
      $('#510').hide();

      $('#511_189').hide();
      $('#511').val('');
      $('#511').hide();

      $('#701_190').hide();
      $('#radio_315').removeAttr('checked');
      $('#radio_316').removeAttr('checked');
      $('#radio_317').removeAttr('checked');
      $('#radio_318').removeAttr('checked');
      $('#radio_319').removeAttr('checked');
      $('#table_701_190').hide();

      $('#div_508').hide();
      $('#radio_313').removeAttr('checked');
      $('#radio_314').removeAttr('checked');
      $('#508_186_313').hide();
      $('#508_186_314').hide();

      $('#56_184').hide();
      $('#56').val('');
      $('#56').hide();

	  $('#div_61').hide();

      $('#509_187').hide();
      $('#509').val('');
      $('#509').hide();

      $('#div_62').hide();
      $('#radio_379').removeAttr('checked');
      $('#radio_380').removeAttr('checked');
      $('#62_200_379').hide();
      $('#62_200_380').hide();

      $('#63_201').hide();
      $('#63').val('');
      $('#63').hide();
  }
});

$('#checkbox_310').change(function() {
  if ($('#checkbox_310').is(':checked')){
      $('#56_184').show();
      $('#56').show();
  }else {
    $('#56_184').hide();
    $('#56').val('');
    $('#56').hide();
  }
});

$('#radio_311').change(function() {
  if ($('#radio_311').is(':checked')){
      $('#div_508').show();
      $('#508_186_313').show();
      $('#508_186_314').show();
      if ($('#radio_313').is(':checked')){
          $('#509_187').show();
          $('#509').show();
      }
  }
});

$('#radio_312').change(function() {
  if ($('#radio_312').is(':checked')){
      $('#div_508').hide();
      $('#508_186_313').hide();
      $('#508_186_314').hide();
      $('#509_187').hide();
      $('#509').hide();
  }
});

$('#radio_313').change(function() {
  if ($('#radio_313').is(':checked')){
      $('#509_187').show();
      $('#509').show();
  }
});

$('#radio_314').change(function() {
  if ($('#radio_314').is(':checked')){
      $('#509_187').hide();
      $('#509').hide();
  }
});

$('#radio_379').change(function() {
  if ($('#radio_379').is(':checked')){
    $('#63_201').show();
    $('#63').show();
  }
});

$('#radio_380').change(function() {
  if ($('#radio_380').is(':checked')){
    $('#63_201').hide();
    $('#63').val('');
    $('#63').hide();
  }
});