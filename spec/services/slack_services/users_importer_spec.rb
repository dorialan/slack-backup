require 'rails_helper'

describe SlackServices::UsersImporter do
  describe '.import' do
    it 'imports Slack users' do
      VCR.use_cassette 'users/list' do
        expect { subject.import }.to change { User.count }.from(0).to(4)
      end
    end
  end
end
