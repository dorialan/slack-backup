module SlackServices
  module GroupsImporter
    extend Client

    def import
      groups = client.groups_list.fetch('groups') { [] }
      groups.each do |group_attributes|
        begin
          import_group(group_attributes)
        rescue => ex
          Rails.logger.error(ex.message)
        end
      end
    end

    def import_group(group_attributes)
      external_id = group_attributes.fetch('id') do
        fail 'Channel has no ID!'
      end
      topic = group_attributes.fetch('topic', {})
      purpose = group_attributes.fetch('purpose', {})

      group = ::Group.where(external_id: external_id).first_or_initialize
      group.name = group_attributes.fetch('name', 'Noname')
      group.topic = topic.fetch('value', 'Unknown')
      group.purpose = purpose.fetch('value', 'Unknown')
      group.save!
    end

    module_function :import, :import_group
  end
end
