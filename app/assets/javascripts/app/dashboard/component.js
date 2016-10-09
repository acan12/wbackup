// initialize react component what you need in this controller page.
docReady([rowDirectoryFileBox, rowBackupDraftConfirmBox]);

var Page = {
  reload: function(){
      $("#profiles").change(function(e){
        var backupId = $('#profiles').val();

        window.location = "?b="+backupId;

      });
  },
  
  loadChar: function(){
      var keys = $("#chart").attr("keys");
      
      
  },
  showChar: function(datas){
      
      
      $("#chart").highcharts({
          chart: {
              type: 'pie'
          },
          title: {
              text: "xxxx"
          },
          tooltip: {
              pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
          },
          plotOptions: {
              pie: {
                  allowPointSelect: true,
                  cursor: 'pointer',
                  dataLabels: {
                      enabled: true,
                      format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                      style: {
                          color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                      }
                  }
              }
          },
          series: [{
              name: 'Brands',
              colorByPoint: true,
              data: datas
          }]
      });
  }
  
}



$(function(e){ 
  Page.reload(); 
  datas = [{ name: 'Microsoft Internet Explorer', y: 56.33}, 
      { name: 'Chrome', y: 24.03, sliced: true, selected: true}, 
      { name: 'Firefox', y: 10.38 }, 
      { name: 'Safari', y: 4.77 }, 
      { name: 'Opera', y: 0.91 }, 
      { name: 'Proprietary or Undetectable', y: 0.2}]
      
  Page.showChar( datas);
})












