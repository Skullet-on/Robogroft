require 'colorize'
threads = []
mutex = Mutex.new
array = Array.new(10)
arr = 0 

def setarr(i, mutex)
	mutex.synchronize do
		arr = i
		puts "#{arr}"
	end
end

3.times do |i|
    threads << Thread.new(i) do |j|
    	for k in 0..9
			if !array[k]
    			array[k] = 1
	    		puts "Thread: #{i} Started: array #{k}".red
	    		time = Time.now
	    		while Time.now - time < 10
	    			setarr(i, mutex)
	    			#mutex.synchronize do
				    #	arr = i
				    #	puts "#{arr}"
				    #end
			    end
			    puts "Thread: #{i} End".green
			    puts "End: array #{k}".yellow
		    end
	    end
    end
end

threads.each do |t|
    begin
        t.join
        rescue RuntimeError => e
        puts "Failed: #{e.message}"
    end
end 