class GamesController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def create
        @game = Game.new
        @game.create_game(10)

        render json: {game_unique_id: @game.unique_id, 
                      player_hands: @game.player_hands, 
                      dealer_hand: [@game.dealer_hand.cards[1]],
                      dealer_hand_value: @game.dealer_hand.calculate_card_value(@game.dealer_hand.cards[1])
                    }
    end

    def hit
        # Need to select the right game with the UUID
        # binding.pry
        @game = Game.find_by(unique_id: params[:active_game_unique_id])
        @hand = Hand.find_by(unique_id: params[:active_hand_unique_id])
        @hand.hit
        render json: {game_unique_id: @game.unique_id, 
                      player_hands: @game.player_hands, 
                      dealer_hand: [@game.dealer_hand.cards[1]],
                      dealer_hand_value: @game.dealer_hand.calculate_card_value(@game.dealer_hand.cards[1])
                    }
    end

    # def stand
    #     # Need to select the right game with the UUID
    #     @game = Game.find_by(unique_id: params[:active_game_unique_id])
    #     @hand = Hand.find_by(unique_id: params[:active_hand_unique_id])
    #     @hand.stand
    #     render json: {game_unique_id: @game.unique_id, 
    #                   player_hands: @game.player_hands, 
    #                   dealer_hand: @game.dealer_hand.cards}
    # end

    def split
        @game = Game.find_by(unique_id: params[:active_game_unique_id])
        @hand = Hand.find_by(unique_id: params[:active_hand_unique_id])
        @hand.split
        render json: {game_unique_id: @game.unique_id, 
                      player_hands: @game.player_hands, 
                      dealer_hand: [@game.dealer_hand.cards[1]],
                      dealer_hand_value: @game.dealer_hand.calculate_card_value(@game.dealer_hand.cards[1])}
    end

    def end
        @game = Game.find_by(unique_id: params[:active_game_unique_id])
        @hand = Hand.find_by(unique_id: params[:active_hand_unique_id])
        @game.define_winner
        render json: {game_unique_id: @game.unique_id, 
                      player_hands: @game.player_hands, 
                      dealer_hand: @game.dealer_hand.cards,
                    dealer_hand_value: @game.dealer_hand.value}
    end

end
