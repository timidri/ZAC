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
    @foreground_observer = App.notification_center.observe UIApplicationWillEnterForegroundNotification do |notification|
      puts "#{self.class} received notification"
      self.view.userInteractionEnabled = false
      @activityIndicator.startAnimating
      ZAC.instance.refresh(self)
    end
  end

  def viewWillDisappear(animated)
    puts "unobserving #{self.class}"
    App.notification_center.unobserve @foreground_observer
  end

  def factoryFinishedRefreshing
    puts "reloading #{self.class} data..."
    view.reloadData
    @activityIndicator.stopAnimating
    self.view.userInteractionEnabled = true
  end

end
