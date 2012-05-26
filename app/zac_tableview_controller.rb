class ZACTableViewController < UITableViewController

  def viewDidLoad
    puts "#{self.class} viewDidLoad"
    @activityIndicator = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhiteLarge)
    @activityIndicator.center = self.view.center
    view.addSubview(@activityIndicator)
    tablestyling
  end

  def viewWillAppear(animated)
    puts "observing #{self.class}"
    notification_center.observe self, UIApplicationWillEnterForegroundNotification do
      puts "#{self.class} received notification"
      @activityIndicator.startAnimating
      ZAC.instance.refresh(self)
    end
  end

  def viewWillDisappear(animated)
    puts "unobserving #{self.class}"
    notification_center.unobserve self  
  end

  def factoryFinishedRefreshing
    puts "reloading #{self.class} data..."
    view.reloadData
    @activityIndicator.stopAnimating
  end

end