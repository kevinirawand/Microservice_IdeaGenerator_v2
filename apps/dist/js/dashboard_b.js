$(function () {
    'use strict';

    Chart.defaults.global.legend.display = false;

    var canvases = $('.chart');
    var ctx = canvases[0].getContext('2d');

    $.get(window.location.href + '/api', function(resp, status) {
        var chartData = resp;
        if (chartData.length == 0) return;

        var data = {
            labels: [],
            datasets: [{
                label: 'Follower',
                data: [],
                borderWidth: 1
            }]
        }

        for (let i = 0; i < chartData.length; i++) {
            console.log(chartData[i]);
            data.labels.push(chartData[i].ig_username);
            data.datasets[0].data.push(chartData[i].follower_count);
        }

        var chart = new Chart(ctx, {
            type: 'horizontalBar',
            data: data,
            options: {}
        });

        initPostChart(chartData);
        initLikeChart(chartData);
        initResponseChart(chartData);
        initScoreChart(chartData);
        initTableGrade(chartData);
    });
});

function initPostChart(apiData) {
    var ctx = $('#postChart');
    var chartData = {
        labels: [],
        datasets: [{
            label: 'Posting Average',
            data: [],
            borderWidth: 1
        }]
    }

    for (let i = 0; i < apiData.length; i++) {
        chartData.labels.push(apiData[i].ig_username);
        chartData.datasets[0].data.push(apiData[i].post_avg);
    }

    var chart = new Chart(ctx, {
        type: 'horizontalBar',
        data: chartData,
        options: {}
    });
}

function initLikeChart(apiData) {
    var ctx = $('#likeChart');
    var chartData = {
        labels: [],
        datasets: [{
            label: 'Engagement',
            data: [],
            borderWidth: 1
        }]
    }

    for (let i = 0; i < apiData.length; i++) {
        chartData.labels.push(apiData[i].ig_username);
        chartData.datasets[0].data.push(apiData[i].like_avg);
    }

    var chart = new Chart(ctx, {
        type: 'horizontalBar',
        data: chartData,
        options: {}
    });
}

function initResponseChart(apiData) {
    var ctx = $('#responseChart');
    var chartData = {
        labels: [],
        datasets: [{
            label: 'Response',
            data: [],
            borderWidth: 1
        }]
    }

    for (let i = 0; i < apiData.length; i++) {
        chartData.labels.push(apiData[i].ig_username);
        chartData.datasets[0].data.push(apiData[i].response_avg);
    }

    var chart = new Chart(ctx, {
        type: 'horizontalBar',
        data: chartData,
        options: {
            tooltips: {
                callbacks: {
                    label: function(tooltipItem, data) {
                        // var label = data.datasets[tooltipItem.datasetIndex].label || '';
    
                        // if (label) {
                        //     label += ': ';
                        // }
                        // label += Math.round(tooltipItem.yLabel * 100) / 100;
                        return data.datasets[tooltipItem.datasetIndex].label + ': ' + tooltipItem.value + '%';
                    }
                }
            },
        }
    });
}

function initScoreChart(apiData) {
    var ctx = $('#scoreChart');
    var chartData = {
        labels: [],
        datasets: [{
            label: 'Score',
            data: [],
            borderWidth: 1
        }]
    }

    for (let i = 0; i < apiData.length; i++) {
        chartData.labels.push(apiData[i].ig_username);
        chartData.datasets[0].data.push(apiData[i].total_score);
    }

    var chart = new Chart(ctx, {
        type: 'horizontalBar',
        data: chartData,
        options: {}
    });
}

function initTableGrade(apiData) {
    var table = $("#table-grade > tbody");
    for (let i = 0; i < apiData.length; i++) {
        table.append('<tr><td>'+ apiData[i].ig_username +'</td><td>'+ apiData[i].grade +'</td></tr>');
    }
}