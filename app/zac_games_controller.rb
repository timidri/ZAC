class ZACGamesController < ZACTableViewController
  include Styling

  SWITCH_TAG = 1
  SHOW_UPCOMING_GAMES = 0
  SHOW_ALL_GAMES = 1
  
  def viewDidLoad
    super
    # puts("#{self.class} viewDidLoad")
    @dateFormatter = NSDateFormatter.alloc.init.setDateFormat("E dd-MM-yyyy HH:mm")
    @switch = self.view.viewWithTag(SWITCH_TAG)
    @switch.addTarget(self, action:'switchClicked:', forControlEvents:UIControlEventValueChanged)
    @currentSelection = SHOW_UPCOMING_GAMES
    # ZAC.instance.refresh self
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone
    tableView.rowHeight = 80
  end

  def switchClicked(sender)
    # puts("switch changed to #{sender.selectedSegmentIndex}")
    @currentSelection = sender.selectedSegmentIndex
    updateGamesSelection(@currentSelection)
  end
  
  def updateGamesSelection(currentSelection)
    if @currentSelection == SHOW_ALL_GAMES
      @games = @team.games
    else
      @games = @team.upcomingGames
    end
    self.view.reloadData
  end
  
  def teamname= teamname
    @team = ZAC.instance.find_team_by_name teamname
    navigationItem.title = teamname
    updateGamesSelection(@currentSelection)
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
      @games.count
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    # puts("cellForRowAtIndexPath: #{indexPath.row}")
    cell = tableView.dequeueReusableCellWithIdentifier("GameCell")
    game = @games[indexPath.row]
    cell.textLabel.text = "#{@dateFormatter.stringFromDate(game.datetime)}"
    if @team == game.referee
      cell.textLabel.text += "\u{1F46E}"
      cell.detailTextLabel.text = "#{game.team1} vs\n #{game.team2}\nveld: #{game.field}"
    else
      cell.detailTextLabel.text = "\u{1F4A9}: #{game.opponentOf(@team)}\n\u{1F3C1}: #{game.field}\n\u{1F46E}: #{game.referee}"
    end
    cellstyling cell
    cell
  end
  
end