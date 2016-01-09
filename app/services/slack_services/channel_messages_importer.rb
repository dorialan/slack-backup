module SlackServices
  class ChannelMessagesImporter
    extend Client

    def initialize(channel)
      @channel = channel
    end

    def import(options = {})
      params = { channel: @channel.external_id }
      deep = options.fetch(:deep, false)

      messages = get_messages(params, deep)
      messages.each do |message|
        begin
          import_message(message)
        rescue => ex
          Rails.logger.error(ex.message)
        end
      end
    end

    private

    def get_messages(params, deep = true)
      history = self.class.client.channels_history(params)
      messages ||= []
      messages += history.fetch('messages', [])
      if deep && history.fetch('has_more', false)
        new_params = params.merge(latest: messages.last.fetch('ts'))
        messages += get_messages(new_params)
      end
      messages
    end

    def import_message(params)
      return if params['subtype']
      external_id = params['user'] + params['ts']
      message = @channel.messages.find_by(external_id: external_id)
      message ||= @channel.messages.new(external_id: external_id)
      message.attributes = {
        text: params['text'],
        user: user(params['user']),
        posted_at: posted_at(params['ts'])
      }
      message.save!
    end

    def user(external_id)
      @user ||= User.find_by(external_id: external_id)
    end

    def posted_at(timestamp)
      DateTime.strptime(timestamp, '%s')
    end
  end
end
