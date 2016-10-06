// initialize react component what you need in this controller page.
docReady([rowDirectoryFileBox, rowBackupDraftConfirmBox]);
$(function(e){ Page().reload(); })


var Page = function(){
  return {
    reload: function(){
        $("#profiles").change(function(e){
          var backupId = $('#profiles').val();
          var qs = $(location).attr("search");
    
          window.location.href = window.location.href.replace(qs, "?b="+backupId)

        });
    }
  }
}







