module SlackServices
  class GroupMessagesImporter
    extend Client

    def initialize(group)
      @group = group
    end

    def import
      messages = self.class.client.groups_history(channel: @group.external_id).fetch("messages", [])
      messages.each do |message|
        import_message(message)
      end
    end

    private

    def import_message(params)
      external_id = params["user"] + params["ts"]
      @group.messages.where(external_id: external_id).first_or_initialize do |message|
        message.text = params["text"]
        message.user = User.where(external_id: params["user"]).first
        message.created_at = params["ts"]
        message.save!
      end
    end
  end
end