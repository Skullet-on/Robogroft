require 'sqlite3'
$pathVBox="\"C:/Program Files/Oracle/VirtualBox/VboxManage.exe\""
@os = ["Windows 2000", "Windows XP", "Windows server 2003", "Windows Vista", "Windows Server 2008", "Windows 7", "Windows Server 2008 R2", "Windows 8", "Windows Server 2012", "Windows 8.1", "Windows Server 2012 R2", "Windows 10"]
@keyword = ["win 2000", "xp", "2003", "vista", "2008 x", "7", "2008 R2", "8.0", "2012 A", "8.1", "2012 R2", "10"]

def getVms()
  @vmslistraw = `#{$pathVBox} list vms`
  @vmlist = @vmslistraw.split(/\n/)
  return @vmlist
end

def convertVmName(vmName)
  newName = vmName.delete("\"").split(" {")
  return newName[0]
end

def convertVmHash(vmName)
  newName = vmName.scan(/(\{[\w-]+\})/)
  return newName[0][0]
end

db = SQLite3::Database.new("D:/projects/robogroft/db/development.sqlite3")
array = db.execute("SELECT * FROM users")
vmss = getVms()
for i in 0..vmss.size-1
	for j in 0..@os.size-1
		if convertVmName(vmss[i]).include? "#{@keyword[j]}"
			puts "#{i} : #{vmss[i]} : #{@os[j]}"
			db.execute("INSERT INTO vms (name, hash, subname, state, progress) VALUES ('#{convertVmName(vmss[i])}', '#{convertVmHash(vmss[i])}', '#{@os[j]}', 'waiting', '0.0')")
		end
	end
	#puts "#{i} : #{vmss[i]}"
	#puts "name : #{convertVmName(vmss[i])}\n"
	#puts "hash : #{convertVmHash(vmss[i])}\n\n"
end