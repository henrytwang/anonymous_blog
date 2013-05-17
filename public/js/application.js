$(document).ready(function() {
  var all_posts = $('.post').filter(":even");
  all_posts.each(function(){
    console.log(this)
    $(this).addClass("even_post")
  });

  var all_tags = $('.tag').filter(":even");
  all_tags.each(function(){
    console.log(this)
    $(this).addClass("even_tag")
  });

  $(function(){
  $('.items').masonry({
  itemSelector: '.item'
  });




});

});
