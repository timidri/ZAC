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
    games.find_all { |game| game.datetime >= Time.new }
  end
  
  
  # def self.all
  #   @@all
  # end

  def to_s
    @name
  end
end