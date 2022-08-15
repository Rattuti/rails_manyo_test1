class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :tittle
      t.string :content
      t.timestamps
      t.date :deadline_on
      t.integer :priority
      t.integer :status
    end
  end
end
