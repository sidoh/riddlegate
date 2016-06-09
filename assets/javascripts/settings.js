$(function() {
  $('.setting-group').each(function() {
    var modeBtns = $('button', this);
    var modeField = $('input[name="settings[' + $(this).data('setting-field') + ']"]');
    var behaviorFields = $($(this).data('setting-group'));

    modeBtns.click(function() {
      modeBtns.removeClass('active');
      $(this).addClass('active');
      modeField.val($(this).data('value'));

      behaviorFields
        .show()
        .filter(function() {
          var modes = $(this).data('modes').split(' ');
          return $.inArray(modeField.val(), modes) == -1;
        })
        .hide();
    });

    modeBtns
      .filter(function() {
        return $(this).data('value') == modeField.val();
      })
      .click();
  });

  $('.field-help').each(function() {
    var elmt = $('<i></i>')
      .addClass('glyphicon glyphicon-question-sign')
      .tooltip({
        placement: 'top',
        title: $(this).data('help-text'),
        container: 'body'
      });
    $(this).append(elmt);
  });

  $('.bootstrap-switch').bootstrapSwitch();
});
