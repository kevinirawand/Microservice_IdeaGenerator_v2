$(document).ready(function() {
	$( "#form" ).submit(function( event ) {
        console.log($( this ).serialize());
        $.post('./report/fair_report', $( this ).serialize(), function( data ) {
            console.log(data);

            var wb = XLSX.utils.book_new();
            wb.SheetNames = ["F", "A", "I", "R"];

            wb.Sheets["F"] = XLSX.utils.json_to_sheet(data.F);
            wb.Sheets["A"] = XLSX.utils.json_to_sheet(data.A);
            wb.Sheets["I"] = XLSX.utils.json_to_sheet(data.I);
            wb.Sheets["R"] = XLSX.utils.json_to_sheet(data.R);

            var date = new Date();
            XLSX.writeFile(wb, 'igreport-' + data.user.ig_username + '-' + date.getFullYear() + ("0" + (date.getMonth() + 1)).slice(-2) + ("0" + date.getDate()).slice(-2) + '.xlsx');
        });
        event.preventDefault();
    });
});