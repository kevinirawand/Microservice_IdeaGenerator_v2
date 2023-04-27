$(document).ready(function() {
    $( ".pattern-panel-day-content a" ).on( "click", function( event ) {
        event.preventDefault();

        var keyword = $(this).children( "li" ).text();
        var dow = $(this).attr( "dow" );
        var id_label = $(this).attr( "id_label" );

        loadSourceKeyword(keyword, dow, id_label);
    });
});

function loadSourceKeyword(keyword, dow, id_label) {
    $( ".pattern-panel-source .row" ).empty();
    $( ".pattern-panel-source .loading" ).css( "display", "flex" );
    $( ".pattern-source-header h3 span" ).text(
        $( ".pattern-panel-day h4" ).eq( dow - 1 ).text()
    );

    $.get( window.location.pathname + "/api_get_source", {

        keyword: keyword,
        dow: dow,
        id_label: id_label,

    }, function( data ) {

        if (data.length) {
            data.forEach( function(item, i) {
                $( ".pattern-panel-source .row" ).append(
                    '<div class="col-md-4">'
                    + '<div>'
                    + '<img src="'+ BASE_URL + 'dist/image/instagram.svg" alt="" style="height: 25px; width: 25px;" />'
                    + '<div>'
                    + '<a href="'+ item['url'] +'" target="_blank">'+ item['url'] +'</a>'
                    + '</div>'
                    + '</div>'
                    + '</div>'
                );
            });
        }
        $( ".pattern-panel-source .loading" ).hide();
        
    });
}
