require 'rails_helper'

describe SlackServices::ChannelMessagesImporter do
  describe '#import' do
    let(:channel) do
      Channel.create(external_id: 'C06JU6JNQ', name: 'Some channel')
    end

    it 'imports Slack Channel messages' do
      VCR.use_cassette 'channels/messages' do
        expect { described_class.new(channel).import }
          .to change { channel.messages.count }.from(0).to(8)
        expect(channel.messages.last.posted_at).to be_truthy
      end
    end

    it 'imports all Slack Channel messages' do
      VCR.use_cassette 'channels/all_messages' do
        expect { described_class.new(channel).import(deep: true) }
          .to change { channel.messages.count }.from(0).to(12)
        expect(channel.messages.last.posted_at).to be_truthy
      end
    end
  end
end
