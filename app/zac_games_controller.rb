class ZACGamesController < UITableViewController
  
  SWITCH_TAG = 1
  SHOW_UPCOMING_GAMES = 0
  SHOW_ALL_GAMES = 1
  
  def viewDidLoad
    # puts("#{self.class} viewDidLoad")
    @dateFormatter = NSDateFormatter.alloc.init.setDateFormat("E dd-MM-yyyy HH:mm")
    @switch = self.view.viewWithTag(SWITCH_TAG)
    @switch.addTarget(self, action:'switchClicked:', forControlEvents:UIControlEventValueChanged)
    @currentSelection = SHOW_UPCOMING_GAMES
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
    @team = Team.find_by_name teamname
    navigationItem.title = "Wedstrijden: #{teamname}"
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
    cell.detailTextLabel.text = "tegen: #{game.opponentOf(@team)} veld: #{game.field}"
    cell
  end
  
  def prepareForSegue(segue, sender:sender)
    # puts("prepareForSegue, segue=#{segue.identifier}, sender=#{sender.textLabel.text}")
  end
end