module SlackServices
  module ChannelsImporter
    extend Client

    def import
      channels = client.channels_list.fetch("channels") { [] }
      channels.each do |channel_attributes|
        topic = channel_attributes.fetch("topic", {})
        purpose = channel_attributes.fetch("purpose", {})
        if channel = ::Channel.where(external_id: channel_attributes["id"]).first_or_initialize
          channel.name = channel_attributes.fetch("name", "Noname")
          channel.topic = topic.fetch("value", "Unknown")
          channel.purpose = purpose.fetch("value", "Unknown")
          channel.save!
        end
      end
    end

    module_function :import
  end
end