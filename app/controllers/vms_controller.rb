class VmsController < ApplicationController

	before_action :find_vm, only: [:show, :edit, :update, :destroy]
	before_filter :admin

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

	def index
		@vms = Vm.all
	end

	def new
	  @vm = Vm.new
	end

	def create
	  @params = params[:vm]
	  vmss = getVms()
	  @os = ["Windows 2000", "Windows XP", "Windows server 2003", "Windows Vista", "Windows Server 2008", "Windows 7", "Windows Server 2008 R2", "Windows 8", "Windows Server 2012", "Windows 8.1", "Windows Server 2012 R2", "Windows 10"]
	  @keyword = ["win 2000", "xp", "2003", "vista", "2008 x", "7", "2008 R2", "8.0", "2012 A", "8.1", "2012 R2", "10"]
	  @vms = Vm.all
	  for i in 0..@vms.size-1
	  	if vmss.size != 0
			if vmss.to_s.include? "#{@vms[i].vhash}"
			else
				@vms[i].destroy
			end
		else
			puts "No vms"
		end
	  end


	  for i in 0..vmss.size-1
	  	for j in 0..@os.size-1
			if convertVmName(vmss[i]).include? "#{@keyword[j]}"
				@params[:name] = "#{convertVmName(vmss[i])}".to_s
	  			@params[:vhash] = "#{convertVmHash(vmss[i])}"
	  			@params[:subname] = "#{@os[j]}"
	  			@params[:timeout] = 0
	  			@vm = Vm.new(vm_params(@params))
	  			begin
				  if @vm.save
				    @z = "Yes"
				  else
				   	@z = "No"
				  end
				rescue
				end
			end
		end
	  end
	  redirect_to vms_path
	end

	def show
	end

	def edit
	end

	def update
	end

	def destroy
	  @vm.destroy
	  redirect_to vms_path
	end

	def vm_params(parameter)
	  parameter.permit(:name, :vhash, :subname, :name, :timeout)
	end

	private

    def find_vm
      @vm = Vm.find(params[:id])
    end
	
end
