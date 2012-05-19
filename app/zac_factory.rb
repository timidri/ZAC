class ZAC
  
  attr_reader :games, :teams
  
  @@instance = ZAC.new
  
  @dateFormatter = NSDateFormatter.alloc.init.setDateFormat("dd-MM-yyyy HH:mm:ss")
  
  def initialize
    link = 'https://spreadsheets.google.com/feeds/list/0Aoe6kaQMB4f4dGRNajhvYlFCT3V4MVNOZlZXZ0tyckE/1/public/basic/'
    feedURL = NSURL.URLWithString(link)
    @request = NSURLRequest.requestWithURL(feedURL)
    @receivedData = NSMutableData.new
    @connection = NSURLConnection.connectionWithRequest(request, delegate:self)
    @games = []
    @teams = []
    @entries = []
  end
  
	def fetch(sender)
	  @delegate = sender
    @connection.start
  end
  
  def find_or_create_team teamName
    team = find_team_by_name teamName
    unless team
      team = Team.new teamName
    end
    team
  end
  
  def find_team_by_name teamname
    @teams.find do |team|
      team.name == teamname
    end
  end
  
  def connection(connection, didReceiveResponse:response)
    @receivedData.setLength(0)
  end

  def connection(connection, didReceiveData:data)
    @receivedData.appendData(data)
  end

  def connection(connection, didFailWithError:error)
    # puts("Connection failed! Error - " + error.localizedDescription + error.userInfo.objectForKey(NSURLErrorFailingURLStringErrorKey))
  end

  def connectionDidFinishLoading(connection)
    # puts("Succeeded! Received bytes of data: "  + @receivedData.length.description);
    parser = NSXMLParser.alloc.initWithData(@receivedData)
    parser.setDelegate(self)
    parser.parse
    @delegate.factoryFinishedFetching
  end

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
      game = Game.new(team1, team2, dateTime, @rowHash["veld"])
      team1.addGame(game)
      team2.addGame(game)
      @games << game
      @teams << team1 << team2      
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
    entryArray.each do |item|
      k,v = item.split(": ")
      hash[k] = v
    end
    hash
  end
  
  def self.instance
      return @@instance
  end
  
  private_class_method :new
end