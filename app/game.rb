class Game
  def initialize team1, team2, date, time, field
    @team1 = team1
    @team2 = team2
    # @date  = date
    # @time  = time
    # @field = field
  end

  def teams
    All.find
  end

  All = [
    Game.new('foo', 'bar', '2012-05-01', '10:30' , 'bla'),
    Game.new('foo', 'bar', '2012-05-01', '10:30' , 'bla'),
    Game.new('foo', 'bar', '2012-05-01', '10:30' , 'bla'),
    Game.new('foo', 'bar', '2012-05-01', '10:30' , 'bla'),
  ]

end