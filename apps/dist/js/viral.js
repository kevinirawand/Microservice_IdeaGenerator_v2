var keywords_offset = [0,0,0,0,0,0];
var top_keywords = [null, null, null, null, null, null];
var interval = 30;
var category = "";
var datasets = [];

function initChart() {
	var ctx = document.getElementById('chart').getContext('2d');
	var labels = ['Nilai Sosial', 'Penghubung', 'Sisi Emosional', 'Publik', 'Tips', 'Cerita'];
	var options = {
		responsive: true,
        maintainAspectRatio : false,
		tooltips: {
            callbacks: {
                label: function(tooltipItem, data) {
                    var label = top_keywords[tooltipItem.index] || '';

                    if (label) {
                        label += ' : ' + tooltipItem.yLabel + '%';
                    }
                    return label;
                }
            }
		},
		scales: {
			yAxes: [{
                ticks: {
                    suggestedMin: 0
                }
            }]
		},
		onClick: function(event, item) {
			if (item[0]) {
				var keyword = top_keywords[item[0]._index];
				var label = labels[item[0]._index];
				loadSourceKeyword(keyword, label);
			}
		}
	};
	
	datasets = [{
		label: 'Value',
		data: [0,0,0,0,0,0],
		backgroundColor: ['#0ED1D6', '#D58F51', '#603CD6', '#EB5757', '#67D66D', '#BABABA']
	}];
	
	window.lineChart = new Chart(ctx, {
		type: 'bar',
		data: { labels: labels, datasets: datasets },
		options: options
	});
}

function loadKeywords(index) {
	$( ".box-label .loading-box-label" ).eq( index ).show();

	var offset 		= keywords_offset[index]
	var id_label	= index + 1;

	$.get("../api_get_keywords", {

		offset      : offset,
		id_label    : id_label,
		interval    : interval,
		category	: category

	} , function(data) {

		if (data.length) {
			var elm_list_keyword = $( ".box-label .slim-scroll" ).eq( index );
			
			if (keywords_offset[index] == 0) {
				datasets[0].data[index] = Number((parseFloat(data[0].p_value) * 100).toFixed(2));
				top_keywords[index] = data[0].normal_text;
				window.lineChart.update();
			}
			
			var max = datasets[0].data[index];
			
			data.forEach( function(item, i) {
				var keyword 		= item.normal_text;
				var id_label		= item.id_label;
				var value 			= Number((parseFloat(item.p_value) * 100).toFixed(2));
				var progress_width 	= Math.round(value / max * 100).toString() + "%";
				var progress_color 	= datasets[0].backgroundColor[index];
		
				elm_list_keyword.append(
					'<a href="#" class="box-keyword" title="' + keyword + '" label="' + id_label + '" onclick="onKeywordClick(event, this)">' +
					'<div class="keyword">' + keyword + '</div>' +
					'<table><tr>' +
					'<td class="progress progress-flat">' +
					'<div class="progress-bar" style="width: '+ progress_width +'; background-color: '+ progress_color +';"></div>' +
					'</td>' +
					'<td class="value-keyword">'+ value +'%</td>' +
					'</tr></table>' +
					'</a>'
				); 
			});
			
			keywords_offset[index] += data.length;

			if (offset > 4) elm_list_keyword.slimScroll({ scrollTo: elm_list_keyword[0].scrollHeight });
		}

		if (!data.length || data.length < 5) {
			$( ".box-label .btn-loadmore" ).eq( index ).prop( "disabled", true ).html( "No more keywords" );
		}

		$( ".box-label .loading-box-label" ).eq( index ).hide();
	});
}

function onKeywordClick(event, object) {
	event.preventDefault();

	var keyword = object.getAttribute("title");
	var id_label = object.getAttribute("label");
	var label = $( ".box-label .box-title" ).eq(id_label - 1).text();

	loadSourceKeyword(keyword, label);
}

function loadSourceKeyword(keyword, label) {
	var container = $( ".box-source ul" );
	container.empty();

	$( ".box-source .box-title span" ).text( label );
	$( ".box-source #loading-source" ).css( "display", "flex" );

	$.get( "../api_get_source", {

		keyword	 : keyword,
		category : category,
		interval : interval

	}, function( data ){

		if (data.length) {
			data.forEach( function(item, i) {
				container.append(
					'<a href="' + item.url + '" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">'
						+ '<li class="item">'
							+ '<div class="product-img">'
								+ '<img src="' + BASE_URL + '/dist/image/instagram.svg" alt="" style="height: 32px; width: 32px;" />'
							+ '</div>'
							+ '<div class="product-info" style="margin-left: 44px;">'
								+ '<span class="product-title" style="font-weight: normal;">' + keyword + '</span>'
								+ '<span class="product-description" style="font-size: 10px; line-height: 11px; color: #15b4c3;">' + item.url + '</span>'
							+ '</div>'
						+ '</li>'
					+ '</a>'
				);
			});
		}

		$( ".box-source #loading-source" ).hide();
	});
}

function searchKeyword( keyword ) {
	$( "#input-search .btn-search" ).hide();
	$( "#input-search .input-group-addon" ).show();

	$.get( "../api_search", {

		keyword	 : keyword,
		category : category,
		interval : interval

	}, function( data ){

		$( ".box-label .slim-scroll" ).empty();

		data.forEach( function(item, i) {
			var index 			= item.id_label - 1;
			var max 			= datasets[0].data[index];

			var keyword 		= item.normal_text;
			var id_label		= item.id_label;
			var value 			= (parseFloat(item.p_value) * 100).toPrecision(2);
			var progress_width 	= Math.round(value / max * 100).toString() + "%";
			var progress_color 	= datasets[0].backgroundColor[index];
	
			$( ".box-label .slim-scroll" ).eq( index ).append(
				'<a href="#" class="box-keyword" title="' + keyword + '" label="' + id_label + '" onclick="onKeywordClick(event, this)">' +
				'<div class="keyword">' + keyword + '</div>' +
				'<table><tr>' +
				'<td class="progress progress-flat">' +
				'<div class="progress-bar" style="width: '+ progress_width +'; background-color: '+ progress_color +';"></div>' +
				'</td>' +
				'<td class="value-keyword">'+ value +'%</td>' +
				'</tr></table>' +
				'</a>'
			); 
		});

		$( "#input-search .input-group-addon" ).hide();
		$( "#input-search .btn-clear" ).show();
		$( ".box-label .btn-loadmore" ).prop( "disabled", true ).html( "No more keywords" );

	});
}

function searchClear() {
	keywords_offset = [0,0,0,0,0,0];
	$( ".box-label .slim-scroll" ).empty();

	for (i = 0; i < 6; i++) {
		loadKeywords(i);
	}

	$( "#input-search input" ).val( "" );
	$( "#input-search .btn-clear" ).hide();
	$( "#input-search .btn-search" ).show();
	$( ".box-label .btn-loadmore" ).prop( "disabled", false ).html( "See more keywords" );
}

$(document).ready(function() {
	interval = $( ".content" ).attr( "interval" );
	category = $( ".content" ).attr( "category" );

	for (i = 0; i < 6; i++) {
		loadKeywords(i);
	}
	
	Chart.defaults.global.legend.display = false;
    Chart.defaults.global.defaultFontColor = 'white';
	
	initChart();

	$( ".box-label .btn-loadmore" ).click(function() {
		var index = $( ".box-label .btn-loadmore" ).index(this);
		loadKeywords(index);
	});

	$( "#input-search .btn-search button" ).click(function() {
		var keyword = $( "#input-search input" ).val().toLowerCase();
		if (keyword.length > 1) {
			searchKeyword(keyword);
		}
	});

	$( "#input-search .btn-clear button" ).click(function() {
		searchClear();
	})

	$( "#input-search input" ).keyup(function( event ) {
		if ( event.keyCode == 13 ) {
			$( "#input-search .btn-search button" ).trigger( "click" );
		} else {
			$( "#input-search .btn-search" ).show();
		}
	});
});