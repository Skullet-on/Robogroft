class TasksController < ApplicationController

	before_action :find_task, only: [:edit, :show, :update, :destroy]
	before_filter :authenticate, :except => [:new, :create, :pending, :current]

	def index
	  #@tasks = Task.all
	  @tasks = Task.where(user_id: current_user.id)
	end

	def new
	  @task = Task.new
	  @time = DateTime.now.strftime('%Q')
	  vmss = getVms()
	  @machines = Array.new(vmss.size, obj=nil)
	  @Computers = Struct.new( :name, :state)
	  for i in 0..vmss.size-1
	    @machines[i] = @Computers.new("#{convertVmName(vmss[i])}","#{vmss[i]}")
	  end
	  @os = ["Windows 2000", "Windows XP", "Windows server 2003", "Windows Vista", "Windows Server 2008", "Windows 7", "Windows Server 2008 R2", "Windows 8", "Windows Server 2012", "Windows 8.1", "windows Server 2012 R2", "Windows 10"]
	  @keyword = ["win 2000", "xp", "2003", "vista", "2008 x", "7", "2008 R2", "8.0", "2012 A", "8.1", "2012 R2", "10"]
	  @vms = Vm.all
	end

	def create
	  @task = Task.new(task_params)
	  if @task.save
	    current_user.tasks << @task
	    redirect_to @task
	  else
	   render 'new'
	  end
	end

	def show
	  #action find_task
	end

	def edit
	  #action find_task    
	end

	def update
	  #action find_task 
	  @params = params[:task]
	  @task.update_attributes(task_params(@params))
	  if @task.errors.empty?
	    redirect_to task_path(@task)
	  else
	    render "edit"
	  end
	end
	  
	def destroy
	  #action find_task  
	  @task.destroy
	  redirect_to tasks_path
	end

	def task_params(parameter)
	  parameter.permit(:name, :cmd, :file, :status, :progress, {:email => []}, :timeout, :restore, :number, :priority)
	end

	def find_task
	  @task = Task.find(params[:id])
	  if @task.user_id == current_user.id
	  	true
	  else
	  	redirect_to tasks_path
	  end
	end

	def upload
		@parameters = params
		@params = params[:task]
		if @params[:file]
			@params[:file] = @params[:file][0].original_filename
		else
			@params[:file] = nil
		end
		@params[:email] << "#{current_user.email}"
		@params[:status] = "Wait"
		@params[:progress] = 0
		@params[:timeout] =  @params[:timeout].to_i
		@params[:number] = @params[:number].to_i
		@params[:priority] = 0
		@task = Task.new(task_params(@params))
		if @task.save
			@task.priority = @task.id
		else
			render 'new'
		end
		if @task.save
		  	current_user.tasks << @task
		  		@vms = Vm.where(:id => @params[:vms])
		  		@task.vms << @vms
		   	redirect_to @task
		else
		   	render 'new'
		end
	end

	def pending
	  @task = Task.new
	  @tasks = Task.all.order("priority")
	end

	def current
	  @task = Task.new
	  @tasks = Task.where(status: "Working")
	end

  private

	def getVms()
	  @vmslistraw = `#{$pathVBox} list vms`
	  @vmlist = @vmslistraw.split(/\n/)
	  return @vmlist
	end

	def convertVmName(vmName)
	  newName = vmName.delete("\"").split(" {")
	  return newName[0]
	end

end
