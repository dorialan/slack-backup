require 'rails_helper'

RSpec.describe User, type: :model do
  it 'validates name presence' do
    expect(subject).to have(1).error_on(:name)
  end

  it 'validates name external id presence' do
    expect(subject).to have(1).error_on(:external_id)
  end
end
