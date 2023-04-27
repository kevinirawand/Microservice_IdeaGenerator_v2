$( function() {
    
    $( "#popup-dialog" ).dialog({
        autoOpen: true,
        resizable: false,
        draggable: false,

        width: 600,
        closeText: "hide",

        show: {
            effect: "drop",
            direction: "right",
            duration: 1000
        },

        position: { 
            my: "right-15 top+15", 
            at: "right top", 
            of: $( ".content-wrapper" ) 
        }
    });

});