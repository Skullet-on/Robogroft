require 'sqlite3'
require 'colorize'
require 'virtualbox'
require File.expand_path("../app/config.rb", __FILE__)


def copyFiles(i, id)
	#system("diskpart /s #{$pathScript}/script_mount#{i}")
	#system("diskpart /s #{$pathScript}/script_vm#{i}")
	#system("robocopy \"#{$pathFile}/#{id}\" \"#{$pathMount}/#{i}/Test/\" \"*.*\" /NJH /NJS /NS /NC /NDL")
	system("diskpart /s #{$pathScript}/script_unmount#{i}")
end
for i in 0..3
	copyFiles(i, 10)
end