module SlackServices
  module Client
    def client
      Slack::Web::Client.new
    end
  end
end
