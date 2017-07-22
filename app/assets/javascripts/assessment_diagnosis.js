function diagnosis(){
	if ($('#72_456').is(':checked')){
      $('#73_229').hide();
      $('#73').hide();
      $('#div_74').hide();
      $('#74_230_457').hide();
      $('#74_230_458').hide();
      $('#558_231').hide();
      $('#558').hide();
  }else{
    if ($('#72_455').is(':checked') == false){
        $('#73_229').hide();
        $('#73').hide();
    }
    if ($('#radio_457').is(':checked') == false){
        $('#558_231').hide();
        $('#558').hide();
    }
  }
}

$('#72_453').click(function() {
  if ($('#72_453').is(':checked')){
    $('#72_456').removeAttr('checked');
    $('#div_74').show();
    $('#74_230_457').show();
    $('#74_230_458').show();
  }else{
    if (($('#72_454').is(':checked') == false) && ($('#72_455').is(':checked') == false)){
      $('#73_229').hide();
      $('#73').val('');
      $('#73').hide();
      $('#div_74').hide();
      $('#radio_457').removeAttr('checked');
      $('#radio_458').removeAttr('checked');
      $('#74_230_457').hide();
      $('#74_230_458').hide();
      $('#558_231').hide();
      $('#558').val('');
      $('#558').hide();
    }
  }
});

$('#72_454').click(function() {
  if ($('#72_454').is(':checked')){
    $('#72_456').removeAttr('checked');
    $('#div_74').show();
    $('#74_230_457').show();
    $('#74_230_458').show();
  }else{
    if (($('#72_453').is(':checked') == false) && ($('#72_455').is(':checked') == false)){
      $('#73_229').hide();
      $('#73').val('');
      $('#73').hide();
      $('#div_74').hide();
      $('#radio_457').removeAttr('checked');
      $('#radio_458').removeAttr('checked');
      $('#74_230_457').hide();
      $('#74_230_458').hide();
      $('#558_231').hide();
      $('#558').val('');
      $('#558').hide();
    }
  }
});

$('#72_455').click(function() {
  if ($('#72_455').is(':checked')){
    $('#72_456').removeAttr('checked');
    $('#73_229').show();
    $('#73').show();
    $('#div_74').show();
    $('#74_230_457').show();
    $('#74_230_458').show();
  }else{
    $('#73_229').hide();
    $('#73').val('');
    $('#73').hide();
    if (($('#72_453').is(':checked') == false) && ($('#72_454').is(':checked') == false)){
      $('#73_229').hide();
      $('#73').val('');
      $('#73').hide();
      $('#div_74').hide();
      $('#radio_457').removeAttr('checked');
      $('#radio_458').removeAttr('checked');
      $('#74_230_457').hide();
      $('#74_230_458').hide();
      $('#558_231').hide();
      $('#558').val('');
      $('#558').hide();
    }
  }
});

$('#72_456').click(function() {
  $('#72_453').removeAttr('checked');
  $('#72_454').removeAttr('checked');
  $('#72_455').removeAttr('checked');
  $('#73_229').hide();
  $('#73').val('');
  $('#73').hide();
  $('#div_74').hide();
  $('#radio_457').removeAttr('checked');
  $('#radio_458').removeAttr('checked');
  $('#74_230_457').hide();
  $('#74_230_458').hide();
  $('#558_231').hide();
  $('#558').val('');
  $('#558').hide();
});

$('#radio_457').click(function() {
  $('#558_231').show();
  $('#558').show();
});

$('#radio_458').click(function() {
  $('#558_231').hide();
  $('#558').val('');
  $('#558').hide();
});