class Poker
  attr_reader :hands
  
  def initialize hands
    @hands = hands.map { |hand| Hand.new hand }
  end

  def best_hand
    [ hands.max_by { |hand| hand.rank }.to_a ]
  end
  
  private

  class Hand
    attr_reader :cards

    def initialize cards
      @cards = cards.map { |card| Card.new card }
    end

    def rank
      if a_pair?
        pair = ranks.group_by { |rank| rank }.select { |rank, cards| cards.size == 2 }.keys.first
        return [1, ranking(pair)]
      end
        
      [0, ranks.map { |card| ranking card }.max]
    end

    def to_a
      cards.map { |card| card.to_s }
    end

    private

    def ranks
      cards.map { |card| card.rank }
    end

    def a_pair?
      ranks.group_by { |rank| rank }.one? { |rank, cards| cards.size == 2 }
    end

    def ranking card
      Card::RANKS.index card   
    end

    class Card
      attr_reader :rank, :suit
 
      def initialize card
        @rank = card[/\d+|[JQKA]/]
        @suit = card[/[CDHS]/]
      end

      def ranking card
        RANKS.index card      
      end
   
      def to_s
        "#{rank}#{suit}"
      end
     
      private

      RANKS = %w{2 3 4 5 6 7 8 9 10 J Q K A} 
    end
  end
end

module BookKeeping
  VERSION = 2
end