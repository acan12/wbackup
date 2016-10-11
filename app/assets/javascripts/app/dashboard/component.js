// initialize react component what you need in this controller page.
docReady([rowDirectoryFileBox, rowBackupDraftConfirmBox]);

var Page = {
  reload: function(){
      $("#profiles").change(function(e){
        var backupId = $('#profiles').val();

        window.location = "?b="+backupId;

      });
  },
  
  loadChart: function(){
      var keys = $("#chart").attr("keys");
      
      
  },
  
  loadBackupProcess: function(){
      var bid = $("#profiles").val();
      $("#progressBar").removeClass("hide");
      
      $.ajax({
        type: 'POST',
        url: '/api/backup',
        data: { bid: bid },
        progress: function(e){

            if(e.lengthComputable) {
              var percent = (e.loaded / e.total) * 100;
              $("#progressBar").attr('value', percent)
              console.log("percent: "+percent)
            }else{
              console.warn('Content Length not reported!');
              
            }
        },
        success: function(data){
          
          $("#progressBar").addClass("hide")
          
          location.href = data.link
        }
      })
      
  },
  
  getStats: function(){
      $.ajax({
        type: 'GET',
        url: '/api/stats',
        success: function(data){
            arr = []
            for(i=0; i<data.length; i++){
              arr[i] = {name: data[i].name, y: data[i].size }
            }
            
            Page.showChart(arr)
        },
        error: function(e){
            console.log('error')
        }
      });
  },
  showChart: function(data){
      
      $("#chart").highcharts({
          chart: {
              type: 'pie'
          },
          title: {
              text: "Backup"
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
              data: data
          }]
      });
  }
  
}



$(function(e){ 
  Page.reload(); 
  Page.getStats();

})












