class ZACFactory	
  
  @@spreadsheetService = nil
  
	def self.startFetchingFromGoogle(sender)
    # link = 'https://docs.google.com/spreadsheet/ccc?key=0Aoe6kaQMB4f4dGRNajhvYlFCT3V4MVNOZlZXZ0tyckE' 
    link = 'https://spreadsheets.google.com/feeds/list/0Aoe6kaQMB4f4dGRNajhvYlFCT3V4MVNOZlZXZ0tyckE/1/public/basic/'
    # link = 'https://spreadsheets.google.com/feeds/list/0Aoe6kaQMB4f4dGRNajhvYlFCT3V4MVNOZlZXZ0tyckE/1/private/full'
    # key = '0Aoe6kaQMB4f4dGRNajhvYlFCT3V4MVNOZlZXZ0tyckE'
    feedURL = NSURL.URLWithString(link)
    # feedURL = NSURL.URLWithString(KGDataGoogleSpreadsheetsPrivateFullFeed)
    ticket = spreadsheetService.fetchFeedWithURL(feedURL, delegate:sender,
                        didFinishSelector:'feedTicket:finishedWithFeed:error:')
  end

  def self.parseFeed(feed)
    @@gamesArray = []
    feed.entries.each do |entry|
      @@entryArray = entry.content.stringValue.split(', ')
      puts("entryArray: #{@@entryArray}")
      hash = {}
      @@entryArray.each do |item|
        k,v = item.split(": ")
        hash[k] = v
      end
      puts("hash: #{hash}")
      @@gamesArray.push(hash)
    end
    puts("gamesArray: #{@@gamesArray}")
    @@gamesArray.each do |entry|
      Game.new(entry["team1"], entry["team2"], entry["datum"], entry["tijd"], entry["veld"])
    end
  end
  
  def self.spreadsheetService
      unless @@spreadsheetService
        @@spreadsheetService = GDataServiceGoogleSpreadsheet.alloc.init
        @@spreadsheetService.setShouldCacheResponseData(true)
        @@spreadsheetService.setServiceShouldFollowNextLinks(true)
      end

      # // username/password may change
      # NSString *username = [mUsernameField stringValue];
      # NSString *password = [mPasswordField stringValue];

      # [service setUserCredentialsWithUsername:username
      #                                password:password];
      @@spreadsheetService
  end    
end