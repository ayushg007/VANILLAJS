class InterviewsController < ApplicationController
    before_action :set_interview, only: [:show, :edit, :update, :destroy]
    before_action :set_participant, only: [:show, :edit, :update, :destroy]
    def index
        @interviews=Interview.all
        #@interviews=Interview.order(id: :desc).paginate(page:params[:page],per_page:2)
    end

    def new
        @interview=Interview.new
    end

    def create
        if(not Interview.create_interview(interview_params,params[:p]))
            flash[:alert]="Overlap"
            redirect_to "google.com"
        end
        
        #@interview = Interview.create(interview_params)
        emails=params[:p]
        emails=emails.split(",")
        @interview=Interview.create(interview_params)
        for email in emails do
            participant=Participant.where(["email= :e",{e: email}]).first
            @interview.participants << participant
            InterviewMailer.with(interview: @interview, participant: participant).new_interview_email.deliver_now
        end
        flash[:success] = "Thank you for your interview! We'll get contact you soon!"
        redirect_to interviews_path
    end

    def show
    end

    def edit
    end

    def update
        @interview.update(interview_params)
        @participants=@interview.participants
        for p in @participants do
            InterviewMailer.with(interview: @interview,participant: p).update_interview_email.deliver_now
        end

        
        redirect_to(interview_path(@interview))
      end

      def destroy
        
        for p in @participants do
            InterviewMailer.with(interview: @interview,participant: p).delete_interview_email.deliver_now
        end
        @interview.destroy
        redirect_to interviews_path
      end

    private
        def interview_params
            params.require(:interview).permit(:start_time, :end_time, :title, :p)
        end

        def set_interview
            @interview=Interview.find(params[:id])
        end

        def set_participant
            @participants=@interview.participants
        end
end
