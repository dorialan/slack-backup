class Messageable < ActiveRecord::Base
  validates :name, presence: true
  validates :external_id, presence: true, uniqueness: true
end
