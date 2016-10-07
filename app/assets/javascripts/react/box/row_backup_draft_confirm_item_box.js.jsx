var RowBackupDraftConfirmItemBox = React.createClass({
  render: function(){
    var row = this.props.item;
    var icon = (row.dirtype) ? "/assets/folder-icon.png" : "/assets/document-icon.png";
    return (
        <tr>
          <td className="hidden-xs">
            <img src={icon} />
          </td>
          <td>
            <a href={"?p="+row.path+"&b="+row.backup_id}>{row.path}</a></td>
        </tr>
    )
  }
  
});