class Deck < ApplicationRecord

    belongs_to :game
    
    def initiate_deck
        self.unique_id = UUID.new.generate
        self.cards = self.create_deck
        self.cards_drawn = []
        self.save
    end


    def create_deck
        card_values = ['A','2','3','4','5','6','7','8','9','10','J','Q','K']
        card_suits = ['d','c','h','s']
        deck = []

        card_values.each do |card_value|
            card =''
            card_suits.each do |card_suit|
                card = card_value + card_suit
                deck.push(card)
            end
        end
        cards = deck.shuffle
        self.save
        return cards
    end


    def draw_cards(number_of_cards_drawn)
        turn_cards_drawn = []
        for i in 0..(number_of_cards_drawn-1)
            card = self.cards[0]
            turn_cards_drawn.push(card)
            self.cards_drawn.push(card)
            self.cards.shift(1)
        end
        self.save
        return turn_cards_drawn
    end


    def discard_cards(number_of_cards_discarded)
        for i in 0..(number_of_cards_discarded-1)
            self.cards_drawn.push(card = self.cards[0])
            self.cards.shift(1)
        end
        self.save
        return nil
    end
end
