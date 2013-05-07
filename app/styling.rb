module Styling
  def tablestyling
    image = UIImage.imageNamed("zac.jpg")
    imageView = UIImageView.alloc.initWithImage(image)
    imageView.setContentMode(UIViewContentModeScaleAspectFill)
    self.tableView.setBackgroundView(imageView)
    self.tableView.separatorColor = UIColor.colorWithWhite(1.0, alpha: 0.0)
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine
  end

  def cellstyling cell
    cell.contentView.backgroundColor = UIColor.colorWithWhite(0.0, alpha: 0.4)
    cell.textLabel.textColor = UIColor.whiteColor
  end

end
