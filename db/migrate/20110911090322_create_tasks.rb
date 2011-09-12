class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :task
      t.integer :level
      t.integer :parent_id
      t.references :category

      t.timestamps
    end
    add_index :tasks, :category_id
  end
end
