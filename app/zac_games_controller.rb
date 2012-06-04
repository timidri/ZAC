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
    cell.detailTextLabel.textColor = UIColor.whiteColor
    if @team == game.referee
      cell.textLabel.text += "\u{1F3C1}"
      cell.detailTextLabel.text = "#{game.team1} vs\n#{game.team2}\nveld: #{game.field}"
    else
      cell.textLabel.text += game.get_score_for(@team)
      cell.detailTextLabel.text = "Tegen: #{game.opponentOf(@team)}\nVeld: #{game.field}\n\u{1F3C1}: #{game.referee}  "
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