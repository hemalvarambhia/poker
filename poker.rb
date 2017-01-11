class Poker
  attr_reader :hands
  def initialize hands
    @hands = hands
  end

  def best_hand
    [ hands.max_by { |hand| rank hand } ]
  end
  
  private

  def rank hand
    ranks = hand.map { |card| card[/[\d+JQKA]/] }
    ranks.map { |card| RANKS.index card }.max
  end

  RANKS = %w{2 3 4 5 6 7 8 9 10 J Q K A} 
end

module BookKeeping
  VERSION = 2
end