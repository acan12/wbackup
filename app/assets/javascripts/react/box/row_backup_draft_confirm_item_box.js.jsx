var RowBackupDraftConfirmItemBox = React.createClass({
  render: function(){
    var row = this.props.item;
    var icon = (row.dirtype) ? "/assets/folder-icon.png" : "/assets/document-icon.png";
    return (
        <tr>
          <td className="hidden-xs">
            <img src={icon} />
          </td>
          <td>{row.path}</td>
        </tr>
    )
  }
  
});