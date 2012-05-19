$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'rubygems'
require 'motion-testflight'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'ZAC'
  
  app.info_plist['CFBundleShortVersionString'] = '0.8'
  app.info_plist['CFBundleVersion'] = '4'

  app.codesign_certificate = 'iPhone Developer: Joachim Nolten (PNCKXWS2NR)'

  app.identifier = '99Z3JG6WQC.org.nolten.zac'

  app.provisioning_profile = '/Users/joachim/ZAC_distribution.mobileprovision'

  app.files += Dir.glob(File.join(app.project_dir, 'lib/**/*.rb'))

  app.icons = %w{ icon.png }

  app.testflight.sdk = 'vendor/TestFlightSDK'
  app.testflight.api_token = '79e630e7e4fe41ea82f17cf4afb6a918_NDQ4NDEwMjAxMi0wNS0xOSAxMTowNDoyNC42MjQzMjY'
  app.testflight.team_token = '2ef31a808a4e76475d33e11259b02e73_OTE3NTAyMDEyLTA1LTE5IDExOjA4OjA4LjcwOTg3OQ'
end
