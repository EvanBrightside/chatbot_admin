// Отображение полей в завиисимости от выбранной опции в селекте

// $(function() {
  function toggleFields() {
    $('.toggle-fields').each(function() {
      var selected = $(this).val(),
          root = $(this).closest('.toggle-fields-container').first();

      if (selected) {
        root.find('.options__item').hide();
        root.find('.options__item').each(function() {
          var types = $(this).data('type').split(' ');
          if ($.inArray(selected, types) != -1) {
            $(this).show();
          }
        });
      }
    });
  }

  function initToggleFields() {
    $(document).on('change', '.toggle-fields', function(e) {
      toggleFields();
    });

    $(document).on('cocoon:after-insert', function() {
      toggleFields();
    });
  }

  $(window).on('turbolinks:load', function() {
    toggleFields();
    initToggleFields();
  });
// });
