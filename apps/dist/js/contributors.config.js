var tableConfig;


function searchKeyUp(ev) {
  var sku = $(ev);
  if(tableConfig) {
    var val = sku.val();
    tableConfig.search(val).draw();
  }
}

function onRowClick(r) {
  $("input[name=name]").val($(r).children('td:eq(0)').text());
  $("input[name=ig_username]").val($(r).children('td:eq(1)').text());
  $("select[name=bidang]").val($(r).children('td:eq(2)').text());
  $("input[name=contributor_id]").val($(r).children('td:eq(4)').text());
}

$(document).ready(function() {

tableConfig = $('#table-config').DataTable({
  bLengthChange: false,
  paging: false,
  info: false,
  // filter: true,
  // order: [[0, 'asc']]
});

});