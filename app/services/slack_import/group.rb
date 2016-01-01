module SlackImport
  class Group
    def self.call
      @client ||= Slack::Web::Client.new
      groups = @client.groups_list.fetch("groups") { [] }
      groups.each do |group_attributes|
        topic = group_attributes.fetch("topic", {})
        purpose = group_attributes.fetch("purpose", {})
        if group = ::Group.where(external_id: group_attributes["id"]).first_or_initialize
          group.name = group_attributes.fetch("name", "Noname")
          group.topic = topic.fetch("value", "Unknown")
          group.purpose = purpose.fetch("value", "Unknown")
          group.save!
        end
      end
    end
  end
end