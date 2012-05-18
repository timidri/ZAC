class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    # @window.rootViewController = NSBundle.mainBundle.loadNibNamed('ZAC', owner:self, options:nil).first
    storyboard = UIStoryboard.storyboardWithName("ZAC", bundle:nil)
    rootViewController = storyboard.instantiateViewControllerWithIdentifier("SplashScreen")
    @window.rootViewController = rootViewController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    ZACFactory.startFetchingFromGoogle(self)
    true
  end
  
  def factoryFinishedFetching
    # puts("going to perform segue")
    @window.rootViewController.performSegueWithIdentifier("GoToMainScreen", sender:nil)
  end
end