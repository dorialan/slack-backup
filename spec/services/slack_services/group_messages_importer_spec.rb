require 'rails_helper'

describe SlackServices::GroupMessagesImporter do
  describe "#import" do
    let(:group) { Group.create(external_id: 'G08CT1V6V', name: 'Some group')  }

    it 'imports Slack Group messages' do
      VCR.use_cassette 'groups/messages' do
        expect { described_class.new(group).import }.to change{ group.messages.count }.from(0).to(22)
      end
    end
  end
end
