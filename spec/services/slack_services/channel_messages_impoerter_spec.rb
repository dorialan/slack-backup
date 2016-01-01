require 'rails_helper'

describe SlackServices::ChannelMessagesImporter do
  describe "#import" do
    let(:channel) { Channel.create(external_id: 'C06JU6JNQ', name: 'Some channel')  }

    it 'imports Slack Channel messages' do
      VCR.use_cassette 'channels/messages' do
        expect { described_class.new(channel).import }.to change{ channel.messages.count }.from(0).to(8)
      end
    end
  end
end
