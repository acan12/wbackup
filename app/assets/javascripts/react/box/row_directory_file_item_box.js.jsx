var RowDirectoryFileItemBox = React.createClass({
  
  handleClick: function(){
    var elem = this.refs.backupOption;
    var path = this.props.item.path;
    var ischecked = $(elem).is(":checked");
    var backupId = $('#profiles').val();

    console.log(ischecked)
    if(backupId != ""){
      $.ajax({
        url: 'api/backup/'+backupId,
        data: { path: path, do: ischecked },
        type: "PUT",
        success: function (data) {
          console.log(data)
          $(".fileLink").each(function(e){ 
            link = $(this).attr("href");
            $(this).attr({'href': link+"&b="+backupId })
          })
        }.bind(this),
        error: function (xhr, status, err) {
        }.bind(this)
      })
    }else{
      alert("You must set your Backup Profile!!")
      $(this.refs.backupMark).removeClass('active');
      return false;
    }
  },
    
  render: function(){
    var row = this.props.item;
    var icon = (row.dirtype) ? "/assets/folder-icon.png" : "/assets/document-icon.png";
    var backupId = $('#profiles').val();
    return (
        <tr>
          <td className="hidden-xs">
            <img src={icon} />
          </td>
          <td>
            <a className="fileLink" href={"?p="+row.path+"&b="+backupId}>{row.name}</a>
          </td>
          <td>{row.mtype}</td>
          <td>{row.size}</td>
          <td>{row.mtime}</td>
          <td>{row.atime}</td>
          <td>{row.permission}</td>
          <td align="center">
            <div className="btn-group" data-toggle="buttons" onClick={this.handleClick} >
              <label className={"btn btn-success "+row.active} ref="backupMark">
                <input data-autocomplete="off" data-checked="" type="checkbox" ref="backupOption"/>
                <span className="glyphicon glyphicon-ok"></span>
              </label>
            </div>
          </td>
        </tr>
    )
  }
  
});