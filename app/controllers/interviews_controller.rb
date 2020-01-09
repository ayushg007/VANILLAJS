class InterviewsController < ApplicationController
    before_action :set_interview, only: [:show, :edit, :update, :destroy]
    before_action :set_participant, only: [:show, :edit, :update, :destroy]
    skip_before_action :verify_authenticity_token

    def index
        @interviews=Interview.all
        #@interviews=Interview.order(id: :desc).paginate(page:params[:page],per_page:2)
        #render json:@interviews
        #respond_with(@interviews)
    end

    def new
        @interview=Interview.new
    end

    def create
        if(params[:cancel])
            redirect_to root_path
        elsif(not Interview.create_interview(interview_params,params[:p]))
            flash[:alert]="Sorry couldn't create ...its overlapping with previous participant interviews!!!"
            #render json: {"error":"timing overlaps"}, status: :unprocessable_entity
            #redirect_to new_interview_path
            redirect_to root_path
        else
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
            #render json: @interview
            redirect_to root_path
        end
    end

    def show
        #render json: @interview
    end

    def edit
        #render json: @interview
        #redirect_to root_path
    end

    def update
        if(params[:cancel])
            redirect_to root_path
        else
            @interview.update(interview_params)
            @participants=@interview.participants
            for p in @participants do
                InterviewMailer.with(interview: @interview,participant: p).update_interview_email.deliver_now
            end
            redirect_to root_path
        end

        #render json: @interview
        
      end

      def destroy
        
        for p in @participants do
            InterviewMailer.with(interview: @interview,participant: p).delete_interview_email.deliver_now
        end
        if @interview.destroy
            #head :no_content, status: :ok
          else
            #render json: @interview.errors, status: :unprocessable_entity
          end
        redirect_to interviews_path
      end

    private
        def interview_params
                params.require(:interview).permit(:start_time, :end_time, :title,:date, :p)
        end

        def set_interview
            @interview=Interview.find(params[:id])
        end

        def set_participant
            @participants=@interview.participants
        end

        
end
