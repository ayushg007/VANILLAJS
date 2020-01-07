class InterviewMailer < ApplicationMailer
    def new_interview_email
        @interview = params[:interview]
        @participant = params[:participant]
        mail(to: @participant.email, subject: "Your interview is scheduled!")
      end
    def update_interview_email
        @interview = params[:interview]
        @participant = params[:participant]
        mail(to: @participant.email, subject: "Your interview is updated!")
    end
    def delete_interview_email
        @interview = params[:interview]
        @participant = params[:participant]
        mail(to: @participant.email, subject: "Your interview is Canceled!")
    end
end
