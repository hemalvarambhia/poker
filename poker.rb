class Poker
  attr_reader :hands
  def initialize hands
    @hands = hands.map { |hand| Hand.new hand }
  end

  def best_hand
    [ hands.max_by { |hand| hand.rank }.cards ]
  end
  
  private

  class Hand
    attr_reader :cards

    def initialize cards
      @cards = cards
    end

    def rank
      ranks = cards.map { |card| card_rank card }
        
      ranks.map { |card| RANKS.index card }.max
    end

    private

    def card_rank card
      card[/\d+|[JQKA]/]
    end

    RANKS = %w{2 3 4 5 6 7 8 9 10 J Q K A} 
  end

  def rank hand
    Hand.new(hand).rank
  end
end

module BookKeeping
  VERSION = 2
end