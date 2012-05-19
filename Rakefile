$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'rubygems'
require 'motion-cocoapods'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'ZAC'

  app.codesign_certificate = 'iPhone Developer: Joachim Nolten (PNCKXWS2NR)'

  app.identifier = '99Z3JG6WQC.org.nolten.zac'

  app.provisioning_profile = '/Users/joachim/ZAC_profile.mobileprovision'

  app.files += Dir.glob(File.join(app.project_dir, 'lib/**/*.rb'))
  # app.pods do
  #   dependency 'GData'
  # end

  app.icons = %w{ icon.png }
end
