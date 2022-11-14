class HandSerializer < ActiveModel::Serializer
    belongs_to :game
    
    attributes :unique_id, :cards, :owner, :value, :result, :turn, :game_id
    
end
