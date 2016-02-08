require 'sqlite3'

db = SQLite3::Database.new("db/development.sqlite3")
array = db.execute("SELECT * FROM tasks WHERE status='Wait' ORDER BY priority ASC")
#a = "SELECT 'vms'.* FROM 'vms' INNER JOIN 'tasks_vms' ON 'vms'.'id' = 'tasks_vms'.'vm_id' WHERE 'tasks_vms'.'task_id' = '#{array[0][0].to_s}'"
#vms = db.execute(a)
id = array[0][0]

def working()
	#Sharing VMS List
		#prepare vms
			#attach VHD
			#copying files
			#detach VHD
		#start vm
			#update statuss
			#calculate progress
		#gathering results
			#copying files in results directory
			#create link on results
			#send result on email

end
