class ZACInfoController < UIViewController
	def viewDidLoad
    # puts("#{self.class} viewDidLoad")
		@label = self.view.viewWithTag(2)
		major_version = NSBundle.mainBundle.infoDictionary["CFBundleShortVersionString"]
		build_number = NSBundle.mainBundle.infoDictionary["CFBundleVersion"]
		@label.text = "#{major_version} (#{build_number})"
	end
end