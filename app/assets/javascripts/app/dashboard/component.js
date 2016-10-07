// initialize react component what you need in this controller page.
docReady([rowDirectoryFileBox, rowBackupDraftConfirmBox]);

var Page = {
  reload: function(){
      $("#profiles").change(function(e){
        var backupId = $('#profiles').val();

        window.location = "?b="+backupId;

      });
  }
}



$(function(e){ Page.reload(); })










