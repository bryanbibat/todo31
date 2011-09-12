class TasksController < ApplicationController
  def index
    @tasks = Task.hierarchical_list
    @task = Task.new level: 3
    @categories = Category.all
  end

  def create
    @task = Task.new(params[:task])
    if @task.save
      redirect_to root_path
    else
      @tasks = Task.hierarchical_list
      render action: :index
    end
  end

  def complete
    @task = Task.find(params[:id])
    @task.complete
    redirect_to root_path, :notice => "Task \"#{@task.task}\" marked as completed"
  end

end
