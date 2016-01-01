require 'rails_helper'

describe SlackServices::ChannelsImporter do
  describe ".import" do
    it 'imports Slack channels' do
      VCR.use_cassette 'channels/list' do
        expect { subject.import }.to change{ Channel.count }.from(0).to(3)
      end
    end
  end
end
