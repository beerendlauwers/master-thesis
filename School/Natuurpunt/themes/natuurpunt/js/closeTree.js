(function ($) {

     $(window).load(function(){
     
        // Hide content border if there are other content divs
        if ($("#topleftcontent").length > 0){
            $("#content").css("border", "solid 2px white");
        }
     
        // Wrap <a> tags in a temporary class to find them more easily
        $(".menu-block-wrapper").find('li > a[href*="taxonomy/term"]').wrap('<div class="temporaryclass" />');

        // Replace <a> tags with just their contents
        $('.temporaryclass').replaceWith(function() {
          var link =  $(this).find('a');
          return link.contents();
        });
        
        // Absolute path for images
        var absolutepathimages = "http://" + document.location.host + "/natuurpunt/themes/natuurpunt/images/";

        // Add <img> tags
        $(".menu-block-wrapper").find('li').not('.leaf').prepend('<img src="' + absolutepathimages + 'bullet_right.png"/>');

        // Add clicking functionality to images
        $(".menu-block-wrapper").find('li').not('.leaf > img').click(
                function(event) {
            $('ul', this).first().toggle();

           var ul = $('ul', this).first();
           
        if (ul.is(":hidden")) {
               $('img', this).first().attr( "src", absolutepathimages + "bullet_right.png" );
            } else {
               $('img', this).first().attr( "src", absolutepathimages + "bullet_down.png" );
            }

            event.stopPropagation();
              });

        // Hide entire structure
        $(".menu-block-wrapper").find("ul").find("ul").hide();
        
        // Expand structure based on current page
        $(".menu-block-wrapper").find("ul > li.active").find("ul").show().end().parents().show();

        // Update expand/close images to correct stance
        $(".menu-block-wrapper").find('li').not('.leaf').each( function() {
            
        var ul = $('ul', this).first();

        if (ul.is(":hidden")) {
               $('img', this).first().attr( "src", absolutepathimages + "bullet_right.png" );
            } else {
               $('img', this).first().attr( "src", absolutepathimages + "bullet_down.png" );
            }
        });

        
    });

})(jQuery);
