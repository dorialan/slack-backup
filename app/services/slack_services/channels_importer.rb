module SlackServices
  module ChannelsImporter
    extend Client

    def import
      channels = client.channels_list.fetch('channels') { [] }
      channels.each do |channel_attributes|
        import_channel(channel_attributes) rescue Rails.logger.error($!.message)
      end
    end

    def import_channel(channel_attributes)
      external_id = channel_attributes.fetch('id') {
        raise 'Channel has no ID!'
      }
      topic = channel_attributes.fetch('topic', {})
      purpose = channel_attributes.fetch('purpose', {})

      if channel = ::Channel.where(external_id: external_id).first_or_initialize
        channel.name = channel_attributes.fetch('name', 'Noname')
        channel.topic = topic.fetch('value', 'Unknown')
        channel.purpose = purpose.fetch('value', 'Unknown')
        channel.save!
      end
    end

    module_function :import, :import_channel
  end
end
