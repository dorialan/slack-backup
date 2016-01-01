class User < ActiveRecord::Base
  validates :name, presence: true
  validates :external_id, presence: true, uniqueness: true

  has_many :messages
end
