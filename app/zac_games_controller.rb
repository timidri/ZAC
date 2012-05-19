class ZACGamesController < UITableViewController
  
  SWITCH_TAG = 1
  SHOW_UPCOMING_GAMES = 0
  SHOW_ALL_GAMES = 1
  
  def viewDidLoad
    # puts("#{self.class} viewDidLoad")
    @dateFormatter = NSDateFormatter.alloc.init.setDateFormat("E dd-MM-yyyy HH:mm")
    @switch = self.view.viewWithTag(SWITCH_TAG)
    puts("switch: #{@switch}")
    @switch.addTarget(self, action:'switchClicked:', forControlEvents:UIControlEventValueChanged)
  end

  def switchClicked(sender)
    puts("switch changed to #{sender.selectedSegmentIndex}")
    p sender
  end
  
  def teamname= teamname
    @team = Team.find_by_name teamname
    navigationItem.title = "Wedstrijden: #{teamname}"
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    # puts "game count: #{@team.games.count}"
    @team.upcomingGames.count
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    # puts("cellForRowAtIndexPath: #{indexPath.row}")
    cell = tableView.dequeueReusableCellWithIdentifier("GameCell")
    game = @team.upcomingGames[indexPath.row]
    cell.textLabel.text = "#{@dateFormatter.stringFromDate(game.datetime)}"
    cell.detailTextLabel.text = "tegen: #{game.opponentOf(@team)} veld: #{game.field}"
    cell
  end
  
  def prepareForSegue(segue, sender:sender)
    # puts("prepareForSegue, segue=#{segue.identifier}, sender=#{sender.textLabel.text}")
  end
end