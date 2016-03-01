require 'sqlite3'
require 'colorize'
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

def calculateprogress(times, currentvms, usertimeout, mutex)
	timeout = usertimeout + currentvms[5]
	timef = Time.now
	time = timef - times
	progress = time.to_f/timeout.to_f*100
	if progress > 100 
		progress = 100
		vm = VirtualBox::VM.find(currentvms[1].to_s)
		mutex.synchronize do
			vm.stop
		end
		string = "UPDATE 'vms' SET progress = #{progress} WHERE ID = #{currentvms[0]}"
		mutex.synchronize do
			@db.execute(string)
		end
	end

	string = "UPDATE 'vms' SET progress = #{progress} WHERE ID = #{currentvms[0]}"
	@db.execute(string)
end

def copyFiles(i, id)
	system("diskpart /s #{$pathScript}/script_mount#{i}")
	system("diskpart /s #{$pathScript}/script_vm#{i}")
	system("robocopy \"#{$pathFile}/#{id}\" \"#{$pathMount}/#{i}/Test/\" \"*.*\" /NJH /NJS /NS /NC /NDL")
	system("diskpart /s #{$pathScript}/script_unmount#{i}")
end

def work()
	task = gettask()
	if task
		begin
			task = gettask()
			id = task[0]
			string = "UPDATE 'tasks' SET status = 'Working' WHERE ID = #{id}"
			@db.execute(string)
			limit = task[10]
			usertimeout = task[8]
			vms = getvms(id)
			nullprogress(vms)
			threads = []
			mutex = Mutex.new
			@array = Array.new(vms.size-1)
			for i in 0..vms.size-1
				string = "UPDATE 'vms' SET progress = 0 WHERE ID = #{vms[i][0]}"
				@db.execute(string)
			end
			puts "Preparation complete\n limit = #{limit}".yellow
			limit.times do |i|
	    		threads << Thread.new(i) do |j|
	    			for k in 0..vms.size-1
	    				sleep(rand(0.1))
		    			if !@array[k]
			    			@array[k] = 1
			    			puts "Thread: #{i} Started: #{k}".red
			    			copyFiles(i, id)
			    			vm = VirtualBox::VM.find(vms[k][1].to_s)
							mutex.synchronize do
								vm.start
							end
							times = Time.now
							while !vm.powered_off?
								calculateprogress(times, vms[k], usertimeout, mutex)
								sleep 1
							end
							string = "UPDATE 'vms' SET progress = 100 WHERE ID = #{vms[k][0]}"
							mutex.synchronize do
								@db.execute(string)
							end
							puts "Thread: #{i} Stopped: #{k}".red
					    end
					end
				end
			end
			threads.each do |t|
			    begin
			        t.join
			        puts "tdread #{t} joined"
			    rescue RuntimeError => e
			        puts "Failed: #{e.message}"
			    end
			end
			if id
				string = "UPDATE 'tasks' SET status = 'Complete' WHERE ID = #{id}"
				@db.execute(string)
			end
		rescue RuntimeError => e
			puts "Failed: #{e.message}"
		end
	end
	sleep 1
	work()
end
work()