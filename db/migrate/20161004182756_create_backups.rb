class CreateBackups < ActiveRecord::Migration[5.0]
  def change
    create_table :backups do |t|
      t.string :name
      t.string :status # draft / backup / restore
      t.string :path
      t.integer :duration
      t.datetime :start_process
      t.datetime :end_process
      t.integer :last_version
            
      t.timestamps null: false
      
      t.belongs_to :user
      
    end
  end
  
end
