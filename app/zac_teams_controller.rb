class ZACTeamsController < UITableViewController
  def viewDidLoad
    puts("#{self.class} viewDidLoad")
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    puts("numberOfRowsInSection: #{Team.all.size}")
    Team.all.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    puts("cellForRowAtIndexPath: #{indexPath.row}")
    cell = tableView.dequeueReusableCellWithIdentifier("TeamCell")
    # cell.textLabel.text = indexPath.row.to_s
    # cell.detailTextLabel.text = indexPath.row.to_s
    team = Team.all[indexPath.row]
    cell.textLabel.text = team.name
    cell
  end
  
  def prepareForSegue(segue, sender:sender)
    destinationController = segue.destinationViewController
    destinationController.teamname = sender.textLabel.text
    puts("prepareForSegue, segue=#{segue.identifier}, sender=#{sender.textLabel.text}")
  end
end