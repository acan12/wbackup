var RowDirectoryFileItemBox = React.createClass({
  
  handleClick: function(){
    var elem = this.refs.backupOption
    var ischecked = $(elem).is(":checked");
    console.log(ischecked)
    


  },
    
  render: function(){
    var row = this.props.item;
    var icon = (row.dirtype) ? "/assets/folder-icon.png" : "/assets/document-icon.png";
    return (
        <tr>
          <td className="hidden-xs">
            <img src={icon} />
          </td>
          <td>
            <a href={"?p="+row.path}>{row.name}</a>
          </td>
          <td>{row.mtype}</td>
          <td>{row.size}</td>
          <td>{row.mtime}</td>
          <td>{row.atime}</td>
          <td>{row.permission}</td>
          <td align="center">
            <div className="btn-group" data-toggle="buttons" onClick={this.handleClick} >
              <label className="btn btn-success">
                <input data-autocomplete="off" data-checked="" type="checkbox" ref="backupOption"/>
                <span className="glyphicon glyphicon-ok"></span>
              </label>
            </div>
          </td>
        </tr>
    )
  }
  
});