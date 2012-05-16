class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    # @window.rootViewController = NSBundle.mainBundle.loadNibNamed('ZAC', owner:self, options:nil).first
    storyboard = UIStoryboard.storyboardWithName("ZAC", bundle:nil)
    rootViewController = storyboard.instantiateViewControllerWithIdentifier("Main")
    @window.rootViewController = rootViewController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
