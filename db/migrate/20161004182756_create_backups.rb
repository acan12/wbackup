class CreateBackups < ActiveRecord::Migration[5.0]
  def change
    create_table :backups do |t|
      t.string :name
      t.string :status # draft / backup / restore
      t.string :path_draft
      t.string :path_backup      
      t.integer :duration
      t.datetime :start_process
      t.datetime :end_process
      t.integer :latest_version, default: 0, null: false
      t.integer :stat_total_size
      t.string :stat_top_files_changed
            
      t.timestamps null: false
      
      t.belongs_to :user
      
    end
  end
  
end
