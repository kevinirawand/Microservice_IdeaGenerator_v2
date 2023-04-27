var interval = "monthly";
var myLineChart = undefined;
var datasets = new Array();

// SIMPAN SETIAP PERUBAHAN UNTUK REFRESH CHART NYA
let currentIg_username = null;
let currentYear = null;
let currentMonth = null;

function onDateChange() {
   var val = $("#hiddenField").val();
   $(".ui-datepicker-trigger").text(new Date(val).toDateString());
   $(".box-source-activity ul").html("");
   // console.info(val)

   $.get("./api_gauge", { interval: interval, date: val, ig_username: currentIg_username }, function (result, status) {
      initGauge(result.activity, result.responsiveness);
   });
}

function activityResponsivenessSetDate(date) {
   $("#hiddenField").datepicker("setDate", date).change();
}

function initDatePicker() {
   var today = new Date();
   var defaultDate = new Date(today.setDate(today.getDate() - 1));

   $("#hiddenField").datepicker({
      showOn: "button",
      maxDate: -1,
      // minDate: -(defaultDate.getDate()),
      dateFormat: "yy-mm-dd"
   }).next(".ui-datepicker-trigger").addClass("btn btn-sm");

   //$( "#hiddenField" ).datepicker("setDate", defaultDate).change();
   activityResponsivenessSetDate(defaultDate);
}

function initMonthPicker2() {
   var arrMonth = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
   var curMonth = new Date().getMonth();
   var curYear = new Date().getFullYear();

   $("#month-picker2 input").MonthPicker({
      Button: '<button type="button" class="btn btn-sm text-bold"><span>' + arrMonth[curMonth] + ' ' + curYear + '</span> &nbsp; <i class="fa fa-caret-down"></i></button>',
      MaxMonth: 0,
      MinMonth: '-9y',
      SelectedMonth: 0,
      Position: {
         my: 'right top+2',
         at: 'right bottom',
         collision: 'flip',
         of: $("#month-picker2")
      },
      OnAfterChooseMonth: function (selectedDate) {
         var year = selectedDate.getFullYear();
         var month = selectedDate.getMonth();

         $("#month-picker2 button span").text(arrMonth[month] + ' ' + year);
         initMonthlyGauge(month, year);
      }
   });
}

function initMonthPickerChart() {
   $("#month-picker input").MonthPicker({
      Button: '<button type="button" class="btn btn-sm text-bold">Data Records &nbsp; <i class="fa fa-caret-down"></i></button>',
      MaxMonth: 0,
      MinMonth: '-9y',
      SelectedMonth: 0,
      Position: {
         my: 'right top+2',
         at: 'right bottom',
         collision: 'flip',
         of: $("#month-picker")
      },
      OnAfterChooseMonth: function (selectedDate) {
         // return selectedDate;
         currentYear = selectedDate.getFullYear();
         currentMonth = selectedDate.getMonth();
         refreshChart(currentYear, currentMonth + 1, currentIg_username);
      }
   });
}

function initYearPickerChart() {
   $("#dropdown-year .dropdown-menu a").click(function (event) {
      $("#dropdown-year .dropdown-menu a").removeClass("selected");
      $(this).addClass("selected");

      $year = event.target.text;
      currentYear = $year;
      currentMonth = null;

      refreshChart(currentYear, currentMonth, currentIg_username);
   });
}

function initChart() {
   var ctx = document.getElementById('chart').getContext('2d');
   var labels = getChartLabels(interval);
   datasets = [
      { label: 'Follower', backgroundColor: '#0ED1D6', borderColor: '#0ED1D6', data: [], fill: false },
      { label: 'Interaction', backgroundColor: '#D58F51', borderColor: '#D58F51', data: [], fill: false }
   ];
   var options = {
      responsive: true,
      maintainAspectRatio: false,
      tooltips: {
         position: 'nearest',
         mode: 'nearest',
         intersect: false,
         callbacks: {
            title: function (tooltipItem, obj) {
               if (interval == "daily") return 'Day ' + tooltipItem[0].label;
               else return tooltipItem[0].label;
            },
            label: function (tooltipItem, obj) {
               return obj.datasets[tooltipItem.datasetIndex].label + ' : ' + floatToShort(tooltipItem.value);
            }
         }
      },
      hover: {
         mode: 'nearest',
         intersect: false
      },
      onClick: function (event, item) {
         if (item[0]) {
            var index = item[0]._index;
            getSource(index + 1);

            /** Update Activity & Responsiveness */
            if (interval == 'daily') {
               year = $("#month-picker input").MonthPicker('GetSelectedYear');
               month = $("#month-picker input").MonthPicker('GetSelectedMonth');
               activityResponsivenessSetDate(new Date(year, month - 1, index + 1));
            } else {
               year = $("#dropdown-year .dropdown-menu a.selected").text();
               setMonthPicker2(year, index);
            }
         }
      },
      scales: {
         yAxes: [{
            ticks: {
               callback: function (value, index, values) {
                  return floatToShort(value);
               }
            }
         }]
      }
   };

   for (var i = 0; i < labels.length; i++) {
      datasets[0].data[i] = null;
      datasets[1].data[i] = null;
   }

   myLineChart = new Chart(ctx, {
      type: 'line',
      data: { labels: labels, datasets: datasets },
      options: options
   });

   refreshChart(currentYear, currentMonth, currentIg_username);
}

function getSelectedTarget() {
   const targetsItem = document.querySelectorAll('.target-item');

   targetsItem.forEach((element) => {
      element.addEventListener('click', (e) => {
         e.preventDefault();
         currentIg_username = element.textContent
         refreshChart(currentYear, currentMonth, currentIg_username);

         document.getElementById("target-anchor").innerHTML = element.textContent;
      });
   });

   return null;
}

function refreshChart(year = null, month = null, ig_username = null) {
   datasets[0].data = new Array(datasets[0].data.length);
   datasets[1].data = new Array(datasets[1].data.length);

   $.get("./api_history_follower_interaction", { interval, year, month, ig_username }, function (result, status) {
      if ($.isArray(result) && result.length) {
         var index = 0;
         result.forEach(row => {
            if (interval == "daily") {
               index = parseInt(row["day"]) - 1;
            }
            else {
               index = parseInt(row["month"]) - 1;
            }
            datasets[0].data[index] = row["total_follower"];
            datasets[1].data[index] = row["total_engagement"];
         });
      }
      myLineChart.update();
   });


   var val = $("#hiddenField").val();

   console.info(currentIg_username);

   // FIX DENGAN GANTI DB KE PRODUCTION
   $.get("./api_gauge", { interval: interval, date: val, ig_username: currentIg_username }, function (result, status) {
      initGauge(result.activity, result.responsiveness);
   });
}

function initMonthlyGauge(month, year) {
   $.get("./api_gauge", { interval: interval, month: month + 1, year: year, ig_username: currentIg_username }, function (result, status) {
      initGauge(parseFloat(result.activity), parseFloat(result.responsiveness));
   });
   $(".box-source-activity ul").html("");
}

function initGauge(activity, responsiveness) {
   // console.info(responsiveness);


   const gauge_acivity = document.querySelector(".gauge-activity .gauge-hand");
   const gauge_responsiveness = document.querySelector(".gauge-responsiveness .gauge-hand");

   let activity_rotate = activity * 30 - 15;
   if (activity_rotate > 180) {
      activity_rotate = 180;
   } else
      if (activity_rotate < 0 || isNaN(activity_rotate)) {
         activity_rotate = 0;
      }
   gauge_acivity.style.transform = `translateY(70px) rotateZ(${activity_rotate}deg)`;

   let responsiveness_rotate = responsiveness * 3 - 15;
   if (responsiveness_rotate > 180) {
      responsiveness_rotate = 180;
   } else
      if (responsiveness_rotate < 0 || isNaN(responsiveness_rotate)) {
         responsiveness_rotate = 0;
      }
   gauge_responsiveness.style.transform = `translateY(70px) rotateZ(${responsiveness_rotate}deg)`;
}

function getSource(index) {
   $(".box-source-like ul").html("");

   if (interval == 'daily') {
      year = $("#month-picker input").MonthPicker('GetSelectedYear');
      month = $("#month-picker input").MonthPicker('GetSelectedMonth');
   } else {
      year = $("#dropdown-year .dropdown-menu a.selected").text();
      month = null;
   }

   $.get("./api_source", { interval, index, year, month }, function (result, status) {
      if ($.isArray(result) && result.length) {
         result.forEach(row => {
            $(".box-source-like ul").append(
               '<a href="' + row.url + '" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">'
               + '<li class="item">'
               + '<div class="product-img ' + (row.category == 'H' ? 'svg-green' : (row.category == 'L' ? 'svg-red' : '')) + '">'
               + '<img src="' + BASE_URL + '/dist/image/instagram.svg" style="height: 32px; width: 32px;" />'
               + '</div>'
               + '<div class="product-info" style="margin-left: 44px;">'
               + '<span class="product-title">' + row.url + '</span>'
               + '<span class="product-description"><i class="fa fa-heart"></i> Like ' + row.like_count + '</span>'
               + '</div>'
               + '</li>'
               + '</a>'
            );
         });
      }
   });
}

function getSourceActivity() {
   if (interval == "daily") {
      var val = $("#hiddenField").val();
      var date = new Date(val);
      var index = date.getDate();
      var month = date.getMonth() + 1;
      var year = date.getFullYear();
   } else {
      var val = $("#month-picker2 input").MonthPicker('GetSelectedDate');
      var index = val.getMonth() + 1;
      var year = val.getFullYear();
   }

   $(".box-source-activity ul").html("");
   $.get("./api_source", { interval: interval, index: index, year: year, month: month }, function (result, status) {
      if ($.isArray(result) && result.length) {
         result.forEach(row => {
            var takenAt = new Date(row.taken_at);
            var responsiveness = row.responsiveness == null ? "- &nbsp; &nbsp;" : Number(parseFloat(row.responsiveness).toFixed(1)) + "%";
            $(".box-source-activity ul").append(
               '<a href="' + row.url + '" target="_blank" class="box-keyword" style="display: grid; margin-bottom: 8px;">'
               + '<li class="item">'
               + '<div class="product-img">'
               + '<img src="' + BASE_URL + '/dist/image/instagram.svg" style="height: 32px; width: 32px;" />'
               + '</div>'
               + '<div class="product-score h4" style="float: right; height: 32px; width: 60px; margin: 0; text-align: right; line-height: 32px; font-weight: bold;">'
               + responsiveness
               + '</div>'
               + '<div class="product-info" style="margin-left: 44px;">'
               + '<span class="product-title" style="color: white;">' + takenAt.toDateString() + '</span>'
               + '<span class="product-description">Time ' + takenAt.toLocaleTimeString('id', { hour: '2-digit', minute: '2-digit' }) + '</span>'
               + '</div>'
               + '</li>'
               + '</a>'
            );
         });
      }
   });
}

function setMonthPicker2(year, month) {
   var arrMonth = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

   $("#month-picker2 input").MonthPicker('option', 'SelectedMonth', `${month + 1}/${year}`);
   $("#month-picker2 button span").text(arrMonth[month] + ' ' + year);

   initMonthlyGauge(month, year);
}


// LOOP TARGET ITEM
function targetContentLoop(item) {
   targetContent += `<li class="target-item"><a href="">${item.ig_username}</a></li>`
}

// SHOW TARGET
function showTargets() {
   let targets = null;
   $.ajax({
      url: "./api_get_targets",
      type: 'get',
      dataType: 'JSON',
      async: false,
      success: function (data) {
         targets = data;
      },
      error: function (err) {
         console.error(err)
      }
   });

   targetContent = '';
   targets.forEach(targetContentLoop);
   document.getElementById("target-container").innerHTML = targetContent;
}

$(document).ready(function () {
   Chart.defaults.global.legend.display = false;
   Chart.defaults.global.defaultFontColor = 'white';
   Chart.defaults.global.elements.line.tension = 0;
   Chart.defaults.global.elements.point.radius = 1;

   interval = $(".content").attr("interval");
   if (interval == "daily") {
      initDatePicker();
      initMonthPickerChart();
   }
   else {
      initMonthPicker2();
      initMonthlyGauge(new Date().getMonth());
      initYearPickerChart();
   }
   initChart();


   showTargets();
   getSelectedTarget();
});