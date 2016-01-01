module SlackServices
  class ChannelMessagesImporter
    extend Client

    def initialize(channel)
      @channel = channel
    end

    def import
      messages = self.class.client.channels_history(channel: @channel.external_id).fetch("messages", [])
      messages.each do |message|
        import_message(message)
      end
    end

    private

    def import_message(params)
      return if params["subtype"]
      external_id = params["user"] + params["ts"]
      @channel.messages.where(external_id: external_id).first_or_initialize do |message|
        message.text = params["text"]
        message.user = User.where(external_id: params["user"]).first
        message.created_at = params["ts"]
        message.save!
      end
    end
  end
end