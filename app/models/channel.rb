class Channel < Messageable
  has_many :messages, as: :messageable
end
