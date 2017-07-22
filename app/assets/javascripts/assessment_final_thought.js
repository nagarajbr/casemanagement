function final_thought(){
	if ($('#radio_955').is(':checked')){
      $('#87_512').show();
      $('#87').show();
  }else {
    $('#87_512').hide();
    $('#87').hide();
  }
}

$('#radio_955').change(function() {
  if ($('#radio_955').is(':checked')){
    $('#87_512').show();
    $('#87').show();
  }
});

$('#radio_956').change(function() {
  if ($('#radio_956').is(':checked')){
    $('#87_512').hide();
    $('#87').val('');
    $('#87').hide();
  }
});