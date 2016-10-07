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
  
  handleClick: function(){
    this.loadDatasFromServer();
  },
  
  render: function () {    
    var row = this.state.rows_directories_files;
    var backupId = $('#profiles').val();
    var style1 = { "display": "none"}
    var style2 = { "margin": "20px"}
    console.log(row)
    return (
      <div>
        <button onClick={this.handleClick} className="pull-right btn btn-success" data-target=".confirm-backup-modal-lg" data-toggle="modal" type="button">Backup Now</button>
        <div aria-hidden="true" data-aria-labelledby="mySmallModalLabel" className="modal fade confirm-backup-modal-lg" data-role="dialog" data-tabindex="-1" style={style1}>
          <div className="modal-dialog">
            <div className="modal-content">
              <div className="content" style={style2}>
                <div className="row">
                  <div className="col-md-12">
                    <br/>
                    <div>
                      <table className="table table-striped table-bordered table-list">
                        <thead>
                          <tr>
                            <th><em className="fa fa-cog"></em></th>
                            <th className="hidden-xs">Path</th>
                          </tr>
                        </thead>
                        <tbody>
                          {row.map(function(item){
                            return (<RowBackupDraftConfirmItemBox item={item}/>)
                          })}
                        </tbody>
                      </table>
                    </div>
                  </div>  
                </div>
                
                
                <div className="row">
                  <div className="col-md-12">
                    <form action="/backup" method="post">
                      <input id="backupid" name="backupid" type="hidden" value={backupId} />
                      <input name="submit_backup" type="submit" value="Continue Backup Process" className="btn btn-primary" />
                    </form>
                  </div>
                </div>
                  
              </div>
            </div>
          </div>
        </div>
      </div>
    
              
    )
  }
});