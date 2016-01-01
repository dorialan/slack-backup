require 'rails_helper'

describe SlackImport::Channel do
  describe ".call" do
    it 'imports Slack channels' do
      VCR.use_cassette 'channels/list' do
        expect { subject.class.call }.to change{ Channel.count }.from(0).to(3)
      end
    end
  end
end
