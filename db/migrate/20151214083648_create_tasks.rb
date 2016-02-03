class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :name
      t.string :status
      t.string :cmd
      t.float :progress
      t.string :vms
      t.string :file
      t.string :email
      t.integer :timeout
      t.boolean :restore
      t.integer :number
      t.integer :priority
      
      t.timestamps
    end
  end
end