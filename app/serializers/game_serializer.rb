class GameSerializer < ActiveModel::Serializer
    has_one :deck
    has_many :hands

    attributes :unique_id


end