module Styling
  def tablestyling
    image = UIImage.imageNamed("back.jpeg")
    imageView = UIImageView.alloc.initWithImage(image)
    self.tableView.setBackgroundView(imageView)
  end

  def cellstyling cell
    cell.contentView.backgroundColor = UIColor.colorWithWhite(0.0, alpha: 0.8)
  end

end