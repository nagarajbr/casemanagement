jQuery(function() {
  var school_names;
  school_names = $('#school_name').html();
  return $('#school_type').change(function() {
    var options, selected_school_type;
    selected_school_type = $('#school_type :selected').attr('value');

    options = $(school_names).filter("optgroup[label='" + selected_school_type + "']").html();
    // alert("option: " + options)
    if (options) {
      $('#school_name').html(options);
      return $("#school_name").prop("selectedIndex", -1);
    } else {
      return $('#school_name').empty();
    }

  });
});

function set_school_names_dropdown() {
  var school_names;
    school_names = $('#school_name').html();
  //alert(school_names)
  if (school_names != null) {
    var options, selected_school_type;
    selected_school_type = $('#school_type :selected').attr('value');
    //alert(selected_school_type)
    options = $(school_names).filter("optgroup[label='" + selected_school_type + "']").html();
    if (options) {
      return $('#school_name').html(options);
      //return $("#school_type").prop("selectedIndex", -1);
    } else {
      return $('#school_name').empty();
    }
  };
}

$(function () {
  set_school_names_dropdown(); //this calls it on load
});











jQuery(function() {
  var school_names;
  school_names = $('#high_grade_level').html();
  return $('#school_type').change(function() {
    var options, selected_school_type;
    selected_school_type = $('#school_type :selected').attr('value');

    options = $(school_names).filter("optgroup[label='" + selected_school_type + "']").html();
    // alert("option: " + options)
    if (options) {
      $('#high_grade_level').html(options);
      return $("#high_grade_level").prop("selectedIndex", -1);
    } else {
      return $('#high_grade_level').empty();
    }

  });
});

function set_high_grade_level_dropdown() {
  var school_names;
    school_names = $('#high_grade_level').html();
  //alert(school_names)
  if (school_names != null) {
    var options, selected_school_type;
    selected_school_type = $('#school_type :selected').attr('value');
    //alert(selected_school_type)
    options = $(school_names).filter("optgroup[label='" + selected_school_type + "']").html();
    if (options) {
      return $('#high_grade_level').html(options);
      //return $("#school_type").prop("selectedIndex", -1);
    } else {
      return $('#high_grade_level').empty();
    }
  };
}

$(function () {
  set_high_grade_level_dropdown(); //this calls it on load
});




