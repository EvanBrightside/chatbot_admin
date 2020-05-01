import 'jquery-datetimepicker/build/jquery.datetimepicker.full.min';

$(window).on('turbolinks:load', function() {
  jQuery.datetimepicker.setLocale('ru');

  $('#custom_datetimepicker').datetimepicker({
    step: 15,
    inline: true
  });
});
