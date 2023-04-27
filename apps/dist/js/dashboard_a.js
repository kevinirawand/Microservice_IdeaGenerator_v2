$(function () {
    'use strict';

    Chart.defaults.global.legend.display = false;
    
    var id_label = [1, 2, 3, 4, 5, 6];
    var canvases = $('.chart');

    id_label.forEach(id => {
        // console.log(window.location.href + '/' + id);
        $.get(window.location.href + '/' + id, function(resp, status) {
            var apiData = resp;
            if (apiData.length == 0) return;

            var ctx = canvases[id - 1].getContext('2d');

            var chartData = {
                labels: [],
                datasets: [{
                    data: []
                }]
            }

            for (let i = 0; i < apiData.length; i++) {
                chartData.labels.push(apiData[i].normal_text);
                chartData.datasets[0].data.push(apiData[i].p_value);
            }

            var chart = new Chart(ctx, {
                type: 'pie',
                data: chartData,
                options: {}
            });
        });
    });
});

function changeDayCount(val) {
    window.location.href = './' + val;
}