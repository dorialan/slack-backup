module SlackServices
  module UsersImporter
    extend Client

    def import
      users = client.users_list.fetch('members') { [] }
      users.each do |user_attributes|
        import_user(user_attributes) rescue Rails.logger.error($!.message)
      end
    end

    def import_user(user_attributes)
      profile = user_attributes.fetch('profile', {})
      user = ::User.where(external_id: user_attributes['id']).first_or_initialize
      user.name = user_attributes.fetch('name', 'Noname')
      user.image_url = profile['image_72']
      user.real_name = profile['real_name']
      user.save!
    end

    module_function :import, :import_user
  end
end
