$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require
require 'rake/version_task'

Rake::VersionTask.new do |task|
  task.with_git_tag = true
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'ZAC'
  version = Version.current.to_a
  app.info_plist['CFBundleShortVersionString'] = version[0..1].join('.')
  app.info_plist['CFBundleVersion'] = '20' #version.inject{|a,i| a * 10 + i}.to_s
  app.info_plist['CFBundleIdentifier'] = 'org.nolten.zac'

  app.codesign_certificate = 'iPhone Distribution: Joachim Nolten'

  app.identifier = 'org.nolten.zac'

  app.seed_id = '99Z3JG6WQC'

  app.provisioning_profile = '/Users/joachim/ZAC_appstore_profile.mobileprovision'

  app.files += Dir.glob(File.join(app.project_dir, 'lib/**/*.rb'))

  app.icons = %w{ icon.png icon@2x.png }

  app.entitlements['get-task-allow'] = false # Defaults to true somehow
  
  app.development do
    # This entitlement is required during development but must not be used for release.
    app.entitlements['get-task-allow'] = false 
  end

  app.testflight.sdk = 'vendor/TestFlightSDK1.1'
  app.testflight.api_token = '79e630e7e4fe41ea82f17cf4afb6a918_NDQ4NDEwMjAxMi0wNS0xOSAxMTowNDoyNC42MjQzMjY'
  app.testflight.team_token = '2ef31a808a4e76475d33e11259b02e73_OTE3NTAyMDEyLTA1LTE5IDExOjA4OjA4LjcwOTg3OQ'
  
  app.files_dependencies 'app/zac_teams_controller.rb' => 'app/zac_tableview_controller.rb'
  app.files_dependencies 'app/zac_games_controller.rb' => 'app/zac_tableview_controller.rb'
end

desc "Deploy"
task :deploy do
  Rake::Task['clean'].invoke
  Rake::Task['version:bump:revision'].invoke
  Rake::Task['testflight:submit'].invoke ENV['notes']
end
