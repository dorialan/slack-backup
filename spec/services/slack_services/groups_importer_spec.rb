require 'rails_helper'

describe SlackServices::GroupsImporter do
  describe ".import" do
    it 'imports Slack groups' do
      VCR.use_cassette 'groups/list' do
        expect { subject.import }.to change{ Group.count }.from(0).to(11)
      end
    end
  end
end
