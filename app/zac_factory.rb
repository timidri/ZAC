class ZACFactory	
  
  @@spreadsheetService = nil
  @@dateFormatter = NSDateFormatter.alloc.init.setDateFormat("dd-MM-yyyy HH:mm:ss")
  
	def self.startFetchingFromGoogle(sender)
	  @@delegate = sender
    link = 'https://spreadsheets.google.com/feeds/list/0Aoe6kaQMB4f4dGRNajhvYlFCT3V4MVNOZlZXZ0tyckE/1/public/basic/'
    @@receivedData = NSMutableData.new
    feedURL = NSURL.URLWithString(link)
    request = NSURLRequest.requestWithURL(feedURL)
    connection = NSURLConnection.connectionWithRequest(request, delegate:self)
    connection.start
  end

  def self.connection(connection, didReceiveResponse:response)
    @@receivedData.setLength(0)
  end

  def self.connection(connection, didReceiveData:data)
    @@receivedData.appendData(data)
  end

  def self.connection(connection, didFailWithError:error)
    # puts("Connection failed! Error - " + error.localizedDescription + error.userInfo.objectForKey(NSURLErrorFailingURLStringErrorKey))
  end

  def self.connectionDidFinishLoading(connection)
    # puts("Succeeded! Received bytes of data: "  + @@receivedData.length.description);
    parser = NSXMLParser.alloc.initWithData(@@receivedData)
    parser.setDelegate(self)
    parser.parse
    @@delegate.factoryFinishedFetching
  end

  def self.parserDidStartDocument(parser)
    @@entries = []
    @@inEntry = false
  end

  def self.parser(parser, didStartElement:elementName, namespaceURI:namespaceURI, qualifiedName:qualifiedName, attributes:attributeDict)
    # puts "start - elname: #{elementName}, qname: #{qualifiedName}" 
    @@currentValue = ""
    if elementName == "entry"
      @@inEntry = true
      @@rowHash = {}
    end
  end

  def self.parser(parser, didEndElement:elementName, namespaceURI:namespaceURI, qualifiedName:qualifiedName)
    # puts "end - elname: #{elementName}, qname: #{qualifiedName}" 
    if elementName == "entry"
      dateTime = @@dateFormatter.dateFromString("#{@@rowHash["datum"]} #{@@rowHash["tijd"]}")
      Game.new(@@rowHash["team1"], @@rowHash["team2"], dateTime, @@rowHash["veld"])
      # Game.new(@@rowHash["team1"], @@rowHash["team2"], @@rowHash["datum"], @@rowHash["tijd"], @@rowHash["veld"])
      @@entries << @@rowHash
      @@inEntry = false
    elsif elementName == "title" && @@inEntry
      @@rowHash['datum'] = @@currentValue
    elsif elementName == "content" && @@inEntry
      @@rowHash = @@rowHash.merge(parseContents(@@currentValue))
    end
  end

  def self.parser(parser, foundCharacters:string)
    @@currentValue += string
    # puts "currentValue: #{@@currentValue}"
  end
  
  def self.parseContents(string)
    hash = {}
    entryArray = string.split(', ')
    entryArray.each do |item|
      k,v = item.split(": ")
      hash[k] = v
    end
    hash
  end
end