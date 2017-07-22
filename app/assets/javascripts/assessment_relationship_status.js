function relationship_status(){
	if ($('#radio_943').is(':checked')){
      $('#caption_732').show();
	    $('#table_732_508').show();
	    $('#733_509').show();
	    $('#table_733_509 ').show();
      $('#div_734  ').show();
      $('#734_510_953').show();
      $('#734_510_954').show();
  }else {
    $('#caption_732').hide();
    $('#table_732_508').hide();
    $('#733_509').hide();
    $('#table_733_509').hide();
    $('#div_734').hide();
    $('#734_510_953').hide();
    $('#734_510_954').hide();
  }
}

$('#radio_943').change(function() {
  if ($('#radio_943').is(':checked')){
    $('#caption_732').show();
    $('#table_732_508').show();
    $('#733_509').show();
    $('#table_733_509').show();
    $('#div_734').show();
    $('#734_510_953').show();
    $('#734_510_954').show();
  }
});

$('#radio_944').change(function() {
  if ($('#radio_944').is(':checked')){
    $("#caption_732").val('');
    $('#caption_732').hide();
    $('#checkbox_945').removeAttr('checked');
    $('#checkbox_946').removeAttr('checked');
    $('#checkbox_947').removeAttr('checked');
    $('#checkbox_948').removeAttr('checked');
    $('#checkbox_949').removeAttr('checked');
    $('#table_732_508').hide();
    $('#733_509').hide();
    $('#radio_950').removeAttr('checked');
    $('#radio_951').removeAttr('checked');
    $('#radio_952').removeAttr('checked');
    $('#table_733_509').hide();
    $('#div_734').hide();
    $('#radio_953').removeAttr('checked');
    $('#radio_954').removeAttr('checked');
    $('#734_510_953').hide();
    $('#734_510_954').hide();
  }
});