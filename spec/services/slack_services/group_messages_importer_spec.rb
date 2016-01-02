require 'rails_helper'

describe SlackServices::GroupMessagesImporter do
  describe "#import" do
    let(:group) { Group.create(external_id: 'G06JV4K5L', name: 'Some group')  }

    it 'imports Slack Group messages' do
      VCR.use_cassette 'groups/messages' do
        expect { described_class.new(group).import }.to change{ group.messages.count }.from(0).to(100)
        expect(group.messages.last.posted_at).to be_truthy
      end
    end

    it 'imports all Slack Group messages' do
      VCR.use_cassette 'groups/all_messages' do
        expect { described_class.new(group).import(deep: true) }.to change{ group.messages.count }.from(0).to(1034)
        expect(group.messages.last.posted_at).to be_truthy
      end
    end
  end
end
