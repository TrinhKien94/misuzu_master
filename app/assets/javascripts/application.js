// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs


// require turbolinks

//= require moment
//= require moment/ja

//= require fullcalendar.min
//= require scheduler.min
// require fullcalendar/gcal
//= require gcal

//= require dataTables/jquery.dataTables.min
//= require dataTables/dataTables.bootstrap.min
//= require dataTables/dataTables.fixedColumns.min
//= require dataTables/dataTables.select.min
//= require dataTables/dataTables.buttons.min

//= require bootstrap-datetimepicker
//= require bootstrap-colorpicker

//= require custom


// require_tree .

$(document).on('ready', function() {
  setTimeout(function() {
    $('.alert').fadeOut('normal');
  }, 3000);
});

$(document).ready(function() {
    $('#export_table').DataTable();
} );
$(document).ready(function() {
  $('#kintai_table').dataTable();
});
