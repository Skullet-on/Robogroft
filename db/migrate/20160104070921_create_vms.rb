class CreateVms < ActiveRecord::Migration
  def change
    create_table :vms do |t|
      t.string :name
      t.string :vhash
      t.string :subname
      t.string :state, null: false, default: "waiting"
      t.integer :timeout
      t.float :progress, null: false, default: 0.0
      t.timestamps
    end
    add_index :vms, :hash,                unique: true
  end
end
