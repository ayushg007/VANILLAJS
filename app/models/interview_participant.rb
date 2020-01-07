class InterviewParticipant < ApplicationRecord
  
  belongs_to :interview
  belongs_to :participant

  
end
