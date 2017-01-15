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
      if flush?
        return [5]
      end
      
      if straight?
        rank_of_straight = STRAIGHTS.index ranks
        return [4, rank_of_straight]
      end
      
      if three_of_a_kind?
        three_of_kind =
          ranks.group_by { |rank| rank }.
          select { |rank, cards| cards.size == 3 }.keys.first
        return [3, ranking(three_of_kind) ]
      end
      
      if two_pair?
        ordered_pair_ranks =
          [ ranking(pairs.first), ranking(pairs.last) ].sort.reverse
        return [2] + ordered_pair_ranks
      end
      
      if a_pair?
        pair = pairs.first
        return [1, ranking(pair)]
      end
        
      [0, ranks.map { |card| ranking card }.max]
    end

    def to_a
      cards.map { |card| card.to_s }
    end

    private

    STRAIGHTS = [
      %w{2 3 4 5 6},
      %w{2 3 4 5 A},
      %w{7 8 9 10 J},
    ]

    def ranks
      cards.map { |card| card.rank }.sort_by { |rank| ranking rank }
    end

    def flush?
      cards.uniq { |card| card.suit }.one?
    end

    def straight?
      STRAIGHTS.include? ranks
    end

    def three_of_a_kind?
      ranks.group_by { |rank| rank }.one? { |rank, cards| cards.size == 3 }
    end

    def two_pair?
      pairs.size == 2
    end

    def a_pair?
      pairs.one?
    end

    def pairs
      ranks.
        group_by { |rank| rank }.
        select { |rank, cards| cards.size == 2 }.keys
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
