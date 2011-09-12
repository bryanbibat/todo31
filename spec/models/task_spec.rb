require 'spec_helper'

describe Task do
  it "should check for existence of task" do
    task = Task.new
    task.should_not be_valid
    task.errors[:task].should include "can't be blank"
  end

  it "should check if level is valid" do
    [0, 6].each do |level|
      task = Task.new task: "dummy task", level: level
      task.should_not be_valid
      task.errors[:level].should include "is not included in the list"
    end
  end
   
  it "should set the default level to 3" do
    task = Task.new task: "dummy task"
    task.should be_valid
    task.save
    task.reload
    task.level.should == 3
  end

  it "should have sub tasks" do
    task = Task.create task: "dummy task", level: 3
    subtask = Task.create task: "dummy subtask", parent: task, level: 2
    subtask2 = Task.create task: "dummy subtask 2", parent: task, level: 1

    task.reload
    task.sub_tasks.should eq([subtask, subtask2])
    subtask.reload
    subtask.parent.should == task
  end

  it "should only have parent tasks with higher level" do
    task = Task.create task: "dummy task", level: 3
    subtask = Task.create task: "dummy task", level: 4, parent: task
    subtask.should_not be_valid
    subtask.errors[:parent_id].should include "should be of higher level than task"
    subtask.level = 2
    subtask.should be_valid
    subtask.level = 3
    subtask.should_not be_valid
    subtask.errors[:parent_id].should include "should be of higher level than task"
  end

  it "should return hierarchical list on hierarchical list" do
    task = Task.create task: "dummy task", level: 5
    subtask = Task.create task: "dummy subtask", parent: task, level: 4
    subtask2 = Task.create task: "dummy subtask 2", parent: subtask, level: 3
    subtask3 = Task.create task: "dummy subtask 3", parent: subtask2, level: 2
    subtask4 = Task.create task: "dummy subtask 4", parent: subtask3, level: 1

    tasks = Task.hierarchical_list
    top = tasks[0]
    top.should == task
    top = top.sub_tasks[0]
    top.should == subtask
    top = top.sub_tasks[0]
    top.should == subtask2
    top = top.sub_tasks[0]
    top.should == subtask3
    top = top.sub_tasks[0]
    top.should == subtask4
  end

end
