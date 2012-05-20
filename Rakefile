$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'rubygems'
require 'motion-testflight'
require 'rake/version_task'

Rake::VersionTask.new do |task|
  task.with_git_tag = true
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'ZAC'
  version = Version.current.to_a
  app.info_plist['CFBundleShortVersionString'] = version[0..1].join('.')
  app.info_plist['CFBundleVersion'] = version[2]

  app.entitlements['get-task-allow'] = false

  app.codesign_certificate = 'iPhone Developer: Joachim Nolten (PNCKXWS2NR)'

  app.identifier = '99Z3JG6WQC.org.nolten.zac'

  app.provisioning_profile = '/Users/joachim/ZAC_distribution.mobileprovision'

  app.files += Dir.glob(File.join(app.project_dir, 'lib/**/*.rb'))

  app.icons = %w{ icon.png }

  app.testflight.sdk = 'vendor/TestFlightSDK'
  app.testflight.api_token = '79e630e7e4fe41ea82f17cf4afb6a918_NDQ4NDEwMjAxMi0wNS0xOSAxMTowNDoyNC42MjQzMjY'
  app.testflight.team_token = '2ef31a808a4e76475d33e11259b02e73_OTE3NTAyMDEyLTA1LTE5IDExOjA4OjA4LjcwOTg3OQ'
end