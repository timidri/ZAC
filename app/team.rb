class Team
  attr_reader :name
  attr_reader :games

  def initialize name 
    @name  = name
    @games = ['game 1', 'game 2', 'game 3', 'game 4']
  end

  @@all = [
    Team.new('foo'),
    Team.new('bar'),
    Team.new('joachim'),
    Team.new('dimitri')
  ]

  def self.all
    @@all
  end

  def self.find_by_name teamname
    @@all.find(:name => @teamname) do |team|
      team
    end
  end
end