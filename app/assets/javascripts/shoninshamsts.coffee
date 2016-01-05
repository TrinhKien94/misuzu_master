# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  oTable = $('.shonin-table').DataTable({
    "pagingType": "full_numbers",
    "oLanguage":{
      "sUrl": "../../assets/resource/dataTable_ja.txt"
    },
    "aoColumnDefs": [
      { "bSortable": false, "aTargets": [ 3,4,5 ]},
      {"targets": [3,4,5],"width": '15px'}
    ],
    "columnDefs": [{
      "targets"  : 'no-sort',
      "orderable": false
    }]
  })