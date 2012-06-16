class ZACGamesController < ZACTableViewController
  include Styling

  SWITCH_TAG = 1
  SHOW_UPCOMING_GAMES = 0
  SHOW_ALL_GAMES = 1
  
  def viewDidLoad
    super
    # puts("#{self.class} viewDidLoad")
    @timeFormatter = NSDateFormatter.alloc.init.setDateFormat("HH:mm")
    @dateFormatter = NSDateFormatter.alloc.init.setDateFormat("E dd-MM-yyyy")
    switch = self.view.viewWithTag(SWITCH_TAG)
    switch.addTarget(self, action:'switchClicked:', forControlEvents:UIControlEventValueChanged)
    @currentSelection = switch.selectedSegmentIndex
    tableView.rowHeight = 80
  end

  def switchClicked(sender)
    # puts("switch changed to #{sender.selectedSegmentIndex}")
    @currentSelection = sender.selectedSegmentIndex
    updateGamesSelection
  end
  
  def updateGamesSelection
    if @currentSelection == SHOW_ALL_GAMES
      @games = @team.games
    else
      @games = @team.upcomingGames
    end
    @dateHash = {}
    @games.each do |game|
      game_date = Time.local(0,0,0,*game.datetime.to_a[3...10])
      # puts game_date
      @dateHash[game_date] ||= []
      @dateHash[game_date] << game
    end
    self.view.reloadData
  end

  def teamname= teamname
    @team = ZAC.instance.find_team_by_name teamname
    navigationItem.title = teamname
    updateGamesSelection
  end
  
  def numberOfSectionsInTableView(tableView)
    @dateHash.size
  end

  def tableView(tableView, titleForHeaderInSection:section)
    # puts "tableView titleForHeaderInSection:#{section} =>#{@dateHash.keys[section].to_s}"
    @dateFormatter.stringFromDate(@dateHash.keys[section])
  end

  def tableView(tableView, numberOfRowsInSection:section)
    # puts "tableView numberOfRowsInSection:#{section} =>#{@dateHash[@dateHash.keys[section]].size}"
    @dateHash[@dateHash.keys[section]].size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    # puts("cellForRowAtIndexPath: #{indexPath.row}")
    cell = tableView.dequeueReusableCellWithIdentifier("GameCell")
    game = @games[indexPath.row]
    cell.textLabel.text = "#{@timeFormatter.stringFromDate(game.datetime)}"
    cell.detailTextLabel.textColor = UIColor.whiteColor
    if @team == game.referee
      cell.textLabel.text += "\u{1F3C1}"
      cell.detailTextLabel.text = "     #{game.team1}\n\u{1F19A} #{game.team2}\n\u{26F3} #{game.field}"
    else
      cell.textLabel.text += "    #{game.get_score_for(@team)}"
      cell.detailTextLabel.text = "\u{1F19A} #{game.opponentOf(@team)}\n\u{26F3} #{game.field}\n\u{1F3C1} #{game.referee}  "
    end
    cellstyling cell
    if @team == game.referee
      cell.textLabel.textColor = UIColor.colorWithRed(253/255.0, green:231/255.0, blue:50/255.0, alpha:1.0)
      # line below doesn't work...
      # cell.textLabel.backgroundColor = UIColor.whiteColor
    end
    cell
  end
  
end