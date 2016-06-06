$(function() {
  $('#logs .show-metadata').click(function() {
    $('.metadata', $(this).closest('.log-item')).fadeToggle();
  });
});
