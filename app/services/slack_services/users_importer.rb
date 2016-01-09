module SlackServices
  module UsersImporter
    extend Client

    def import
      users = client.users_list.fetch('members') { [] }
      users.each do |user_attributes|
        begin
          import_user(user_attributes)
        rescue => ex
          Rails.logger.error(ex.message)
        end
      end
    end

    def import_user(user_attributes)
      profile = user_attributes.fetch('profile', {})
      user = ::User.find_by(external_id: user_attributes['id'])
      user ||= ::User.new(external_id: user_attributes['id'])
      user.name = user_attributes.fetch('name', 'Noname')
      user.image_url = profile['image_72']
      user.real_name = profile['real_name']
      user.save!
    end

    module_function :import, :import_user
  end
end
