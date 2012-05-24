$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'rubygems'
require 'motion-testflight'
require 'rake/version_task'
require 'bubble-wrap'

Rake::VersionTask.new do |task|
  task.with_git_tag = true
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'ZAC'
  version = Version.current.to_a
  app.info_plist['CFBundleShortVersionString'] = version[0..1].join('.')
  app.info_plist['CFBundleVersion'] = version[2]
  app.info_plist['CFBundleIdentifier'] = 'org.nolten.zac'

  app.icons = %w{Icon.png Icon-114.png}

  app.codesign_certificate = 'iPhone Distribution: Joachim Nolten'

  app.identifier = 'org.nolten.zac'

  app.seed_id = '99Z3JG6WQC'

  app.provisioning_profile = '/Users/joachim/ZAC_app_store.mobileprovision'

  app.files += Dir.glob(File.join(app.project_dir, 'lib/**/*.rb'))

  app.icons = %w{ icon.png }

  app.testflight.sdk = 'vendor/TestFlightSDK'
  app.testflight.api_token = '79e630e7e4fe41ea82f17cf4afb6a918_NDQ4NDEwMjAxMi0wNS0xOSAxMTowNDoyNC42MjQzMjY'
  app.testflight.team_token = '2ef31a808a4e76475d33e11259b02e73_OTE3NTAyMDEyLTA1LTE5IDExOjA4OjA4LjcwOTg3OQ'
end

desc "Deploy"
task :deploy do
  Rake::Task['clean'].invoke
  Rake::Task['version:bump:revision'].invoke
  Rake::Task['testflight:submit'].invoke ENV['notes']
end