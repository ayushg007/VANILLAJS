class AddAttachmentResumeToParticipants < ActiveRecord::Migration[4.2]
  def self.up
    change_table :participants do |t|
      t.attachment :resume
    end
  end

  def self.down
    remove_attachment :participants, :resume
  end
end
