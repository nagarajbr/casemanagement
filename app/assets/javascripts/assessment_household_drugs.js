function household_drugs(){
	if ($('#radio_579').is(':checked')){
      $('#76_313').show();
      $('#76').show();
  }else {
    $('#76_313').hide();
    $('#76').hide();
  }
}

$('#radio_579').change(function() {
  if ($('#radio_579').is(':checked')){
    $('#76_313').show();
    $('#76').show();
  }
});

$('#radio_580').change(function() {
  if ($('#radio_580').is(':checked')){
    $('#76_313').hide();
    $('#76').val('');
    $('#76').hide();
  }
});