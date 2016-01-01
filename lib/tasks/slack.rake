namespace :slack do
  desc "Import users, groups, channels and messages from Slack"
  task import: :environment do
    Rails.logger.info "Importing users"
    SlackServices::UsersImporter.import

    Rails.logger.info "Importing groups"
    SlackServices::GroupsImporter.import

    Rails.logger.info "Importing channels"
    SlackServices::ChannelsImporter.import

    Rails.logger.info "Importing messages"
    Group.all.each do |group|
      SlackServices::GroupMessagesImporter.new(group).import
    end

    Channel.all.each do |channel|
      SlackServices::ChannelMessagesImporter.new(channel).import
    end

    Rails.logger.info "Done Slack importing!"
  end

end
