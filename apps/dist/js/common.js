function floatToShort(val, decimalDigits = 1, akhiran = "") {
	var val = parseFloat(val);
    var n = val / 1000000;

    if (isNaN(n)) return "-";

    if (n >= 1 ) {
        return parseFloat(n.toFixed(decimalDigits)) + "M" + akhiran;
    } else
    if (n >= 0.001) {
        return parseFloat((n * 1000).toFixed(decimalDigits)) + "K" + akhiran;
    } else {
        return parseFloat(val.toFixed(decimalDigits)).toString() + akhiran;
    }
}

function getChartLabels(interval) {
    switch (interval.toLowerCase()) {
        case "daily":
            return [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
        case "monthly":
            return ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
        default:
            return [];
    }
}