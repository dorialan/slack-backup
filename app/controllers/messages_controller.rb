class MessagesController < ApplicationController
  before_action :get_messageable, only: :index

  def index
    @messages = @messageable.messages.order(posted_at: :desc).page params[:page]
    @messageables = Messageable.all
  end

  private

  def get_messageable
    @messageable = Messageable.find(messageable_id)
  end

  def messageable_id
    params.fetch("messageable_id") { Messageable.first.id }
  end
end
