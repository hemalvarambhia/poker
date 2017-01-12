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

      if a_pair?
        pair = ranks.group_by { |rank| rank }.select { |rank, cards| cards.size == 2 }.keys.first
        return [1, ranking(pair)]
      end
        
      [0, ranks.map { |card| ranking card }.max]
    end

    private

    def a_pair?
      ranks = cards.map { |card| card_rank card }

      ranks.group_by { |rank| rank }.one? { |rank, cards| cards.size == 2 }
    end

    def card_rank card
      card[/\d+|[JQKA]/]
    end

    def ranking card
      RANKS.index card      
    end

    RANKS = %w{2 3 4 5 6 7 8 9 10 J Q K A} 
  end
end

module BookKeeping
  VERSION = 2
end