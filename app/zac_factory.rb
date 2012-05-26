class ZAC
  
  attr_reader :games, :teams
      
  def initialize
    # puts "ZAC initialize"
    @receivedData = NSMutableData.new
    @dateFormatter = NSDateFormatter.alloc.init.setDateFormat("dd-MM-yyyy HH:mm:ss")
    @refreshing = false
  end
  
  @@instance = ZAC.new
  
  def refresh(sender)
    if @refreshing
      # puts ("ZAC refresh: already refreshing, ignoring refresh")
      return
    end
    # puts ("ZAC refreshing")
    @refreshing = true
    @games = []
    @teams = []
    @delegate = sender    
    link = 'https://spreadsheets.google.com/feeds/list/0Aoe6kaQMB4f4dGRNajhvYlFCT3V4MVNOZlZXZ0tyckE/1/public/basic/'
    feedURL = NSURL.URLWithString(link)
    # using default caching policy and a reduced timeout interval of 10 seconds
    # NSURLRequestReturnCacheDataElseLoad
    @request = NSURLRequest.requestWithURL(feedURL, cachePolicy:NSURLRequestUseProtocolCachePolicy, timeoutInterval:10)
    @connection = NSURLConnection.connectionWithRequest(@request, delegate:self)
  end
  
  def refreshFromCache(sender)
    path = NSBundle.mainBundle.pathForResource("rooster", ofType:"xml")
    # puts("path = #{path}")
    data = NSFileManager.defaultManager.contentsAtPath(path)
    # puts("data = #{data}")
    parseData(data)
    @refreshing = false
    @delegate.factoryFinishedRefreshing
  end
    
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
  
  def find_team_by_name teamname
    @teams.find do |team|
      team.name == teamname
    end
  end
  
  def parseData(data)
    parser = NSXMLParser.alloc.initWithData(data)
    parser.setDelegate(self)
    parser.parse
    @teams.sort! { |a,b| a.name <=> b.name }
  end
  
  # connection delegate methods
  
  def connection(connection, didReceiveResponse:response)
    # puts ("connection didReceiveResponse")
    @receivedData.setLength(0)
  end

  def connection(connection, didReceiveData:data)
    # puts ("connection didReceiveData")
    @receivedData.appendData(data)
  end

  def connection(connection, didFailWithError:error)
+    alertView = UIAlertView.alloc.initWithTitle("Offline!", message:"ZAC rooster ophalen is mislukt.\nDe app is alleen offline te gebruiken",
      delegate:self, cancelButtonTitle:"Bummer!", otherButtonTitles:nil)
  end

  def alertView(alertView, clickedButtonAtIndex:index)
    ZAC.instance.refreshFromCache()
  end

  def connection(connection, willCacheResponse:cachedResponse)
    # puts("cachedResponse: #{cachedResponse}")
    return cachedResponse
  end
  
  def connectionDidFinishLoading(connection)
    # puts("Succeeded! Received bytes of data: "  + @receivedData.length.description);
    parseData(@receivedData)
    @refreshing = false
    puts("ZAC: finished refreshing")
    @delegate.factoryFinishedRefreshing
  end
  
  # parser delegate methods
  
  def parserDidStartDocument(parser)
    @entries = []
    @inEntry = false
  end

  def parser(parser, didStartElement:elementName, namespaceURI:namespaceURI, qualifiedName:qualifiedName, attributes:attributeDict)
    # puts "start - elname: #{elementName}, qname: #{qualifiedName}" 
    @currentValue = ""
    if elementName == "entry"
      @inEntry = true
      @rowHash = {}
    end
  end

  def parser(parser, didEndElement:elementName, namespaceURI:namespaceURI, qualifiedName:qualifiedName)
    # puts "end - elname: #{elementName}, qname: #{qualifiedName}" 
    if elementName == "entry"
      dateTime = @dateFormatter.dateFromString("#{@rowHash["datum"]} #{@rowHash["tijd"]}")
      team1 = find_or_create_team(@rowHash["team1"])
      team2 = find_or_create_team(@rowHash["team2"])
      referee = find_or_create_team(@rowHash["scheidsrechter"])
      game = Game.new(team1, team2, dateTime, @rowHash["veld"], referee)
      team1.addGame(game)
      team2.addGame(game)
      referee.addGame(game)
      @games << game
      @entries << @rowHash
      @inEntry = false
    elsif elementName == "title" && @inEntry
      @rowHash['datum'] = @currentValue
    elsif elementName == "content" && @inEntry
      @rowHash = @rowHash.merge(parseContents(@currentValue))
    end
  end

  def parser(parser, foundCharacters:string)
    @currentValue += string
    # puts "currentValue: #{@currentValue}"
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
  
  def self.instance
    # puts "self.instance: #{@@instance}"
    @@instance
  end
  
  private_class_method :new
end