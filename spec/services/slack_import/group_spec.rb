require 'rails_helper'

describe SlackImport::Group do
  describe ".call" do
    it 'imports Slack groups' do
      VCR.use_cassette 'groups/list' do
        expect { subject.class.call }.to change{ Group.count }.from(0).to(11)
      end
    end
  end
end
