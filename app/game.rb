class Game
  
  @@all = []
  
  attr_reader :team1
  attr_reader :team2
  attr_reader :date
  attr_reader :time
  attr_reader :field
  
  def initialize team1, team2, date, time, field
    @date  = date
    @time  = time
    @field = field
    @team1 = Team.findOrCreate team1, self
    @team2 = Team.findOrCreate team2, self
    @@all << self
  end

  def self.all
    @@all
  end

  # All = [
  #   Game.new('foo', 'bar', '2012-05-01', '10:30' , 'bla'),
  #   Game.new('foo', 'bar', '2012-05-01', '10:30' , 'bla'),
  #   Game.new('foo', 'bar', '2012-05-01', '10:30' , 'bla'),
  #   Game.new('foo', 'bar', '2012-05-01', '10:30' , 'bla'),
  # ]

end