class ZAC

  attr_reader :games, :teams, :points

  SAVE_FILE_NAME = "rooster"
  SAVE_FILE_TYPE = "json"

  def initialize
    # puts "ZAC initialize"
    @dateFormatter = NSDateFormatter.alloc.init.setDateFormat("dd-MM-yyyy HH.mm")
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
        # save the newly fetched response body
        save_data response.body
        parse_data response.body
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
    data = load_data
    parse_data data
    @refreshing = false
    @delegate.factoryFinishedRefreshing
  end

  def save_data data
    perror = Pointer.new(:object)
    # Create the url to the documents directory. Create the directory if needed.
    parentURL = NSFileManager.defaultManager.URLForDirectory(NSDocumentDirectory, inDomain:NSUserDomainMask,
        appropriateForURL:nil, create:true, error:perror)

    if !parentURL
      puts "save_data: *** Failed to get documents directory: #{perror[0]}"
      return nil
    end

    # append the filename to the url
    furl = parentURL.URLByAppendingPathComponent("#{SAVE_FILE_NAME}.#{SAVE_FILE_TYPE}")
    error = nil
    ok = data.writeToURL(furl, options:NSDataWritingAtomic, error:perror)
    if !ok
      puts "save_data: *** Failed to write to #{furl.path}: #{perror[0]}"
    end
  end

  def load_data
    perror = Pointer.new(:object)
    # create the url to the documents directory
    parentURL = NSFileManager.defaultManager.URLForDirectory(NSDocumentDirectory, inDomain:NSUserDomainMask,
        appropriateForURL:nil, create:true, error:perror)
    # append the filename to the url
    furl = parentURL.URLByAppendingPathComponent("#{SAVE_FILE_NAME}.#{SAVE_FILE_TYPE}")
    # load the file from the documents directory
    data = NSData.dataWithContentsOfURL(furl)
    if !data
      # bummer, load the bundled file
      path = NSBundle.mainBundle.pathForResource(SAVE_FILE_NAME, ofType:SAVE_FILE_TYPE)
      data = NSFileManager.defaultManager.contentsAtPath(path)
    end
    data
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

  def parse_data data
    json = BubbleWrap::JSON.parse data
    entries = json[:feed][:entry]
    entries.each do |entry|
      date = entry[:title][:$t]
      hash = parseContents entry[:content][:$t]
      puts "DATETIME: #{date} #{hash['tijd']}"
      dateTime = @dateFormatter.dateFromString("#{date} #{hash["tijd"]}")
      team1 = find_or_create_team(hash["team1"])
      team2 = find_or_create_team(hash["team2"])
      referee = find_or_create_team(hash["scheidsrechter"])
      game = Game.new(team1, team2, dateTime, hash["veld"], referee)
      game.set_scores hash["score1"], hash["score2"] if hash["score1"] and hash["score2"]
      if hash["punten1"]
        punten1 = Integer(hash["punten1"])
        @points[hash["team1"]] = @points[hash["team1"]] ? @points[hash["team1"]] + punten1 : punten1
      end
      if hash["punten2"]
        punten2 = Integer(hash["punten2"])
        @points[hash["team2"]] = @points[hash["team2"]] ? @points[hash["team2"]] + punten2 : punten2
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
      hash[k] = v.strip if v
    end
    hash
  end

  private_class_method :new
end
