class CreateBackups < ActiveRecord::Migration[5.0]
  def change
    create_table :backups do |t|
      t.string :name
      t.string :backup_file_name
      t.string :path_draft
      t.string :path_backup
      t.datetime :start_process
      t.datetime :end_process
      t.integer :version, default: 0, null: false
      t.integer :stat_total_size
      t.string :stat_top_files_changed
            
      t.timestamps null: false
      
      
      
      t.belongs_to :user
      
    end
  end
  
end
