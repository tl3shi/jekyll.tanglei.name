(function(){

    var totop = '[data-toggle="totop"]';
    var documentHeight = $(document).height();
    var windowHeight = $(window).height();

    var ToTop = function (element) {
        $(element).on('click',totop,this.toTop());
    }



    ToTop.prototype.toTop = function(e){
        $('html, body').animate({scrollTop:0},200);
    }


    if(documentHeight > windowHeight){
        $(totop).show();
    }else{
       $(totop).hide();
    }

    $(document).on('click.totop.data-api', totop, ToTop.prototype.toTop);


    function displayTagClouds(limit_count) {
        var limit = limit_count | 50;
        var data = $('#tag-values').val(); 
        if (data) {
            var array = '[' + data + ']';
            var objs = JSON.parse(array);
            var sorted = objs.sort(function(a, b){
                return b.count - a.count;
            });
            var tag = $('#tag-value');
            var prefix = tag.prop('href');
            $.each(sorted.slice(0, limit), function(index, value){
                var clone_tag = tag.clone();
                clone_tag.prop('href', prefix + value.name);
                clone_tag.attr('data-target-cate', '#' + value.name);
                var inner = value.name + '<span class="count">[' + value.count + ']</span>';
                clone_tag.html(inner);
                $(clone_tag).appendTo($('.tag-values-container'));
            });
        }
    }

    displayTagClouds(50);
}());
