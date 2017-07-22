function housing_situation(){
  if ($('#radio_291').is(':checked')){
      $('#54_180').show(); // If yes, please explain.
      $('#54').show();
      $('#803_173').show(); // What is your current housing situation?
      $('#table_803_173').show();
      $('#50_174').show(); // If other, please specify:
      $('#50').show(); // textarea
      if ($('#radio_298').is(':checked')){
        $('#50_174').show();
        $('#50').show();
      }else{
        $("#50_174").val('');
        $("#50").val('');
        $('#50_174').hide();
        $('#50').hide();
      }
      $('#51_175').show();
      $('#table_804').show();
      $('#804').show();
      if ($('#804').is(':checked')){ // Has not moved
          $('#52_178').show();  // Explanation:
          $('#52').show(); // textarea
          $('#231_177').hide(); // Number of times moved (If applicable)
          $('#231').hide(); // text
      }else {
        $('#231_177').show();
        $('#231').show();
        $('#231').attr('onkeypress','return isNaturalNumber(event)');
        $('#52_178').hide();
        $('#52').hide();
      }
  }else {
    $('#54_180').hide(); // If yes, please explain.
    $('#54').hide();
    $('#803_173').hide();
    $('#table_803_173').hide();
    $("#50_174").val('');
    $("#50").val('');
    $('#50_174').hide();
    $('#50').hide();
    $('#51_175').hide();
    $('#table_804').hide();
    $('#804').hide();
    $('#231_177').hide();
    $('#231').hide();
    $('#52_178').hide();
    $('#52').hide();
  }
}

$('#radio_291').change(function() {
  if ($('#radio_291').is(':checked')){
    $('#54_180').show(); // If yes, please explain.
    $('#54').show();
    $('#803_173').show();
    $('#table_803_173').show();
    $('#50_174').show();
    $('#50').show();
  }
  if ($('#radio_298').is(':checked')){
    $('#50_174').show();
    $('#50').show();
  }

  if ($('#radio_298').is(':checked')){
    $('#50_174').show();
    $('#50').show();
  }else{
    $("#50_174").val('');
    $("#50").val('');
    $('#50_174').hide();
    $('#50').hide();
  }
  $('#51_175').show();
  $('#table_804').show();
  $('#804').show();
  $('#231_177').show();
  $('#231').show();
  $('#231').attr('onkeypress','return isNaturalNumber(event)');
});

$('#radio_292').change(function() {
  if ($('#radio_292').is(':checked')){
    $('#54_180').hide(); // If yes, please explain.
    $('#54').val('');
    $('#54').hide();
    $('#radio_293').removeAttr('checked');
    $('#radio_294').removeAttr('checked');
    $('#radio_295').removeAttr('checked');
    $('#radio_296').removeAttr('checked');
    $('#radio_297').removeAttr('checked');
    $('#radio_298').removeAttr('checked');
    $('#803_173').hide();
    $('#table_803_173').hide();
    $('#50_174').hide();
    $('#50').hide();
    if ($('#radio_298').is(':checked')){
    }else{
      $("#50_174").val('');
      $("#50").val('');
      $('#50_174').hide();
      $('#50').hide();
    }
    $('#51_175').hide();
    $('#table_804').hide();
    $('#804').removeAttr('checked');
    $('#804').hide();
    $('#231_177').hide();
    $('#231').val('');
    $('#231').hide();
    $('#52_178').hide();
    $('#52').val('');
    $('#52').hide();
  }
});

$('#radio_293').change(function() {
  $("#50_174").val('');
  $("#50").val('');
  $('#50_174').hide();
  $('#50').hide();
});

$('#radio_294').change(function() {
  $("#50_174").val('');
  $("#50").val('');
  $('#50_174').hide();
  $('#50').hide();
});

$('#radio_295').change(function() {
  $("#50_174").val('');
  $("#50").val('');
  $('#50_174').hide();
  $('#50').hide();
});

$('#radio_296').change(function() {
  $("#50_174").val('');
  $("#50").val('');
  $('#50_174').hide();
  $('#50').hide();
});

$('#radio_297').change(function() {
  $("#50_174").val('');
  $("#50").val('');
  $('#50_174').hide();
  $('#50').hide();
});

$('#radio_298').change(function() {
  if ($('#radio_298').is(':checked')){
    $('#50_174').show();
    $('#50').show();
  }else{
    $("#50_174").val('');
    $("#50").val('');
    $('#50_174').hide();
    $('#50').hide();
  }
});

$('#804').change(function() {
  if ($('#804').is(':checked')){
      $('#52_178').show();
      $('#52').show();
      $('#231_177').hide();
      $('#231').val('');
      $('#231').hide();
  }else {
    $('#231_177').show();
    $('#231').show();
    $('#231').attr('onkeypress','return isNaturalNumber(event)');
    $('#52_178').hide();
    $('#52').val('');
    $('#52').hide();
  }
});