class CreateInterviewHasParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :interview_has_participants do |t|
      t.references :interview, null: false, foreign_key: true
      t.references :participants, null: false, foreign_key: true
      t.timestamps
    end
  end
end
