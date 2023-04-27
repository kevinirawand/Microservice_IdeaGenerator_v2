const colors = ["#FFFF00", "#F7931E", "#00FF00", "#009245", "#00FFFF", "#0000FF", "#93278F", "#FF0000", "#8C6239", "#CCCCCC", "#5000FF", "#43278F", "#2C62FF", "#FFFFFF", "#1CCCCC"];
const COLUMN_TOP_LEAST = [{data: 'name', title: "Name"}, {data: 'bidang', title: "Sector"}, {data: 'like_count', width: '30px', orderable: false, render: function ( data, type, row ) {
	return '<span><i class="fas fa-heart"></i></span> ' + data;
}}, {data: 'comment_count', width: '30px', orderable: false, render: function ( data, type, row ) {
	return '<span><i class="fas fa-comment"></i></span> ' + data;
}}];

var interval = "daily";
var mydatasets = [];
var topRangking = [];
var userIG = "";
var tableList, tableTop, tableLeast;

$(document).ready(function() {
	Chart.defaults.global.legend.display = false;
    Chart.defaults.global.defaultFontColor = 'white';
	Chart.defaults.global.elements.line.tension = 0;
	Chart.defaults.global.elements.line.borderWidth = 2;
	Chart.defaults.global.elements.point.radius = 2;
	
	interval = $( ".content" ).attr( "interval" );
	userIG = $( "#userIG" ).text();

	// const today = new Date();
	const yesterday = new Date(new Date().setDate(new Date().getDate() - 1));

	// createEmptyLineChart();

	// initAll(today.getFullYear(), today.getMonth() + 1, today.getDate()-1);
	initAll(yesterday.getFullYear(), yesterday.getMonth() + 1, yesterday.getDate());
	
	if(interval == 'daily') {
		initMonthPicker();
	} else {
		initYearPicker();
	}
});

async function initAll(year, month, day) {
	await api_detail_get_content_and_response(year, month, day); // -1 is yesterday
	await api_detail_get_like_and_comment(year, month, day); // -1 is yesterday

	initBar();
	await api_get_sector_bar(year, month, day);
		
	await api_top_contributor(year, month, day); // -1 is yesterday
	await api_least_contributor(year, month, day); // -1 is yesterday

	api_all_contributor_urgent(year, month, day);
	

	// api_get_like_line(year, month, day); // -1 is yesterday
	// api_top_sector(year, month, day); // -1 is yesterday

}

function searchKeyUp(ev) {
	var sku = $(ev);
	if(tableList && tableTop && tableLeast) {
		var val = sku.val();
		tableList.search(val).draw();
		tableTop.search(val).draw();
		tableLeast.search(val).draw();
	}
}

async function api_detail_get_content_and_response(year, month, day) {
	var result = await $.get( "./api_detail_get_content_and_response", { interval, year, month, day });
	if ($.isArray(result) && result.length) {
			const dcr = result[0];
			$("#detail_content_count").text(dcr.post_count ? dcr.post_count : 0);
			$("#detail_respon_avg").html(dcr.respon_avg ? Math.round(dcr.respon_avg) + " <small>%</small>" : 0 + " <small>%</small>");
		}
		else {
			$( ".msg-not-counted" ).show();
		}

		$( ".box-top-rangking .loading" ).hide();
}

async function api_detail_get_like_and_comment(year, month, day) {
	var result = await $.get( "./api_detail_get_like_and_comment", { interval, year, month, day });
	if ($.isArray(result) && result.length) {
			const dlc = result[0];
			$("#detail_like_count").text(dlc.like_count ? dlc.like_count : 0);
			$("#detail_comment_count").text(dlc.comment_count ? dlc.comment_count : 0);
		}
		else {
			$( ".msg-not-counted" ).show();
		}

		$( ".box-top-rangking .loading" ).hide();
}

function all_contributor_urgent_generate(result) {

		if ($.isArray(result) && result.length) {

			const buttonCommon = {
        exportOptions: {
            format: {
                header: function ( data, column) {
                	if(column === 2) {
                		data = "Like";
                	} else if(column === 3) {
                		data = "Comment"
                	}
                	return data;
                }
            }
        }
    	};

    	if(!tableList) {
    		tableList = $('#table-list').DataTable({
					pageLength: result.length,
					bLengthChange: true,
					paging: false,
					info: false,
					data: result,
					order: [[2, 'desc']],
					columns: COLUMN_TOP_LEAST,
					dom: 'Bfrtip',
					buttons: [
						// 'excel'
						$.extend( true, {}, buttonCommon, {
							text: "Export Excel",
	            extend: 'excelHtml5'
	          } ),
					]
				});
    	} else {
    		tableList.clear();
    		tableList.rows.add(result);
    		tableList.draw();
    	}
		}
		else {
			$( ".msg-not-counted" ).show();
		}

		$( ".box-list-contributor .loading" ).hide();
	
}

async function api_all_contributor_urgent(year, month, day) {
	$( ".box-list-contributor ul" ).html("");
	$( ".box-list-contributor .loading" ).css( "display", "flex" );

	var data = await $.get( "./api_get_all_contributor_id" );

	var result = [];

	for (var i = 0; i < data.length; i++) {
		var contributor_id = data[i].contributor_id;
		var r = await $.get( "./api_get_all_contributor_urgent", { interval, year, month, day, contributor_id });
		if(r && r.length > 0) {
			result.push(r[0]);
		}
		all_contributor_urgent_generate(result);
	}
}

function api_all_contributor(year, month, day) {
	$( ".box-list-contributor ul" ).html("");
	$( ".box-list-contributor .loading" ).css( "display", "flex" );

	$.get( "./api_get_all_contributor", { interval, year, month, day }, function(result, status) {
		if ($.isArray(result) && result.length) {

			const buttonCommon = {
        exportOptions: {
            format: {
                header: function ( data, column) {
                	if(column === 2) {
                		data = "Like";
                	} else if(column === 3) {
                		data = "Comment"
                	}
                	return data;
                }
            }
        }
    	};

			tableList = $('#table-list').DataTable({
				pageLength: result.length,
				bLengthChange: true,
				paging: false,
				info: false,
				data: result,
				order: [[2, 'desc']],
				columns: COLUMN_TOP_LEAST,
				dom: 'Bfrtip',
				buttons: [
					// 'excel'
					$.extend( true, {}, buttonCommon, {
						text: "Export Excel",
            extend: 'excelHtml5'
          } ),
				]
			});
		}
		else {
			$( ".msg-not-counted" ).show();
		}

		$( ".box-list-contributor .loading" ).hide();
	});
}

async function api_top_contributor(year, month, day) {
	$( ".box-top-rangking ul" ).html("");
	$( ".box-top-rangking .loading" ).css( "display", "flex" );

	var result = await $.get( "./api_get_top_contributor", { interval, year, month, day } );
	if ($.isArray(result) && result.length) {
			result = result.filter(d=>{
				if(!isNaN(d.like_count) && Number(d.like_count) > 0) {
					return d;
				}
			});

			tableTop = $('#table-top').DataTable({
				pageLength: result.length,
				bLengthChange: false,
				paging: false,
				info: false,
				data: result,
				order: [[2, 'desc']],
				columns: COLUMN_TOP_LEAST
			});
		}
		else {
			$( ".msg-not-counted" ).show();
		}

		$( ".box-top-rangking .loading" ).hide();
}

async function api_least_contributor(year, month, day) {
	$( ".box-least-rangking ul" ).html("");
	$( ".box-least-rangking .loading" ).css( "display", "flex" );

	var result = await $.get( "./api_get_zero_contributor", { interval, year, month, day } );
	if ($.isArray(result) && result.length) {
			result.map(item=>{
				item.like_count = 0;
				item.comment_count = 0;
				return item;
			});
			tableLeast = $('#table-least').DataTable({
				pageLength: result.length,
				bLengthChange: false,
				paging: false,
				info: false,
				data: result,
				columns: COLUMN_TOP_LEAST
			});
		}
		else {

			// START Least
			$.get( "./api_get_least_contributor", { interval, year, month, day }, function(result, status) {
				if ($.isArray(result) && result.length) {
					result.map(item=>{
						item.like_count = 0;
						item.comment_count = 0;
						return item;
					});
					tableLeast = $('#table-least').DataTable({
						pageLength: result.length,
						bLengthChange: false,
						paging: false,
						info: false,
						data: result,
						columns: COLUMN_TOP_LEAST
					});
				}
				else {
			
					$( ".msg-not-counted" ).show();
				}
			});
			// END Least

		}

		$( ".box-least-rangking .loading" ).hide();
}

async function api_get_sector_bar(year, month, day) {
	mydatasets = [];
	$( ".box-top-sector .loading" ).css( "display", "flex" );
	$( ".msg-not-counted" ).hide();

	var result  = await $.get( "./api_get_rank_sector", { interval, year, month, day } );
	if ($.isArray(result) && result.length) {
			var dataBar = [];
			var dataLabels = [];
			result.map(item=>{
				let percentage = (item.like_count/(item.user_count*item.post_count))*100;
				item.percentage = Math.round(percentage);
				dataLabels.push(item.singkatan);
				dataBar.push(item.percentage);
				return item;
			});
			generateBar(dataBar, dataLabels);
		}
		else {
			generateBar([0]);
			$( ".msg-not-counted" ).show();
		}

		$( ".box-top-sector .loading" ).hide();
}

function initBar() {
	var ctx = document.getElementById('chart-sector').getContext('2d');
	// var labels = ['AKTA', 'ILMATE', 'PDN', 'PK', 'PLN', 'SEKRE', 'AGRO BDG', 'AMDK CRB', 'KTG BGR', 'LE KRW', 'INLOG', 'IPOK'];
	var labels = ['Data'];
	var options = {
		responsive: true,
    maintainAspectRatio : false,
		tooltips: {
      callbacks: {
        label: function(tooltipItem, data) {
          return tooltipItem.yLabel + '%';
        }
      }
		},
		scales: {
			yAxes: [{
                ticks: {
                    suggestedMin: 0,
                    suggestedMax: 100,
                    callback: function(value, index, values) {
                        return value + "%";
                    }
                }
            }]
		}
	};
	var dataBar = [0];
	
	datasets = [{
		label: 'Value',
		data: dataBar
	}];
	
	window.lineChart = new Chart(ctx, {
		type: 'bar',
		data: { labels: labels, datasets: datasets },
		options: options
	});
}

function generateBar(data, labels) {
	var colorBar = [];
	for (var i = 0; i < data.length; i++) {
		colorBar[i] = colors[i];
	}
	var barDataset = [{
		label: 'Value',
		data: data,
		backgroundColor: colorBar
	}];
	window.lineChart.data.labels = labels;
	window.lineChart.data.datasets = barDataset;
	window.lineChart.update();
}

function api_get_like_line(year, month) {
	mydatasets = [];
	$( ".box-top-rangking .loading" ).css( "display", "flex" );
	$( ".msg-not-counted" ).hide();

	$.get( "./api_get_like_line", { interval, year, month }, function(result, status) {
		if ($.isArray(result) && result.length) {
			// initSelectOptions();
			generateLine(result);
			api_get_comment_line(year, month);
		}
		else {
			generateLine([{type_time:0, type_count:0}]);
			$( ".msg-not-counted" ).show();
		}

		$( ".box-top-rangking .loading" ).hide();


	});
}

function api_get_comment_line(year, month) {
	$.get( "./api_get_comment_line", { interval, year, month }, function(result, status) {
		if ($.isArray(result) && result.length) {
			generateLine(result, false);
		}
		else {
			generateLine([{type_time:0, type_count:0}]);
			$( ".msg-not-counted" ).show();
		}
	});
}

function generateLine(data, isLike=true) {
	if(isLike) {
		var likeC = 0;
	}
	var dataLine = [];
	var limitCount = 31;
	labels = [];
	if(interval == 'weekly') {
		limitCount = data.length;
		for (let index = 0; index < data.length; index++) {
			labels.push(index+1);
		}
	} else if(interval == 'monthly') {
		limitCount = 12;
	}
	for(var i = 0; i < limitCount; i++) {
		var d = [];
		if(interval == 'monthly') {
			d = data.filter(x=>Number(x.type_time) == i);
		} else {
			d = data.filter(x=>Number(x.type_time) == (i+1));
		}
		var lc = d.length > 0 ? Number(d[0].type_count) : 0;
		dataLine[i] = lc;
		if(isLike) {
			likeC += lc;
		}
	}

	indx = mydatasets.length;
	mydatasets.push({
		label : isLike ? "Like" : "Comment",
		backgroundColor: colors[indx] ? colors[indx] : '#FFFFFF',
		borderColor: colors[indx] ? colors[indx] : '#FFFFFF',
		data: dataLine,
		fill: false
	});
	window.lineChart.data.datasets = mydatasets;
	if(interval == 'weekly') {
		window.lineChart.data.labels = labels.reverse();
	}
	window.lineChart.update();

	// assign total like
	if(isLike){
		$("#title_like_count").text(likeC);
	}
}

function initSelectOptions() {
	$( "#dropdown-competitors .dropdown-menu" ).html( "" );

	topRangking.forEach((row, index) => {
		$( "#dropdown-competitors .dropdown-menu" ).append(
			'<li>'
				+ '<a href="#" title="'+ row.ig_username +'" class="'+ ((index > 4 && row.ig_username != userIG) ? 'disabled' : '' ) +'">' 
					+ '<span class="fa fa-square" style="color: '+ colors[index] +'"></span>'
					+ row.ig_username
				+ '</a>'
			+ '</li>'
		);
	});

	$( "#dropdown-competitors .dropdown-menu a" ).click( function(event) {
		var ig_username = $( this ).attr( "title" );

		if ( this.classList.contains( "disabled" ) ) {
			$( this ).removeClass( "disabled" );
			mydatasets.find(dataset => dataset.label == ig_username).hidden = false;
		}
		else {
			$( this ).addClass( "disabled" );
			mydatasets.find(dataset => dataset.label == ig_username).hidden = true;
		}
		window.lineChart.update();
	});

	$( ".box-fair-score .dropdown-toggle" ).show();

	$(document).on('click', '#dropdown-competitors .dropdown-menu', function (e) {
		e.stopPropagation();
	});
}

function initMonthPicker() {
	$( "#month-picker input" ).MonthPicker({ 
		Button: '<button type="button" class="btn btn-sm text-bold">Data Records &nbsp; <i class="fa fa-caret-down"></i></button>',
		MaxMonth: 0,
		MinMonth: '-9y',
		SelectedMonth: 0,
		Position: {
			my: 'right top+2', 
			at: 'right bottom', 
			collision: 'flip',
			of: $( "#month-picker" )
		},
		OnAfterChooseMonth: function( selectedDate ) {
			initAll(selectedDate.getFullYear(), selectedDate.getMonth() + 1)
			// initTopRangking( selectedDate.getFullYear(), selectedDate.getMonth() + 1 );
			// initTopFAIR( selectedDate.getFullYear(), selectedDate.getMonth() + 1 );
		}
	});
}

function initYearPicker() {
	$( "#dropdown-year .dropdown-menu a" ).click( function(event) {
		$( "#dropdown-year .dropdown-menu a" ).removeClass( "selected" );
		$( this ).addClass( "selected" );
		
		const year = event.target.text;
		initAll(year);
	});
}

// function createEmptyLineChart() {
// 	var ctx = document.getElementById('chart').getContext('2d');
// 	var labels =  [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
// 	if(interval.toLowerCase() == "weekly") {
// 		labels = [1,2,3,4];
// 	} else if(interval.toLowerCase() == "monthly") {
// 		labels = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
// 	}

// 	var options = {
// 		responsive: true,
// 		maintainAspectRatio : false,
// 		tooltips: {
// 			position: 'nearest',
// 			mode: 'index',
// 			intersect: false,
// 			callbacks: {
// 				title: function(tooltipItem, obj) {
// 					if (interval == "daily") return 'Day ' + tooltipItem[0].label;
// 					else return tooltipItem[0].label;
// 				}
// 			}
// 		},
// 		hover: {
// 			mode: 'nearest',
// 			intersect: false
// 		}
// 	}

// 	mydatasets = [];

// 	window.lineChart = new Chart(ctx, {
// 		type: 'line',
// 		data: { labels: labels, datasets: mydatasets },
// 		options: options
// 	});
// }
