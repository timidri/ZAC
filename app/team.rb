class Team
  attr_reader :name

  # @@all = []
  
  def initialize name
    @name  = name
    @games = []
    @gamesSorted = false
    # @@all << self
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
    time_limit = Time.new + 30*60 # a game lasts for half an hour
    games.find_all { |game| game.datetime >= time_limit }
  end

  def to_s
    @name
  end

  def short
    if @name.size < 32
      @name
    else
      @name[0...30] + "..."
    end
  end
end