class Team
  attr_reader :name

  @@all = []
  
  def initialize name
    @name  = name
    @games = []
    @gamesSorted = false
    @@all << self
    @now = Time.new
  end

  def addGame game
    @games << game
    @gamesSorted = false
  end
  
  def games
    unless @gamesSorted
      # puts("Game: sorting games")
      @games.sort! { |a,b| a.datetime <=> b.datetime }
      @gamesSorted = true
    end
    @games
  end
  
  def upcomingGames
    games.find_all { |game| game.datetime >= @now }
  end
  
  def self.findOrCreate teamName, game
    team = find_by_name teamName
    unless team
      team = Team.new teamName
    end
    team.addGame game
    team
  end
  
  def self.all
    @@all
  end

  def self.find_by_name teamname
    if @@all.count > 0
      @@all.find do |team|
        team.name == teamname
      end
    end
  end
  
  def to_s
    @name
  end
end