  function set_activity_dropdown(){
  if (document.getElementById('activity_classification').value == 6234) {
  	//alert(1)
  		  document.getElementById('activity_classification_core').disabled=false;
  		  document.getElementById('div_activity_classification_core').style.display = 'inline';
                  document.getElementById('activity_classification_non_core').disabled=true;
                  document.getElementById('div_activity_classification_non_core').style.display = 'none';
    }else if (document.getElementById('activity_classification').value == 6235){
    	//alert(2)
    		document.getElementById('activity_classification_core').disabled=true;
    		document.getElementById('div_activity_classification_core').style.display = 'none';
    				document.getElementById('activity_classification_non_core').disabled=false;
                  document.getElementById('div_activity_classification_non_core').style.display = 'inline';
    }else{
    	//alert(3)
        document.getElementById('activity_classification_core').disabled=false;
  		  document.getElementById('div_activity_classification_core').style.display = 'inline';
                  document.getElementById('activity_classification_non_core').disabled=true;
                  document.getElementById('div_activity_classification_non_core').style.display = 'none';
    }
  }

  function set_action_plan_details_outcome(){
    //alert(document.getElementById('activity_status').value)
    if (document.getElementById('activity_status').value == 6044) {
        document.getElementById('action_plan_detail_outcome').style.display = 'inline';
    }else {
        if (document.getElementById('action_plan_detail_outcome') != null) {
          document.getElementById('action_plan_detail_outcome').style.display = 'none';
        };
    }
  }

  function set_frequency_menu(){
      if (document.getElementById('frequency_id').value == 2320) {
          document.getElementById('div_weekly').style.display = 'inline';
          document.getElementById('num_of_weeks').style.display = 'inline';
          document.getElementById('num_of_days').style.display = 'none';
          document.getElementById('div_duration').style.display = 'inline';
      }else {
        document.getElementById('div_weekly').style.display = 'none';
        //alert(1)
        if (document.getElementById('frequency_id').value == 2325) {
          document.getElementById('num_of_weeks').style.display = 'none';
          document.getElementById('num_of_days').style.display = 'inline';
          document.getElementById('div_duration').style.display = 'inline';
        }else {
          //document.getElementById('num_of_weeks').style.display = 'none';
          //document.getElementById('num_of_days').style.display = 'none';
          document.getElementById('div_duration').style.display = 'none';

        }
      }
  }

 // jQuery(function set_frequency_menu(){
 //      $('#frequency_id').change(function hide_or_show_components() {
 //        var options, selected_frequency_type;
 //        selected_frequency_type = $('#frequency_id :selected').attr('value');

 //        if (selected_frequency_type == 2320) {
 //          $('#div_weekly').show();
 //          $('#num_of_weeks').show();
 //          $('#num_of_days').hide();
 //          $('#div_duration').show();
 //        }else {
 //          $('#div_weekly').hide();
 //          //alert(1)
 //          if (selected_frequency_type == 2325) {
 //            $('#num_of_weeks').hide();
 //            $('#num_of_days').show();
 //            $('#div_duration').show();
 //          }else {
 //            $('#div_duration').hide();
 //          }
 //        }

 //      });


 //  });



jQuery(function() {
  var providers_list;
  providers_list = $('#activity_providers').html();
  return $('#activity_type').change(function() {
    var provider_options, selected_activity_type;
    selected_activity_type = $('#activity_type :selected').attr('value');
    // alert(selected_activity_type)

    provider_options = $(providers_list).filter("optgroup[label='" + selected_activity_type + "']").html();
    // alert(provider_options)

    if (provider_options) {
      $('#activity_providers').html(provider_options);
      return $("#activity_providers").prop("selectedIndex", -1);
    } else {
      return $('#activity_providers').empty();
    }

  });
});

jQuery(function() {
  var components_list;
  components_list = $('#activity_components').html();
  return $('#activity_type').change(function() {
    var options, selected_activity_type;
    selected_activity_type = $('#activity_type :selected').attr('value');

    options = $(components_list).filter("optgroup[label='" + selected_activity_type + "']").html();
    // alert("option: " + options)
    if (options) {
      $('#activity_components').html(options);
      return $("#activity_components").prop("selectedIndex", -1);
    } else {
      return $('#activity_components').empty();
    }

  });
});

jQuery(function() {
  var activity_types_list;
  activity_types_list = $('#activity_type').html();
  return $('#barrier_id').change(function() {
    var options, selected_barrier_id;
    selected_barrier_id = $('#barrier_id :selected').attr('value');

    options = $(activity_types_list).filter("optgroup[label='" + selected_barrier_id + "']").html();
    // alert("option: " + options)
    if (options) {
      $('#activity_type').html(options);
      return $("#activity_type").prop("selectedIndex", -1);
    } else {
      return $('#activity_type').empty();
      return $('#activity_components').empty();
    }

  });
});


$(function () {
    set_activity_types_dropdown();
    set_activity_components_dropdown(); //this calls it on load
    set_activity_providers_dropdown();
    onload_step2();
    // hide_or_show_components();
});

function set_activity_types_dropdown() {
  var components_list;
    activity_types_list = $('#activity_type').html();
  //alert(activity_types_list)
  if (activity_types_list != null) {
    var options, selected_barrier_id;
    selected_barrier_id = $('#barrier_id :selected').attr('value');
    //alert(selected_barrier_id)
    options = $(activity_types_list).filter("optgroup[label='" + selected_barrier_id + "']").html();
    if (options) {
      return $('#activity_type').html(options);
      //return $("#activity_components").prop("selectedIndex", -1);
    } else {
      return $('#activity_type').empty();
      return $('#activity_components').empty();
    }
  };
}

function set_activity_components_dropdown() {
  var components_list;
    components_list = $('#activity_components').html();
  //alert(components_list)
  if (components_list != null) {
    var options, selected_activity_type;
    selected_activity_type = $('#activity_type :selected').attr('value');
    //alert(selected_activity_type)
    options = $(components_list).filter("optgroup[label='" + selected_activity_type + "']").html();
    if (options) {
      return $('#activity_components').html(options);
      //return $("#activity_components").prop("selectedIndex", -1);
    } else {
      return $('#activity_components').empty();
    }
  };
}

function set_activity_providers_dropdown() {
  // alert("Manoj")
  var providers_list,all_providers_list;
  var options, selected_activity_type,filter_string;
  // all_providers_list will have all providers
  all_providers_list = $('#all_providers').html();
 // providers_list is used to filter contents
  providers_list = all_providers_list;

  // alert("Provider list")
  // alert(providers_list)
  // selected_activity_type = $('#activity_type :selected').attr('value');
  selected_activity_type = $('#action_plan_detail_activity_type :selected').attr('value');
  // alert(selected_activity_type)
  // if activity type in code table = 182 - "Services Types" - then show provider drop down
  if (selected_activity_type == "6362" || selected_activity_type == "6361" || selected_activity_type == "6722" || selected_activity_type == "6360" || selected_activity_type == "6359" || selected_activity_type == "6327" || selected_activity_type == "6326" || selected_activity_type == "6324" || selected_activity_type == "6323" || selected_activity_type == "6322" || selected_activity_type == "6321" || selected_activity_type == "6293" || selected_activity_type == "6292" || selected_activity_type == "6291" || selected_activity_type == "6290" || selected_activity_type == "6289" || selected_activity_type == "6287" || selected_activity_type == "6286" || selected_activity_type == "6285" || selected_activity_type == "6284")
  {
    document.getElementById('action_plan_detail_provider_div').style.display = 'inline';

    // filter provider dropdown for selected activity
      filter_string = "optgroup[label="+selected_activity_type+"]"
      options = $(providers_list).filter(filter_string).html();
      if (options) {
          return $('#activity_providers').html(options);
        }
      else
        {
            return $('#activity_providers').empty();
        }
  }
  else if (document.getElementById('action_plan_detail_provider_div') != null)
  {
    // make provider dropdown is invisible
    document.getElementById('action_plan_detail_provider_div').style.display = 'none';
    document.getElementById('activity_providers').value = null;
  }

}

function onload_step2() {
    // var warnings_count = $('#action_plan_detail_warning').val()
    if ($('#action_plan_detail_warning') != null) {
      if($('#action_plan_detail_warning').val() > 0) {
          $('#action_plan_detail_skip_warnings').show();
          $('#action_plan_detail_next').hide();
      } else {
          $('#action_plan_detail_skip_warnings').hide();
          $('#action_plan_detail_next').show();
      }
      $('#frequency_id').click(function(){
          $('#action_plan_detail_skip_warnings').hide();
          $('#action_plan_detail_next').show();
      });
      $('#action_plan_detail_hours_per_day').click(function(){
          $('#action_plan_detail_skip_warnings').hide();
          $('#action_plan_detail_next').show();
      });
      $('#div_weekly').click(function(){
          $('#action_plan_detail_skip_warnings').hide();
          $('#action_plan_detail_next').show();
      });
      $('#action_plan_detail_duration').click(function(){
          $('#action_plan_detail_skip_warnings').hide();
          $('#action_plan_detail_next').show();
      });
    };
}

function set_action_plan_detail_extension_button() {
    // var warnings_count = $('#action_plan_detail_warning').val()
    if ($('#action_plan_detail_extension_warning') != null) {
      if($('#action_plan_detail_extension_warning').val() > 0) {
          $('#action_plan_detail_extension_skip_warnings').show();
          $('#action_plan_detail_extension_save').hide();
      } else {
          $('#action_plan_detail_extension_skip_warnings').hide();
          $('#action_plan_detail_extension_save').show();
      }
      $('#action_plan_detail_extension_duration').click(function(){
          $('#action_plan_detail_extension_skip_warnings').hide();
          $('#action_plan_detail_extension_save').show();
      });
      $('#action_plan_detail_extension_reason').click(function(){
          $('#action_plan_detail_extension_skip_warnings').hide();
          $('#action_plan_detail_extension_save').show();
      });
    };
}
