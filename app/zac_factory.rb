class ZAC
  
  attr_reader :games, :teams, :points
      
  def initialize
    # puts "ZAC initialize"
    @dateFormatter = NSDateFormatter.alloc.init.setDateFormat("dd-MM-yyyy HH:mm:ss")
    @refreshing = false
    @sheet_key = '0Aoe6kaQMB4f4dGRNajhvYlFCT3V4MVNOZlZXZ0tyckE'
  end
  
  @@instance = ZAC.new
  

  def self.instance
    # puts "self.instance: #{@@instance}"
    @@instance
  end

  def refresh(sender)
    if @refreshing
      puts ("ZAC refresh: already refreshing, ignoring refresh")
      return
    end
    puts ("ZAC refreshing")
    @games = []
    @teams = []
    @points = {}
    @delegate = sender    
    link = "https://spreadsheets.google.com/feeds/list/#{@sheet_key}/1/public/basic/"
    BubbleWrap::HTTP.get("#{link}?alt=json") do |response|
      if response.ok?
        parseData response.body.to_str
        @delegate.factoryFinishedRefreshing
        @refreshing = false
      else
        alertView = UIAlertView.alloc.initWithTitle("Offline!", message:"ZAC rooster ophalen is mislukt.\nDe app is alleen offline te gebruiken",
          delegate:self, cancelButtonTitle:"Bummer!", otherButtonTitles:nil)
        alertView.show
      end
    end
  end
  
  def find_team_by_name teamname
    @teams.find do |team|
      team.name == teamname
    end
  end

  protected 

  def alertView(alertView, clickedButtonAtIndex:index)
    ZAC.instance.refreshFromCache()
    @delegate.factoryFinishedRefreshing
    @refreshing = false
  end

  def refreshFromCache()
    path = NSBundle.mainBundle.pathForResource("rooster", ofType:"json")
    data = NSFileManager.defaultManager.contentsAtPath(path)
    parseData(data)
    @refreshing = false
    @delegate.factoryFinishedRefreshing
  end
  
  private

  def find_or_create_team teamName
    teamName = "*UNKNOWN*" if teamName == nil
    team = find_team_by_name teamName
    # puts("find_or_create #{teamName} => #{team}")
    unless team
      team = Team.new teamName
      @teams << team
    end
    team
  end
    
  def parseData(data)

    json = BubbleWrap::JSON.parse(data)
    entries = json[:feed][:entry]
    entries.each do |entry|
      date = entry[:title][:$t]
      hash = parseContents entry[:content][:$t]
      dateTime = @dateFormatter.dateFromString("#{date} #{hash["tijd"]}")
      team1 = find_or_create_team(hash["team1"])
      team2 = find_or_create_team(hash["team2"])
      referee = find_or_create_team(hash["scheidsrechter"])
      game = Game.new(team1, team2, dateTime, hash["veld"], referee)
      if hash["punten1"]
        @points[hash["team1"]] = @points[hash["team1"]] ? @points[hash["team1"]] + hash["punten1"] : hash["punten1"]
      end
      if hash["punten2"]
        @points[hash["team2"]] = @points[hash["team2"]] ? @points[hash["team2"]] + hash["punten2"] : hash["punten2"]
      end
      team1.addGame(game)
      team2.addGame(game)
      referee.addGame(game)
      @games << game
    end
    @teams.sort! { |a,b| a.name <=> b.name }
    @points = @points.sort_by{ |k,v| v }.reverse
  end

  def parseContents(string)
    hash = {}
    entryArray = string.split(', ')
    # puts entryArray
    entryArray.each do |item|
      k,v = item.split(": ")
      hash[k] = v.strip
    end
    hash
  end
  
  private_class_method :new
end