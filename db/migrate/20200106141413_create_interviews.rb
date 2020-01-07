class CreateInterviews < ActiveRecord::Migration[5.1]
  def change
    create_table :interviews do |t|
      t.time :start_time
      t.time :end_time
      t.string :title

      t.timestamps
    end
  end
end
