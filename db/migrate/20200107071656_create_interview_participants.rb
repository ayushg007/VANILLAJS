class CreateInterviewParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :interview_participants do |t|
      t.references :interview, foreign_key: true
      t.references :participant, foreign_key: true

      t.timestamps
    end
  end
end
