class ZACTeamsController < UITableViewController
  def viewDidLoad
    # puts("#{self.class} viewDidLoad")
  end

  def viewDidAppear(animated)
    # puts("#{self.class} viewDitAppear, animated:#{animated}")
    # puts("presenting: #{presentingViewController.class}, presented: #{presentedViewController.class}")
  end
    
  def tableView(tableView, numberOfRowsInSection:section)
    # puts("numberOfRowsInSection: #{Team.all.size}")
    Team.all.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    # puts("cellForRowAtIndexPath: #{indexPath.row}")
    cell = tableView.dequeueReusableCellWithIdentifier("TeamCell")
    team = Team.all[indexPath.row]
    cell.textLabel.text = team.name
    cell
  end
  
  def prepareForSegue(segue, sender:sender)
    destinationController = segue.destinationViewController
    clickedTeamName = sender.textLabel.text
    destinationController.teamname = clickedTeamName
    # defaults = NSUserDefaults.standardUserDefaults
    # defaultTeam = defaults.stringForKey("defaultTeam")
    # puts("defaults: #{defaultTeam}")
    # if clickedTeamName != defaultTeam
    #   defaults.setObject(clickedTeamName, forKey:"defaultTeam")
    #   puts("defaults: synchronizing")
    #   defaults.synchronize
    # end
    puts("prepareForSegue, segue=#{segue.identifier}, sender=#{sender.textLabel.text}")
  end
end