var RowDirectoryFileBox = React.createClass({
  getInitialState: function () {
    return { rows_directories_files: [] }
  },
  componentDidMount: function () {
    this.loadDatasFromServer();
  },
  
  loadDatasFromServer: function (query) {

    var url = this.props.url;
    var path  = $("#container").attr("path");
    var backupId = $('#profiles').val();
    
    $.ajax({
      url: url,
      data: { path: path, b: backupId },
      type: "GET",
      success: function (data) {

        this.setState({
            rows_directories_files: data,
           });
      }.bind(this),
      error: function (xhr, status, err) {
      }.bind(this)
    })

  },
  
  handleClick: function(e){
    e.preventDefault();
    // var keyword = $("#searchBox").val();
    // this.loadCommentsFromServer(keyword); // reload box component
  },

  render: function () {    
    return (
      <div>
        <table className="table table-striped table-bordered table-list">
          <thead>
            <tr>
              <th><em className="fa fa-cog"></em></th>
              <th className="hidden-xs">Name</th>
              <th>Mime/Type</th>
              <th>Size</th>
              <th>Change</th>
              <th>Modified</th>
              <th>Created</th>              
              <th>Permission</th>
              <th>Backup</th>
            </tr>
          </thead>
          <tbody>
            {this.state.rows_directories_files.map(function(item){
              return (<RowDirectoryFileItemBox item={item}/>)
            })}
          </tbody>
        </table>
      </div>
    )
  }
});