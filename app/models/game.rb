class Game < ApplicationRecord
    has_one :deck
    has_many :hands

    
    def create_game(number_of_players=1)
        self.create_deck()

        for i in 0..(number_of_players-1)
            self.create_hand("player #{i}")
        end
        self.create_hand('dealer')

        # the loop from 0 to number of players include dealing to the dealer
        for i in 0..number_of_players
            self.distribute_cards(self.hands[i],2)
            self.hands[i].calculate_value()
            self.hands[i].save
        end
        self.unique_id = UUID.new.generate
        self.save
    end

    def distribute_cards(hand, number_of_cards_distributed)
        hand.cards = self.deck.draw_cards(number_of_cards_distributed)
        hand.save
    end

    def create_hand(owner)
        hand = Hand.new()
        hand.game = self
        hand.owner = owner
        hand.unique_id = UUID.new.generate
        hand.increment_turn('deal')
        hand.save
        self.save
    end
    
    def create_deck
        deck = Deck.new()
        deck.initiate_deck()
        self.deck = deck
        deck.unique_id = UUID.new.generate
        deck.save
        self.save
    end

    def define_winner
        dealer_hand = self.dealer_hand
        self.deal_dealer_cards()
        dealer_hand.calculate_value()
        dealer_hand_value = self.dealer_hand.value
        self.hands.each do |hand|
            if hand.owner != 'dealer'
                hand.calculate_value()
                if hand.value === 21 && hand.cards.length === 2
                    hand.result = 'blackjack'
                elsif hand.value > 21
                    hand.result = 'lose'
                elsif hand.value <= 21
                    if dealer_hand_value > 21
                        hand.result = 'win'
                    elsif dealer_hand_value <= 21
                        if hand.value > dealer_hand_value 
                            hand.result = 'win'
                        elsif dealer_hand_value === hand.value
                            hand.result = 'push'
                        elsif hand.value < dealer_hand_value 
                            hand.result = 'lose'
                        end
                    end
                end
            end
            hand.save
        end
    end

    def deal_dealer_cards
        # Look for the first hand where the owner is the dealer and hit cards until hand value is superior or equal to 17
        dealer_hand = self.dealer_hand
        while dealer_hand.value < 17
            dealer_hand.hit()
        end
        self.save
    end

    def player_hands
        player_hands = []
        self.hands.each do |hand|
            if hand.owner != 'dealer'
                player_hands.append(hand)
            end
        end
        return player_hands
    end

    def dealer_hand
        return Hand.find_by(game_id: self.id, owner: 'dealer')
    end

    
end
