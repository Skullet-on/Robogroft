require 'sqlite3'
require 'virtualbox'
require File.expand_path("../app/config.rb", __FILE__)

@vboxvms = VirtualBox::VM.all
@db = SQLite3::Database.new("db/development.sqlite3")

def nullprogress(vms)
	for i in 0..vms.size-1
		string = "UPDATE 'vms' SET progress = '0.0' WHERE ID = #{vms[i][0]}"
		@db.execute(string)
	end
end

def getrunningsize()
	num = 0
	for i in 0..@vboxvms.size-1
		if @vboxvms[i].running? || @vboxvms[i].paused?
			num += 1
		end
	end
	return num
end

def gettask()
	array = @db.execute("SELECT * FROM tasks WHERE status='Wait' ORDER BY priority ASC")
	id = array[0]
	return id
end


def getvms(id)
	a = "SELECT 'vms'.* FROM 'vms' INNER JOIN 'tasks_vms' ON 'vms'.'id' = 'tasks_vms'.'vm_id' WHERE 'tasks_vms'.'task_id' = '#{id.to_s}'"
	vms = @db.execute(a)
	return vms
end

def stop(i, vms)
	vm = VirtualBox::VM.find(vms[i][1].to_s)
	vm.stop
end

def calculatetime(times, timef, num, limit, vms, usertimeout)
	for i in 0..num
		vm = VirtualBox::VM.find(vms[i][1].to_s)
		timeout = usertimeout + vms[i][5]
		if vm.powered_off?
		else
			timef[i] = Time.now
			if timef[i] - times[i] >= timeout
				stop(i, vms)
				puts "stopped"	
			end
		end
		tim = timef[i] - times[i]
		progress = tim.to_f/timeout.to_f*100
		if progress > 100 
			progress = 100
		end
		string = "UPDATE 'vms' SET progress = #{progress} WHERE ID = #{vms[i][0]}"
		@db.execute(string)
	end
	sleep 1
end

def waitstart(times, timef, num, limit, currentvms, vms, usertimeout)
	while getrunningsize() >= limit
		calculatetime(times, timef, num-1, limit, vms, usertimeout)
	end
	vm = VirtualBox::VM.find(vms[num][1].to_s)
	vm.start
	times[num] = Time.now
	puts "started"
end

def waitclose(times, timef, num, limit, vms, usertimeout)
	while getrunningsize() != 0
		calculatetime(times, timef, num, limit, vms, usertimeout)
	end
	puts "END!"
end
def work()
	begin
		task = gettask()
		id = task[0]
		string = "UPDATE 'tasks' SET status = 'Working' WHERE ID = #{id}"
		@db.execute(string)
		limit = task[10]
		usertimeout = task[8]
		vms = getvms(id)
		nullprogress(vms)

		times = Array.new(vms.size)
		timef = Array.new(vms.size)
		for i in 0..vms.size-1
			waitstart(times, timef, i, limit, vms[i][1], vms, usertimeout)
		end
		waitclose(times, timef, vms.size-1, limit, vms, usertimeout)
		string = "UPDATE 'tasks' SET status = 'Complete' WHERE ID = #{id}"
		@db.execute(string)
	rescue 
		sleep 1
	end

	#Sharing VMS List 								OK

		#prepare vms 								not released
			#attach VHD 							not released
			#copying files 							not released
			#detach VHD 							not released
		#start vm 									OK	
			#update statuss 						OK
			#calculate progress 					OK...
		#gathering results 							not released
			#copying files in results directory 	not released
			#create link on results 				not released
			#send result on email 					not released
	work()
end
work()