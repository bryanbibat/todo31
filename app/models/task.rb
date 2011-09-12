class Task < ActiveRecord::Base
  belongs_to :category
  belongs_to :parent, class_name: "Task"
  has_many :sub_tasks, class_name: "Task", foreign_key: :parent_id, conditions: { completed: false }

  validates_presence_of :task
  validates_inclusion_of :level, :in => 1..5
  validate :parent_should_be_higher_level, :unless => "parent_id.blank?"

  before_validation :set_default_level

  LevelNames = %w{ Action Objective Task Quest Epic }
  LevelTooltips = [ "Actions should only take minutes to finsh",
    "Objectives can take hours to finsh",
    "Tasks can take days to finsh",
    "Quests can take weeks to finsh",
    "Epics can take months to finish" ]

  def self.level_dropdown
    (1..5).map { |idx| [LevelNames[idx - 1], idx] }.reverse
  end

  def level_class
    LevelNames[level - 1].downcase
  end

  def self.hierarchical_list
    where(parent_id: nil, completed: false).includes(sub_tasks: {sub_tasks: {sub_tasks: {sub_tasks: :sub_tasks}}})
  end

  def complete
    self.update_attributes completed: true
  end

  def tooltip
    "Entry created: #{created_at} (#{LevelTooltips[level-1]})"
  end

  private

  def parent_should_be_higher_level
    unless parent.level > level
      errors.add :parent_id, "should be of higher level than task"
    end
  end

  def set_default_level
    self.level = 3 if level.blank?
  end
end
