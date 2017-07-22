jQuery(function() {
  var disposition_reasons_list;
  disposition_reasons_list = $('#application_disposition_reason').html();
  return $('#application_disposition_status').change(function() {
    var options, selected_application_disposition_status;
    selected_application_disposition_status = $('#application_disposition_status :selected').attr('value');

    options = $(disposition_reasons_list).filter("optgroup[label='" + selected_application_disposition_status + "']").html();
    // alert("option: " + options)
    if (options) {
      $('#application_disposition_reason').html(options);
      if (selected_application_disposition_status == 6017) {
      } else{
        return $("#application_disposition_reason").prop("selectedIndex", -1);
      }
      ;

    } else {
      return $('#application_disposition_reason').empty();
    }

  });
});

$(function () {

    set_disposition_reasons_dropdown(); //this calls it on load

});

function set_disposition_reasons_dropdown() {
  var disposition_reasons_list;
    disposition_reasons_list = $('#application_disposition_reason').html();
  //alert(components_list)
    var options, selected_activity_type;
    selected_activity_type = $('#application_disposition_status :selected').attr('value');
    //alert(selected_activity_type)
    options = $(disposition_reasons_list).filter("optgroup[label='" + selected_activity_type + "']").html();
    if (options) {
      return $('#application_disposition_reason').html(options);
      //return $("#application_disposition_reason").prop("selectedIndex", -1);
    } else {
      return $('#application_disposition_reason').empty();
    }
}