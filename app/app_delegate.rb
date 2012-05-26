class AppDelegate
  attr_reader :window, :rootViewController
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    storyboard = UIStoryboard.storyboardWithName("ZAC", bundle:nil)
    @rootViewController = storyboard.instantiateViewControllerWithIdentifier("SplashScreen")
    @rootViewController.wantsFullScreenLayout = true
    @window.rootViewController = @rootViewController
    @window.makeKeyAndVisible
    ZAC.instance.refresh(self)
  end

  def factoryFinishedRefreshing
    @window.rootViewController.performSegueWithIdentifier("GoToMainScreen", sender:nil)
  end
  
end
