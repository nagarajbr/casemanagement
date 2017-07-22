jQuery ->
  school_names = $('#education_school_name').html()

  $('#education_school_type').change ->
    school_type = $('#education_school_type :selected').text()

    options = $(school_names).filter("optgroup[label='#{school_type}']").html()

    if options
      $('#education_school_name').html(options)
      $("#education_school_name").prop("selectedIndex", -1)
    else
      $('#education_school_name').empty()
