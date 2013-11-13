$(document).ready(function() {

  $('#form_id').on('submit', function(e) {
    e.preventDefault()
    textTweet = $('#text_id').val()
    $.ajax({
      url: '/tweet_time',
      type: 'post',
      data: {"tweet": textTweet}
    }).done($('#text_id').val(""))
    

  })


  // This is called after the document has loaded in its entirety
  // This guarantees that any elements we bind to will exist on the page
  // when we try to bind to them

  // See: http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
});
