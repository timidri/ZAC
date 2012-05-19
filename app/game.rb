class Game
  
#  @@all = []
  
  attr_reader :team1
  attr_reader :team2
  attr_reader :datetime
  attr_reader :field
  
  def initialize team1, team2, datetime, field
    @team1 = team1
    @team2 = team1
    @datetime  = datetime
    @field = field
#    @@all << self
  end

  # def self.all
  #   @@all
  # end

  def to_s
    "#{@datetime}-#{@field}, #{@team1} vs #{@team2}"
  end
  
  def opponentOf(team)
    if team == team1
      @team2
    else
      @team1
    end
  end
end