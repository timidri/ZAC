class AppDelegate
  attr_reader :window, :rootViewController
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    # @window.rootViewController = NSBundle.mainBundle.loadNibNamed('ZAC', owner:self, options:nil).first
    true
  end
  
  def applicationDidBecomeActive(application)
    # puts("#{self.class} applicationDidBecomeActive")
    storyboard = UIStoryboard.storyboardWithName("ZAC", bundle:nil)
    @rootViewController = storyboard.instantiateViewControllerWithIdentifier("SplashScreen")
    @window.rootViewController = @rootViewController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    ZAC.instance.refresh(self)
  end
  
  def factoryFinishedRefreshing
    # puts("going to perform segue")
    @window.rootViewController.performSegueWithIdentifier("GoToMainScreen", sender:nil)
  end
  
  def factoryFailedRefreshing
    alertView = UIAlertView.alloc.initWithTitle("Offline!", message:"ZAC rooster ophalen is mislukt.\nDe app is alleen offline te gebruiken",
      delegate:self, cancelButtonTitle:"Bummer!", otherButtonTitles:nil)
    alertView.show
  end
  
  def alertView(alertView, clickedButtonAtIndex:index)
    # puts("clicked index: #{index}")
    ZAC.instance.refreshFromCache(self)
  end
  
end