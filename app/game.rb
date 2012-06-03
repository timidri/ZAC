class Game
  
#  @@all = []
  
  attr_reader :team1
  attr_reader :team2
  attr_reader :datetime
  attr_reader :field
  attr_reader :referee
  
  def initialize team1, team2, datetime, field, referee
    @team1 = team1
    @team2 = team2
    @datetime = datetime
    @field = field
    @referee = referee
    @points = {}
  end

  def setpoints team1, points1, team2, points2
    @points[team1] = points1
    @points[team2] = points2
  end

  def getpoints team
    @points[team]
  end

  def to_s
    "#{@datetime}-#{@field}, #{@team1} vs #{@team2}, referee: #{@referee}"
  end
  
  def opponentOf(team)
    if team == team1
      @team2
    else
      @team1
    end
  end
end