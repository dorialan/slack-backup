require 'rails_helper'

RSpec.describe Group, type: :model do
  it 'validates name' do
    expect(subject).to have(1).error_on(:name)
  end

  it 'validates external_id' do
    expect(subject).to have(1).error_on(:external_id)
  end
end
