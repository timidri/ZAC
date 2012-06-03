class ZACPointsController < ZACTableViewController
  include Styling

  def tableView(tableView, numberOfRowsInSection:section)
    ZAC.instance.points.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    # puts("cellForRowAtIndexPath: #{indexPath.row}")
    cell = tableView.dequeueReusableCellWithIdentifier("ScoreCell")
    team, score = ZAC.instance.points[indexPath.row]
    cell.textLabel.text = "#{score}: #{team}"
    cellstyling cell
    cell
  end
end