var RowBackupDraftConfirmBox = React.createClass({
  getInitialState: function () {
    return { rows_directories_files: [] }
  },
  componentDidMount: function () {
    this.loadDatasFromServer();
  },
  
  loadDatasFromServer: function (query) {

    var url = this.props.url;
    var backupId = $('#profiles').val();
    
    $.ajax({
      url: url+"/"+backupId,
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
  
  render: function () {    
    var row = this.state.rows_directories_files;
    console.log(row)
    return (
      <div>
        <table className="table table-striped table-bordered table-list">
          <thead>
            <tr>
              <th><em className="fa fa-cog"></em></th>
              <th className="hidden-xs">Name</th>
            </tr>
          </thead>
          <tbody>
            {this.state.rows_directories_files.map(function(item){
              return (<RowBackupDraftConfirmItemBox item={item}/>)
            })}
          </tbody>
        </table>
      </div>
    )
  }
});