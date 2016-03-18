require 'colorize'
#require 'virtualbox'
#require File.expand_path("../app/config.rb", __FILE__)

=begin
vm = VirtualBox::VM.find("win xp x86 sp2 IDE")

puts "#{vm.name}".green
puts "#{vm.uuid}".green

hdd = VirtualBox::HardDrive.all

for i in 0..hdd.size-1
	puts hdd[i].machines
	#puts hdd[i].filename
end
hd = VirtualBox::HardDrive.find("#{hdd[2].uuid}")


puts "#{hdd[1].uuid}".green
puts "#{hd.filename}".green
puts vm.storage_controllers[0].medium_attachments[0].type
vm.storage_controllers[0].medium_attachments << hdd[1].uuid
vm.storage_controllers[0].save
vm.storage_controllers[0].medium_attachments << hdd[1]
puts "#{hdd[1].medium}".red

puts "#{hdd[1].uuid}".yellow 
puts "#{hdd[1].filename}".yellow
puts vm.storage_controllers[0].medium_attachments[1].type
puts vm.storage_controllers[0].medium_attachments[1].port
puts vm.storage_controllers[0].medium_attachments[1].device
puts vm.storage_controllers[0].medium_attachments[1].medium.location
puts vm.storage_controllers[0].medium_attachments[1].medium.uuid
=end

#string = "#{$pathVBox} storageattach \"win xp x86 sp2 IDE\" --storagectl \"IDE\" --device 0 --port 1 --type hdd --medium \"d:/Vhd/0.vhd\" && echo %errorlevel%"
#string = "#{$pathVBox} storageattach {44bb4cce-0eab-48fd-a739-d50d213b06d9} --storagectl \"IDE\" --port 1 --device 0 --type hdd --medium \"d:\\Vhd\\2.vhd\""
#string2 = "#{$pathVBox} startvm \"win 7 x86 sp1 AHCI\""
#puts string
#exec(string)
#output = `env`
output = `"C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage.exe" storageattach "win xp x86 sp2 IDE" --storagectl storage --port 1 --device 0 --type hdd --medium "d:\\Vhd\\3.vhd"`
puts output
#C:\Program Files\Oracle\VirtualBox>VBoxManage storageattach "win xp x86 sp2 IDE"
# --storagectl "IDE контроллер" --device 0 --port 1 --type hdd --medium "d:\Vhd\2
#.vhd"
#rem   --storagectl "IDE" --device 0 --port 1 --type hdd --medium "d:\Vhd\2.vhd"
#rem "win xp x86 sp2 IDE"
#rem C