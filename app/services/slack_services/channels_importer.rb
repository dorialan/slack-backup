module SlackServices
  module ChannelsImporter
    extend Client

    def import
      channels = client.channels_list.fetch('channels') { [] }
      channels.each do |channel_attributes|
        begin
          import_channel(channel_attributes)
        rescue => ex
          Rails.logger.error(ex.message)
        end
      end
    end

    def import_channel(channel_attributes)
      external_id = channel_attributes.fetch('id') do
        fail 'Channel has no ID!'
      end

      topic = channel_attributes.fetch('topic', {})
      purpose = channel_attributes.fetch('purpose', {})

      params = {
        name: channel_attributes.fetch('name', 'Noname'),
        topic: topic.fetch('value', 'Unknown'),
        purpose: purpose.fetch('value', 'Unknown')
      }

      create_or_update_channel(external_id, params)
    end

    def create_or_update_channel(external_id, params)
      channel = ::Channel.where(external_id: external_id).first_or_initialize
      return unless channel
      channel.attributes = params
      channel.save!
    end

    module_function :import, :import_channel, :create_or_update_channel
  end
end
