class Group < Messageable
  has_many :messages, as: :messageable
end
