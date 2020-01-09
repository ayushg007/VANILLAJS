class Interview < ApplicationRecord
    has_many :interview_participants,dependent: :destroy
    has_many :participants, through: :interview_participants
    after_create :reminder

    def self.interview_non_overlap(participant)
        prevInterviews = participant.interviews
        
        for prevInterview in prevInterviews do
          print(@interview.start_time.strftime( "%H%M%S%N" )..@interview.end_time.strftime( "%H%M%S%N" ))
          print(prevInterview.start_time.strftime( "%H%M%S%N" )..prevInterview.end_time.strftime( "%H%M%S%N" ))
          print((@interview.start_time.strftime( "%H%M%S%N" )..@interview.end_time.strftime( "%H%M%S%N" )).overlaps?(prevInterview.start_time.strftime( "%H%M%S%N" )..prevInterview.end_time.strftime( "%H%M%S%N" )))
          print(prevInterview.date == @interview.date) 
          print((@interview.start_time.strftime( "%H%M%S%N" )..@interview.end_time.strftime( "%H%M%S%N" )).overlaps?(prevInterview.start_time.strftime( "%H%M%S%N" )..prevInterview.end_time.strftime( "%H%M%S%N" )))
          if (prevInterview.date == @interview.date) and (@interview.start_time.strftime( "%H%M%S%N" )..@interview.end_time.strftime( "%H%M%S%N" )).overlaps?(prevInterview.start_time.strftime( "%H%M%S%N" )..prevInterview.end_time.strftime( "%H%M%S%N" )) 
            return false
          else
            return true
          end
        end
    end
  # Notify our appointment attendee X minutes before the appointment time
    def reminder
        @twilio_number = ENV['TWILIO_NUMBER']
        account_sid = ENV['TWILIO_ACCOUNT_SID']
        @client = Twilio::REST::Client.new account_sid, ENV['TWILIO_AUTH_TOKEN']
        time_str = ((self.time).localtime).strftime("%I:%M%p on %b. %d, %Y")
        body = "Hi #{self.name}. Just a reminder that you have an appointment coming up at #{time_str}."
        message = @client.messages.create(
        :from => @twilio_number,
        :to => self.email,
        :body => body,
        )
    end

    def when_to_run
        minutes_before_appointment = 30.minutes
        #time - minutes_before_appointment
    end

    handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }

    def self.create_interview(interview_params,emails)
        @interview=Interview.new(interview_params)
        emails=emails.split(",")
        for email in emails do
            participant=Participant.where(["email= :e",{e: email}]).first
            if(not interview_non_overlap(participant))
                return false
            end
        end
        
        return true
    end
    
end
