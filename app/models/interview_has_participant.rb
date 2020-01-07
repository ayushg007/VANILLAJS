class InterviewHasParticipant < ApplicationRecord
    belongs to :interview
    belongs to :participant
end
