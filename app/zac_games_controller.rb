class ZACGamesController < UITableViewController
  
  def initalize
  end
  
  def viewDidLoad
    # puts("#{self.class} viewDidLoad")
    @dateFormatter = NSDateFormatter.alloc.init.setDateFormat("E dd-MM-yyyy HH:mm")
  end

  def teamname= teamname
    @team = Team.find_by_name teamname
    navigationItem.title = "Wedstrijden: #{teamname}"
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    # puts "game count: #{@team.games.count}"
    @team.games.count
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    # puts("cellForRowAtIndexPath: #{indexPath.row}")
    cell = tableView.dequeueReusableCellWithIdentifier("GameCell")
    game = @team.games[indexPath.row]
    cell.textLabel.text = "#{@dateFormatter.stringFromDate(game.datetime)}"
    cell.detailTextLabel.text = "tegen: #{game.opponentOf(@team)} veld: #{game.field}"
    cell
  end
  
  def prepareForSegue(segue, sender:sender)
    # puts("prepareForSegue, segue=#{segue.identifier}, sender=#{sender.textLabel.text}")
  end
end