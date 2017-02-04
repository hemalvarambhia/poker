class Poker
  attr_reader :hands
  
  def initialize hands
    @hands = hands.map { |hand| Hand.new hand }
  end

  def best_hand
    return [ hands.max_by { |hand| hand.rank }.to_a ] if hands.size == 2

    hands.max_by(2) { |hand| hand.rank }.map { |best| best.to_a }
  end
  
  private

  class Hand
    attr_reader :cards

    def initialize cards
      @cards = cards.map { |card| Card.new card }
    end

    def rank
      return [8, ranking(ranks.first)] if straight_flush?

      return [7, ranking(kind 4) ] if square?

      return [6, ranking(kind 3) ] if full_house?

      return [5, ranks.map { |card| ranking card }.max] if flush?
      
      if straight?
        rank_of_straight = STRAIGHTS.index ranks
        return [4, rank_of_straight]
      end
      
      return [3, ranking(kind 3) ] if three_of_a_kind?
      
      if two_pair?
        ordered_pair_ranks =
          pairs.map { |pair| ranking pair }.reverse
        return [2] + ordered_pair_ranks
      end
      
      return [1, ranking(pairs.first)] if a_pair?
        
      [0] + ranks.map { |card| ranking card }.reverse
    end

    def to_a
      cards.map { |card| card.to_s }
    end

    private

    STRAIGHTS = [
      %w{2 3 4 5 6},
      %w{2 3 4 5 A},
      %w{4 5 6 7 8},
      %w{5 6 7 8 9},
      %w{6 7 8 9 10},
      %w{7 8 9 10 J},
    ]

    def ranks
      cards.
        sort_by { |card| card.ranking_position }.
        map { |card| card.rank }
    end

    def kind number_of
      grouped_by_rank.
        select { |_, cards| cards.size == number_of }.keys.first
    end
 
    def straight_flush?
      straight? && flush?
    end

    def square?
      grouped_by_rank.one? { |_, cards| cards.size == 4 }
    end

    def full_house?
      three_of_a_kind? && a_pair?
    end

    def flush?
      cards.uniq { |card| card.suit }.one?
    end

    def straight?
      STRAIGHTS.include? ranks
    end

    def three_of_a_kind?
      grouped_by_rank.one? { |_, cards| cards.size == 3 }
    end

    def two_pair?
      pairs.size == 2
    end

    def a_pair?
      pairs.one?
    end

    def pairs
      grouped_by_rank.
        select { |_, cards| cards.size == 2 }.keys.sort
    end

    def grouped_by_rank
      cards.group_by { |card| card.rank }
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

      def ranking_position
        RANKS.index rank      
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
