class Team
  attr_reader :name
  attr_reader :games

  @@all = []
  
  def initialize name
    @name  = name
    @games = []
    @@all << self
  end

  def addGame game
    @games << game
    # puts ("games before sort: #{@games}")
    @games.sort! { |a,b| a.datetime <=> b.datetime }
    # puts ("games after sort: #{@games}")
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