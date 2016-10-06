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

