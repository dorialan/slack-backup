class MessagesController < ApplicationController
  def index
    @messages = messageable.messages.order(posted_at: :desc).page params[:page]
    @messageables = Messageable.all
  end

  private

  def messageable
    @messageable ||= Messageable.find(messageable_id)
  end

  def messageable_id
    params.fetch('messageable_id') { Messageable.first.id }
  end
end
