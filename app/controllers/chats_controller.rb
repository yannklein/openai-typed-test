class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: %i[show]

  def show
    @message = Message.new
  end

  def create
    @chat = Chat.create(user: current_user)
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end
end
