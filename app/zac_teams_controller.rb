class ZACTeamsController < UITableViewController
  include Styling

  def viewDidLoad
    # puts("#{self.class} viewDidLoad")
    tablestyling
  end

  def factoryFinishedRefreshing
    puts "reloading teams..."
    self.view.reloadData
  end

  def viewDidAppear(animated)
    # puts("#{self.class} viewDitAppear, animated:#{animated}")
    # puts("presenting: #{presentingViewController.class}, presented: #{presentedViewController.class}")
    # ZAC.instance.refresh self
  end
    
  def tableView(tableView, numberOfRowsInSection:section)
    # puts("numberOfRowsInSection: #{Team.all.size}")
    ZAC.instance.teams.size
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    # puts("cellForRowAtIndexPath: #{indexPath.row}")
    cell = tableView.dequeueReusableCellWithIdentifier("TeamCell")
    team = ZAC.instance.teams[indexPath.row]
    cell.textLabel.text = team.name
    cellstyling cell
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
    # puts("prepareForSegue, segue=#{segue.identifier}, sender=#{sender.textLabel.text}")
  end
end