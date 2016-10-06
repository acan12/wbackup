var init = function(){
    // initialize Dragdrop
}

var docReady = function(components){
  $(document).ready(components);
}

docReady([init]);  // always call `init`


var rowDirectoryFileBox = function () {    
  ReactDOM.render(
    <RowDirectoryFileBox url="/api/files" pollInterval="1000" />,
    document.getElementById('rowDirectoryFileBox')
  );
};

var rowBackupDraftConfirmBox = function () {
  ReactDOM.render(
    <RowBackupDraftConfirmBox url="/api/backup" pollInterval="1000" />,
    document.getElementById('rowBackupDraftConfirmBox')
  );
}

