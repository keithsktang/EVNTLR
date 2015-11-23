class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)

    Pusher.trigger('chat', 'new_message', {
      name: current_user.name,
      message: @message.message
    }, {
      socket_id: params[:socket_id]
    })

    respond_to :js
    @message.save
  end

  private
  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:name, :message, :user_id)
  end
end