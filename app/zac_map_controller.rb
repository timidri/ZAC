class ZACMapController < UIViewController
  def loadView
    # Background color while loading and scrolling beyond the page boundaries
    background = UIColor.blackColor
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    self.view.backgroundColor = background
    webFrame = UIScreen.mainScreen.applicationFrame
    webFrame.origin.y = 0.0
    @webView = UIWebView.alloc.initWithFrame(webFrame)
    @webView.backgroundColor = background
    @webView.scalesPageToFit = true
    @webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)
    @webView.delegate = self
    # @webView.loadRequest(NSURLRequest.requestWithURL(NSURL.fileURLWithPath(NSBundle.mainBundle.pathForResource('kaart', ofType:'jpeg'))))
    @webview_loaded = false
    @request = NSURLRequest.requestWithURL(NSURL.URLWithString("http://www.zachockey.nl/wp-content/uploads/Veldindeling-ZAC.jpg"))
    @webView.loadRequest(@request)
  end

  # Remove the following if you're showing a status bar that's not translucent
  def wantsFullScreenLayout
    true
  end

  def viewWillAppear(animated)
    puts "observing #{self.class}"
    # listen to the app coming to the foreground
    @foreground_observer  = App.notification_center.observe UIApplicationWillEnterForegroundNotification do
      puts "#{self.class} received notification; @webview_loaded = #{@webview_loaded}"
      # if the webview is not yet loaded, do it now
      @webView.loadRequest(@request) if !@webview_loaded
    end
  end

  def viewWillDisappear(animated)
    puts "unobserving #{self.class}"
    App.notification_center.unobserve @foreground_observer
  end

  # Only add the web view when the page has finished loading
  def webViewDidFinishLoad(webView)
    self.view.addSubview(@webView)
    @webview_loaded = true
  end
  
  # Enable rotation
  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    # On the iPhone, don't rotate to upside-down portrait orientation
    if UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPad
      if interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown
        return false
      end
    end
    true
  end
  
  # Open absolute links in Mobile Safari
  def webView(inWeb, shouldStartLoadWithRequest:inRequest, navigationType:inType)
    if inType == UIWebViewNavigationTypeLinkClicked && inRequest.URL.scheme != 'file' 
      UIApplication.sharedApplication.openURL(inRequest.URL)
      return false
    end
    true
  end
end
