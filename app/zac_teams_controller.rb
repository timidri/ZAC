class ZACTeamsController < UITableViewController
  def viewDidLoad
    puts("#{self.class} viewDidLoad")
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    10
  end
  
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    puts("cellForRowAtIndexPath: #{indexPath.row}")
    cell = tableView.dequeueReusableCellWithIdentifier("TeamCell")
    cell.textLabel.text = indexPath.row.to_s
    cell.detailTextLabel.text = indexPath.row.to_s
    cell
  end
  
  def prepareForSegue(segue, sender:sender)
    puts("prepareForSegue, segue=#{segue.identifier}, sender=#{sender.textLabel.text}")
  end
end