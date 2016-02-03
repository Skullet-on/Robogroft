class AddConnectionTableTasksVms < ActiveRecord::Migration
  def change
  	create_table :tasks_vms, id: false do |t|
  		t.belongs_to	:task, 	index: true
  		t.belongs_to	:vm, index: true
  		remove_column :tasks, :vms
  	end
  end
end
