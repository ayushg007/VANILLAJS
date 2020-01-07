class ParticipantsController < ApplicationController
    before_action :set_participant, only: [:show, :edit, :update, :destroy]
    def index
        @participants=Participant.all
        #@participants=participant.order(id: :desc).paginate(page:params[:page],per_page:2)
    end

    def new
        @participant=Participant.new
    end

    def create
        @participant = Participant.create(participant_params)
        #participantMailer.with(participant: @participant).new_participant_email.deliver_now
        flash[:success] = "Thank you for your participant! We'll get contact you soon!"
        redirect_to participants_path
    end

    def show
    end

    def edit
    end

    def update
        @participant.update(participant_params)
        #participantMailer.with(participant: @participant).update_participant_email.deliver_now
        redirect_to(participant_path(@participant))
      end

      def destroy
        @participant.destroy
        #participantMailer.with(participant: @participant).delete_participant_email.deliver_now
        redirect_to participants_path
      end

    private
        def participant_params
            params.require(:participant).permit(:email, :resume )
        end

        def set_participant
            @participant=participant.find(params[:id])
        end

end
