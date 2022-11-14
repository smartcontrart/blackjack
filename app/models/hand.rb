class Hand < ApplicationRecord
    belongs_to :game

    def hit
        self.cards.append(self.game.deck.draw_cards(1)[0])
        self.calculate_value()
        self.increment_turn('hit')
        self.save
    end
    
    def stand
        self.increment_turn('stand')
        self.save
    end

    def split
        # Create a new hand wich is the splitted hand
        splitted_hand = Hand.create(owner: self.owner, game: self.game, unique_id: UUID.new.generate)
        
        # Transfer the second card of the original hand to the splitted hand
        splitted_hand.cards.append(self.cards[1])
        
        # Add the splitted hand to the array of hands for the current game
        self.game.hands << splitted_hand
        # Remove the transfered cards from the original hand
        self.cards.pop()
        
        # Increment the turn to add a split
        self.increment_turn('split')
        splitted_hand.increment_turn('split')
        
        # Calculate the value of both hands
        self.calculate_value()
        splitted_hand.calculate_value()
        
        # Save the new state of the game and both hands
        splitted_hand.save
        self.save
    end


    #need to refactor calculate_value and calculate_card_value so they work with one another
    def calculate_value
        card_values_hash = {'A'=> 1,'2'=> 2,'3'=> 3,'4'=> 4,'5'=> 5,'6'=> 6,'7'=> 7,'8'=> 8,'9'=> 9,'10'=> 10,'J'=> 10,'Q'=> 10,'K'=> 10}
        hand_value = 0
        number_of_aces = 0
        self.cards.each do |card|
            if card[0] == 'A'
                number_of_aces += 1
            else
                hand_value += card_values_hash[card.slice(0,card.length-1)]
            end
        end

        if number_of_aces > 0
            if hand_value > 10
                hand_value += number_of_aces
            elsif hand_value == 10
                if number_of_aces == 1
                    hand_value += 11
                else
                    hand_value += number_of_aces
                end
            else
                if hand_value + 11 + number_of_aces -1 > 21
                    hand_value += number_of_aces
                else
                    hand_value += 11 + number_of_aces -1
                end
            end
        end
        self.value = hand_value
        self.save
    end

    def calculate_card_value(card)
        # Value of Aces is 11 vs 1 above - to be refactored
        card_values_hash = {'A'=> 11,'2'=> 2,'3'=> 3,'4'=> 4,'5'=> 5,'6'=> 6,'7'=> 7,'8'=> 8,'9'=> 9,'10'=> 10,'J'=> 10,'Q'=> 10,'K'=> 10}
        return card_values_hash[card.slice(0,card.length-1)]
        
    end


    def increment_turn(action)
        self.turn.append(action)
    end

end
