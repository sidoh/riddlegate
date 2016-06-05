$(function() {
  var modeBtns = $('#settings .btn-group.mode button');
  var modeField = $('input[name="settings[mode]"]');
  var behaviorFields = $('#behavior-fields .behavior-field');
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

  var securityField = $('input[name="settings[security_enabled]"]');
  securityField.on('switchChange.bootstrapSwitch',
    function(e, state) {
      if ($(this).is(':checked')) {
        $('#security-settings').fadeIn();
      } else {
        $('#security-settings').fadeOut();
      }
    }
  );
  securityField.trigger('switchChange.bootstrapSwitch');

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
