module SlackServices
  class GroupMessagesImporter
    extend Client

    def initialize(group)
      @group = group
    end

    def import(options = {})
      params = {channel: @group.external_id}
      deep = options.fetch(:deep, false)

      messages = get_messages(params, deep)
      messages.each do |message|
        import_message(message) rescue Rails.logger.error($!.message)
      end
    end

    private

    def get_messages(params, deep = true)
      history = self.class.client.groups_history(params)
      messages ||= []
      messages += history.fetch('messages', [])
      if deep && history.fetch('has_more', false)
        new_params = params.merge(latest: messages.last.fetch('ts'))
        messages += get_messages(new_params)
      end
      messages
    end

    def import_message(params)
      external_id = params['user'] + params['ts']
      @group.messages.where(external_id: external_id).first_or_initialize do |message|
        message.text = params['text']
        message.user = User.where(external_id: params['user']).first
        message.posted_at = DateTime.strptime(params['ts'], '%s')
        message.save!
      end
    end
  end
end