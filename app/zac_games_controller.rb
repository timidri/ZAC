class ZACGamesController < UITableViewController
  def viewDidLoad
    puts("#{self.class} viewDidLoad")
  end

  def teamname= teamname
    @team = Team.find_by_name teamname
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    puts "game count: #{@team.games.count}"
    @team.games.count
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    puts("cellForRowAtIndexPath: #{indexPath.row}")
    cell = tableView.dequeueReusableCellWithIdentifier("GameCell")
    # cell.textLabel.text = indexPath.row.to_s
    # cell.detailTextLabel.text = indexPath.row.to_s

    game = @team.games[indexPath.row]
    cell.textLabel.text = game.field
    cell
  end
  
  def prepareForSegue(segue, sender:sender)
    puts("prepareForSegue, segue=#{segue.identifier}, sender=#{sender.textLabel.text}")
  end
end