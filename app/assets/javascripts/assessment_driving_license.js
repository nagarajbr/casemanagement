function driving_license(){
	if ($('#radio_320').is(':checked')){
      $('#caption_58').show();
	    $('#table_58_192').show();
      if ($('#checkbox_325').is(':checked')){
        $('#59_193').show();
        $('#59').show();
      }
      $('#60_194_60').show();
      $('#dropdown_60 ').show();
      $('#div_512').hide();
      $('#512_195_326').hide();
      $('#512_195_327').hide();
      $('#radio_326').hide();
      $('#radio_327').hide();
      $('#59_193').hide();
      $('#59').hide();
      $('#515_199').hide();
      $('#515').hide();

      if ($('#radio_326').is(':checked')) {
        $('#594_196').show();
        $('#594').show();
        $('#513_197').show();
        $('#513').show();
        $('#514_198').show();
        $('#514').show();
        $('#515_199').hide();
        $('#515').hide();
      } else{
        $('#594_196').hide();
        $('#594').hide();
        $('#513_197').hide();
        $('#513').hide();
        $('#514_198').hide();
        $('#514').hide();
      };
  }else {
    $('#caption_58').hide();
    $('#table_58_192').hide();
    $('#59_193').hide();
    $('#59').hide();
    $('#60_194_60').hide();
    $('#dropdown_60').hide();
    $('#div_512').hide();
    $('#512_195_326').hide();
    $('#512_195_327').hide();
    $('#594_196').hide();
    $('#594').hide();
    $('#513_197').hide();
    $('#513').hide();
    $('#514_198').hide();
    $('#514').hide();
    $('#515_199').hide();
    $('#515').hide();
    if ($('#radio_321').is(':checked')) {
      $('#radio_326').show();
      $('#radio_327').show();
      $('#div_512').show();
      $('#512_195_326').show();
      $('#512_195_327').show();
      if ($('#radio_327').is(':checked')) {
        $('#515_199').show();
        $('#515').show();
      }
    }
    if ($('#radio_326').is(':checked')) {
        $('#594_196').show();
        $('#594').show();
        $('#513_197').show();
        $('#513').show();
        $('#514_198').show();
        $('#514').show();
        $('#515_199').hide();
        $('#515').hide();
      } else{
        $('#594_196').hide();
        $('#594').hide();
        $('#513_197').hide();
        $('#513').hide();
        $('#514_198').hide();
        $('#514').hide();
      };
  }
}

$('#radio_320').change(function() {
  if ($('#radio_320').is(':checked')){
    $('#caption_58').show();
    $('#table_58_192').show();
    if ($('#checkbox_325').is(':checked')){
      $('#59_193').show();
      $('#59').show();
    }
    $('#60_194_60').show();
    $('#dropdown_60 ').show();
    $('#div_512').hide();
    $('#radio_326').removeAttr('checked');
    $('#radio_327').removeAttr('checked');
    $('#radio_326').removeAttr('checked');
    $('#radio_327').removeAttr('checked');
    $('#512_195_326').hide();
    $('#512_195_327').hide();
    $('#594_196').hide();
    $('#594').val('');
    $('#594').hide();

    $('#513_197').hide();
    $('#513').val('');
    $('#513').hide();

    $('#514_198').hide();
    $('#514').val('');
    $('#514').hide();

    $('#515_199').hide();
    $('#515').val('');
    $('#515').hide();

  }
});

$('#radio_321').change(function() {
  if ($('#radio_321').is(':checked')){
    $("#caption_58").hide();
    $('#checkbox_322').removeAttr('checked');
    $('#checkbox_323').removeAttr('checked');
    $('#checkbox_324').removeAttr('checked');
    $('#checkbox_325').removeAttr('checked');
    $("#table_58_192").hide();
    $('#59_193').hide();
    $('#59').val('');
    $('#59').hide();
    $('#60_194_60').hide();
    $('#dropdown_60 ').val('');
    $('#dropdown_60 ').hide();
    $('#div_512').show();
    $('#512_195_326').show();
    $('#512_195_327').show();
    $('#594_196').hide();
    $('#594').hide();
    $('#513_197').hide();
    $('#513').hide();
    $('#514_198').hide();
    $('#514').hide();
    $('#515_199').hide();
    $('#515').hide();
    $('#radio_326').show();
    $('#radio_327').show();
  }
});

$('#checkbox_325').change(function() {
  if ($('#checkbox_325').is(':checked')){
    $('#59_193').show();
    $('#59').show();
  }else{
    $('#59_193').hide();
    $('#59').val('');
    $('#59').hide();
  }
});

$('#radio_326').change(function() {
  if ($('#radio_326').is(':checked')) {
    $('#594_196').show();
    $('#594').show();
    $('#513_197').show();
    $('#513').show();
    $('#514_198').show();
    $('#514').show();
    $('#515_199').hide();
    $('#515').val('');
    $('#515').hide();
  }
});

$('#radio_327').change(function() {
  $('#594_196').hide();
  $('#594').val('');
  $('#594').hide();
  $('#513_197').hide();
  $('#513').val('');
  $('#513').hide();
  $('#514_198').hide();
  $('#514').val('');
  $('#514').hide();
  $('#515_199').show();
  $('#515').show();
});