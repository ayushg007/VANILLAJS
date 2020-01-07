class Participant < ActiveRecord::Base
    validates :resume, presence: true
    has_attached_file :resume 
    validates_attachment_content_type :resume, content_type: [ 'application/pdf']

    has_many :interview_participants,dependent: :destroy
    has_many :interviews, through: :interview_participants
end
