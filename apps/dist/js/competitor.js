const colors = ["#FFFF00", "#F7931E", "#00FF00", "#009245", "#00FFFF", "#0000FF", "#93278F", "#FF0000", "#8C6239", "#CCCCCC"];
var interval = "monthly";
var mydatasets = [];
var topRangking = [];
var userIG = "";

$(document).ready(function() {
	Chart.defaults.global.legend.display = false;
    Chart.defaults.global.defaultFontColor = 'white';
	Chart.defaults.global.elements.line.tension = 0;
	Chart.defaults.global.elements.line.borderWidth = 2;
	Chart.defaults.global.elements.point.radius = 2;
	
	interval = $( ".content" ).attr( "interval" );
	userIG = $( "#userIG" ).text();

	const today = new Date();
	
	createEmptyLineChart();
	initTopRangking( today.getFullYear(), today.getMonth() + 1 );
	initTopFAIR( today.getFullYear(), today.getMonth() + 1 );

	if (interval == 'daily') initMonthPicker();
	else initYearPicker();
});

function initTopRangking(year, month) {
	$( ".box-top-rangking ul" ).html("");
	$( ".box-top-rangking .loading" ).css( "display", "flex" );
	$( ".msg-not-counted" ).hide();
	$( ".box-fair-score .dropdown-toggle" ).hide();

	$.get( "./api_top_rangking", { interval, year, month }, function(result, status) {
		if ($.isArray(result) && result.length) {

			result.forEach(row => {
				$( ".box-top-rangking ul" ).append(
					'<a href="https://www.instagram.com/' + row.ig_username + '" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">'
						+ '<li class="item">'
							+ '<div class="product-img">'
								+ '<img src="'+ BASE_URL +'/dist/image/bintang.svg" alt="" style="height: 32px; width: 32px;" />'
							+ '</div>'
							+ '<div class="product-score h4" style="float: right; height: 32px; width: 45px; margin: 0; text-align: right; line-height: 32px; font-weight: bold;">'
								+ (row.total_score ? parseFloat(row.total_score).toFixed(2) : '-')
							+ '</div>'
							+ '<div class="product-info" style="margin-left: 44px;">'
								+ '<span class="product-title" style="font-weight: normal;">'+ row.ig_username +'</span>'
								+ '<span class="product-description" style="font-size: 10px; line-height: 11px; color: #15b4c3;">https://www.instagram.com/'+ row.ig_username +'</span>'
							+ '</div>'
						+ '</li>'
					+ '</a>'
				);
			});

			topRangking = result;
			initSelectOptions();
			initLineChart(year, month);
		}
		else {
			$( ".msg-not-counted" ).show();
		}

		$( ".box-top-rangking .loading" ).hide();
	});
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
			initTopRangking( selectedDate.getFullYear(), selectedDate.getMonth() + 1 );
			initTopFAIR( selectedDate.getFullYear(), selectedDate.getMonth() + 1 );
		}
	});
}

function initYearPicker() {
	$( "#dropdown-year .dropdown-menu a" ).click( function(event) {
		$( "#dropdown-year .dropdown-menu a" ).removeClass( "selected" );
		$( this ).addClass( "selected" );
		
		const year = event.target.text;
		// initLineChart(year);
		initTopRangking(year);
		initTopFAIR(year);
	});
}

function createEmptyLineChart() {
	var ctx = document.getElementById('chart').getContext('2d');
	var labels = interval.toLowerCase() == "daily" ? [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31] : ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
	var options = {
		responsive: true,
		maintainAspectRatio : false,
		tooltips: {
			position: 'nearest',
			mode: 'index',
			intersect: false,
			callbacks: {
				title: function(tooltipItem, obj) {
					if (interval == "daily") return 'Day ' + tooltipItem[0].label;
					else return tooltipItem[0].label;
				}
			}
		},
		hover: {
			mode: 'nearest',
			intersect: false
		}
	}

	mydatasets = [];

	window.lineChart = new Chart(ctx, {
		type: 'line',
		data: { labels: labels, datasets: mydatasets },
		options: options
	});
}

function initLineChart(year, month) {
	mydatasets = [];
	window.lineChart.data.datasets = mydatasets;

	topRangking.forEach((row, index) => {
		mydatasets.push({
			label : row.ig_username,
			backgroundColor: colors[index] ? colors[index] : '#FFFFFF',
			borderColor: colors[index] ? colors[index] : '#FFFFFF',
			data: [],
			fill: false,
			hidden: (index > 4 && row.ig_username != userIG) ? true : false
		});

		$.get( "./api_history_target", { id_target: row.id_target, interval: interval,  year, month }, function(result, status) {
			mydatasets[index].data = result;
			window.lineChart.update();
		});
	});

	window.lineChart.update();
}

// function refreshChart(year, month) {
// 	topRangking.forEach((row, index) => {
// 		datasets[index].data = [];
// 		$.get( "./api_history_target", { id_target: row.id_target, interval, year, month }, function(result, status) {
// 			datasets[index].data = result;
// 			window.lineChart.update();
// 		});
// 	});
// }

function initTopFAIR(year, month) {
	$( ".box-follower .slim-scroll" ).html( "" );
	$( ".box-activity .slim-scroll" ).html( "" );
	$( ".box-interaction .slim-scroll" ).html( "" );
	$( ".box-responsiveness .slim-scroll" ).html( "" );

	//#region Follower
	$.get( "./api_top_follower", { interval: interval, year, month } , function(result, status) {
		if ($.isArray(result) && result.length) {
			var maxFollower = result[0].total_follower;
			result.forEach(target => {
				$( ".box-follower .slim-scroll" ).append(
					'<div class="box-keyword">'
						+ '<div class="keyword">'+ target.ig_username +'</div>'
						+ '<table>'
							+ '<tr>'
								+ '<td class="progress progress-flat">'
									+ '<div class="progress-bar" style="width: '+ Math.round(target.total_follower / maxFollower * 100) +'%; background-color: #0ED1D6;"></div>'
								+ '</td>'
								+ '<td class="value-keyword">'
									+ floatToShort(target.total_follower)
								+ '</td>'
							+ '</tr>'
						+ '</table>'
					+ '</div>'
				);
			});
		}
	});
	//#endregion
	
	//#region Activity
	$.get( "./api_top_activity", { interval: interval, year, month }, function(result, status) {
		if ($.isArray(result) && result.length) {
			var max = result[0].total_content;
			result.forEach(target => {
				$( ".box-activity .slim-scroll" ).append(
					'<div class="box-keyword">'
						+ '<div class="keyword">'+ target.ig_username +'</div>'
						+ '<table>'
							+ '<tr>'
								+ '<td class="progress progress-flat">'
									+ '<div class="progress-bar" style="width: '+ Math.round(target.total_content / max * 100) +'%; background-color: #D58F51;"></div>'
								+ '</td>'
								+ '<td class="value-keyword">'
									+ floatToShort(target.total_content, 1, "/day")
								+ '</td>'
							+ '</tr>'
						+ '</table>'
					+ '</div>'
				);
			});
		}
	});
	//#endregion
	
	//#region Interaction
	$.get( "./api_top_interaction", { interval: interval, year, month }, function(result, status) {
		if ($.isArray(result) && result.length) {
			var max = result[0].interaction;
			result.forEach(target => {
				$( ".box-interaction .slim-scroll" ).append(
					'<div class="box-keyword">'
						+ '<div class="keyword">'+ target.ig_username +'</div>'
						+ '<table>'
							+ '<tr>'
								+ '<td class="progress progress-flat">'
									+ '<div class="progress-bar" style="width: '+ Math.round(target.interaction / max * 100) +'%; background-color: #603CD6;"></div>'
								+ '</td>'
								+ '<td class="value-keyword">'
									+ floatToShort(target.interaction, 1, "/Post")
								+ '</td>'
							+ '</tr>'
						+ '</table>'
					+ '</div>'
				);
			});
		}
	});
	//#endregion
	
	//#region Responsiveness
	$.get( "./api_top_responsiveness", { interval: interval, year, month }, function(result, status) {
		if ($.isArray(result) && result.length) {
			var max = result[0].responsiveness;
			result.forEach(target => {
				$( ".box-responsiveness .slim-scroll" ).append(
					'<div class="box-keyword">'
						+ '<div class="keyword">'+ target.ig_username +'</div>'
						+ '<table>'
							+ '<tr>'
								+ '<td class="progress progress-flat">'
									+ '<div class="progress-bar" style="width: '+ Math.round(target.responsiveness / max * 100) +'%; background-color: #EB5757;"></div>'
								+ '</td>'
								+ '<td class="value-keyword">'
									+ floatToShort(target.responsiveness, 2, "%")
								+ '</td>'
							+ '</tr>'
						+ '</table>'
					+ '</div>'
				);
			});
		}
	});
	//#endregion
}