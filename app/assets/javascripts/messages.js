// to get quote from api using ajax
$(window).on('load', function() {
  $.ajax({
    type: 'GET',
    url: 'https://talaikis.com/api/quotes/random/',
    dataType: 'json',
    async: true,
    success: function(json) {
      $('#quote').html('<q>' + json.quote + '</q>');
      $('#author').html('by ' + json.author);
      $('#quoteBlock').append('<hr>');
    }
  });
});
// end