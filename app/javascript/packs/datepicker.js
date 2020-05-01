function initDatePicker() {
  $('.new-datepicker').datepicker({
    format: 'yyyy-mm-dd',
    language: 'ru',
    todayHighlight: true,
    toggleActive: true,
    startDate: '2010-01-01',
    endDate: '+2y'
  }).on('changeDate', function(e) {
      $(this).closest('.input-date-field').find('input').val(e.date);
    });
}

function setDate() {
  $('.input-date-field').each(function(index, element) {
    var date = $(element).find('input').val();
    $(element).find('.new-datepicker').datepicker('setDate', date);
  });
}

$(window).on('turbolinks:load', function() {
  initDatePicker();
  setDate();
});
